import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/model/UserModel.dart';
import 'package:firebasework/view/authScreen/VerifyEmailScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;


  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> registerUser(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      print('Form not valid');
      return;
    }

    isLoading.value = true;
    try {
      final normalizedEmail = emailController.text.trim().toLowerCase();
      print('Checking if email exists: $normalizedEmail');
      var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(normalizedEmail);
      print('Sign in methods for email: $methods');
      if (methods.isNotEmpty) {
        print('Email already registered');
        Get.snackbar('Error', 'Email is already registered', backgroundColor: Colors.red, colorText: Colors.white);
        isLoading.value = false;
        return;
      }

      print('Registering user...');
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: passwordController.text,
      );
      print('User registered: ${userCredential.user?.uid}');

      print('Sending email verification...');
      await userCredential.user!.sendEmailVerification();
      print('Verification email sent.');

      print('Writing user to Firestore...');
      final userModel = UserModel(
        id: userCredential.user!.uid,
        userName: fullNameController.text.trim(),
        userAvatarUrl: '',
        email: normalizedEmail,
      );

      await FirebaseFirestore.instance.collection('users')
          .doc(userCredential.user!.uid)
          .set({
        ...userModel.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'uid': userCredential.user!.uid,
      });
      print('User document written to Firestore.');

      Get.snackbar(
        'Success',
        'Account created! Please verify your email.',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
      fullNameController.clear();
      emailController.clear();
      passwordController.clear();
      Get.offAll(() => const VerifyEmailScreen());
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      Get.snackbar('Error', e.message ?? 'Signup failed', backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      print('General Exception: $e');
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      print('Registration process complete. Loading: ${isLoading.value}');
    }
  }
}