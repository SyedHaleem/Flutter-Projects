import 'dart:math' as math;

import 'package:cofee_shop/components/CustomTextField.dart';
import 'package:cofee_shop/pages/Home.dart';
import 'package:cofee_shop/pages/Signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController uName = TextEditingController();
    TextEditingController uPass = TextEditingController();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double textFieldWidth = screenWidth * 0.75; // 75% of screen width
    double buttonWidth = screenWidth * 0.75; // 75% of screen width

    double baseFontSize = screenWidth / 25; // Base font size proportional to screen width
    double subTextFontSize = math.max(screenWidth / 30, 14); // Minimum 14 for readability

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.15), // Adjust top margin based on screen height
                child: Column(
                  children: [
                    Image.asset('assets/icons/bean_logo1.png'),
                    SizedBox(height: screenHeight * 0.05), // Adjust gap between logo and text fields
                    CustomTextField(
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      bgColor: Colors.white70,
                      controller: uName,
                      hintText: 'Username',
                      icon: Icons.person,
                      keyboardType: TextInputType.name,
                      width: textFieldWidth,
                    ),
                    SizedBox(height: screenHeight * 0.03), // Adjust gap between fields
                    CustomTextField(
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      bgColor: Colors.white70,
                      controller: uPass,
                      hintText: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      width: textFieldWidth,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.35), // Adjust left padding
                      child: GestureDetector(
                        onTap: () {
                          // Add forgot password functionality here
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: baseFontSize, // Responsive font size
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015), // Adjust gap
                    Container(
                      width: buttonWidth,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(const Home());
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.white70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08), // Adjust gap before sign-up prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: baseFontSize, // Enforced minimum font size
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              const Signup(),
                              transition: Transition.downToUp, // Smooth transition
                              duration: const Duration(seconds: 1),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: subTextFontSize, // Enforced minimum font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
