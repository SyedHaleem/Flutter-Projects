import 'package:firebasework/config/theme/app_Color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,
    fontFamily: 'Satoshi',
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(fontWeight: FontWeight.w500,color: Color(0xff383838)),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: EdgeInsets.all(20),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.black,width: 0.4)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.black,width: 0.4)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.black,width: 0.4)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      )
    ),

  );
}