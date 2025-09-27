import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../Database/DatabaseHelper.dart';
import 'recognition.dart';

class Recognizer {
  Interpreter? interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 160;
  static const int HEIGHT = 160;
  final dbHelper = DatabaseHelper();

  // Multiple embeddings per person
  Map<String, List<Recognition>> registered = {};

  String get modelName => 'assets/models/facenet.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();
    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
  }

  Future<void> init() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName, options: _interpreterOptions);
      await initDB();
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: $e');
      rethrow;
    }
  }

  Future<void> initDB() async {
    await dbHelper.database;
    await loadRegisteredFaces();
  }

  Future<void> loadRegisteredFaces() async {
    final allRows = await dbHelper.getAllFaces();
    registered.clear();
    for (final row in allRows) {
      String name = row[DatabaseHelper.columnName];
      dynamic embdRaw = row[DatabaseHelper.columnEmbedding];
      List<double> embd = embdRaw is String
          ? embdRaw.split(',').map((e) => double.tryParse(e) ?? 0.0).toList()
          : <double>[];
      Recognition recognition = Recognition(name, Rect.zero, embd, 0);
      registered.putIfAbsent(name, () => []).add(recognition);
    }
  }

  // Register additional image/embedding for a person
  Future<void> registerFaceInDB(String name, List<double> embedding, Uint8List faceImage) async {
    await dbHelper.insertFace(name, embedding, faceImage);
    // Immediately reload registered faces so isAlreadyRegistered works correctly after registration
    await loadRegisteredFaces();
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage = img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = [];
    for (int y = 0; y < HEIGHT; y++) {
      for (int x = 0; x < WIDTH; x++) {
        final pixel = resizedImage.getPixel(x, y);
        flattenedList.add((pixel.r - 127.5) / 127.5);
        flattenedList.add((pixel.g - 127.5) / 127.5);
        flattenedList.add((pixel.b - 127.5) / 127.5);
      }
    }
    Float32List float32Array = Float32List.fromList(flattenedList);
    return float32Array.reshape([1, HEIGHT, WIDTH, 3]);
  }

  Future<Recognition> recognize(img.Image image, Rect location) async {
    if (interpreter == null) {
      throw Exception('Interpreter not initialized. Call await recognizer.init() before using recognize().');
    }
    var input = imageToArray(image);
    List output = List.filled(1 * 512, 0).reshape([1, 512]);
    interpreter!.run(input, output);

    List<double> outputArray = output.first.cast<double>();
    Pair pair = findBestMatch(outputArray);

    return Recognition(pair.name, location, outputArray, pair.distance);
  }

  // Best match from all registered embeddings
  Pair findBestMatch(List<double> emb, {double threshold = 1.0}) {
    String bestName = "Unknown";
    double bestDist = double.maxFinite;

    registered.forEach((name, recognitions) {
      for (var rec in recognitions) {
        double distance = euclideanDistance(emb, rec.embeddings);
        if (distance < bestDist) {
          bestDist = distance;
          bestName = name;
        }
      }
    });

    if (bestDist < threshold) {
      return Pair(bestName, bestDist);
    } else {
      return Pair("Unknown", bestDist);
    }
  }

  // Fix: After registering, reload registered faces so this works!
  bool isAlreadyRegistered(List<double> newEmbedding, {double threshold = 1.0}) {
    for (var recognitions in registered.values) {
      for (var rec in recognitions) {
        final dist = euclideanDistance(newEmbedding, rec.embeddings);
        if (dist < threshold) return true;
      }
    }
    return false;
  }

  double euclideanDistance(List<double> v1, List<double> v2) {
    double sum = 0.0;
    for (int i = 0; i < v1.length; i++) {
      final d = v1[i] - v2[i];
      sum += d * d;
    }
    return sqrt(sum);
  }

  void close() {
    interpreter?.close();
  }
}

class Pair {
  String name;
  double distance;
  Pair(this.name, this.distance);
}