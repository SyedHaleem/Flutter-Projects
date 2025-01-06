import 'dart:async';
import 'package:cofee_shop/pages/Home.dart';
import 'package:cofee_shop/pages/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseServices {
  Future<void> isLogin() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    await Future.delayed(const Duration(seconds: 1)); // Simulate some delay

    if (user != null) {
      // Navigate to Home if the user is already logged in
      Get.to(
        const Home(),
        transition: Transition.fadeIn,
        duration: const Duration(seconds: 1),
      );
    } else {
      // Navigate to Login if the user is not logged in
      Get.to(
        const Login(),
        transition: Transition.downToUp,
        duration: const Duration(seconds: 1),
      );
    }
  }
}
