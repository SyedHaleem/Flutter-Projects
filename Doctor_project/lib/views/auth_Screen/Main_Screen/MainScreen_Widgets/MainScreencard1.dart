import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mainscreencard1 extends StatelessWidget {
  final String imagepath;
  final String headingtext;
  final String text;
  const Mainscreencard1({Key? key, required this.imagepath, required this.headingtext, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105.21,
      height: 146.3,
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Container(
              width: 75.33,
              height: 70.97,
              decoration: BoxDecoration(
                color: Color(0xFF0EBE7F),
                borderRadius: BorderRadius.circular(11.83),
              ),
            ),
          ),
          Image.asset(imagepath,width: 71.59,height: 87.15,),
          Padding(
            padding: const EdgeInsets.only(top: 82.53),
            child: Card(
              color: Colors.white,
              elevation: 2,
              child: Container(
                width: 105.21,
                height: 59.76,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.98)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(headingtext,style: GoogleFonts.rubik(fontWeight: FontWeight.w500,letterSpacing: -0.19,fontSize: 7,color: Color(0xFF333333),),),
                    Text(text,style: GoogleFonts.rubik(fontWeight: FontWeight.w300,letterSpacing: -0.19,fontSize: 6,color: Color(0xFF677294),height: 2),)

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
