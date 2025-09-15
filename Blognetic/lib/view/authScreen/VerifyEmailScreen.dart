import 'package:firebasework/view/authScreen/LoginScreen.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:firebasework/view/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBackBtn: true,
        title: Image.asset(
          'assets/vectors/Blog_logo.png',
          width: 200,
          height: 200,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Verify Your Email',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Text(
              'A verification email has been sent to your email address. '
                  'Please check your inbox and click the link to activate your account.\n\n'
                  'Didn\'t receive the email?',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 33),
            AppButton(
              onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && !user.emailVerified) {
                    await user.sendEmailVerification();
                    Get.snackbar(
                      'Verification Email Sent',
                      'A new verification email has been sent to your inbox.',
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      'Already Verified',
                      'Your email is already verified.',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Could not send verification email.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              title: 'Resend Verification Email',
            ),
            const SizedBox(height: 16),
            AppButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser?.reload();
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && user.emailVerified) {
                  Get.offAll(() => LoginScreen());
                } else {
                  Get.snackbar(
                    'Not Verified',
                    'Please verify your email before continuing.',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                }
              },
              title: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}