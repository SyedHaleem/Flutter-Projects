import 'package:doctor_project/models/doctordetailcontent.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/Doctordetailcard.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/Hospitalcard.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class Doctorpage extends StatelessWidget {
  const Doctorpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Color(0xFF191919),
        elevation: 0,backgroundColor: Colors.white,centerTitle: true,title: Heading_Text(text: 'Doctors in Kohat', fw: FontWeight.bold, fs: 17, fc: Color(0xFF191919), ls: 0.19, tp: 0),),
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
              itemCount: doctorcontent.length,
              itemBuilder: (context, index) {
                return  Doctordetailcard(
                    imgpath: doctorcontent[index].imagepath,
                    doctorname: doctorcontent[index].docname,
                  );
              },
            ),
            ),
          ),
        ),
    );
  }
}
