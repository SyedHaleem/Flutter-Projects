import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegScreen2.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/Circular_Container.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Reg_Screen1 extends StatefulWidget {
  const Reg_Screen1({Key? key}) : super(key: key);

  @override
  State<Reg_Screen1> createState() => _Reg_Screen1State();
}

class _Reg_Screen1State extends State<Reg_Screen1> {
  bool isSelectedm=false;
  bool isSelectedf=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(padding: EdgeInsets.only(top: 30),onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF191919),)),
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
                  Text('Step 1 of 7',softWrap: true,style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,color: Color(0xFF191919),fontSize: 12),),
                  Heading_Text(text: 'Select Your gender', fw: FontWeight.w700, fs: 15, fc: Colors.black, ls: -0.19, tp: 5),
                ],
              ),
            ),
            Center(child: InkWell(onTap: (){
              setState(() {
                isSelectedm=!isSelectedm;
                isSelectedf=false;
              });
            },child: circular_Container(isSelected: isSelectedm,icondata: Icons.male_outlined,text: 'Male',))),
            Center(child: InkWell(onTap: (){
              setState(() {
                isSelectedf=!isSelectedf;
                isSelectedm=false;
              });
            },child: circular_Container(isSelected: isSelectedf,icondata: Icons.female_outlined,text: 'Female',))),
            Center(child: custom_ElevatedButton(onPressed: (){
              if(isSelectedm==true||isSelectedf==true)
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegScreen2(),));
                }
            },
                btnw: 331, btnh: 50, btntext: 'Next', btnbgcolor: Color(0xFF5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10, tm: 100)),
          ],
        ),
      ),
    );
  }
}
