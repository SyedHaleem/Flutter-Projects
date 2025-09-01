import 'package:flutter/material.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/view/widgets/AppButton.dart';
import 'package:get/get.dart';
import 'package:firebasework/controller/EditBlogController.dart';

class CustomBottomModalSheet {
  static Future<T?> showEditBlogSheet<T>({
    required BuildContext context,
    required TextEditingController titleController,
    required TextEditingController subtitleController,
    required TextEditingController readTimeController,
    required TextEditingController? categoryController, // For custom category text
    required String initialCategory,
    required Future<void> Function(String title, String subtitle, int readTime, String category) onUpdate,
    required EditBlogController controller,
  }) {
    // Categories
    final List<String> categories = [
      "Technology", "Education", "Health & Wellness", "Travel", "Food", "Business",
      "Science", "Lifestyle", "Entertainment", "Sports", "Art & Design", "News",
      "Personal Development", "Others"
    ];
    final RxString selectedCategory =
    RxString(categories.contains(initialCategory) ? initialCategory : "Others");

    // Only use categoryController if "Others" is selected
    categoryController ??= TextEditingController(text: categories.contains(initialCategory) ? "" : initialCategory);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 32,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Blog",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.primary,
                    fontFamily: 'Satoshi',
                  ),
                ),
                const SizedBox(height: 26),
                TextField(
                  controller: titleController,
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
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: subtitleController,
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
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: readTimeController,
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
                ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final selected = selectedCategory.value == cat;
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
                            setState(() {
                              selectedCategory.value = cat;
                              if (cat != "Others") categoryController!.text = "";
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                selectedCategory.value == "Others"
                    ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: categoryController,
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
                    : const SizedBox.shrink(),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => AppButton(
                    title: controller.isUpdating.value ? 'Updating Blog...' : 'Update Blog',
                    onPressed: controller.isUpdating.value
                        ? null
                        : () async {
                      final updatedTitle = titleController.text.trim();
                      final updatedSubtitle = subtitleController.text.trim();
                      final updatedReadTime = int.tryParse(readTimeController.text.trim()) ?? 1;
                      final updatedCategory = selectedCategory.value == "Others"
                          ? categoryController!.text.trim()
                          : selectedCategory.value;

                      if (updatedTitle.isEmpty) {
                        Get.snackbar("Error", "Blog title cannot be empty",
                            backgroundColor: Colors.red.shade100,
                            colorText: Colors.red.shade900);
                        return;
                      }
                      if (updatedCategory.isEmpty) {
                        Get.snackbar("Error", "Please select a category",
                            backgroundColor: Colors.red.shade100,
                            colorText: Colors.red.shade900);
                        return;
                      }

                      controller.isUpdating.value = true;
                      await onUpdate(
                        updatedTitle,
                        updatedSubtitle,
                        updatedReadTime,
                        updatedCategory,
                      );
                      controller.isUpdating.value = false;

                      Navigator.of(context).pop();
                    },
                    height: 54,
                  )),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}