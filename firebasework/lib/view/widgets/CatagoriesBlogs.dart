import 'package:firebasework/controller/HomeController.dart';
import 'package:firebasework/view/blogDetailScreen/BlogDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/model/BlogModel.dart';
import 'package:firebasework/view/widgets/BlogCard.dart';
import 'package:get/get.dart';

class CategoriesBlogs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final TextEditingController customCategoryController;
  final Function(String) onCategorySelected;
  final Function(String) onCustomCategoryChanged;
  final List<BlogModel> filteredBlogs;
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatarUrl;

  const CategoriesBlogs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.customCategoryController,
    required this.onCategorySelected,
    required this.onCustomCategoryChanged,
    required this.filteredBlogs,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Column(
      children: [
        // Chips row with shadow and padding
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 4),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == selectedCategory;
                return ChoiceChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.darkGrey,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.grey.shade300,
                      width: isSelected ? 1.2 : 1,
                    ),
                  ),
                  onSelected: (_) => onCategorySelected(cat),
                  elevation: isSelected ? 2 : 0,
                );
              },
            ),
          ),
        ),
        // "Others" TextField with nice margin and rounded border
        if (selectedCategory == "Others")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: TextField(
              controller: customCategoryController,
              onChanged: onCustomCategoryChanged,
              decoration: InputDecoration(
                labelText: "Enter your category",
                labelStyle: const TextStyle(color: AppColors.darkGrey, fontSize: 13),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
          ),
        const SizedBox(height: 10),
        Expanded(
          child: filteredBlogs.isEmpty
              ? Center(
            child: Text(
              selectedCategory == "Others" && customCategoryController.text.isEmpty
                  ? "Enter a category to see blogs."
                  : "No blogs found in this category.",
              style: const TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 15,
                color: AppColors.darkGrey,
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            itemCount: filteredBlogs.length,
            itemBuilder: (context, index) {
              final blog = filteredBlogs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: BlogCard(
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
                  currentUserId: currentUserId,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}