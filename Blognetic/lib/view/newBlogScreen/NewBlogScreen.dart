import 'dart:io';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/controller/NewBlogController.dart';
import 'package:firebasework/model/UserModel.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:firebasework/view/widgets/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewBlogScreen extends StatelessWidget {
  NewBlogScreen({super.key});

  final controller = Get.put(NewBlogController());
  final List<String> categories = [
    "Technology", "Education", "Health & Wellness", "Travel", "Food", "Business",
    "Science", "Lifestyle", "Entertainment", "Sports", "Art & Design", "News",
    "Personal Development", "Others"
  ];

  Future<UserModel?> getCurrentUserModel() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!, uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: BasicAppbar(
        title: Text('New Blog',style: TextStyle(color: AppColors.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => GestureDetector(
              onTap: controller.pickCoverImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey, width: 1.2),
                ),
                child: controller.pickedImage.value != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    controller.pickedImage.value!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate,
                        color: AppColors.grey, size: 36),
                    const SizedBox(height: 8),
                    Text(
                      "Tap to select a cover image",
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontFamily: 'Satoshi',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 26),
            Obx(() => TextField(
              onChanged: (v) => controller.titleController.value = v,
              decoration: InputDecoration(
                labelText: "Blog Title",
                labelStyle: const TextStyle(color: AppColors.darkGrey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 0.7),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.darkGrey,
              ),
              controller: TextEditingController(text: controller.titleController.value)
                ..selection = TextSelection.collapsed(offset: controller.titleController.value.length),
            )),
            const SizedBox(height: 16),
            Obx(() => TextField(
              onChanged: (v) => controller.subtitleController.value = v,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Blog Subtitle",
                labelStyle: const TextStyle(color: AppColors.darkGrey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 0.7),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.darkGrey,
              ),
              controller: TextEditingController(text: controller.subtitleController.value)
                ..selection = TextSelection.collapsed(offset: controller.subtitleController.value.length),
            )),
            const SizedBox(height: 16),
            Obx(() => TextField(
              onChanged: (v) => controller.readTimeController.value = v,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Read Time (minutes)",
                labelStyle: const TextStyle(color: AppColors.darkGrey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.darkGrey, width: 0.7),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.darkGrey,
              ),
              controller: TextEditingController(text: controller.readTimeController.value)
                ..selection = TextSelection.collapsed(offset: controller.readTimeController.value.length),
            )),
            const SizedBox(height: 18),
            Text(
              "Select Category",
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final selected = controller.selectedCategory.value == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(cat,
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          color: selected ? Colors.white : AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      onSelected: (v) {
                        controller.selectedCategory.value = cat;
                        if (cat != "Others") controller.customCategoryController.value = "";
                      },
                    ),
                  );
                }).toList(),
              ),
            )),
            Obx(() => controller.selectedCategory.value == "Others"
                ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextField(
                onChanged: (v) => controller.customCategoryController.value = v,
                decoration: InputDecoration(
                  labelText: "Your Category",
                  labelStyle: const TextStyle(color: AppColors.darkGrey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primary, width: 0.7),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.darkGrey,
                ),
              ),
            )
                : SizedBox.shrink()
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: Obx(() => AppButton(
                title: controller.isLoading.value ? 'Publishing Blog...' : 'Publish Blog',
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                  final userModel = await getCurrentUserModel();
                  if (userModel == null) {
                    Get.snackbar("Error", "User not found.",
                        backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }
                  await controller.publishBlog(userModel);
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}