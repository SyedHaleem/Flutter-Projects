import 'package:firebasework/controller/MainScreenController.dart';
import 'package:firebasework/controller/NotificationController.dart';
import 'package:firebasework/view/newBlogScreen/NewBlogScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebasework/view/homeScreen/HomeScreen.dart';
import 'package:firebasework/view/bookmarkScreen/BookmarkScreen.dart';
import 'package:firebasework/view/notificationScreen/NotificationScreen.dart';
import 'package:firebasework/view/profileScreens/ProfileScreen.dart';
import 'package:firebasework/view/widgets/CustomBottomNavigationBar.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  final int initialTab;
  MainScreen({super.key, this.initialTab = 0});

  final MainScreenController controller = Get.put(MainScreenController());
  final NotificationController notificationController = Get.put(NotificationController());

  final List<Widget> _screens = [
    HomeScreen(),
    BookmarkScreen(),
    NotificationScreen(),
    ProfileScreen(), // Add your profile screen here
  ];

  void _onAddBlog() {
    Get.to(NewBlogScreen());
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.tabInitialized) {
      controller.selectedIndex.value = initialTab;
      controller.tabInitialized = true;
    }

    return Obx(() => Scaffold(
      body: IndexedStack(
        index: controller.selectedIndex.value,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTabChanged: (index) {
          controller.changeTab(index);
          // If notification tab is opened, mark all as read
          if (index == 2) {
            notificationController.markAllAsRead();
          }
        },
        onAddBlog: _onAddBlog,
      ),
    ));
  }
}