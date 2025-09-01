import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final double width;
  final bool? isSearched;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.bgColor,
    required this.textColor,
    required this.iconColor,
    required this.width,
    this.isSearched = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: isSearched == true ? 54 : 64,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        // validator: validator, // Hook validator here
        decoration: InputDecoration(
          filled: true,
          fillColor: bgColor,
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor,
            fontSize: 18,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: iconColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}