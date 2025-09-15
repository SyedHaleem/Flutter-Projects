import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/controller/HomeController.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:firebasework/view/widgets/AppRefreshIndicator.dart';
import 'package:firebasework/view/widgets/BlogCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({super.key});
  final HomeController controller = Get.find<HomeController>();
  Future<void> _refreshBookmarks() async {
    // If not, you can call reloadBlogs() or your refresh logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBackBtn: true,
        title: Text('Bookmarked', style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold),),
      ),
      body: AppRefreshIndicator(
    onRefresh: _refreshBookmarks,
    child: Obx(() {
        final currentUserId = controller.currentUserId.value; // <-- FIXED
        final bookmarkedBlogs = controller.bookmarkedBlogs;
        if (bookmarkedBlogs.isEmpty) {
          return const Center(child: Text('No bookmarks yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: bookmarkedBlogs.length,
          itemBuilder: (context, index) {
            final blog = bookmarkedBlogs[index];
            return BlogCard(
              blog: blog,
              isLiked: blog.likedUserIds.contains(currentUserId),       // <-- FIXED
              isBookmarked: blog.bookmarkedUserIds.contains(currentUserId), // <-- FIXED
              onLikeChanged: (isLiked) async =>
              await controller.toggleLike(blog, isLiked),
              onBookmarkChanged: (isBookmarked) async =>
              await controller.toggleBookmark(blog, isBookmarked),
              onTap: () {},
              // onMore: () {},
              currentUserId: currentUserId,
            );
          },
        );
      }),
      ),
    );
  }
}