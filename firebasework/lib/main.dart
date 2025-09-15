import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'package:firebasework/controller/HomeController.dart';
import 'package:firebasework/controller/UserProfileController.dart';
import 'package:firebasework/config/theme/app_theme.dart';
import 'package:firebasework/view/splashScreen/SplashScreen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingbackgroundHandler);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingbackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up GetX bindings and FirebaseAuth user context
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(UserProfileController());
        Get.put(HomeController());
        FirebaseAuth.instance.authStateChanges().listen((user) {
          final homeCtrl = Get.find<HomeController>();
          if (user != null) {
            homeCtrl.setCurrentUserId(user.uid);
          } else {
            homeCtrl.setCurrentUserId('');
          }
        });
      }),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      defaultTransition: Transition.size,
      transitionDuration: Duration(milliseconds: 1200),
      home: SplashScreen(),
    );
  }
}