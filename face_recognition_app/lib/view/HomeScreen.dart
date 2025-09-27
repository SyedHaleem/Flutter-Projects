import 'package:face_recognition_app/controller/RecognitionController.dart';
import 'package:face_recognition_app/controller/RegisteredFacesController.dart';
import 'package:face_recognition_app/view/RecognitionScreen.dart';
import 'package:face_recognition_app/view/RegisteredFacesScreen.dart';
import 'package:face_recognition_app/view/RegistrationScreen.dart';
import 'package:face_recognition_app/view/widgets/AppButton.dart' show AppButton;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/RegistrationController.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // CHANGED: Linear gradient from greenish to light purple
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0C3FC), // Light purple
              Color(0xFF8EC5FC), // Light blue-purple
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  'IdentiFy App',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Secure • Fast • Accurate',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: size.width * 0.55,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        label: 'Register Face',
                        icon: Icons.person_add_alt_1,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: context.read<RegistrationController>(),
                                child: const RegistrationScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Recognize Face',
                        icon: Icons.face_retouching_natural,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: context.read<RecognitionController>(),
                                child: const RecognitionScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Registered Faces',
                        icon: Icons.list_alt,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: context.read<RegisteredFacesController>(),
                                child: const RegisteredFacesScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}