import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:animate_do/animate_do.dart';

import '../ML/Recognizer.dart';
import '../ML/recognition.dart';

enum RecognitionLoadingState {
  idle,
  loadingImage,
  detectingFaces,
}

class RecognitionController extends ChangeNotifier {
  late ImagePicker imagePicker;
  File? _image;
  File? get image => _image;

  late FaceDetector faceDetector;
  late Recognizer recognizer;
  bool recognizerReady = false;

  RecognitionLoadingState loadingState = RecognitionLoadingState.idle;

  List<Face> faces = [];
  ui.Image? uiImage;

  RecognitionController() {
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
    loadingState = RecognitionLoadingState.loadingImage;
    notifyListeners();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _handleImage();
    }
    loadingState = RecognitionLoadingState.idle;
    notifyListeners();
  }

  Future<void> imgFromGallery() async {
    if (!recognizerReady) return;
    loadingState = RecognitionLoadingState.loadingImage;
    notifyListeners();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _handleImage();
    }
    loadingState = RecognitionLoadingState.idle;
    notifyListeners();
  }

  Future<void> _handleImage() async {
    if (_image == null) return;
    _image = await removeRotation(_image!);
    faces = [];
    uiImage = null;
    notifyListeners();
    await _loadUiImage();
    loadingState = RecognitionLoadingState.detectingFaces;
    notifyListeners();
    await doFaceDetection();
    loadingState = RecognitionLoadingState.idle;
    notifyListeners();
  }

  Future<void> _loadUiImage() async {
    if (_image == null) return;
    final bytes = await _image!.readAsBytes();
    uiImage = await decodeImageFromList(bytes);
    notifyListeners();
  }

  Future<void> doFaceDetection() async {
    if (_image == null) return;
    InputImage inputImage = InputImage.fromFile(_image!);

    await recognizer.loadRegisteredFaces();

    faces = await faceDetector.processImage(inputImage);
    notifyListeners();

    if (faces.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
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
                  const Icon(Icons.sentiment_dissatisfied, color: Colors.black87, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Please try again with a clearer image.",
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
      });
      return;
    }

    final bytes = await _image!.readAsBytes();
    final img.Image? fullImg = img.decodeImage(bytes);
    if (fullImg == null) return;

    for (final face in faces) {
      final rect = face.boundingBox;
      final x = rect.left.toInt().clamp(0, fullImg.width - 1);
      final y = rect.top.toInt().clamp(0, fullImg.height - 1);
      final w = rect.width.toInt().clamp(1, fullImg.width - x);
      final h = rect.height.toInt().clamp(1, fullImg.height - y);
      final cropped = img.copyCrop(fullImg, x: x, y: y, width: w, height: h);
      final croppedBytes = Uint8List.fromList(img.encodeJpg(cropped));

      // Get embedding for detected face
      final recognition = await recognizer.recognize(cropped, rect);

      // Find best match from all embeddings
      final double matchThreshold = 1.0; // Tune for your dataset, start at 1.0
      final Pair bestMatch = recognizer.findBestMatch(recognition.embeddings, threshold: matchThreshold);

      print('Detected face best match: name=${bestMatch.name}, distance=${bestMatch.distance}');
      print('Detected face embeddings: ${recognition.embeddings}');

      if (bestMatch.name != 'Unknown') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (_) => RecognizedFaceDialog(
              name: bestMatch.name,
              croppedFace: croppedBytes,
            ),
          );
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
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
                    const Icon(Icons.warning_amber, color: Colors.black87, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "This face is not registered.",
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
        });
      }
    }
    notifyListeners();
  }

  Future<File> removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await inputImage.readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await inputImage.writeAsBytes(img.encodeJpg(orientedImage));
  }
}

class RecognizedFaceDialog extends StatelessWidget {
  final String name;
  final Uint8List croppedFace;

  const RecognizedFaceDialog({
    Key? key,
    required this.name,
    required this.croppedFace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Center(
      child: ZoomIn(
        duration: const Duration(milliseconds: 500),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundImage: MemoryImage(croppedFace),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Hello,",
                    style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF0E6FD), Color(0xFFDDEBFB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => Navigator.of(context).pop(),
                        child: const Center(
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}