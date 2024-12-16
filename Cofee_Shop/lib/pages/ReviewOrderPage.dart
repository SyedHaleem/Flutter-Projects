import 'package:cofee_shop/components/CustomBottomNavigatorButton.dart';
import 'package:cofee_shop/components/ReviewOrderCard.dart';
import 'package:cofee_shop/config/Colors.dart';
import 'package:cofee_shop/pages/PaymentMethod.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ReviewOrderPage extends StatelessWidget {
  final double price;
  final String size;
  final String image;
  final double rating;
  final String item;
  final String specs;

  const ReviewOrderPage({
    super.key,
    required this.price,
    required this.size,
    required this.rating,
    required this.item,
    required this.specs,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Pixel 4 XL baseline dimensions
    const double baseWidth = 411.0;
    const double baseHeight = 823.0;

    final double widthScale = screenWidth / baseWidth;
    final double heightScale = screenHeight / baseHeight;

    final double appBarTitleFontSize = (28 * widthScale).clamp(20, 32).toDouble();
    final double titleFontSize = (18 * widthScale).clamp(14, 24).toDouble();
    final double addressFontSize = (14 * widthScale).clamp(12, 18).toDouble();
    final double paddingHorizontal = (35.0 * widthScale).clamp(20, 50).toDouble();
    final double verticalSpacing = (16.0 * heightScale).clamp(12, 24).toDouble();
    final double totalSpacing = (56.0 * heightScale).clamp(40, 70).toDouble();

    final RxDouble totalPrice = price.obs; // Reactive variable for total price

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(Icons.arrow_back_ios_new, color: CofeeBox),
          onPressed: () {
            Get.back();
          },
        ),
        titleSpacing: paddingHorizontal * 1.2,
        title: Text(
          "Review Order",
          style: TextStyle(
            fontSize: appBarTitleFontSize,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: totalSpacing),
            ReviewOrderCard(
              price: price,
              rating: rating,
              specs: specs,
              size: size,
              title: item,
              image: image,
              onQuantityChanged: (quantity) {
                totalPrice.value = price * quantity; // Update total price
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: totalSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total :',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() => Text(
                        '\$${totalPrice.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping Charges :',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$0.00',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address ',
                        style: TextStyle(
                          fontSize: addressFontSize,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '23/6 A New York USA',
                          style: TextStyle(
                            fontSize: addressFontSize,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => CustomBottomNavigatorButton(
        isPrice: true,
        totalAmount: totalPrice.value,
        onPressed: () {
          Get.to(PaymentMethod(totalPrice: totalPrice.value));
        },
        btn_text: 'Review Order',
      )),
    );
  }
}
