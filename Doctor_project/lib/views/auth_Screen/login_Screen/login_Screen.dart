import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/Registration_Screen.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/forgotPassword_Screen.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/Image_Container.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_LoweBar.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_RichText.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class login_Screen extends StatefulWidget {
  final String? email;
  final String? pass;
  const login_Screen({Key? key, this.email, this.pass}) : super(key: key);

  @override
  State<login_Screen> createState() => _login_ScreenState();
}

class _login_ScreenState extends State<login_Screen> {
  TextEditingController Email =TextEditingController();
  TextEditingController password=TextEditingController();
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
                Center(child: Image_Container(Width: Get.width*0.61, height: Get.height*0.31, tmargin: Get.height * 0.06, asset: 'assets/images/logo.png')),
                Container(
                  width: 331,
                  height: 367.44,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Heading_Text(text: 'Sign in to your account', fw:FontWeight.w700 , fs: 18, fc: Colors.black, ls: -0.19, tp: 0),
                      Paraghraph_Text(text: 'Welcome back, Sign in to your account', fs: 11, fc: Color(0xFF6B7280), ls: 0.29, tp: 5, isunderline: false),
                      custom_TextformField(check: widget.email,fieldw: 331,fieldh: 55.79,tmrgin: 15.4,textController: Email, keytype: TextInputType.emailAddress, text: 'Email', regx: r'^[a-z,A-Z,0-9]+@[a-z,A-Z,0-9]+\.[a-z,A-Z]+', isPassword: false, isDateofBirth: false, readonly: false,),
                      custom_TextformField(check: widget.pass,fieldw: 331,fieldh: 55.79,tmrgin: 15.4,textController: password, keytype: TextInputType.visiblePassword, text: 'Password', regx: r'^[a-z,A-Z,0-9]', isPassword: true, isDateofBirth: false, readonly: false,),
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => forgotPassword_Screen(),)),
                        child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Paraghraph_Text(text: 'Forgot Password?', fs: 11, fc: Colors.blue, ls: 0.5, tp: 10, isunderline: false),
                    ]),
                      ),
                      custom_ElevatedButton(onPressed:(){
                        if(formKey.currentState!.validate())
                        {
                          // final snackBar=SnackBar(content: Center(child: Text('You have been Logged In')),backgroundColor: Color(0xFF5B7FFF),duration: Duration(milliseconds: 800),);
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(),));
                        }
                      }
                      ,btnw: 331, btnh: 50, btntext: 'Sign In', btnbgcolor: Color(0xFF5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10, tm: 86),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: InkWell(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Registration_Screen(),)),
                      child: custom_RichText(txt1: "Don't have an account? ", txt2: "Register Now")),
                ),
                custom_LowerBar(Width:  Get.width*0.5, height: Get.height*0.01, bgcolor: Color(0xFF1D3A70), tmargin: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}