import 'package:cofee_shop/pages/Home.dart';
import 'package:cofee_shop/pages/Launch.dart';
import 'package:cofee_shop/pages/Login.dart';
import 'package:cofee_shop/pages/ReviewOrderPage.dart';
import 'package:cofee_shop/pages/Tab1detailpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(

      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:
          // ReviewOrderPage()
      Launch()
      // Login()
      // Home()
      // Tab1detailpage()
      ,
    );
  }
}

