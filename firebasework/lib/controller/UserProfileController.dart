import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'dart:async';

class UserProfileController extends GetxController {
  var avatarUrl = ''.obs;
  var userName = ''.obs;
  var email = ''.obs;
  var isLoading = true.obs;
  var avatarCacheBuster = 0.obs;

  StreamSubscription<DocumentSnapshot>? _profileSubscription;

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _listenToProfile(user.uid);
      } else {
        _cancelProfileStream();
        _clearProfile();
      }
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _listenToProfile(user.uid);
    } else {
      _clearProfile();
    }
  }

  void _listenToProfile(String uid) {
    isLoading.value = true;
    _cancelProfileStream();
    _profileSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        avatarUrl.value = data['userAvatarUrl'] ?? '';
        userName.value = data['userName'] ?? '';
        email.value = data['email'] ?? FirebaseAuth.instance.currentUser?.email ?? '';
      } else {
        _clearProfile();
      }
      isLoading.value = false;
    });
  }


  Future<void> refreshProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    isLoading.value = true;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      avatarUrl.value = data['userAvatarUrl'] ?? '';
      userName.value = data['userName'] ?? '';
      email.value = data['email'] ?? user.email ?? '';
      avatarCacheBuster.value = DateTime.now().millisecondsSinceEpoch; // force image reload!
    } else {
      _clearProfile();
    }
    isLoading.value = false;
  }

  void _cancelProfileStream() {
    _profileSubscription?.cancel();
    _profileSubscription = null;
  }

  void _clearProfile() {
    avatarUrl.value = '';
    userName.value = '';
    email.value = '';
    isLoading.value = false;
  }

  @override
  void onClose() {
    _cancelProfileStream();
    super.onClose();
  }

  Future<String> saveDeviceToken(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'deviceToken': token,
      });
    }
    return token!;
  }
}