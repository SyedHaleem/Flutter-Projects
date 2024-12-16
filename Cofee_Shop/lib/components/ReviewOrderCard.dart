import 'package:cofee_shop/components/customIncDecBtn.dart';
import 'package:cofee_shop/config/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewOrderCard extends StatelessWidget {
  final String image;
  final String title;
  final String specs;
  final double rating;
  final double price;
  final String size;
  final ValueChanged<int> onQuantityChanged;

  ReviewOrderCard({
    super.key,
    required this.image,
    required this.title,
    required this.specs,
    required this.rating,
    required this.price,
    required this.size,
    required this.onQuantityChanged,
  });

  final RxInt quantity = 1.obs;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Pixel 4 XL baseline dimensions
    const double baseWidth = 411.0;

    // Scaling factor
    final double widthScale = screenWidth / baseWidth;

    // Responsive dimensions
    final double cardWidth = (360 * widthScale).clamp(300, 400).toDouble();
    final double imageWidth = (140 * widthScale).clamp(100, 160).toDouble();
    final double fontSizeSmall = (14 * widthScale).clamp(12, 18).toDouble();
    final double fontSizeLarge = (16 * widthScale).clamp(14, 20).toDouble();
    final double padding = (12 * widthScale).clamp(8, 20).toDouble();
    final double iconSize = (16 * widthScale).clamp(12, 20).toDouble();

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: searchBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Image.asset(
              image,
              width: imageWidth,
              height: 120, // Fixed height for consistency
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: padding),

          // Product Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Item Name
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Specs
                  Text(
                    specs,
                    style: TextStyle(
                      fontSize: fontSizeSmall,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Rating and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: iconSize,
                            color: CofeeBox,
                          ),
                          SizedBox(width: padding * 0.5),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              fontSize: fontSizeSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: fontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // Size and Quantity Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Size: $size',
                        style: TextStyle(
                          fontSize: fontSizeSmall,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          customIncDecBtn(
                            icon: Icons.remove,
                            onPressed: () {
                              if (quantity.value > 1) {
                                quantity.value--;
                                onQuantityChanged(quantity.value);
                              }
                            },
                          ),
                          SizedBox(width: padding * 0.5),
                          Obx(() => Text(
                            '${quantity.value}',
                            style: TextStyle(
                              fontSize: fontSizeLarge,
                              fontWeight: FontWeight.bold,
                              color: CofeeBox,
                            ),
                          )),
                          SizedBox(width: padding * 0.5),
                          customIncDecBtn(
                            icon: Icons.add,
                            onPressed: () {
                              quantity.value++;
                              onQuantityChanged(quantity.value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
