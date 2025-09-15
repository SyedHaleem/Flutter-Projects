import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/controller/BlogDetailController.dart';
import 'package:firebasework/model/BlogModel.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatarUrl;
  BlogDetailScreen({
    required this.blog,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatarUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(BlogDetailController(blog));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppbar(
        title: Text('Blog Details', style: TextStyle(color: AppColors.primary)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(blog.userAvatarUrl),
                      radius: 25,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            blog.timeAgo,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _NetworkImageWithLoader(url: blog.blogCoverUrl),
                ),
                const SizedBox(height: 16),
                Text(blog.blogTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                const SizedBox(height: 4),
                Text(blog.blogSubtitle, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 20),
                const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                const SizedBox(height: 10),
                Obx(() {
                  if (ctrl.isLoadingComments.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36.0),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }
                  if (ctrl.comments.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(child: Text('No comments yet', style: TextStyle(color: Colors.grey))),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ctrl.comments.length,
                    itemBuilder: (context, index) {
                      final comment = ctrl.comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(comment.userAvatarUrl),
                              radius: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          comment.userName,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _commentTimeAgo(comment.createdAt),
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(comment.commentText),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: 75), // Leave space for bottom comment bar
              ],
            ),
          ),
          // Comment input at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl.commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.green.shade100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() => IconButton(
                  icon: Icon(Icons.send, color: AppColors.primary, size: 32),
                  onPressed: ctrl.isSending.value ? null : () {
                    ctrl.sendComment(
                      userId: currentUserId,
                      userName: currentUserName,
                      userAvatarUrl: currentUserAvatarUrl,
                    );
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper for "time ago" for comments
  String _commentTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

/// Professional network image widget with loader/error handling for slow/no network.
class _NetworkImageWithLoader extends StatelessWidget {
  final String url;
  const _NetworkImageWithLoader({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 180,
          width: double.infinity,
          color: AppColors.grey.withOpacity(0.08),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        height: 180,
        width: double.infinity,
        color: AppColors.grey,
        child: const Center(child: Icon(Icons.broken_image, color: AppColors.darkGrey)),
      ),
    );
  }
}