import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Are_You_Doctor_Screen/Are_you_Doctor_Widgets/CustomRadioButton.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/material.dart';

class AreYouDoctorScreen extends StatefulWidget {
  const AreYouDoctorScreen({Key? key}) : super(key: key);

  @override
  State<AreYouDoctorScreen> createState() => _AreYouDoctorScreenState();
}

class _AreYouDoctorScreenState extends State<AreYouDoctorScreen> {
  String Q1='';
  String Q2='';
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController phno=TextEditingController();
  TextEditingController city=TextEditingController();
  TextEditingController speciality=TextEditingController();
  TextEditingController pmdc=TextEditingController();
  TextEditingController message=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.black, elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Are you a Doctor?', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
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
                Paraghraph_Text(text: 'Lets us know if you want to display your information as doctor or wants us to edit it. We will be happy to heip.', align: TextAlign.start,fs: 12, fc: Color(0xff6B7280), ls: 0.29, tp: 40, isunderline: false),
                custom_TextformField(textController: name, keytype: TextInputType.name, text: 'Name', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 25),
                custom_TextformField(textController: email, keytype: TextInputType.emailAddress, text: 'Email', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 16),
                custom_TextformField(textController: phno, keytype: TextInputType.name, text: 'Phone Number', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 16),
                custom_TextformField(textController: city, keytype: TextInputType.name, text: 'City', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 16),
                custom_TextformField(textController: speciality, keytype: TextInputType.name, text: 'Speciality', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 16),
                custom_TextformField(textController: pmdc, keytype: TextInputType.name, text: 'PMDC', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 55.79, tmrgin: 16),
                custom_TextformField(textController: message, keytype: TextInputType.name, text: 'Enter Message', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 161, tmrgin: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Divider(color: Color(0xff6969691A),),
                ),
                Heading_Text(text: 'Do you want to grow your practice? (more patient leads)', fw:FontWeight.w600, fs: 13, fc: Color(0xff0F172A), ls: 0.29, tp: 8),
                CustomRadioButton(
                  groupName: 'group1',
                  yesLabel: 'Yes',
                  noLabel: 'No',
                  onChanged: (value) {
                    Q1=value;
                    print('Question 1 Answer $Q1');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Divider(color: Color(0xff6969691A),),
                ),
                Heading_Text(text: 'Do you want to manage practice? (Scheduling, EMR, reminder, data, patient record?)', fw:FontWeight.w600, fs: 13, fc: Color(0xff0F172A), ls: 0.29, tp: 8),
                CustomRadioButton(
                  groupName: 'group2',
                  yesLabel: 'Yes',
                  noLabel: 'No',
                  onChanged: (value) {
                    Q2=value;
                    print('Question 1 Answer $Q2');
                  },
                ),
                custom_ElevatedButton(btnw: 331, btnh: 50, btntext: 'Submit', btnbgcolor: Color(0xff5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10,tm: 31,),
                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
