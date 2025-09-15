import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebasework/controller/HomeController.dart';
import 'package:firebasework/view/widgets/BlogCard.dart';
import 'package:firebasework/view/blogDetailScreen/BlogDetailScreen.dart';

class SearchBlogs extends StatelessWidget {
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatarUrl;

  const SearchBlogs({
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() {
      if (controller.searchResults.isEmpty) {
        return Center(child: Text('No blogs found.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final blog = controller.searchResults[index];
          return BlogCard(
            blog: blog,
            isLiked: blog.likedUserIds.contains(currentUserId),
            isBookmarked: blog.bookmarkedUserIds.contains(currentUserId),
            onLikeChanged: (isLiked) async {
              await controller.toggleLike(blog, isLiked);
            },
            onBookmarkChanged: (isBookmarked) async {
              await controller.toggleBookmark(blog, isBookmarked);
            },
            onTap: () {
              Get.to(() => BlogDetailScreen(
                blog: blog,
                currentUserId: currentUserId,
                currentUserName: currentUserName,
                currentUserAvatarUrl: currentUserAvatarUrl,
              ));
            },
            // onMore: () {},
            currentUserId: currentUserId,
          );
        },
      );
    });
  }
}