import 'package:cofee_shop/config/Colors.dart';
import 'package:flutter/material.dart';

class customIncDecBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  const customIncDecBtn({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Pixel 4 XL baseline dimensions
    const double baseWidth = 500.0;
    const double baseHeight = 823.0;

    // Scaling factors
    double widthScale = screenWidth / baseWidth;
    double heightScale = screenHeight / baseHeight;

    // Responsive dimensions
    double buttonSize = (26 * widthScale).clamp(20, 36); // Responsive button size
    double iconSize = (16 * widthScale).clamp(12, 24); // Responsive icon size
    double borderRadius = (10 * widthScale).clamp(8, 16); // Responsive border radius

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: CofeeBox,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: CofeeBox,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
