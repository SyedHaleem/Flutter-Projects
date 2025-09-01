import 'package:firebasework/controller/ForgotPasswordController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:firebasework/view/widgets/AppButton.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  // Use Get.put to provide the controller instance
  final ForgotPasswordController ctrl = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppbar(
        title: Image.asset('assets/vectors/Blog_logo.png', width: 200, height: 200,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Form(
            key: ctrl.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset('assets/images/lock.png', width: 165.83, height: 170),
                const SizedBox(height: 30),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your email address to get an OTP code to reset your password',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.29,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: ctrl.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Obx(() => AppButton(
                  onPressed: ctrl.isLoading.value
                      ? null
                      : () async {
                    print('EMAIL PASSED TO CONTROLLER: "${ctrl.emailController.text}"');
                    if (ctrl.formKey.currentState!.validate()) {
                      await ctrl.handleForgotPassword(context);
                    }
                  },
                  title: ctrl.isLoading.value ? 'Sending Reset Email...' : 'Send me Email',
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}