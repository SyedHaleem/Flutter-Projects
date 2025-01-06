import 'package:cofee_shop/config/Colors.dart';
import 'package:cofee_shop/firebase_Services/FirebaseServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Launch extends StatelessWidget {
  const Launch({super.key});

  @override
  Widget build(BuildContext context) {
    // Getting screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Initialize the LaunchController
    final controller = Get.put(LaunchController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Logo and Text Section
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.15), // Responsive margin
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/bean_logo1.png',
                    width: screenWidth * 0.5, // Responsive logo size
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Find the best coffee\nfor you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Get Started Button Section
            const Spacer(),
            Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.08,
              margin: EdgeInsets.only(bottom: screenHeight * 0.1),
              child: Obx(() => ElevatedButton(
                onPressed: () async {
                  controller.toggleLoading(true);
                  try {
                    await FirebaseServices().isLogin();
                  } finally {
                    controller.toggleLoading(false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: CofeeBox,
                )
                    : const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class LaunchController extends GetxController {
  var isLoading = false.obs;

  void toggleLoading(bool value) {
    isLoading.value = value;
  }
}
