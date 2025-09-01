import 'dart:async';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Are_You_Doctor_Screen/AreYouDoctorScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawerscreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Health_Blog_Screen/HealthBlogScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Invite_Family_Screen/InviteFamilyScreen.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/My_Favorite_Doctor_Screen/MyFavoriteDoctor.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Profile_Screens/EditProfileScreen.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen.dart';
import 'package:doctor_project/views/auth_Screen/Search_Tab_Screens/SearchScreens.dart';
import 'package:doctor_project/views/auth_Screen/onBoarding_Screen/onBoarding_Screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const
          // SearchScreens(),
          // InviteFamilyScreen(),
          // AreYouDoctorScreen(),
          // HealthBlogScreen(),
          // MyFavoriteDoctor(),
          // FriendandFamilyScreen(),
      // EditProfileScreen(),
      // MainScreen(),
      // Drawerscreen(),
      // AddFriendScreen(),
      // Doctorpage(),
      //  Reg_Screen1(),
      SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key,});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => onBoarding_Screen(),));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
            child: Image.asset('assets/images/logo.png',width: 200,height: 200,),
        ),
      )
    );
  }
}
