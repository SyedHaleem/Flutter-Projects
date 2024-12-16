import 'package:cofee_shop/components/CustomBottomNavigationBar.dart';
import 'package:cofee_shop/components/CustomTabBar.dart';
import 'package:cofee_shop/components/CustomTextField.dart';
import 'package:cofee_shop/config/Colors.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    // Fetch screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Dynamic font sizes
    double greetingFontSize = screenWidth / 20; // Responsive greeting text size
    double searchFieldWidth = screenWidth * 0.9; // Responsive width for search field
    double padding = screenWidth * 0.02; // General padding, 4% of screen width

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: padding), // Responsive padding for logo
          child: Image.asset('assets/icons/bean_logo2.png'),
        ),
        leadingWidth: screenWidth * 0.2, // Responsive leading width
        actions: [
          Padding(
            padding: EdgeInsets.only(right: padding),
            child: Image.asset('assets/images/profile_img.png'),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.9, // 95% of screen width for the main container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02, left: padding),
                child: Text(
                  'Hi Haleem,',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    fontSize: greetingFontSize, // Responsive font size
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Dynamic spacing
              CustomTextField(
                width: searchFieldWidth,
                isSearched: true,
                iconColor: CofeeText,
                textColor: CofeeText,
                bgColor: searchBgColor,
                hintText: 'Find your best coffee',
                icon: Icons.search,
                controller: searchController,
              ),
              SizedBox(height: screenHeight * 0.03), // Dynamic spacing
              const Expanded(child: CustomTabBar()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
