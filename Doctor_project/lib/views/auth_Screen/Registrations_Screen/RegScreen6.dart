import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegScreen7.dart';
import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/RegScreenTextFormfield.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegScreen6 extends StatefulWidget {
  const RegScreen6({Key? key}) : super(key: key);

  @override
  State<RegScreen6> createState() => _RegScreen6State();
}

class _RegScreen6State extends State<RegScreen6> {
  final _formkey=GlobalKey<FormState>();
  final _scaffoldkey=GlobalKey<ScaffoldState>();
  TextEditingController disease=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(padding: EdgeInsets.only(top: 30),onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF191919),)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                      Text('Step 6 of 7',softWrap: true,style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,color: Color(0xFF191919),fontSize: 12),),
                      Heading_Text(text: 'Start typing the symptom (s)', fw: FontWeight.w700, fs: 15, fc: Colors.black, ls: -0.19, tp: 5),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(child: Image.asset('assets/images/girl.png',height: 186.28,width: 279.66,))),

                Center(
                  child: Container(
                    width: 335,
                    height: 313.65,
                    margin: EdgeInsets.only(top: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Tell us about persistent symptoms troubling you and we will help you address them effectively',style: GoogleFonts.openSans(fontSize: 12,color: Colors.black,letterSpacing: 0.3,fontWeight: FontWeight.w400,),),
                        RegScreenTextFormfield(textController: disease, keytype: TextInputType.text, text: 'E.g Headache', validatetext: 'disease', fieldw: 331, fieldh: 55.79, tmrgin: 30),
                        custom_ElevatedButton(onPressed: (){
                          if (_formkey.currentState!.validate()) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegScreen7(),));
                          } else {
                            final snackBar = SnackBar(
                              content: Center(child: Text('Please enter your disease')),
                              backgroundColor: Color(0xFF5B7FFF),
                              duration: Duration(milliseconds: 1000),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },btnw: 331, btnh: 49.79, btntext: 'Continue', btnbgcolor: Color(0xFF5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 11.48, tm: 60),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
