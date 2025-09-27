import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/RegisteredFacesController.dart';
import 'widgets/DeleteFaceDialog.dart';

class RegisteredFacesScreen extends StatelessWidget {
  const RegisteredFacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RegisteredFacesController>();

    final themeGradient = const LinearGradient(
      colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: themeGradient),
        child: SafeArea(
          child: controller.isLoading
              ? Center(child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Color(0xFFF0E6FD), Color(0xFFDDEBFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // This is ignored due to the ShaderMask
              backgroundColor: Colors.transparent,
            ),
          ))
              : controller.faces.isEmpty
              ? const Center(
            child: Text(
              "No registered faces found.",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 32.0, left: 24.0, right: 24.0),
                child: Text(
                  "Registered Faces",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.faces.length,
                  itemBuilder: (context, idx) {
                    final face = controller.faces[idx];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF0E6FD), Color(0xFFDDEBFB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Dismissible(
                        key: Key(face.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: _buildSwipeBackground(),
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => DeleteFaceDialog(
                              name: face.name,
                              onConfirm: () {
                                Navigator.of(ctx).pop(true);
                              },
                            ),
                          );
                        },
                        onDismissed: (_) async {
                          await controller.deleteFace(face.id, context, face.name);
                        },
                        child: SizedBox(
                        height: 90,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16), // adjust if needed
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center, // ensures vertical centering
                            children: [
                              face.faceImage != null
                                  ? CircleAvatar(
                                backgroundImage: MemoryImage(face.faceImage!),
                                radius: 28,
                              )
                                  : CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Text(
                                  face.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                radius: 28,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  face.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 32),
    );
  }
}