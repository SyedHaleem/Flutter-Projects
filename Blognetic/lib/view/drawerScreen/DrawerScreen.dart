import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasework/controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/controller/UserProfileController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebasework/view/authScreen/LoginScreen.dart';

class DrawerScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onContactTap;

  const DrawerScreen({
    super.key,
    this.onProfileTap,
    this.onSettingsTap, this.onPrivacyTap, this.onContactTap,
  });

  Future<void> _handleSignOut(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 50,backgroundColor: Colors.green.shade50,child: Center(child: Image.asset('assets/vectors/logoutIcon.png',width: 100,height: 100,))),
          const Divider(),
        ],
      ),
        // title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: AppColors.darkGrey)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      bool isGoogle = false;
      for (final info in user.providerData) {
        if (info.providerId == 'google.com') {
          isGoogle = true;
          break;
        }
      }

      try {
        final advancedDrawerController = Get.find<HomeController>().advancedDrawerController;
        advancedDrawerController.hideDrawer();
        await Future.delayed(const Duration(milliseconds: 250));
        final uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'deviceToken': '',
        });
        if (isGoogle) {
          final googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
        }
        await FirebaseAuth.instance.signOut();
        Get.offAll(LoginScreen());
      } catch (e) {
        Get.snackbar('Error', "Error signing out: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileController = Get.find<UserProfileController>();
    double drawerWidth = MediaQuery.of(context).size.width * 0.8;

    return SafeArea(
      child: Container(
        width: drawerWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.7),
              blurRadius: 10,
              offset: const Offset(6, 2),
            ),
          ],
        ),
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: AppColors.primary,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(() {
                if (userProfileController.isLoading.value) {
                  return Container(
                    width: 110,
                    height: 110,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                final profileImagePath = userProfileController.avatarUrl.value;
                final cacheBuster = userProfileController.avatarCacheBuster.value;
                return Container(
                  width: 110.0,
                  height: 110.0,
                  margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: profileImagePath.isNotEmpty
                      ? (profileImagePath.startsWith('http')
                      ? Image.network(
                    "$profileImagePath?t=$cacheBuster", // ADD cacheBuster
                    fit: BoxFit.cover,
                  )
                      : Image.asset(profileImagePath, fit: BoxFit.cover))
                      : Icon(Icons.account_circle_rounded, size: 80, color: AppColors.primary),
                );
              }),
              Obx(() => Text(
                userProfileController.userName.value.isNotEmpty
                    ? userProfileController.userName.value
                    : 'No Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              )),
              Obx(() => Text(
                userProfileController.email.value.isNotEmpty
                    ? userProfileController.email.value
                    : 'No Email',
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 15,
                ),
              )),
              const SizedBox(height: 32),
              ListTile(
                splashColor: Color(0xFFB6F5C9),
                leading: Icon(Icons.person_outline, color: AppColors.grey),
                title: const Text('Profile',style: TextStyle(color:AppColors.primary)),
                onTap: onProfileTap,
              ),
              ListTile(
                splashColor: Color(0xFFB6F5C9),
                leading: Icon(Icons.settings, color: AppColors.grey),
                title: const Text('Settings',style: TextStyle(color:AppColors.primary),),
                onTap: onSettingsTap,
              ),
              ListTile(
                splashColor: Color(0xFFB6F5C9),
                leading: Icon(Icons.privacy_tip, color: AppColors.grey),
                title: const Text('Privacy Policy',style: TextStyle(color:AppColors.primary),),
                onTap: onPrivacyTap,
              ),
              ListTile(
                splashColor: Color(0xFFB6F5C9),
                leading: Icon(Icons.call, color: AppColors.grey),
                title: const Text('Contact Us',style: TextStyle(color:AppColors.primary),),
                onTap: onContactTap,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.logout,color: Colors.white,),
                  label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => _handleSignOut(context),
                ),
              ),
              DefaultTextStyle(
                style: TextStyle(fontSize: 12, color: Colors.black),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}