import 'package:flutter/material.dart';

class PopularShopCard extends StatelessWidget {
  const PopularShopCard({super.key});

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
    double containerHeight = (126 * heightScale).clamp(100, 180);
    double borderRadius = (20 * widthScale).clamp(16, 30);
    double marginTop = (24 * heightScale).clamp(16, 32);

    return Container(
      margin: EdgeInsets.only(top: marginTop),
      width: double.infinity,
      height: containerHeight,
      decoration: BoxDecoration(
        color: Colors.green,
        image: const DecorationImage(
          image: AssetImage('assets/images/shop1.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}