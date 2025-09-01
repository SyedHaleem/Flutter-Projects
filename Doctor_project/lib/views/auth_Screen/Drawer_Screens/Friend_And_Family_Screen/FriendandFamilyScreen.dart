import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawer_Screen_Widgets/customCircleContainer.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Friend_And_Family_Screen/AddFriendScreen.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/RegScreenButton.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_LoweBar.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/widgets/DropDownButton.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FriendandFamilyScreen extends StatefulWidget {
  const FriendandFamilyScreen({Key? key}) : super(key: key);

  @override
  State<FriendandFamilyScreen> createState() => _FriendandFamilyScreenState();
}

class _FriendandFamilyScreenState extends State<FriendandFamilyScreen> {
  String selectedGoal = '';
  void handleButtonClick(String goal) {
    setState(() {
      selectedGoal = goal;
    });
  }
  TextEditingController name=TextEditingController();
  TextEditingController phoneno=TextEditingController();
  String _selectedGender = 'Select Your Gender'; // Default selected gender
  List<String> _genders = ['Select Your Gender','Male', 'Female', 'Other']; // List
  String _selectedrelation = 'Your Relationship'; // Default selected gender
  List<String> _relation = ['Your Relationship','Brother', 'Father','Mother','Sister','Friend'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.black, elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Friend & Family', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
          centerTitle: true),
      body: Stack(
        children: [
          Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
          Container(
            width: 327,
            height: 344,
            margin: EdgeInsets.only(top: 90,left: 16),
            decoration: BoxDecoration(
                // color: Colors.cyanAccent,
                image: DecorationImage(image: AssetImage('assets/images/familyframe.png'))
              ),
          ),
          Container(
            margin: EdgeInsets.only(top: 130,left: 31.67),
            width: 295.66,
            height: 297.67,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     customCircleContainer(imgpath: 'assets/images/img1.png'),
                     customCircleContainer(imgpath: 'assets/images/img2.png'),
                   ],
                 ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customCircleContainer(imgpath: 'assets/images/img3.png'),
                customCircleContainer(imgpath: 'assets/images/img4.png'),
              ],
            ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Center(child: custom_ElevatedButton(onPressed: () {
              showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (context) {
                return Container(height: 475,width: 375,decoration: BoxDecoration(borderRadius: BorderRadius.circular(27.19),color: Colors.white),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         Heading_Text(text: 'Add Friends & Family', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 25),
                         SizedBox(width: 49,),
                         InkWell(onTap: (){Navigator.pop(context);},child: Heading_Text(text: 'X', fw: FontWeight.w700, fs: 15, fc: Colors.black, ls: -0.19, tp: 25)),
                        SizedBox(width: 25,),
                      ],
                    ),
                    custom_TextformField(textController: name, keytype: TextInputType.name, text: 'Name', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 50, tmrgin: 25),
                    custom_TextformField(textController: phoneno, keytype: TextInputType.phone, text: 'Phone Number', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 50, tmrgin: 15.43),
                    DropDownButton(selectedGender: _selectedrelation, genders: _relation, onChanged: (String newValue) {
                      setState(() {
                        _selectedrelation = newValue;
                      });
                    }, toppadding: 15.43),
                    DropDownButton(selectedGender: _selectedGender, genders: _genders, onChanged: (String newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    }, toppadding: 15.43),
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                      custom_ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                      },btnw: 129, btnh: 43, btntext: 'Exit', btnbgcolor: Colors.white, btnfgcolor: Color(0xff5B7FFF), btnbordercolor: Color(0xff5B7FFF), btnradius: 8,tm: 40,textsize: 12,),
                      SizedBox(width: 18,),
                      custom_ElevatedButton(onPressed: () {
                      },btnw: 129, btnh: 43, btntext: 'Add', btnbgcolor: Color(0xff5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Color(0xff5B7FFF), btnradius: 8,tm: 40,textsize: 12,),
                    ],),
                    custom_LowerBar(Width:  Get.width*0.4, height: 4.42, bgcolor: Color(0xFF1D3A70), tmargin: 25.8),
                  ],
                ),
                );
              },);
            },btnw: 327, btnh: 50, btntext: 'Add a Member', btnbgcolor: Color(0xff5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Color(0xff5B7FFF), btnradius:10)),
          ),
          Center(child: Paraghraph_Text(text: ' Terms & Conditions', fs: 11, fc: Color(0xff5B7FFF), ls: -0.25, tp: 630, isunderline: true)),
      ],
      ),
    );
  }
}