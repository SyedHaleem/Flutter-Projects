import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

import '../ML/recognition.dart';
import '../ML/Recognizer.dart';
import '../view/widgets/FaceRegistrationDialog.dart';
import 'RegisteredFacesController.dart';

enum RegistrationLoadingState {
  idle,
  loadingImage,
  detectingFaces,
}

typedef ShowSnackbar = void Function(String msg);

class RegistrationController extends ChangeNotifier {
  late ImagePicker imagePicker;
  File? _imageFile;
  File? get imageFile => _imageFile;
  ui.Image? _uiImage;
  ui.Image? get uiImage => _uiImage;

  List<Face> faces = [];
  late FaceDetector faceDetector;
  RegistrationLoadingState loadingState = RegistrationLoadingState.idle;

  late Recognizer recognizer;
  bool recognizerReady = false;

  List<_FaceWithCrop> _crops = [];

  ShowSnackbar? _showSnackbar;

  RegistrationController() {
    imagePicker = ImagePicker();
    final options = FaceDetectorOptions(enableClassification: true, performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);
    recognizer = Recognizer(numThreads: 2);
    _initRecognizer();
  }

  Future<void> _initRecognizer() async {
    await recognizer.init();
    recognizerReady = true;
    notifyListeners();
  }

  Future<void> imgFromCamera() async {
    if (!recognizerReady) return;
    loadingState = RegistrationLoadingState.loadingImage;
    notifyListeners();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await _setImage(File(pickedFile.path));
    }
    loadingState = RegistrationLoadingState.idle;
    notifyListeners();
  }

  Future<void> imgFromGallery() async {
    if (!recognizerReady) return;
    loadingState = RegistrationLoadingState.loadingImage;
    notifyListeners();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _setImage(File(pickedFile.path));
    }
    loadingState = RegistrationLoadingState.idle;
    notifyListeners();
  }

  Future<void> _setImage(File file) async {
    _imageFile = await removeRotation(file);
    faces = [];
    _uiImage = null;
    notifyListeners();

    await _loadUiImage();

    loadingState = RegistrationLoadingState.detectingFaces;
    notifyListeners();

    await doFaceDetection();

    loadingState = RegistrationLoadingState.idle;
    notifyListeners();
  }

  Future<void> doFaceDetection() async {
    if (_imageFile == null) return;
    if (!recognizerReady) return;
    final inputImage = InputImage.fromFile(_imageFile!);
    faces = await faceDetector.processImage(inputImage);

    _crops.clear();
    if (faces.isEmpty) {
      notifyListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          "No Face Detected",
          "Please try again with a clearer image.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.transparent,
          colorText: Colors.black87,
          icon: const Icon(Icons.sentiment_dissatisfied, color: Colors.black87, size: 32),
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
          duration: const Duration(seconds: 3),
          messageText: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF0E6FD),
                  Color(0xFFDDEBFB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Text(
              "Please try again with a clearer image.",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          titleText: const Text(
            "No Face Detected",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      });
      return;
    }

    final bytes = await _imageFile!.readAsBytes();
    final img.Image? fullImg = img.decodeImage(bytes);
    if (fullImg == null) return;

    for (final face in faces) {
      final rect = face.boundingBox;
      final x = rect.left.toInt().clamp(0, fullImg.width - 1);
      final y = rect.top.toInt().clamp(0, fullImg.height - 1);
      final w = rect.width.toInt().clamp(1, fullImg.width - x);
      final h = rect.height.toInt().clamp(1, fullImg.height - y);

      final cropped = img.copyCrop(
        fullImg,
        x: x,
        y: y,
        width: w,
        height: h,
      );
      final croppedBytes = Uint8List.fromList(img.encodeJpg(cropped));

      Recognition rec = await recognizer.recognize(cropped, rect);

      final alreadyExists = recognizer.isAlreadyRegistered(rec.embeddings);

      _crops.add(_FaceWithCrop(
        croppedBytes: croppedBytes,
        recognition: rec,
        alreadyExists: alreadyExists,
      ));
    }

    notifyListeners();
    if (_crops.isNotEmpty && onFacesDetected != null) {
      await onFacesDetected!();
      onFacesDetected = null;
    }
  }

  Future<void> _loadUiImage() async {
    if (_imageFile == null) return;
    final bytes = await _imageFile!.readAsBytes();
    _uiImage = await decodeImageFromList(bytes);
    notifyListeners();
  }

  Future<File> removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await inputImage.readAsBytes());
    if (capturedImage == null) return inputImage;
    final img.Image orientedImage = img.bakeOrientation(capturedImage);
    return await inputImage.writeAsBytes(img.encodeJpg(orientedImage));
  }

  Future<void> Function()? onFacesDetected;

  void setupDialogCallback(BuildContext context, {ShowSnackbar? showSnackbar}) {
    _showSnackbar = showSnackbar;
    onFacesDetected = () async {
      await showFaceRegistrationDialogs(context);
    };
  }

  Future<void> _showFaceExistsDialog(BuildContext context, Uint8List croppedBytes) async {
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE0C3FC),
                Color(0xFF8EC5FC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Face Already Exists",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(croppedBytes, width: 96, height: 96, fit: BoxFit.cover),
                ),
                const SizedBox(height: 18),
                const Text(
                  "This face already exists in the database.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF0E6FD),
                          Color(0xFFDDEBFB),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showFaceRegistrationDialogs(BuildContext context) async {
    for (var faceCrop in _crops) {
      if (faceCrop.alreadyExists) {
        await _showFaceExistsDialog(context, faceCrop.croppedBytes);
      } else {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => FaceRegistrationDialog(
            croppedFaceBytes: faceCrop.croppedBytes,
            onRegister: (name) async {
              await recognizer.registerFaceInDB(name, faceCrop.recognition.embeddings, faceCrop.croppedBytes);
              try {
                context.read<RegisteredFacesController>().reload();
              } catch (_) {}
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF0E6FD),
                          Color(0xFFDDEBFB),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.black87, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Face registered as $name.",
                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  duration: const Duration(seconds: 3),
                  padding: EdgeInsets.zero,
                ),
              );
            },
          ),
        );
      }
    }
  }
}

class _FaceWithCrop {
  final Uint8List croppedBytes;
  final Recognition recognition;
  final bool alreadyExists;

  _FaceWithCrop({
    required this.croppedBytes,
    required this.recognition,
    required this.alreadyExists,
  });
}