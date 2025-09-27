import 'package:face_recognition_app/controller/RecognitionController.dart';
import 'package:face_recognition_app/controller/RegisteredFacesController.dart';
import 'package:face_recognition_app/controller/RegistrationController.dart';
import 'package:face_recognition_app/view/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const FaceRecognitionApp());
}

class FaceRecognitionApp extends StatelessWidget {
  const FaceRecognitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecognitionController()),
        ChangeNotifierProvider(create: (_) => RegistrationController()),
        ChangeNotifierProvider(create: (_) => RegisteredFacesController()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face ID App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF1f4037),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}