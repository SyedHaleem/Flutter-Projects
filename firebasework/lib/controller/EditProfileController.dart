import 'dart:io';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebasework/controller/UserProfileController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileController extends GetxController {
  var avatarUrl = ''.obs;
  var userName = ''.obs;
  var email = ''.obs;
  var selectedImage = Rx<File?>(null);

  var isSaving = false.obs;
  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final userCtrl = Get.find<UserProfileController>();
    avatarUrl.value = userCtrl.avatarUrl.value;
    userName.value = userCtrl.userName.value;
    email.value = userCtrl.email.value;
    nameController.text = userName.value;
  }

  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library,color: AppColors.primary),
              title: const Text('Gallery',style: TextStyle(color: AppColors.primary),),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt,color: AppColors.primary),
              title: const Text('Camera',style: TextStyle(color: AppColors.primary)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        selectedImage.value = File(picked.path);
      }
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    isSaving.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user");

      String? newAvatarUrl = avatarUrl.value;
      String newUserName = nameController.text.trim();

      // Upload new image if selected
      if (selectedImage.value != null) {
        final ref = FirebaseStorage.instance.ref('avatars/${user.uid}.jpg');
        await ref.putFile(selectedImage.value!);
        newAvatarUrl = await ref.getDownloadURL();
      }

      // Update Firestore user profile
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'userName': newUserName,
        'userAvatarUrl': newAvatarUrl,
      });

      // Update all blogs authored by this user
      await updateUserBlogs(user.uid, newUserName, newAvatarUrl ?? '');
      await updateUserComments(user.uid, newUserName, newAvatarUrl?? '');
      // Update UserProfileController for all screens
      final userCtrl = Get.find<UserProfileController>();
      userCtrl.avatarUrl.value = newAvatarUrl ?? '';
      userCtrl.userName.value = newUserName;

      Get.snackbar('Success', 'Profile updated successfully!',
          backgroundColor: AppColors.primary, colorText: Colors.white);

      Navigator.of(context).pop(); // Return to profile screen
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  /// Update all blogs (in Firestore) for this user, setting new userName and userAvatarUrl
  Future<void> updateUserBlogs(String userId, String newUserName, String newAvatarUrl) async {
    final batch = FirebaseFirestore.instance.batch();
    final query = await FirebaseFirestore.instance
        .collection('blogs')
        .where('userId', isEqualTo: userId)
        .get();

    for (final doc in query.docs) {
      batch.update(doc.reference, {
        'userName': newUserName,
        'userAvatarUrl': newAvatarUrl,
      });
    }
    if (query.docs.isNotEmpty) {
      await batch.commit();
    }
  }
  /// Update all comments (in Firestore) for this user, setting new userName and userAvatarUrl
  Future<void> updateUserComments(String userId, String newUserName, String newAvatarUrl) async {
    final blogsQuery = await FirebaseFirestore.instance.collection('blogs').get();

    final batch = FirebaseFirestore.instance.batch();
    for (final blogDoc in blogsQuery.docs) {
      final commentsQuery = await blogDoc.reference
          .collection('comments')
          .where('userId', isEqualTo: userId)
          .get();

      for (final commentDoc in commentsQuery.docs) {
        batch.update(commentDoc.reference, {
          'userName': newUserName,
          'userAvatarUrl': newAvatarUrl,
        });
      }
    }
    // Only commit if there are changes
    if (batch.commit != null) {
      await batch.commit();
    }
  }
}