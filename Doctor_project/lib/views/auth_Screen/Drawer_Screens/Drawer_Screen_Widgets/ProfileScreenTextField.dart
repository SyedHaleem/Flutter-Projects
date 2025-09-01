import 'package:flutter/material.dart';

class ProfileScreenTextField extends StatelessWidget {
  final String text;
  final String option1;
  final String option2;
  final TextEditingController controller;
  final IconData? icon1;
  final IconData? icon2;
  final IconData? icon;
  final double toppadding;
  const ProfileScreenTextField({Key? key, required this.text, required this.controller,this.icon1, required this.toppadding, this.icon2, required this.option1, required this.option2,this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: toppadding),
      child: Container(
        height: 40,
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: text == option1 ? Icon(icon1, size: 24, color: Color(0xFF9CA3AF)) : text == option2 ? Icon(icon2, size: 24, color: Color(0xFF9CA3AF)) : Icon(icon, size: 24, color: Color(0xFF9CA3AF)),
            hintText: text,
            hintStyle: TextStyle(fontSize: 13,letterSpacing: 0.5,color: Color(0xFF1B1E28),fontWeight: FontWeight.w600,),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF7F7F9))),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF7F7F9))),
          ),
        ),
      ),
    );
  }
}
