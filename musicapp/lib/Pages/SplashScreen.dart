import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Pages/SongPage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Schedule navigation when the widget is built
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const SongPage());
    });

    return Scaffold(
      body: Center(
        child: Image.asset("assets/icons/bag.png"),
      ),
    );
  }
}
