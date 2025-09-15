import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasework/model/BlogModel.dart';
import 'package:firebasework/controller/EditBlogController.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/view/widgets/CustomBottomModalSheet.dart';

class BlogCardController extends GetxController {
  Future<void> showEditBlogSheet(BuildContext context, BlogModel blog, EditBlogController controller) async {
    final titleController = TextEditingController(text: blog.blogTitle);
    final subtitleController = TextEditingController(text: blog.blogSubtitle);
    final readTimeController = TextEditingController(text: blog.readTimeMinutes.toString());
    final categoryController = TextEditingController(text: blog.category);

    await CustomBottomModalSheet.showEditBlogSheet(
      context: context,
      titleController: titleController,
      subtitleController: subtitleController,
      readTimeController: readTimeController,
      categoryController: categoryController,
      initialCategory: blog.category,
      controller: controller,
      onUpdate: (title, subtitle, readTime, category) async {
        try {
          await FirebaseFirestore.instance.collection('blogs').doc(blog.id).update({
            'blogTitle': title,
            'blogSubtitle': subtitle,
            'readTimeMinutes': readTime,
            'category': category,
          });
          Get.snackbar(
            'Success',
            'Blog updated successfully!',
            backgroundColor: Colors.white,
            colorText: AppColors.darkGrey,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.check_circle, color: AppColors.primary),
          );
        } catch (e) {
          Get.snackbar(
            'Failed',
            'Failed to update blog: $e',
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.error, color: Colors.red),
          );
        }
      },
    );
  }

  Future<bool> showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 50, backgroundColor: Colors.red.shade50,child: Image.asset('assets/vectors/deleteIcon.png', width: 50, height: 50)),
            const Divider(),
          ],
        ),
        content: const Text('Are you sure you want to delete this blog? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: AppColors.darkGrey)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> deleteBlogWithImage(BuildContext context, String blogId, String blogCoverUrl) async {
    try {
      await FirebaseFirestore.instance.collection('blogs').doc(blogId).delete();

      if (blogCoverUrl.isNotEmpty) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(blogCoverUrl);
          await ref.delete();
        } catch (e) {}
      }

      Get.snackbar(
        'Deleted',
        'Blog deleted successfully!',
        backgroundColor: Colors.white,
        colorText: AppColors.darkGrey,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.delete, color: AppColors.primary),
      );
    } catch (e) {
      Get.snackbar(
        'Failed',
        'Failed to delete blog: $e',
        backgroundColor: Colors.red,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.red),
      );
    }
  }
}