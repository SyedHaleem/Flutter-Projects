import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasework/controller/HomeController.dart';
import 'package:firebasework/controller/UserProfileController.dart';
import 'package:firebasework/view/blogDetailScreen/BlogDetailScreen.dart';
import 'package:firebasework/view/widgets/AppRefreshIndicator.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:firebasework/view/widgets/BlogCard.dart';
import 'package:firebasework/view/widgets/CatagoriesBlogs.dart';
import 'package:firebasework/view/widgets/CustomSearchAndButton.dart';
import 'package:firebasework/view/drawerScreen/DrawerScreen.dart';
import 'package:firebasework/view/privacyPolicyScreen/PrivacyPolicyScreen.dart';
import 'package:firebasework/view/contactUsScreen/ContactUsScreen.dart';
import 'package:firebasework/view/profileScreens/ProfileScreen.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/view/widgets/SearchBlogs.dart';
import 'package:firebasework/view/widgets/TrendingBlogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.find<HomeController>();
  final UserProfileController userProfileController =
  Get.find<UserProfileController>();

  Future<void> _refreshData() async {
    await userProfileController.refreshProfile();
  }

  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? "";
  final customCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: controller.advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      backdrop: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      drawer: DrawerScreen(
        onProfileTap: () {
          Get.to(ProfileScreen());
        },
        onSettingsTap: () {},
        onPrivacyTap: () {
          Get.to(PrivacyPolicyScreen());
        },
        onContactTap: () {
          Get.to(ContactUsScreen());
        },
      ),
      child: Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: BasicAppbar(
          isCircleAvatar: true,
          avatarUrl: userProfileController.avatarUrl.value.isNotEmpty
              ? "${userProfileController.avatarUrl.value}?t=${userProfileController.avatarCacheBuster.value}" // ADD cacheBuster
              : null,
          title: Image.asset('assets/vectors/Blog_logo.png',
              width: 200, height: 200),
          onAvatarTap: controller.openDrawer,
        ),
        body: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CustomSearchAndButton(
                onSearch: controller.onSearch, // Only triggers on button tap
              ),
            ),
            TabBar(
              controller: controller.tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding:
              const EdgeInsets.symmetric(vertical: 40, horizontal: 5),
              dividerColor: Colors.transparent,
              labelColor: context.isDarkMode ? Colors.white : Colors.black,
              indicatorColor: AppColors.primary,
              tabs: const [
                Text('All',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                Text('Trending',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                Text('Following',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                Text('Categories',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  // "All" Tab with RefreshIndicator
                  AppRefreshIndicator(
                    onRefresh: _refreshData,
                    child: Obx(() {
                      if (controller.isSearching.value) {
                        // Show search results only
                        return SearchBlogs(
                          currentUserId: currentUserId,
                          currentUserName: userProfileController.userName.value,
                          currentUserAvatarUrl: userProfileController.avatarUrl.value,
                        );
                      } else {
                        // Show all blogs
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (controller.blogs.isEmpty) {
                          return Center(child: Text('No blogs found.'));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: controller.blogs.length,
                          itemBuilder: (context, index) {
                            final blog = controller.blogs[index];
                            return BlogCard(
                              blog: blog,
                              isLiked: blog.likedUserIds.contains(currentUserId),
                              isBookmarked: blog.bookmarkedUserIds
                                  .contains(currentUserId),
                              onLikeChanged: (isLiked) async {
                                await controller.toggleLike(blog, isLiked);
                              },
                              onBookmarkChanged: (isBookmarked) async {
                                await controller.toggleBookmark(
                                    blog, isBookmarked);
                              },
                              onTap: () {
                                Get.to(() => BlogDetailScreen(
                                  blog: blog,
                                  currentUserId: currentUserId,
                                  currentUserName:
                                  userProfileController.userName.value,
                                  currentUserAvatarUrl:
                                  userProfileController.avatarUrl.value,
                                ));
                              },
                              // onMore: () {},
                              currentUserId: currentUserId,
                            );
                          },
                        );
                      }
                    }),
                  ),
                  TrendingBlogs(
                    currentUserId: currentUserId,
                    currentUserName: userProfileController.userName.value,
                    currentUserAvatarUrl: userProfileController.avatarUrl.value,
                  ),
                  Center(child: Text('Following Content')),
                  Obx(() => CategoriesBlogs(
                    categories: controller.categories,
                    selectedCategory: controller.selectedCategory.value,
                    customCategoryController: customCategoryController,
                    onCategorySelected: controller.selectCategory,
                    onCustomCategoryChanged: (val) {
                      controller.setCustomCategory(val);
                    },
                    filteredBlogs: controller.filteredCategoryBlogs,
                    currentUserId: currentUserId,
                    currentUserName: userProfileController.userName.value,
                    currentUserAvatarUrl: userProfileController.avatarUrl.value,
                  )),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}