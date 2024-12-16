import 'package:doctor_project/models/HealthBlogContent.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/material.dart';

class BlogContainer extends StatelessWidget {
  final double width;
  final double height;
  final String imgpath;
  final String headingtext;
  final String paragraphtext;
  const BlogContainer({Key? key, required this.width, required this.height, required this.imgpath, required this.headingtext, required this.paragraphtext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(imgpath,width: 326.91,height: 154.69,),
          Heading_Text(align: TextAlign.end,text: headingtext, fw: FontWeight.w700, fs: 10.38, fc: Color(0xff191919), ls: 0, tp: 12.38),
          Paraghraph_Text(text: paragraphtext, fs: 8.31, fc: Color(0xff191919), ls: 0, tp: 12.38, isunderline: false),

        ],
      ),
    );
  }
}
