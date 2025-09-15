import 'package:firebasework/model/serverkey.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebasework/model/BlogModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:firebasework/controller/UserProfileController.dart';
import 'package:firebasework/controller/NotificationServices.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var blogs = <BlogModel>[].obs;
  var isLoading = true.obs;
  var bookmarkedBlogs = <BlogModel>[].obs;
  late Stream<List<BlogModel>> blogStream;
  final AdvancedDrawerController advancedDrawerController = AdvancedDrawerController();
  final customCategoryController = TextEditingController();

  // Search state
  final searchQuery = ''.obs;
  final isSearching = false.obs;
  var searchResults = <BlogModel>[].obs;

  // User ID
  final currentUserId = ''.obs;

  // Categories logic
  final categories = [
    "Technology", "Education", "Health & Wellness", "Travel", "Food", "Business",
    "Science", "Lifestyle", "Entertainment", "Sports", "Art & Design", "News",
    "Personal Development", "Others"
  ];
  var selectedCategory = "Technology".obs;
  var customCategory = "".obs;

  final NotificationServices notificationServices = NotificationServices();

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);

    blogStream = FirebaseFirestore.instance
        .collection('blogs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => BlogModel.fromJson(doc.data(), doc.id))
        .toList());

    blogStream.listen((blogList) {
      blogs.value = blogList;
      updateBookmarkedBlogs();
      isLoading.value = false;
      if (isSearching.value && searchQuery.value.trim().isNotEmpty) {
        onSearch(searchQuery.value);
      }
    });

    super.onInit();
  }

  void setCurrentUserId(String id) {
    if (currentUserId.value != id) {
      currentUserId.value = id;
      updateBookmarkedBlogs();
    }
  }

  void updateBookmarkedBlogs() {
    if (currentUserId.value.isEmpty) return;
    bookmarkedBlogs.value = blogs.where((blog) =>
        blog.bookmarkedUserIds.contains(currentUserId.value)).toList();
  }

  // --- Categories Tab logic ---
  void selectCategory(String cat) {
    selectedCategory.value = cat;
    if (cat != "Others") customCategory.value = "";
  }

  void setCustomCategory(String val) {
    customCategoryController.text = val;
    customCategory.value = val;
  }

  List<BlogModel> get filteredCategoryBlogs {
    if (selectedCategory.value == "Others") {
      final query = customCategory.value.trim().toLowerCase();
      if (query.isEmpty) return [];
      return blogs.where((blog) {
        final cat = blog.category.trim().toLowerCase();
        return cat.contains(query);
      }).toList();
    }
    // For regular categories, still match exactly
    return blogs.where((blog) => blog.category == selectedCategory.value).toList();
  }
  // --- End Categories Tab logic ---

  DocumentReference getBlogDocRef(String blogId) {
    return FirebaseFirestore.instance.collection('blogs').doc(blogId);
  }

  void onSearch(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      isSearching.value = false;
      searchResults.clear();
    } else {
      isSearching.value = true;
      final lowerQuery = query.trim().toLowerCase();
      searchResults.value = blogs.where((blog) {
        final title = blog.blogTitle.toLowerCase();
        final userName = blog.userName.toLowerCase();
        return title.contains(lowerQuery) || userName.contains(lowerQuery);
      }).toList();
    }
  }

  Future<void> toggleBookmark(BlogModel blog, bool isBookmarked) async {
    final docRef = getBlogDocRef(blog.id);
    final uid = currentUserId.value;
    if (uid.isEmpty) return;
    if (isBookmarked) {
      await docRef.update({
        'bookmarkedUserIds': FieldValue.arrayUnion([uid]),
      });

      if (uid != blog.userId) {
        final userProfileCtrl = Get.find<UserProfileController>();
        await sendNotificationOnLikeOrBookmark(
          senderId: uid,
          senderName: userProfileCtrl.userName.value,
          senderAvatarUrl: userProfileCtrl.avatarUrl.value,
          receiverId: blog.userId,
          blogId: blog.id,
          type: 'bookmark',
        );
      }
    } else {
      await docRef.update({
        'bookmarkedUserIds': FieldValue.arrayRemove([uid]),
      });
    }
  }


  Future<void> toggleLike(BlogModel blog, bool isLiked) async {
    final docRef = getBlogDocRef(blog.id);
    final uid = currentUserId.value;
    if (uid.isEmpty) return;
    if (isLiked) {
      await docRef.update({
        'likedUserIds': FieldValue.arrayUnion([uid]),
        'likes': FieldValue.increment(1),
      });

      if (uid != blog.userId) {
        final userProfileCtrl = Get.find<UserProfileController>();
        await sendNotificationOnLikeOrBookmark(
          senderId: uid,
          senderName: userProfileCtrl.userName.value,
          senderAvatarUrl: userProfileCtrl.avatarUrl.value,
          receiverId: blog.userId,
          blogId: blog.id,
          type: 'like',
        );
      }
    } else {
      await docRef.update({
        'likedUserIds': FieldValue.arrayRemove([uid]),
        'likes': FieldValue.increment(-1),
      });
    }
  }


  Future<void> sendNotificationOnLikeOrBookmark({
    required String senderId,
    required String senderName,
    required String senderAvatarUrl,
    required String receiverId,
    required String blogId,
    required String type,
  }) async {
    String message = type == 'like'
        ? '$senderName liked your post.'
        : '$senderName bookmarked your post.';

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
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(receiverId).get();
    final deviceToken = userDoc.data()?['deviceToken'];
    if (deviceToken == null || deviceToken.isEmpty) return;

    final serverKeyProvider = get_server_key();
    final serverKey = await serverKeyProvider.server_token();

    var url = Uri.parse('https://fcm.googleapis.com/v1/projects/peak-catbird-459818-j8/messages:send');
    var payload = {
      "message": {
        "token": deviceToken,
        "notification": {
          "title": "Blog Update",
          "body": message,
        },
        "data": {
          "blogId": blogId,
          "type": type,
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
    print('FCM response code: ${response.statusCode}');
    print('FCM response body: ${response.body}');
  }

  void openDrawer() {
    advancedDrawerController.showDrawer();
  }
}