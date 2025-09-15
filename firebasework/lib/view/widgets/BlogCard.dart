import 'package:firebasework/controller/EditBlogController.dart';
import 'package:firebasework/controller/BlogCardController.dart';
import 'package:firebasework/view/widgets/BeautifulPopupMenuButton.dart';
import 'package:flutter/material.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/model/BlogModel.dart';
import 'package:get/get.dart';

class BlogCard extends StatelessWidget {
  final BlogModel blog;
  final bool isLiked;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final Future<void> Function(bool isLiked)? onLikeChanged;
  final Future<void> Function(bool isBookmarked)? onBookmarkChanged;
  final String currentUserId;

  const BlogCard({
    super.key,
    required this.blog,
    required this.isLiked,
    required this.isBookmarked,
    required this.currentUserId,
    this.onTap,
    this.onLikeChanged,
    this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isOwnBlog = blog.userId == currentUserId;
    final editBlogController = Get.put(EditBlogController(), tag: 'editBlog_${blog.id}');
    final blogCardController = Get.put(BlogCardController(), tag: 'card_${blog.id}');

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: AppColors.lightBackground,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: blog.userAvatarUrl.isNotEmpty
                        ? NetworkImage(blog.userAvatarUrl)
                        : null,
                    child: blog.userAvatarUrl.isEmpty
                        ? const Icon(Icons.person, color: AppColors.darkGrey)
                        : null,
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
                            fontSize: 15,
                            color: AppColors.darkGrey,
                            fontFamily: 'Satoshi',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          blog.timeAgo,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isOwnBlog)
                    BeautifulPopupMenuButton(
                      onEdit: () => blogCardController.showEditBlogSheet(context, blog, editBlogController),
                      onDelete: () async {
                        final confirmed = await blogCardController.showDeleteConfirmation(context);
                        if (confirmed) {
                          await blogCardController.deleteBlogWithImage(context, blog.id, blog.blogCoverUrl);
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (blog.blogCoverUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _NetworkImageWithLoader(url: blog.blogCoverUrl),
                ),
              if (blog.blogCoverUrl.isNotEmpty) const SizedBox(height: 14),
              Text(
                blog.blogTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGrey,
                  fontFamily: 'Satoshi',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                blog.blogSubtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                  fontFamily: 'Satoshi',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  Icon(Icons.timer, color: AppColors.primary, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "${blog.readTimeMinutes} min read",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Satoshi',
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (onLikeChanged != null) await onLikeChanged!(!isLiked);
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? AppColors.primary : AppColors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        blog.likes.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  GestureDetector(
                    onTap: () async {
                      if (onBookmarkChanged != null) await onBookmarkChanged!(!isBookmarked);
                    },
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? AppColors.primary : AppColors.grey,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkImageWithLoader extends StatelessWidget {
  final String url;
  const _NetworkImageWithLoader({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: 175,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 175,
          width: double.infinity,
          color: AppColors.grey.withOpacity(0.08),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 4),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        height: 175,
        width: double.infinity,
        color: AppColors.grey,
        child: const Center(child: Icon(Icons.broken_image, color: AppColors.darkGrey)),
      ),
    );
  }
}