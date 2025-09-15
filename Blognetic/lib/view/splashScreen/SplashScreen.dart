import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasework/controller/NotificationServices.dart';
import 'package:firebasework/view/authScreen/LoginScreen.dart';
import 'package:firebasework/view/homeScreen/HomeScreen.dart';
import 'package:firebasework/view/mainScreen/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NotificationServices().requestNotificationPermission();
    NotificationServices().firebaseInit(context);
    NotificationServices().setupInteractMessage(context);
    _navigateUser();
  }

  Future<void> _navigateUser() async {

    await Future.delayed(const Duration(seconds: 2)); // you can adjust splash duration

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If using email/password, you might want to check email is verified:
      final isGoogle = user.providerData.any((info) => info.providerId == 'google.com');
      if (isGoogle || user.emailVerified) {
        Get.offAll(() =>  MainScreen());
        return;
      }
    }
    // Default: Go to login
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/vectors/Blog_logo.png'),
      ),
    );
  }
}