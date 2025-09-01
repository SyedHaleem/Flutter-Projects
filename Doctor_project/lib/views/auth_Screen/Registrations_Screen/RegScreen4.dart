import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegScreen5.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/RegScreenButton.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegScreen4 extends StatefulWidget {
  const RegScreen4({Key? key}) : super(key: key);

  @override
  State<RegScreen4> createState() => _RegScreen4State();
}

class _RegScreen4State extends State<RegScreen4> {
  String selectedGoal = '';
  void handleButtonClick(String goal) {
    setState(() {
      selectedGoal = goal;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegScreen5(),
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
              width: 315,
              height: 86,
              margin: EdgeInsets.only(top: 25,left: 22.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 4 of 7',softWrap: true,style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,color: Color(0xFF191919),fontSize: 12),),
                  Heading_Text(text: 'Have you ever been diagnosed with high blood pressure', fw: FontWeight.w700, fs: 15, fc: Colors.black, ls: -0.19, tp: 5),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 60),
                child: Center(child: Image.asset('assets/images/scope.png',height: 184.53,width: 180.5,))),

            Center(
              child: Container(
                width: 335,
                height: 313.65,
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Tell us about persistent symptoms troubling you and we will help you address them effectively',style: GoogleFonts.openSans(fontSize: 12,color: Colors.black,letterSpacing: 0.3,fontWeight: FontWeight.w400,),),
                    RegScreenButton(isSelected: selectedGoal == 'Yes',onPressed: (){
                      handleButtonClick('Yes');
                    },btnw: 331, btnh: 49.79, btntext: 'Yes', btnbgcolor: Color(0xFFF1F1F1), btnfgcolor: Color(0xFF9CA3AF), btnbordercolor: Color(0xFF9CA3AF), btnradius: 11.48, tm: 30,fontsize: 12),
                    RegScreenButton(isSelected: selectedGoal == 'No',onPressed: (){
                      handleButtonClick('No');
                    },btnw: 331, btnh: 49.79, btntext: 'No', btnbgcolor: Color(0xFFF1F1F1), btnfgcolor: Color(0xFF9CA3AF), btnbordercolor: Color(0xFF9CA3AF), btnradius: 11.48, tm: 16,fontsize: 12),
                    GestureDetector(
                      onTap: () {
                        handleButtonClick("I'm sure");
                      },
                      child: Paraghraph_Text(text: "I'm sure", fs: 12, fc: Color(0xFF5B7FFF), ls: 0.3, tp: 21, isunderline: false),
                    ),
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
