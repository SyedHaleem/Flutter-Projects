import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/Image_Container.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/otp_Screen.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class forgotPassword_Screen extends StatefulWidget {
  const forgotPassword_Screen({Key? key}) : super(key: key);

  @override
  State<forgotPassword_Screen> createState() => _forgotPassword_ScreenState();
}

class _forgotPassword_ScreenState extends State<forgotPassword_Screen> {
  TextEditingController Email=TextEditingController();
  final _ScaffoldKey=GlobalKey<ScaffoldState>();
  final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back_rounded,color: Color(0xFF222B45),)),
        elevation: 0,backgroundColor: Colors.white,),
      key: _ScaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image_Container(Width: 165.83, height: 170, tmargin: 66, asset: 'assets/images/lock.png'),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 331,
                  height: 252.64,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Heading_Text(text: 'Forgot Password?', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
                        Text('Enter your email address to get an OTP code to reset your password',style: TextStyle(fontSize: 12,color: Color(0xFF6B7280),letterSpacing: 0.29,fontWeight: FontWeight.w400),),
                        custom_TextformField(fieldw: 331,fieldh: 55.79,tmrgin: 15.4,textController: Email, keytype: TextInputType.emailAddress, text: 'Email', regx: r'^[a-z,A-Z,0-9]+@[a-z,A-Z,0-9]+\.[a-z,A-Z]+', isPassword: false, isDateofBirth: false, readonly: false,),
                        custom_ElevatedButton(
                          onPressed: (){
                            if(_formkey.currentState!.validate())
                              {
                                final snackBar=SnackBar(content: Center(child: Text('Check your Email for the OTP'),),backgroundColor: Color(0xFF5B7FFF),duration: Duration(seconds: 1),);
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => otp_Screen(),));
                              }
                          },
                            btnw: 331, btnh: 55, btntext: 'Send me Email', btnbgcolor: Color(0xFF5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10, tm: 53.4),
                      ],
                ),),
              ],
            ),
          ),
        )
      ),

    );
  }
}
