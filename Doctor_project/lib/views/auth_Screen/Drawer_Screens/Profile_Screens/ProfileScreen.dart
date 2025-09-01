import 'dart:ffi';
import 'dart:io';

import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawer_Screen_Widgets/ProfileScreenTextField.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Profile_Screens/EditProfileScreen.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/RegScreenButton.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String? imgpath;
  final String? email;
  final String? date;
  final String? gender;
  final String? status;
  const ProfileScreen({Key? key, this.imgpath,this.email, this.date, this.gender, this.status}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedGoal = '';
  void handleButtonClick(String goal) {
    setState(() {
      selectedGoal = goal;
    });
  }
  TextEditingController email=TextEditingController();
  TextEditingController date=TextEditingController();
  TextEditingController gender=TextEditingController();
  TextEditingController status=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.black,elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Profile', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
      actions: [InkWell(onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),));},child: Image.asset('assets/images/edit.png',width: 33,height: 33,)),SizedBox(width: 21.7,)],
        centerTitle: true,
      ),
      body: Stack(
        children:[ Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
          Center(
            child: Container(
              width: 335,
              height: 634.82,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage: widget.imgpath != null && widget.imgpath!.isNotEmpty
                        ? FileImage(File(widget.imgpath!))
                        : AssetImage('assets/images/accountpic.png') as ImageProvider<Object>?,
                  ),
                  Heading_Text(text: 'Ashfaq Sayem', fw: FontWeight.w700, fs: 15, fc: Colors.black, ls: -0.1, tp: 12),
                  Heading_Text(text: 'qureshi234@gmail.com', fw: FontWeight.w400, fs: 9, fc: Color(0xFF848484) ,ls: -0.1, tp: 0),
                  ProfileScreenTextField(controller: email,text: widget.email!=null&&widget.email!=''?widget.email!:'qureshi234@gmail.com',icon: Icons.email,option1: '',option2: '',toppadding: 32),
                  ProfileScreenTextField(controller: date,text: widget.date!=null&&widget.date!=''?widget.date!:'20/8/2000',icon: Icons.calendar_today,option1: '',option2: '',toppadding: 24.32),
                  ProfileScreenTextField(controller: gender,text:  widget.gender!=null&&widget.gender!=''?widget.gender!:'Male',icon: null,icon1: Icons.male,icon2: Icons.female_outlined,option1: 'Male',option2: 'Female',toppadding: 24.32),
                  ProfileScreenTextField(controller: status,text: widget.status!=null&&widget.status!=''?widget.status!:'Married',icon: null,icon1: Icons.group_outlined,icon2: Icons.person,option1: 'Married',option2: 'UnMarried',toppadding: 24.32),
                  SizedBox(height: 46.32,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RegScreenButton( isSelected: selectedGoal == 'Symptoms',onPressed: (){
                        handleButtonClick('Symptoms');
                      },btnw: 93.68, btnh: 30.38, btntext: 'Symptoms', btnbgcolor: Colors.white, btnfgcolor: Color(0xFFA59F9F), btnbordercolor: Colors.transparent, btnradius: 8, tm: 0,fontsize: 9),
                      RegScreenButton(onPressed: (){
                        handleButtonClick('Diseases');
                      },isSelected: selectedGoal == 'Diseases',btnw: 105.66, btnh: 30.38, btntext: 'Diseases', btnbgcolor: Colors.white, btnfgcolor: Color(0xFFA59F9F), btnbordercolor: Colors.transparent, btnradius: 8, tm: 0,fontsize: 9),
                      RegScreenButton(onPressed: (){
                        handleButtonClick('Wellness Goals');
                      },isSelected: selectedGoal == 'Wellness Goals',btnw: 105.66, btnh: 30.38, btntext: 'Wellness Goals', btnbgcolor: Colors.white, btnfgcolor: Color(0xFFA59F9F), btnbordercolor: Colors.transparent, btnradius: 8, tm: 0,fontsize: 8),
                     ],
                  ),
                  SizedBox(height: 56+36,),
                  Row(mainAxisAlignment: MainAxisAlignment.end,children: [Image.asset('assets/images/addbutton.png',width: 36,height: 36,),SizedBox(width: 12,)],)

                ],
              ),
            ),
          )
      ],
      ),
      
    );
  }
}//56+36
