import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customCircleContainer extends StatelessWidget {
  final String imgpath;
  const customCircleContainer({Key? key,required this.imgpath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 126.71,
      height: 126.71,
      decoration: BoxDecoration(
        color: Color(0xffD9D9D9),
          shape: BoxShape.circle,
      ),
      child: CircleAvatar(backgroundColor: Color(0xffD9D9D9),backgroundImage: AssetImage(this.imgpath,),),
    );
  }
}
