import 'package:cofee_shop/config/Colors.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigatorButton extends StatelessWidget {
  final String btn_text;
  final VoidCallback? onPressed;
  final bool isPrice;
  final double? totalAmount;

  const CustomBottomNavigatorButton({
    super.key,
    required this.btn_text,
    this.onPressed,
    required this.isPrice,
    this.totalAmount = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Pixel 4 XL baseline dimensions
    const double baseWidth = 411.0;
    const double baseHeight = 823.0;

    // Scaling factors
    double widthScale = screenWidth / baseWidth;
    double heightScale = screenHeight / baseHeight;

    // Responsive dimensions
    double containerHeight = (83 * heightScale).clamp(60, 100);
    double buttonWidth = (216 * widthScale).clamp(180, 250);
    double buttonHeight = (53 * heightScale).clamp(40, 70);
    double paddingHorizontal = (30 * widthScale).clamp(16, 40);
    double fontSize = (18 * widthScale).clamp(14, 22);
    double labelFontSize = (16 * widthScale).clamp(12, 20);

    return Container(
      color: searchBgColor,
      height: containerHeight,
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Row(
        mainAxisAlignment: isPrice ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isPrice) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '\$${totalAmount?.toStringAsFixed(2)}', // Display total price
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: CofeeBox,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((10 * widthScale).clamp(8, 16)),
                ),
              ),
              child: Text(
                btn_text,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
