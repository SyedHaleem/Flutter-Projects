
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Paraghraph_Text extends StatelessWidget {
  final String text;
  final double fs;
  final Color fc;
  final double ls;
  final double tp;
  final bool isunderline;
  final TextAlign? align;
  const Paraghraph_Text({Key? key, required this.text, required this.fs, required this.fc, required this.ls, required this.tp, required this.isunderline, this.align}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: tp),
      child: Text(textAlign: align!=null?align:TextAlign.start,text,style: GoogleFonts.nunito(fontWeight: FontWeight.w400,fontSize: fs,color: fc,letterSpacing: ls,wordSpacing: 01,height: 1.2,decoration:isunderline?TextDecoration.underline:null),),
    );
  }
}
