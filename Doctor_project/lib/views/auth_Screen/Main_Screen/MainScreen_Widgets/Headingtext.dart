import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Headingtext extends StatefulWidget {
  final String headingtxt;
  final double toppadding;
  final VoidCallback? onTap;
  const Headingtext({Key? key, required this.headingtxt, required this.toppadding, this.onTap}) : super(key: key);

  @override
  State<Headingtext> createState() => _HeadingtextState();
}

class _HeadingtextState extends State<Headingtext> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.toppadding,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Heading_Text(text: widget.headingtxt, fw: FontWeight.w600, fs: 15, fc: Color(0xFF101828), ls: 0.19, tp: 0),
          InkWell(onTap: widget.onTap,child: Text('see all',style: GoogleFonts.inter(fontSize: 10.48,fontWeight: FontWeight.w500,color: Color(0xFF5B7FFF)),))
        ],
      ),
    );
  }
}
