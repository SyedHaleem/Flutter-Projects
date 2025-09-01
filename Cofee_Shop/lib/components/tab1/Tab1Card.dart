import 'package:cofee_shop/components/customIncDecBtn.dart';
import 'package:cofee_shop/config/Colors.dart';
import 'package:cofee_shop/pages/Tab1detailpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tab1Card extends StatelessWidget {
  final String image;
  final String title;
  final String specs;
  final String description;
  final double price;
  final double rating;

  const Tab1Card({
    super.key,
    required this.image,
    required this.specs,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
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

    // Responsive dimensions based on Pixel 4 XL
    double imageHeight = (120 * heightScale).clamp(100, screenHeight * 0.25);
    double titleFontSize = (14 * widthScale).clamp(10, 20);
    double specsFontSize = (12 * widthScale).clamp(10, 18);
    double priceFontSize = (14 * widthScale).clamp(10, 20);
    double ratingFontSize = (12 * widthScale).clamp(10, 18);
    double iconSize = (16 * widthScale).clamp(12, 24);
    double padding = (8 * widthScale).clamp(6, 12);

    return GestureDetector(
      onTap: () {
        Get.to(
          Tab1detailPage(
            item: title,
            specs: specs,
            rating: rating,
            price: price,
            description: description,
            image: image,
          ),
        );
      },
      child: Card(
        color: searchBgColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20 * widthScale),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: image,
              child: Container(
                width: double.infinity,
                height: imageHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20 * widthScale),
                    topLeft: Radius.circular(20 * widthScale),
                  ),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleFontSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: CofeeBox,
                            size: iconSize,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '$rating',
                            style: TextStyle(fontSize: ratingFontSize),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: (screenHeight * 0.005).clamp(4, 8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        specs,
                        style: TextStyle(
                          fontSize: specsFontSize,
                          color: CofeeText,
                        ),
                      ),
                      Text(
                        '\$$price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: priceFontSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: (screenHeight * 0.01).clamp(6, 12)),
                  Center(child: const customIncDecBtn(icon: Icons.add)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}