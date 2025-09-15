import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebasework/controller/HomeController.dart';
import 'package:firebasework/model/BlogModel.dart';
import 'package:firebasework/view/widgets/BlogCard.dart';
import 'package:firebasework/view/blogDetailScreen/BlogDetailScreen.dart';

class TrendingBlogs extends StatelessWidget {
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatarUrl;

  const TrendingBlogs({
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatarUrl,
    super.key,
  });

  // Trending logic: Only recent blogs, score by (likes * 2) + bookmarks
  List<BlogModel> getTrendingBlogs(List<BlogModel> blogs) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    // Filter for recent blogs (last 30 days)
    final recentBlogs = blogs.where((blog) {
      return blog.createdAt.isAfter(thirtyDaysAgo);
    }).toList();

    // Sort by score descending (score = likes * 2 + bookmarks)
    recentBlogs.sort((a, b) {
      int aScore = (a.likes * 2) + a.bookmarkedUserIds.length;
      int bScore = (b.likes * 2) + b.bookmarkedUserIds.length;
      return bScore.compareTo(aScore); // descending
    });

    return recentBlogs;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() {
      final trendingBlogs = getTrendingBlogs(controller.blogs);
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (trendingBlogs.isEmpty) {
        return const Center(child: Text('No trending blogs found.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: trendingBlogs.length,
        itemBuilder: (context, index) {
          final blog = trendingBlogs[index];
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