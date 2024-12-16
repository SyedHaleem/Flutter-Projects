import 'dart:ui';

import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegScreen3.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/Circular_Container.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegScreen2 extends StatefulWidget {
  const RegScreen2({Key? key}) : super(key: key);

  @override
  State<RegScreen2> createState() => _RegScreen2State();
}

class _RegScreen2State extends State<RegScreen2> {
  bool isSelectedmarry=false;
  bool isSelectedunmarry=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(padding: EdgeInsets.only(top: 30),onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF191919),)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 181,
              height: 86,
              margin: EdgeInsets.only(top: 25,left: 22.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 2 of 7',softWrap: true,style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,color: Color(0xFF191919),fontSize: 12),),
                  Heading_Text(text: 'Marital Status!', fw: FontWeight.w700, fs: 15, fc: Colors.black, ls: -0.19, tp: 5),
                ],
              ),
            ),
            Center(child: InkWell(onTap: (){
              setState(() {
                isSelectedmarry=!isSelectedmarry;
                isSelectedunmarry=false;
              });
            },child: circular_Container(isSelected: isSelectedmarry,icondata:  FontAwesomeIcons.solidUser,text: 'Single',))),
            Center(child: InkWell(onTap: (){
              setState(() {
                isSelectedunmarry=!isSelectedunmarry;
                isSelectedmarry=false;
              });
            },child: circular_Container(isSelected: isSelectedunmarry,icondata: FontAwesomeIcons.userGroup,text: 'Married',))),
            Center(child: custom_ElevatedButton(onPressed: (){
              if(isSelectedmarry==true||isSelectedunmarry==true)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegScreen3(),));
              }
            },btnw: 331, btnh: 50, btntext: 'Next', btnbgcolor: Color(0xFF5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10, tm: 100)),
          ],
        ),
      ),
    );
  }
}
