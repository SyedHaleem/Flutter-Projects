import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class custom_LowerBar extends StatelessWidget {
  final double Width;
  final double height;
  final Color bgcolor;
  final double tmargin;
  const custom_LowerBar({Key? key,required this.Width,
    required this.height,required this.bgcolor,required this.tmargin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: this.tmargin),
      height: height,
      width: Width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: bgcolor),
    );
  }
}
