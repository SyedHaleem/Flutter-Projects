import 'package:cofee_shop/components/CustomBottomNavigatorButton.dart';
import 'package:cofee_shop/components/tab1/Tab1Details.dart';
import 'package:cofee_shop/pages/ReviewOrderPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Tab1detailPage extends StatelessWidget {
  final String item;
  final double rating;
  final String description;
  final String specs;
  final double price;
  final String image;

  Tab1detailPage({
    super.key,
    required this.item,
    required this.specs,
    required this.rating,
    required this.price,
    required this.description,
    required this.image,
  });

  final RxString selectedSize = ''.obs;

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
    double imageHeight = (406 * heightScale).clamp(300, 500);
    double padding = (20 * widthScale).clamp(16, 24);
    double titleFontSize = (18 * widthScale).clamp(16, 24);
    double descriptionFontSize = (16 * widthScale).clamp(14, 20);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            Icons.arrow_back_ios_new,
            size: (24 * widthScale).clamp(20, 32), // Responsive icon size
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: image,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular((20 * widthScale).clamp(16, 30)),
                  topRight: Radius.circular((20 * widthScale).clamp(16, 30)),
                ),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: (16 * heightScale).clamp(12, 24)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tab1Details(
                    item: item,
                    price: price,
                    rating: rating,
                    specs: specs,
                    onSizeSelected: (size) {
                      selectedSize.value = size;
                    },
                  ),
                  SizedBox(height: (16 * heightScale).clamp(12, 24)),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: (8 * heightScale).clamp(6, 16)),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigatorButton(
        isPrice: false,
        onPressed: () {
          Get.to(ReviewOrderPage(
            size: selectedSize.value,
            specs: specs,
            rating: rating,
            price: price,
            item: item,
            image: image,
          ));
        },
        btn_text: 'Place Order',
      ),
    );
  }
}
