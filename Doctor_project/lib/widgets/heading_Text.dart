
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Heading_Text extends StatelessWidget {
  final String text;
  final FontWeight fw;
  final double fs;
  final Color fc;
  final double ls;
  final double tp;
  final TextAlign? align;
  const Heading_Text({Key? key, required this.text, required this.fw, required this.fs, required this.fc, required this.ls, required this.tp, this.align}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: tp),
      child: Text(textAlign: align,text,style: TextStyle(fontWeight: fw,fontSize: fs,color: fc,letterSpacing: ls,),),
    );
  }
}
