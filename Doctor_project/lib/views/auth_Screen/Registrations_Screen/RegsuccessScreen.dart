import 'dart:async';

import 'package:doctor_project/views/auth_Screen/login_Screen/login_Screen.dart';
import 'package:doctor_project/views/auth_Screen/onBoarding_Screen/onBoarding_Screen.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegsuccessScreen extends StatefulWidget {
  const RegsuccessScreen({Key? key}) : super(key: key);

  @override
  State<RegsuccessScreen> createState() => _RegsuccessScreenState();
}


class _RegsuccessScreenState extends State<RegsuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1300), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => login_Screen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/frame.png'))),
        child: Container(
          width: 277,
          height: 343.33,
          margin: EdgeInsets.only(top: 205),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/success.png',width: 277,height: 273.33,),
              Heading_Text(text: 'Success!', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 10),
              Paraghraph_Text(text: "You have been successfully signed up!", fs: 11, fc: Color(0xFF0F172A), ls: 0.29, tp: 5, isunderline: false),
            ],
          ),
        ),
      ),
    );
  }
}
