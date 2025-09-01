import 'package:cofee_shop/components/CustomTextField.dart';
import 'package:cofee_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/Colors.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final RegistrationController regController = Get.put(RegistrationController());
    TextEditingController uName = TextEditingController();
    TextEditingController uPass = TextEditingController();
    TextEditingController uEmail = TextEditingController();

    // Fetch the screen size to adapt UI
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate dynamic dimensions based on screen size
    double textFieldWidth = screenWidth * 0.75; // TextField width is 75% of the screen width
    double buttonWidth = screenWidth * 0.75;   // Button width is also 75% of the screen width
    double fontSize = screenWidth / 25;        // Font size scaled to screen width

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Custom Back Button
                Container(
                  margin: EdgeInsets.only(
                    top: screenHeight * 0.07, // Responsive top margin
                    left: screenWidth * 0.05, // Responsive left margin
                  ),
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Get.back(); // Navigate back
                    },
                    child: Image.asset('assets/icons/back_btn.png'),
                  ),
                ),
                // Logo and Fields
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.05), // Responsive top margin
                  child: Column(
                    children: [
                      Image.asset('assets/icons/bean_logo1.png'),
                      SizedBox(height: screenHeight * 0.05), // Responsive gap
                      CustomTextField(
                        width: textFieldWidth, // Responsive TextField width
                        iconColor: Colors.black,
                        textColor: Colors.black,
                        bgColor: Colors.white70,
                        controller: uName,
                        hintText: 'Username',
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: screenHeight * 0.03), // Responsive gap
                      CustomTextField(
                        width: textFieldWidth, // Responsive TextField width
                        iconColor: Colors.black,
                        textColor: Colors.black,
                        bgColor: Colors.white70,
                        controller: uEmail,
                        hintText: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: screenHeight * 0.03), // Responsive gap
                      CustomTextField(
                        width: textFieldWidth, // Responsive TextField width
                        iconColor: Colors.black,
                        textColor: Colors.black,
                        bgColor: Colors.white70,
                        controller: uPass,
                        hintText: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: screenHeight * 0.08), // Responsive gap
                      Container(
                        width: buttonWidth,
                        height: 64,
                        child: Obx(() {
                          return ElevatedButton(
                            onPressed: regController.isLoading.value
                                ? null
                                : () {
                                regController.toggleLoading(true);
                                _auth
                                    .createUserWithEmailAndPassword(
                                  email: uEmail.text.trim(),
                                  password: uPass.text.trim(),
                                )
                                    .then((value) {
                                  // Show success message
                                  Utils().toastMessage("Registration successful!");

                                  // Stop loading
                                  regController.toggleLoading(false);
                                })
                                    .onError((error, stackTrace) {
                                  // Show error message
                                  Utils().toastMessage(error.toString());
                                  // Stop loading
                                  regController.toggleLoading(false);
                                });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: regController.isLoading.value
                                ? const CircularProgressIndicator(
                              strokeWidth: 3,
                              color: CofeeBox,
                            )
                                : const Text(
                              'Signup',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: screenHeight * 0.07), // Responsive gap
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationController extends GetxController {
  var isLoading = false.obs;

  void toggleLoading(bool value) {
    isLoading.value = value;
  }
}
