import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart'; // Professional Package
import 'package:image/image.dart' as img; // For resizing images
import 'package:csv/csv.dart';
class FoodScannerScreen extends StatefulWidget {
  const FoodScannerScreen({super.key});

  @override
  State<FoodScannerScreen> createState() => _FoodScannerScreenState();
}

class _FoodScannerScreenState extends State<FoodScannerScreen> {
  // CONFIGURATION
  final Color primaryColor = const Color(0xFF2196F3);
  final ImagePicker _picker = ImagePicker();

  // AI VARIABLES
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isModelLoaded = false;

  // STATE VARIABLES
  File? _selectedImage;
  bool _loading = false;

  // RESULTS
  String _foodName = "";
  String _confidence = "";
  Map<String, Map<String, dynamic>> _nutritionDb = {};
  Map<String, dynamic> _currentNutrition = {};

  @override
  void initState() {
    super.initState();
    _initSystem();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _initSystem() async {
    setState(() => _loading = true);
    await _loadNutritionCSV();
    await _loadModel();
    setState(() => _loading = false);
  }

  // 1. LOAD MODEL (tflite_flutter style)
  Future<void> _loadModel() async {
    try {
      // Load the Brain
      _interpreter = await Interpreter.fromAsset('assets/model/food_classifier.tflite');

      // Load the Labels
      final labelData = await rootBundle.loadString('assets/model/labels.txt');
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();

      // Configure Model Input/Output shapes
      _interpreter?.allocateTensors();

      setState(() => _isModelLoaded = true);
      print("✅ TFLite Model Loaded Successfully");
    } catch (e) {
      print("❌ Failed to load model: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Model Error: $e")));
    }
  }

  // 2. LOAD NUTRITION DATABASE
  Future<void> _loadNutritionCSV() async {
    try {
      final rawData = await rootBundle.loadString("assets/model/nutrition.csv");
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

      for (var row in csvTable) {
        if (row.length > 1) {
          // Cleanup name for matching (apple_pie -> apple_pie)
          String key = row[0].toString().trim().toLowerCase().replaceAll(" ", "_");
          _nutritionDb[key] = {
            'calories': row[1],
            'carbs': row.length > 2 ? row[2] : '0',
            'protein': row.length > 3 ? row[3] : '0',
            'fat': row.length > 4 ? row[4] : '0',
          };
        }
      }
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  // 3. PICK IMAGE
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
        _loading = true;
        _foodName = "";
      });

      // Analyze immediately
      await Future.delayed(const Duration(milliseconds: 100));
      await _runInference(File(image.path));

    } catch (e) {
      print(e);
    }
  }

  // 4. RUN AI (Manual Preprocessing)
  Future<void> _runInference(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) return;

    try {
      // A. Read Image
      final imageData = await imageFile.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageData);

      if (decodedImage == null) {
        throw Exception("Could not decode image");
      }

      // B. Resize to 224x224 (The size MobileNet expects)
      final img.Image resizedImage = img.copyResize(decodedImage, width: 224, height: 224);

      // C. Convert to Float32 List [1, 224, 224, 3] and Normalize (0-1)
      // Your training used rescale=1./255, so we divide pixel values by 255.0
      var input = List.generate(1, (i) =>
          List.generate(224, (y) =>
              List.generate(224, (x) {
                var pixel = resizedImage.getPixel(x, y);
                return [
                  pixel.r / 255.0, // Red
                  pixel.g / 255.0, // Green
                  pixel.b / 255.0  // Blue
                ];
              })
          )
      );

      // D. Prepare Output Buffer [1, 101]
      // 101 is the number of food classes
      var output = List.filled(1 * 101, 0.0).reshape([1, 101]);

      // E. Run Inference
      _interpreter!.run(input, output);

      // F. Find the Winner (Highest Confidence)
      List<double> probabilities = List<double>.from(output[0]);
      double maxScore = 0.0;
      int maxIndex = 0;

      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxScore) {
          maxScore = probabilities[i];
          maxIndex = i;
        }
      }

      // G. Process Result
      String rawLabel = _labels.length > maxIndex ? _labels[maxIndex] : "Unknown";

      // TFLite labels sometimes have numbers (e.g. "0 apple_pie"). Clean them.
      String cleanKey = rawLabel.replaceAll(RegExp(r'[0-9]'), '').trim().toLowerCase().replaceAll(" ", "_");
      String displayName = rawLabel.replaceAll(RegExp(r'[0-9]'), '').trim().replaceAll("_", " ").toUpperCase();

      var nutrition = _nutritionDb[cleanKey] ?? {
        'calories': 'Unknown', 'carbs': '-', 'protein': '-', 'fat': '-'
      };

      setState(() {
        _foodName = displayName;
        _confidence = "${(maxScore * 100).toStringAsFixed(0)}%";
        _currentNutrition = nutrition;
        _loading = false;
      });

    } catch (e) {
      print("Inference Error: $e");
      setState(() {
        _foodName = "Error Analyzing";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('AI Food Scanner'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageCard(),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(child: _buildButton(Icons.camera_alt, "Camera", ImageSource.camera)),
                const SizedBox(width: 15),
                Expanded(child: _buildButton(Icons.photo_library, "Gallery", ImageSource.gallery)),
              ],
            ),
            const SizedBox(height: 30),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_foodName.isNotEmpty)
              _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _selectedImage != null
            ? Image.file(_selectedImage!, fit: BoxFit.cover)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_rounded, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text("Take a photo of your food", style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, ImageSource source) {
    return ElevatedButton.icon(
      onPressed: () => _pickImage(source),
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  Widget _buildResultCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: primaryColor.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))
            ],
          ),
          child: Column(
            children: [
              Text(
                _foodName,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                "Confidence: $_confidence",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_currentNutrition.isNotEmpty && _currentNutrition['calories'] != 'Unknown')
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: [
              _buildNutrientTile(Icons.local_fire_department, "Calories", "${_currentNutrition['calories']}", Colors.orange),
              _buildNutrientTile(Icons.bakery_dining, "Carbs", "${_currentNutrition['carbs']}g", Colors.brown),
              _buildNutrientTile(Icons.fitness_center, "Protein", "${_currentNutrition['protein']}g", Colors.blueAccent),
              _buildNutrientTile(Icons.opacity, "Fat", "${_currentNutrition['fat']}g", Colors.amber),
            ],
          )
        else
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(10)),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange),
                SizedBox(width: 10),
                Expanded(child: Text("Nutrition info not found in database.", style: TextStyle(color: Colors.orange)))
              ],
            ),
          ),
        const SizedBox(height: 20),
        const Center(child: Text("Values per 100g serving", style: TextStyle(color: Colors.grey))),
      ],
    );
  }

  Widget _buildNutrientTile(IconData icon, String label, String value, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 30, // 2 columns
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),

          // --- FIX: Wrap Column in Expanded ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis, // Safety: Add dots if too long
                  maxLines: 1,
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  overflow: TextOverflow.ellipsis, // Safety: Add dots if too long
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // ------------------------------------
        ],
      ),
    );
  }
}