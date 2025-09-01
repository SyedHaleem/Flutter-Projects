import 'package:flutter/material.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  const AppButton({super.key, required this.onPressed, required this.title,  this.height,});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(height ?? 80),
        backgroundColor: AppColors.primary,
          foregroundColor: AppColors.lightBackground,
        ),
        onPressed: onPressed, child: Text(title));
  }
}
