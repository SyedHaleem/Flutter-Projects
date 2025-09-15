import 'dart:io';
import 'package:firebasework/controller/EditProfileController.dart';
import 'package:firebasework/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/view/widgets/AppButton.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController ctrl = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BasicAppbar(
        title: Text('Edit Profile', style: TextStyle(color: AppColors.primary),),
      ),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: ctrl.selectedImage.value != null
                      ? FileImage(ctrl.selectedImage.value!)
                      : (ctrl.avatarUrl.value.isNotEmpty
                      ? NetworkImage(ctrl.avatarUrl.value)
                      : null) as ImageProvider?,
                  child: (ctrl.selectedImage.value == null && ctrl.avatarUrl.value.isEmpty)
                      ? Icon(Icons.account_circle_rounded, size: 100, color: Colors.grey.shade400)
                      : null,
                ),
                Positioned(
                  top: 68,
                  left: 68,
                  child: GestureDetector(
                    onTap: () => ctrl.pickImage(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              ctrl.userName.value.isNotEmpty
                  ? ctrl.userName.value
                  : 'No Name',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              ctrl.email.value.isNotEmpty
                  ? ctrl.email.value
                  : 'No Email',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: ctrl.nameController,
              readOnly: false,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                ),
              ),
            ),
            const SizedBox(height: 50),
            AppButton(
              onPressed: ctrl.isSaving.value ? null : () => ctrl.saveProfile(context),
              title: ctrl.isSaving.value ? 'Saving...' : 'Save',
            ),
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}