import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasework/model/BlogModel.dart';
import 'package:firebasework/model/CommentModel.dart';
import 'package:firebasework/model/serverkey.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BlogDetailController extends GetxController {
  final BlogModel blog;
  BlogDetailController(this.blog);

  final comments = <CommentModel>[].obs;
  final commentController = TextEditingController();
  final isSending = false.obs;
  final isLoadingComments = true.obs;

  late final StreamSubscription _commentSub;

  @override
  void onInit() {
    super.onInit();
    _commentSub = FirebaseFirestore.instance
        .collection('blogs')
        .doc(blog.id)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
      comments.value = snapshot.docs.map((doc) => CommentModel.fromJson(doc.data(), doc.id)).toList();
      isLoadingComments.value = false;
    });
  }

  Future<void> sendComment({
    required String userId,
    required String userName,
    required String userAvatarUrl,
  }) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    isSending.value = true;
    await FirebaseFirestore.instance
        .collection('blogs')
        .doc(blog.id)
        .collection('comments')
        .add({
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'commentText': text,
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Send notification to blog owner (if not commenting on own post)
    if (userId != blog.userId) {
      await sendNotificationToBlogOwnerOnComment(
        senderId: userId,
        senderName: userName,
        senderAvatarUrl: userAvatarUrl,
        receiverId: blog.userId,
        blogId: blog.id,
        commentText: text,
      );
    }

    commentController.clear();
    isSending.value = false;
  }

  Future<void> sendNotificationToBlogOwnerOnComment({
    required String senderId,
    required String senderName,
    required String senderAvatarUrl,
    required String receiverId,
    required String blogId,
    required String commentText,
  }) async {
    String message = '$senderName commented on your post.';

    // 1. Save to Firestore (in-app notification)
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(receiverId)
        .collection('items')
        .add({
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'message': message,
      'blogId': blogId,
      'type': 'comment',
      'commentText': commentText,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Get device token of blog owner
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(receiverId).get();
    final deviceToken = userDoc.data()?['deviceToken'];
    if (deviceToken == null || deviceToken.isEmpty) return;

    // 3. Get FCM server key (OAuth2 Bearer token)
    final serverKeyProvider = get_server_key();
    final serverKey = await serverKeyProvider.server_token();

    // 4. Prepare FCM v1 payload
    var url = Uri.parse('https://fcm.googleapis.com/v1/projects/peak-catbird-459818-j8/messages:send');
    var payload = {
      "message": {
        "token": deviceToken,
        "notification": {
          "title": "New Comment",
          "body": "$senderName commented: $commentText",
          },
        "data": {
          "blogId": blogId,
          "type": "comment",
          "senderName": senderName,
          "commentText": commentText,
        }
      }
    };

    // 5. Send push notification
    final response = await http.post(
      url,
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $serverKey',
      },
    );
    print('FCM response code: ${response.statusCode}');
    print('FCM response body: ${response.body}');
  }

  @override
  void onClose() {
    _commentSub.cancel();
    super.onClose();
  }
}