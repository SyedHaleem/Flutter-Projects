import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/model/BlogModel.dart';
import 'package:firebasework/model/UserModel.dart';
import 'package:firebasework/model/serverkey.dart';
import 'package:firebasework/view/mainScreen/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class NewBlogController extends GetxController {
  final titleController = "".obs;
  final subtitleController = "".obs;
  final readTimeController = "".obs;
  final pickedImage = Rxn<File>();
  final isLoading = false.obs;
  final selectedCategory = "".obs;
  final customCategoryController = "".obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickCoverImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        pickedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Image Picker failed: $e",
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    }
  }

  Future<String> uploadCoverImage(File imageFile) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('blog_covers/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  void resetFields() {
    titleController.value = "";
    subtitleController.value = "";
    readTimeController.value = "";
    pickedImage.value = null;
    selectedCategory.value = "";
    customCategoryController.value = "";
  }

  Future<void> publishBlog(UserModel user) async {
    if (pickedImage.value == null ||
        titleController.value.isEmpty ||
        subtitleController.value.isEmpty ||
        readTimeController.value.isEmpty ||
        selectedCategory.value.isEmpty ||
        (selectedCategory.value == "Others" && customCategoryController.value.isEmpty)) {
      Get.snackbar(
        "Error",
        "All fields including category are required",
        backgroundColor: const Color(0xFFE57373),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final coverUrl = await uploadCoverImage(pickedImage.value!);

      final category = selectedCategory.value == "Others"
          ? customCategoryController.value
          : selectedCategory.value;

      final blog = BlogModel(
        id: '', // Firestore will set this automatically
        userId: user.id,
        userName: user.userName,
        userAvatarUrl: user.userAvatarUrl,
        blogTitle: titleController.value,
        blogSubtitle: subtitleController.value,
        blogCoverUrl: coverUrl,
        readTimeMinutes: int.tryParse(readTimeController.value) ?? 1,
        createdAt: DateTime.now(),
        likes: 0,
        likedUserIds: [],
        bookmarkedUserIds: [],
        category: category,
      );

      // Save blog to Firestore
      final blogDoc = await FirebaseFirestore.instance
          .collection('blogs')
          .add(blog.toJson());

      final blogId = blogDoc.id;

      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      final tokensToNotify = <Map<String, dynamic>>[];
      for (final doc in usersSnapshot.docs) {
        final data = doc.data();
        final token = data['deviceToken'];
        final receiverId = doc.id;
        if (token != null && token.isNotEmpty && receiverId != user.id) {
          tokensToNotify.add({
            'token': token,
            'receiverId': receiverId,
          });
        }
      }

      final notificationData = {
        'senderId': user.id,
        'senderName': user.userName,
        'senderAvatarUrl': user.userAvatarUrl,
        'message': "New blog uploaded by ${user.userName}: ${titleController.value}",
        'blogId': blogId,
        'type': 'blog',
        'createdAt': FieldValue.serverTimestamp(),
      };

      final serverKeyProvider = get_server_key();
      final serverKey = await serverKeyProvider.server_token();

      for (final item in tokensToNotify) {
        await sendPushNotificationFCMV1(
          deviceToken: item['token'],
          title: "New Blog Published!",
          body: "${user.userName} just posted: ${titleController.value}",
          serverKey: serverKey,
          blogId: blogId,
          senderName: user.userName,
        );
      }

      for (final item in tokensToNotify) {
        final receiverId = item['receiverId'];
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(receiverId)
            .collection('items')
            .add(notificationData);
      }

      resetFields();

      Get.snackbar(
        "Success",
        "Blog Published!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: AppColors.darkGrey,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: AppColors.primary),
      );

      Get.offAll(() => MainScreen());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to publish blog: $e",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPushNotificationFCMV1({
    required String deviceToken,
    required String title,
    required String body,
    required String serverKey,
    required String blogId,
    required String senderName,
  }) async {
    var url = Uri.parse('https://fcm.googleapis.com/v1/projects/peak-catbird-459818-j8/messages:send');
    var payload = {
      "message": {
        "token": deviceToken,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "blogId": blogId,
          "type": "blog",
          "senderName": senderName,
        }
      }
    };

    final response = await http.post(
      url,
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $serverKey',
      },
    );
    if (response.statusCode != 200) {
      print('FCM response code: ${response.statusCode}');
      print('FCM response body: ${response.body}');
    }
  }
}