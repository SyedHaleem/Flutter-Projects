import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasework/controller/HomeController.dart';
import 'package:firebasework/controller/UserProfileController.dart';
import 'package:firebasework/model/UserModel.dart';
import 'package:firebasework/view/homeScreen/HomeScreen.dart';
import 'package:firebasework/view/mainScreen/MainScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isGoogleSigningIn = false.obs;

  Future<void> signInWithGoogle() async {
    isGoogleSigningIn.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isGoogleSigningIn.value = false;
        return;
      } // User canceled

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // If new user, create Firestore entry using UserModel
      final User? user = userCredential.user;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          final userModel = UserModel(
            id: user.uid,
            userName: user.displayName ?? '',
            userAvatarUrl: user.photoURL ?? '',
            email: user.email ?? '',
          );

          await _firestore.collection('users').doc(user.uid).set({
            ...userModel.toJson(),
            'createdAt': FieldValue.serverTimestamp(),
            'uid': user.uid,
            'signInMethod': 'google',
          });
        }
        Get.find<HomeController>().setCurrentUserId(userCredential.user!.uid);
        await Get.find<UserProfileController>().saveDeviceToken(userCredential.user!.uid);
      }

      // Success, go to home screen
      Get.offAll(MainScreen());
    } catch (e) {
      Get.snackbar('Google Sign-In Failed', e.toString(), backgroundColor: Colors.red, colorText: Get.theme.colorScheme.onError);
    }
    finally{
      isGoogleSigningIn.value = false;
    }
  }
}