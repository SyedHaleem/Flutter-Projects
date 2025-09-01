import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Are_You_Doctor_Screen/AreYouDoctorScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Contact_Us_Screen/ContactusScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Friend_And_Family_Screen/AddFriendScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Friend_And_Family_Screen/FriendandFamilyScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Health_Blog_Screen/HealthBlogScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Invite_Family_Screen/InviteFamilyScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/My_Favorite_Doctor_Screen/AddDoctorScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/My_Favorite_Doctor_Screen/MyFavoriteDoctor.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Privacy_Policy_Screen/PrivacyPolicyScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Profile_Screens/EditProfileScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Profile_Screens/ProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerPageContent {
  final IconData icon;
  final String pagename;
  final Widget screen;

  DrawerPageContent( {required this.screen,required this.pagename, required this.icon});
}

List<DrawerPageContent> drawerContents = [
  DrawerPageContent(pagename: 'My Profile', screen: const ProfileScreen(),icon: Icons.person,),
  DrawerPageContent(pagename: 'Friends & Family', icon: Icons.group_outlined,screen: const FriendandFamilyScreen()),
  DrawerPageContent(pagename: 'My Favorite Doctors', icon: Icons.favorite,screen: const MyFavoriteDoctor()),
  DrawerPageContent(pagename: 'Privacy Policy', icon: Icons.privacy_tip_rounded,screen: const PrivacyPolicyScreen()),
  DrawerPageContent(pagename: 'Health Blog', icon: Icons.health_and_safety,screen: const HealthBlogScreen()),
  DrawerPageContent(pagename: 'Are you a Doctor?', icon: FontAwesomeIcons.userDoctor,screen: const AreYouDoctorScreen()),
  DrawerPageContent(pagename: 'Tell a Friend', icon: Icons.groups_sharp,screen: const InviteFamilyScreen()),
  DrawerPageContent(pagename: 'Contact Us', icon: Icons.call,screen: const ContactusScreen()),
];
