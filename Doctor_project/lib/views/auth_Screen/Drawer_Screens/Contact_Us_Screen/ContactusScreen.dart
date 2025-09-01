import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Are_You_Doctor_Screen/Are_you_Doctor_Widgets/CustomRadioButton.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/material.dart';

class ContactusScreen extends StatefulWidget {
  const ContactusScreen({Key? key}) : super(key: key);

  @override
  State<ContactusScreen> createState() => _ContactusScreenState();
}

class _ContactusScreenState extends State<ContactusScreen> {
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController phno=TextEditingController();
  TextEditingController message=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.black, elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Contact Us', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
          centerTitle: true),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 331,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Heading_Text(text: 'Assalam o Alaikum,', fw:FontWeight.w600, fs: 15, fc: Color(0xff0F172A), ls: 0.29, tp: 40),
                Paraghraph_Text(text: 'We love to hear your problems and kind words. talk to Us:)', align: TextAlign.start,fs: 12, fc: Color(0xff6B7280), ls: 0.29, tp: 5, isunderline: false),
                custom_TextformField(textController: name, keytype: TextInputType.name, text: 'Name', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 50),
                custom_TextformField(textController: email, keytype: TextInputType.emailAddress, text: 'Email', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 16),
                custom_TextformField(textController: phno, keytype: TextInputType.name, text: 'Phone Number', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 16),
                custom_TextformField(textController: message, keytype: TextInputType.name, text: 'Enter Message', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 161, tmrgin: 16),
                custom_ElevatedButton(btnw: 331, btnh: 50, btntext: 'Submit', btnbgcolor: Color(0xff5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10,tm: 38.62,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}