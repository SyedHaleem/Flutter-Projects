import 'package:firebasework/view/profileScreens/EditProfileScreen.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebasework/controller/UserProfileController.dart';
import 'package:firebasework/config/theme/app_Color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileController = Get.find<UserProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppbar(
        title: Text('Profile',style: TextStyle(color: AppColors.primary),),
        actions: [Padding(padding: EdgeInsets.only(right: 10,bottom: 5),child: Image.asset('assets/vectors/edit.png',height: 35,width: 35,fit: BoxFit.cover,))],
      onActionsTap: (){ Get.to(EditProfileScreen());},
      ),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: userProfileController.avatarUrl.value.isNotEmpty
                    ? NetworkImage(userProfileController.avatarUrl.value)
                    : null,
                child: userProfileController.avatarUrl.value.isEmpty
                    ? Icon(Icons.account_circle_rounded, size: 100, color: Colors.grey.shade400)
                    : null,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              userProfileController.userName.value.isNotEmpty
                  ? userProfileController.userName.value
                  : 'No Name',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              userProfileController.email.value.isNotEmpty
                  ? userProfileController.email.value
                  : 'No Email',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            _ProfileInfoTile(
              icon: Icons.person,
              label: userProfileController.userName.value, // Replace with user's date of birth if available
            ),
            const SizedBox(height: 20),
            const Divider(height: 24, thickness: 1.2),
          const SizedBox(height: 20),
            _ProfileInfoTile(
              icon: Icons.email_outlined,
              label: userProfileController.email.value,
            ),


          ],
        ),
      )),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ProfileInfoTile({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.grey, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, color: AppColors.darkGrey, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  final String label;
  const _ReadonlyField({required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _TagButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TagButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Text(label, style: const TextStyle(fontSize: 15, color: Colors.black54)),
      ),
    );
  }
}