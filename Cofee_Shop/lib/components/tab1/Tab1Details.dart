import 'package:cofee_shop/components/SizeOptionBtn.dart';
import 'package:cofee_shop/components/customIncDecBtn.dart';
import 'package:cofee_shop/config/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tab1Details extends StatelessWidget {
  final String item;
  final double rating;
  final String specs;
  final double price;
  final Function(String size) onSizeSelected;

  final RxString selectedSize = ''.obs;

  Tab1Details({
    super.key,
    required this.item,
    required this.specs,
    required this.rating,
    required this.price,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: CofeeBox, size: 22),
                const SizedBox(width: 4),
                Text(
                  "$rating",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

          ],
        ),
        const SizedBox(height: 19,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              specs,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 4),
                Text(
                  "\$$price",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

          ],
        ),
        const SizedBox(height: 16),
        const customIncDecBtn(icon: Icons.add),
        const SizedBox(height: 16),
        const Text(
          "Size",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Row(
          children: [
            SizeOptionBtn(
              isSelected: selectedSize.value == 'S',
              btntext: 'S',
              onPressed: () {
                selectedSize.value = 'S';
                onSizeSelected('S');
              },
            ),
            const SizedBox(width: 8),
            SizeOptionBtn(
              isSelected: selectedSize.value == 'M',
              btntext: 'M',
              onPressed: () {
                selectedSize.value = 'M';
                onSizeSelected('M');
              },
            ),
            const SizedBox(width: 8),
            SizeOptionBtn(
              isSelected: selectedSize.value == 'L',
              btntext: 'L',
              onPressed: () {
                selectedSize.value = 'L';
                onSizeSelected('L');
              },
            ),
          ],
        )),
      ],
    );
  }
}
