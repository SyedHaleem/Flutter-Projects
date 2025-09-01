import 'dart:ui';

import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegScreen4.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/Circular_Container.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/RegScreenButton.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegScreen3 extends StatefulWidget {
  const RegScreen3({Key? key}) : super(key: key);

  @override
  State<RegScreen3> createState() => _RegScreen3State();
}

class _RegScreen3State extends State<RegScreen3> {
  String selectedGoal = '';
  void handleButtonClick(String goal) {
    setState(() {
      selectedGoal = goal;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegScreen4(),
      ),
    );
  }
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
                  Text('Step 3 of 7',softWrap: true,style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,color: Color(0xFF191919),fontSize: 12),),
                  Heading_Text(text: 'Select your goal', fw: FontWeight.w700, fs: 15, fc: Colors.black, ls: -0.19, tp: 5),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60),
                child: Center(child: Image.asset('assets/images/apple.png',height: 176.41,width: 257.04,))),

            Center(
              child: Container(
                width: 335,
                height: 323.65,
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Share your wellness goals and lifestyle preference to again access to your personalized weightloss clinic',style: GoogleFonts.nunito(fontSize: 11,color: Colors.black,letterSpacing: 0.3,fontWeight: FontWeight.w400,),),
                    RegScreenButton( isSelected: selectedGoal == 'Loose or maintain weight',onPressed: (){
                      handleButtonClick('Loose or maintain weight');
                    },btnw: 331, btnh: 49.79, btntext: 'Loose or maintain weight', btnbgcolor: Color(0xFFF1F1F1), btnfgcolor: Color(0xFF9CA3AF), btnbordercolor: Color(0xFF9CA3AF), btnradius: 11.48, tm: 30,fontsize: 12),
                    RegScreenButton(onPressed: (){
                      handleButtonClick('Gain weight or muscles');
                    },isSelected: selectedGoal == 'Gain weight or muscles',btnw: 331, btnh: 49.79, btntext: 'Gain weight or muscles', btnbgcolor: Color(0xFFF1F1F1), btnfgcolor: Color(0xFF9CA3AF), btnbordercolor: Color(0xFF9CA3AF), btnradius: 11.48, tm: 14,fontsize: 12),
                    RegScreenButton(onPressed: (){
                      handleButtonClick('Healthy lifestyle');
                    },isSelected: selectedGoal == 'Healthy lifestyle',btnw: 331, btnh: 49.79, btntext: 'Healthy lifestyle', btnbgcolor: Color(0xFFF1F1F1), btnfgcolor: Color(0xFF9CA3AF), btnbordercolor: Color(0xFF9CA3AF), btnradius: 11.48, tm: 14,fontsize: 12),
                    GestureDetector(
                      onTap: () {
                        handleButtonClick('None');
                      },
                      child: Paraghraph_Text(text: 'None', fs: 12, fc: Color(0xFF5B7FFF), ls: 0.3, tp: 21, isunderline: false
                      ),
                    )
                  ],
                ),
              ),
            ),
           ],
        ),
      ),
    );
  }
}
