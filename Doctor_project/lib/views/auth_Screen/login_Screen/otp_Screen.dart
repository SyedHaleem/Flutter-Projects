import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/Image_Container.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_RichText.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class otp_Screen extends StatefulWidget {
  const otp_Screen({Key? key}) : super(key: key);

  @override
  State<otp_Screen> createState() => _otp_ScreenState();
}

class _otp_ScreenState extends State<otp_Screen> {

  @override
  Widget build(BuildContext context) {
    String email = '*****@mail.com';
    String text = 'We send a code to ($email). Enter it here to verify your identity';
    final defaultPinTheme = PinTheme(
      width: 53,
      height: 53,
      textStyle: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color(0xFF5B7FFF)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color(0xFF5B7FFF),
      ),
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image_Container(Width: 159.5, height: 177.8, tmargin: 56, asset: 'assets/images/message.png'),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 331,
              height: 299.64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Heading_Text(text: 'Verify Code', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RichText(softWrap: true,
                  text: TextSpan(
                    style: TextStyle(color: Color(0xFF6B7280),fontSize: 15,letterSpacing: 0.29,fontWeight: FontWeight.w400,height: 1.5),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'We send a code to (',
                      ),
                      TextSpan(
                        text: email,
                        style: TextStyle(
                          color: Color(0xFF5B7FFF),
                        ),
                      ),
                      TextSpan(
                        text: '). \nEnter it here to verify your identity',
                      ),
                    ],
                  ),),
              ),
                Center(
                  child: Pinput(
                    length: 5,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    // validator: (s) {
                    //   return s == '2222' ? null : 'Pin is incorrect';
                    // },
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                  ),
                ),
                  Center(child: Paraghraph_Text(text: 'Resend Code', fs: 11, fc: Color(0xFF5B7FFF), ls: 0.3, tp: 20, isunderline:false)),
                  custom_ElevatedButton(onPressed: (){},
                      btnw: 331, btnh: 55, btntext: 'Verify', btnbgcolor: Color(0xFF5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10, tm: 45),
                ],
              ),),
          ],
        ),
      ),
    );
  }
}
