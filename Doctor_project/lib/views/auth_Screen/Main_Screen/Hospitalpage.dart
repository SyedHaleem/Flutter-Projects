import 'package:doctor_project/models/hospitalcardcontent.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/Hospitalcard2.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class Hospitalpage extends StatelessWidget {
  const Hospitalpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Color(0xFF191919),
        elevation: 0,backgroundColor: Colors.white,centerTitle: true,title: Heading_Text(text: 'Hospitals in Kohat', fw: FontWeight.bold, fs: 17, fc: Color(0xFF191919), ls: 0.19, tp: 0),),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Container(
            width: 335,
            height: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: hospitalcontents.length-3,
              itemBuilder: (context, index) {
                 return Hospitalcard2(imgpath: hospitalcontents[index+3].imagepath,title: hospitalcontents[index+3].heading,subtitle: hospitalcontents[index+3].address,);
              },
            ),
          ),
        ),
      ),
    );
  }
}
