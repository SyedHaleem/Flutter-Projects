import 'package:flutter/material.dart';
import 'package:quiz_app/config/Colors.dart'; // Assuming bgColor is defined in Colors.dart

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: bgColor,
    primary: primaryColor,
  )
),
    textTheme =const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: "Poppins",
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: fontColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Poppins",
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      labelSmall: TextStyle(
        fontFamily: "Poppins",
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: labelColor,
      ),
      labelMedium: TextStyle(
        fontFamily: "Poppins",
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: labelColor,
      ),

);




