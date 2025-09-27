import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../ML/Recognizer.dart';

class RegisteredFace {
  final int id;
  final String name;
  final List<double> embedding;
  final Uint8List? faceImage;
  RegisteredFace({required this.id, required this.name, required this.embedding, this.faceImage});
}

class RegisteredFacesController extends ChangeNotifier {
  final recognizer = Recognizer();
  List<RegisteredFace> faces = [];
  bool isLoading = true;

  RegisteredFacesController() {
    loadFaces();
  }

  Future<void> loadFaces() async {
    isLoading = true;
    notifyListeners();
    await recognizer.initDB();
    await recognizer.loadRegisteredFaces();
    final allRows = await recognizer.dbHelper.getAllFaces();
    faces = allRows
        .map((row) => RegisteredFace(
      id: row['id'] as int,
      name: row['name'] as String,
      embedding: (row['embedding'] as String)
          .split(',')
          .map((e) => double.tryParse(e) ?? 0.0)
          .toList(),
      faceImage: row['faceImage'] is Uint8List ? row['faceImage'] : null,
    ))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> reload() async => await loadFaces();

  Future<void> deleteFace(int id, BuildContext context, String name) async {
    await recognizer.dbHelper.deleteFace(id);
    recognizer.registered.removeWhere((key, value) =>
    faces.firstWhere((face) => face.id == id).name == key);
    faces.removeWhere((face) => face.id == id);
    notifyListeners();
    _showCustomSnackbar(context, "Deleted", "Face '$name' deleted from database.");
  }

  void _showCustomSnackbar(BuildContext context, String title, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40,
        left: 18,
        right: 18,
        child: _GradientSnackbar(title: title, message: message),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

class _GradientSnackbar extends StatelessWidget {
  final String title;
  final String message;
  const _GradientSnackbar({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF0E6FD), Color(0xFFDDEBFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.black87, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(message,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}