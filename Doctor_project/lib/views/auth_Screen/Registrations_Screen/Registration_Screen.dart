import 'package:doctor_project/views/auth_Screen/Registrations_Screen/Reg_Screen1.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/Image_Container.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_LoweBar.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_RichText.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/login_Screen.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
class Registration_Screen extends StatefulWidget {
  const Registration_Screen({Key? key}) : super(key: key);

  @override
  State<Registration_Screen> createState() => _Registration_ScreenState();
}

class _Registration_ScreenState extends State<Registration_Screen> {
  TextEditingController Email =TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController Name=TextEditingController();
  TextEditingController Phonenumber=TextEditingController();
  TextEditingController Dob=TextEditingController();

  final formKey=GlobalKey<FormState>();
  final _scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Image_Container(Width: Get.width*0.6, height: Get.height*0.29, tmargin: Get.height * 0.04, asset: 'assets/images/logo.png')),
                Container(
                  width: 331,
                  height: 460,
                  // color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Heading_Text(text: 'Register Now', fw:FontWeight.w700 , fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
                      Paraghraph_Text(text: 'Welcome back, Sign in to your account', fs: 11, fc: Color(0xFF6B7280), ls: 0.29, tp: 5, isunderline: false),
                      custom_TextformField(fieldw: 331,fieldh: 55.79,tmrgin: 10,textController: Name, keytype: TextInputType.text, text: 'Name', regx: r'^[a-zA-Z]+$', isPassword: false, isDateofBirth: false, readonly: false,),
                      custom_TextformField(fieldw: 331,fieldh: 55.79,tmrgin: 10,textController: Email, keytype: TextInputType.emailAddress, text: 'Email', regx: r'^[a-z,A-Z,0-9]+@[a-z,A-Z,0-9]+\.[a-z,A-Z]+', isPassword: false, isDateofBirth: false, readonly: false,),
                      custom_TextformField(fieldw: 331,fieldh: 55.79,tmrgin: 10,textController: Phonenumber, keytype: TextInputType.number, text: 'Phone Number', regx: r'^03[0-9]{9}$', isPassword: false, isDateofBirth: false, readonly: false,),
                      custom_TextformField(fieldw: 331,fieldh: 55.79,tmrgin: 10,textController: password, keytype: TextInputType.visiblePassword, text: 'Password', regx: r'^[a-z,A-Z,0-9]', isPassword: true, isDateofBirth: false, readonly: false,),
                      custom_TextformField(fieldw: 331,fieldh: 55.79,tmrgin: 10,textController: Dob, keytype: TextInputType.none, text: 'Date of Birth', regx: r'^\d{2}-\d{2}-\d{4}$', isPassword: false, isDateofBirth: true, readonly: true,),
                      custom_ElevatedButton(onPressed:(){

                        if(formKey.currentState!.validate())
                        {
                          // final snackBar=SnackBar(content: Center(child: Text('You have been Registered')),backgroundColor: Color(0xFF5B7FFF),duration: Duration(milliseconds: 400),);
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          String email=Email.text.toString();
                          String pass=password.text.toString();
                          login_Screen(email: email,pass: pass);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Reg_Screen1()));
                        }

                      }
                          ,btnw: 331, btnh: 50, btntext: 'Sign In', btnbgcolor: Color(0xFF5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10, tm: 25),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login_Screen(),)),
                      child: custom_RichText(txt1: "Don't have an account? ", txt2: "Sign In")),
                ),
                custom_LowerBar(Width:  Get.width*0.5, height: Get.height*0.01, bgcolor: Color(0xFF1D3A70), tmargin: 16),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
