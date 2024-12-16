import 'package:cofee_shop/config/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;

    // Dynamic paddings and icon sizes
    double padding = screenWidth * 0.05; // Padding proportional to screen width
    double iconSize = screenWidth / 15; // Icon size proportional to screen width// Tab border radius

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(padding), // Dynamic padding
        child: GNav(
          tabBorderRadius: 15,
          backgroundColor: Colors.white,
          color: CofeeText,
          activeColor: Colors.white,
          tabBackgroundColor: CofeeBox,
          padding: EdgeInsets.all(padding / 2), // Adjust inner padding
          tabs: [
            GButton(icon: Icons.home, iconSize: iconSize, gap: padding / 4),
            GButton(icon: Icons.favorite_border, iconSize: iconSize, gap: padding / 4),
            GButton(icon: FontAwesomeIcons.bagShopping, iconSize: iconSize, gap: padding / 4),
            GButton(icon: Icons.person_2_outlined, iconSize: iconSize, gap: padding / 4),
          ],
        ),
      ),
    );
  }
}
