import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class custom_RichText extends StatelessWidget {
  final String txt1;
  final String txt2;
  const custom_RichText({Key? key,required this.txt1,required this.txt2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(
        style: TextStyle(color: Color(0xFF6B7280),fontSize: 15,),
        children: <TextSpan>[
          TextSpan(text: txt1,style: GoogleFonts.nunito(fontSize: 15,)),
          TextSpan(text: txt2,style: GoogleFonts.roboto(fontSize: 15,color: Color(0xFF5B7FFF))),
        ]
    ));
  }
}
