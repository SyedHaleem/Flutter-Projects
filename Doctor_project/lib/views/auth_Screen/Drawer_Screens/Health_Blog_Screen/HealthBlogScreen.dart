import 'package:doctor_project/models/HealthBlogContent.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Health_Blog_Screen/Blog_Screen_Widget/BlogContainer.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class HealthBlogScreen extends StatelessWidget {
  const HealthBlogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(foregroundColor: Colors.black, elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Health Blog', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
          centerTitle: true),
      body: Center(
        child: Container(
          width: 330,
          height: double.infinity,
          color: Colors.white,
            child: ListView.separated(scrollDirection: Axis.vertical,itemBuilder: (context, index) {
              return BlogContainer(width: blogcontent[index].width, height: blogcontent[index].height, imgpath: blogcontent[index].imgpath, headingtext: blogcontent[index].headingtext, paragraphtext: blogcontent[index].text);
            }, separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 25.78,bottom: 20.62),
              child: Divider(color: Color(0xff6969691A),),
            ), itemCount: blogcontent.length),
        ),
      ),
    );
  }
}
