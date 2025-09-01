import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesCard extends StatelessWidget {
  final String imgpath;
  final String service;
  const ServicesCard({Key? key, required this.imgpath, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> serviceParts = service.split(' '); // Split the service string by space
    return Container(
      width: 158,
      height: 168,
      margin: EdgeInsets.only(top: 0),
      decoration: BoxDecoration(color: Colors.white,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 23),
              width: 67.43,
              height: 67.43,
               child: Card(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.87)),
                 elevation: 5,
                 shadowColor: Colors.white,
                 child: FittedBox(
                   fit: BoxFit.contain,
                   child: Image.asset(
                     imgpath,
                     width: 15.5,
                     height: 31.09,
                   ),
                 )

               ),
            ),
      SizedBox(height: 2.6,),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '${serviceParts[0]}\n', // First part of the service string
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            TextSpan(
              text: '${serviceParts.sublist(1).join(' ')}', // Remaining parts joined by space
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
          ],
        ),),],
        ),
      ),
    );
  }
}
