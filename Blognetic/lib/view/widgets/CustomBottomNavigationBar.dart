import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:get/get.dart';
import 'package:firebasework/controller/NotificationController.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onAddBlog;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.onAddBlog,
  });

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.find<NotificationController>();

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Obx(() => GNav(
                selectedIndex: currentIndex,
                onTabChange: onTabChanged,
                textStyle: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF42C83C),
                ),
                tabBorderRadius: 12,
                backgroundColor: Colors.white,
                color: const Color(0xFF8696BB),
                activeColor: const Color(0xFF42C83C),
                tabBackgroundColor: const Color(0xFF42C83C).withOpacity(0.1),
                padding: const EdgeInsets.all(14),
                tabs: [
                  const GButton(icon: Icons.home, iconSize: 24, text: 'Home', gap: 2),
                  const GButton(icon: Icons.bookmark_add, iconSize: 24, text: 'Bookmark', gap: 2),
                  GButton(
                    icon: Icons.notifications,
                    iconSize: 24,
                    text: 'Notifications',
                    gap: 2,
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 24,
                          color: currentIndex == 2
                              ? const Color(0xFF42C83C) // active color
                              : const Color(0xFF8696BB), // normal color like other icons
                        ),
                        if (notificationController.unreadCount.value > 0)
                          Positioned(
                            right: -2,
                            top: -5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '${notificationController.unreadCount.value}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const GButton(icon: Icons.manage_accounts, iconSize: 24, text: 'Account', gap: 2),
                ],
              )),
            ),
          ),
          Positioned(
            top: -35,
            child: GestureDetector(
              onTap: onAddBlog,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey,
                      blurRadius: 8,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}