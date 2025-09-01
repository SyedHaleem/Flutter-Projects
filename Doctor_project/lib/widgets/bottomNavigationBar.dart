import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class bottomNavigationBar extends StatelessWidget {
  const bottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GNav(
          textStyle: TextStyle(fontSize: 11,color: Color(0xFF63B4FF)),
          tabBorderRadius: 12,
          backgroundColor: Colors.white,
          color: Color(0xFF8696BB),
          activeColor: Color(0xFF63B4FF),
          tabBackgroundColor: Color(0xFF63B4FF).withOpacity(0.1),
          padding: EdgeInsets.all(16),
          tabs: [
            GButton(icon: Icons.home,iconSize: 24,text: 'Home',gap: 2),
            GButton(icon: Icons.calendar_month_outlined,iconSize: 24,text: 'Calendar',gap: 2),
            GButton(icon: FontAwesomeIcons.notesMedical,iconSize: 19,text: 'Report',gap: 2),
            GButton(icon: Icons.call,iconSize: 20,text: 'Call',gap: 2),
          ],),
      ),
    );
  }
}
