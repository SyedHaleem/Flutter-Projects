import 'package:cofee_shop/components/PopularShopCard.dart';
import 'package:cofee_shop/components/SpecialOffer.dart';
import 'package:cofee_shop/components/tab1/Tab1Card.dart';
import 'package:cofee_shop/models/Tab1cardContents.dart';
import 'package:flutter/material.dart';

class Tab1Contents extends StatelessWidget {
  const Tab1Contents({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Dynamic values for responsiveness
    double paddingTop = screenHeight * 0.07; // Top padding
    double gridHeight = screenHeight * 0.3; // Height for the GridView
    double cardSpacing = screenWidth * 0.035; // Spacing between grid items
    double aspectRatio = screenWidth > 600 ? 4 / 5 : 3 / 4; // Adjust aspect ratio for larger screens
    double textFontSize = screenWidth * 0.055; // Font size for 'Popular Shops'

    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: gridHeight, // Responsive grid height
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2, // 3 columns for larger screens, 2 for smaller
                    crossAxisSpacing: cardSpacing,
                    mainAxisSpacing: cardSpacing,
                    childAspectRatio: aspectRatio, // Responsive card aspect ratio
                  ),
                  itemCount: tab1cardcontents.length,
                  itemBuilder: (context, index) {
                    return Tab1Card(
                      image: tab1cardcontents[index].imagepath,
                      title: tab1cardcontents[index].item,
                      specs: tab1cardcontents[index].specs,
                      description: tab1cardcontents[index].description,
                      price: tab1cardcontents[index].price,
                      rating: tab1cardcontents[index].rating,
                    );
                  },
                ),
              ),
              const SpecialOffer(),
              SizedBox(height: screenHeight * 0.02), // Dynamic spacing
              Text(
                'Popular Shops',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: textFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const PopularShopCard(),
            ],
          ),
        ),
      ),
    );
  }
}
