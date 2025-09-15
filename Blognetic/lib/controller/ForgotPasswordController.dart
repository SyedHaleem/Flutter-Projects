import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebasework/view/authScreen/OtpScreen.dart';
import 'package:firebasework/config/theme/app_Color.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<bool> doesUserExist(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    print('DEBUG: Checking email existence in Firestore for: "$cleanEmail"');

    try {
      // Query Firestore for users matching the email
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('DEBUG: User exists for email "$cleanEmail"');
        return true;
      } else {
        print('DEBUG: No user found for email "$cleanEmail"');
        Get.snackbar(
          "No Account",
          "No account found with this email address. Please ensure you typed it correctly or check if the account exists.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('DEBUG: Error querying Firestore for email "$cleanEmail": $e');
      Get.snackbar(
        'Error',
        'Something went wrong while checking your account. Please try again later.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  String generateOtp() {
    final rnd = Random();
    return (10000 + rnd.nextInt(90000)).toString();
  }

  Future<void> storeOtpInFirestore({required String email, required String otp}) async {
    await FirebaseFirestore.instance
        .collection('password_reset_otps')
        .doc(email)
        .set({
      'otp': otp,
      'expiresAt': DateTime.now().add(Duration(minutes: 10)),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendOtpEmail({required String toEmail, required String otp}) async {
    final gmailSmtp = gmail(
      dotenv.env["GMAIL_MAIL"]!,
      dotenv.env["GMAIL_PASSWORD"]!,
    );
    final message = Message()
      ..from = Address(dotenv.env["GMAIL_MAIL"]!, 'Blognetic')
      ..recipients.add(toEmail)
      ..subject = 'Your Password Reset OTP'
      ..text = 'Your OTP code for password reset is: $otp\n\n'
          'This code will expire in 10 minutes. If you did not request this, please ignore this email.';

    await send(message, gmailSmtp);
  }

  Future<void> handleForgotPassword(BuildContext context) async {
    final email = emailController.text.trim().toLowerCase();
    print('📨 Forgot password requested for: "$email"');
    isLoading.value = true;

    try {
      bool exists = await doesUserExist(email);
      if (!exists) {
        isLoading.value = false;
        return;
      }

      final otp = generateOtp();
      await storeOtpInFirestore(email: email, otp: otp);
      await sendOtpEmail(toEmail: email, otp: otp);

      Get.snackbar(
        'Send',
        'Check your Email for the OTP',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
      Get.off(() => OtpScreen(), arguments: {'email': email});
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP email. Please try again. (${e.toString()})',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}