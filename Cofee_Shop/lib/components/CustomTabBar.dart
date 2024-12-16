import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cofee_shop/components/tab1/Tab1Contents.dart';
import 'package:cofee_shop/config/Colors.dart';
import 'package:cofee_shop/controller/TabController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  final TabControllerX tabControllerX = Get.put(TabControllerX());

  @override
  void initState() {
    super.initState();
    tabControllerX.initializeTabController(this); // Provide vsync to TabController
  }

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Dynamic sizing
    double tabHeight = screenHeight * 0.05; // Tab bar height (5% of screen height)
    double tabRadius = screenWidth * 0.03; // Radius for rounded corners
    double tabPadding = screenWidth * 0.04; // Horizontal padding for tabs
    double fontSize = screenWidth * 0.04; // Font size proportional to screen width

    return Column(
      children: [
        Obx(() {
          // Only display the tab bar after the controller is initialized
          return tabControllerX.isInitialized.value
              ? ButtonsTabBar(
            physics:
            const AlwaysScrollableScrollPhysics(), // Enable horizontal scroll
            backgroundColor: CofeeBox,
            unselectedBackgroundColor: searchBgColor,
            unselectedLabelStyle: TextStyle(
              color: CofeeText,
              fontSize: fontSize, // Responsive font size
            ),
            controller: tabControllerX.tabController,
            splashColor: CofeeText,
            radius: tabRadius, // Responsive radius
            height: tabHeight, // Responsive height
            contentPadding: EdgeInsets.symmetric(horizontal: tabPadding),
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: fontSize, // Responsive font size
            ),
            tabs: const <Widget>[
              Tab(
                text: "Cappuccino",
              ),
              Tab(text: "Latte"),
              Tab(text: "Americano"),
              Tab(text: "Espresso"),
            ],
          )
              : const SizedBox.shrink(); // Show nothing until initialized
        }),
        Expanded(
          child: Obx(() {
            return tabControllerX.isInitialized.value
                ? TabBarView(
              controller: tabControllerX.tabController,
              children: const [
                Tab1Contents(),
                Center(child: Text('Latte Tab')),
                Center(child: Text('Americano Tab')),
                Center(child: Text('Espresso Tab')),
              ],
            )
                : const Center(
                child: CircularProgressIndicator()); // Loading spinner
          }),
        ),
      ],
    );
  }
}
