import 'dart:io';
import 'package:doctor_project/Controllers/ImagePickerController.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Profile_Screens/ProfileScreen.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/widgets/DropDownButton.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
 ImagePickerController controller=Get.put(ImagePickerController());
  String selectedGoal = '';
  void handleButtonClick(String goal) {
    setState(() {
      selectedGoal = goal;
    });
  }
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController date=TextEditingController();
  String _selectedGender = 'Select Your Gender'; // Default selected gender
  List<String> _genders = ['Select Your Gender','Male', 'Female', 'Other']; // List
  String _selectedStatus = 'Select Your Status'; // Default selected gender
  List<String> _Status = ['Select Your Status','Married', 'UnMarried',];// of// genders
  String image='';
  String sendemail='';
  String senddate='';
  String gender='';
  String status='';
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: InkWell(
        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(imgpath: this.image,email: sendemail,date: senddate,gender: this.gender,status: this.status),)),
      child: Icon(Icons.arrow_back_outlined)),foregroundColor: Colors.black, elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Edit Profile', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
      centerTitle: true),
      body: Stack(
        children:[ Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: 335,
                height: 634.82,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () =>  Stack(alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(radius: 44,
                            
                            backgroundImage: controller.imagePath.isNotEmpty?FileImage(File(controller.imagePath.toString())):AssetImage('assets/images/accountpic.png')as ImageProvider<Object>?,),
                            InkWell(onTap: (){
                              showModalBottomSheet(backgroundColor: Colors.transparent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),context: context, builder: (context) =>
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                                    child: Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children: [
                                      Column(children: [
                                        InkWell(onTap: (){
                                          controller.getImage(ImageSource.gallery);
                                        },child: Icon(Icons.image,color: Color(0xff5B7FFF),size: 50,)),
                                        Text('Gallery',style: GoogleFonts.nunito(fontSize: 11,fontWeight: FontWeight.w600,color: Color(0xff5B7FFF)))
                                      ],),
                                      Column(children: [
                                        InkWell(onTap: (){
                                          controller.getImage(ImageSource.camera);
                                        },child: Icon(Icons.camera_alt,color: Color(0xff5B7FFF),size: 50,)),
                                        Text('Camera',style: GoogleFonts.nunito(fontSize: 11,fontWeight: FontWeight.w600,color: Color(0xff5B7FFF)))
                                      ],),
                                    ],),
                                  ),);
                            },splashColor: Colors.grey,child: Image.asset('assets/images/camera.png',width: 23,height: 23,))
                      ]),
                    ),
                    Heading_Text(text: 'Ashfaq Sayem', fw: FontWeight.w700, fs: 15, fc: Colors.black, ls: -0.1, tp: 12),
                    Heading_Text(text: 'qureshi234@gmail.com', fw: FontWeight.w400, fs: 9, fc: Color(0xFF848484) ,ls: -0.1, tp: 0),
                    custom_TextformField(textController: name, keytype: TextInputType.name, text: 'Name', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 50.79, tmrgin: 35),
                    custom_TextformField(textController: email, keytype: TextInputType.emailAddress, text: 'Email', regx: '', isPassword: false, isDateofBirth: false, readonly: false, fieldw: 331, fieldh: 50.79, tmrgin: 15.38),
                    custom_TextformField(textController: date, keytype: TextInputType.none, text: 'Date of Birth', regx: '', isPassword: false, isDateofBirth: true, readonly: true, fieldw: 331, fieldh: 50.79, tmrgin: 15.38),
                    Row(
                      children: [
                        DropDownButton(
                          toppadding: 15.38,
                          selectedGender: _selectedGender,
                          genders: _genders,
                          onChanged: (String newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    DropDownButton(
                      toppadding: 15.38,
                      selectedGender: _selectedStatus,
                      genders: _Status,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      },
                    ),
                    custom_ElevatedButton(onPressed: () {
                     setState(() {
                       this.image=controller.imagePath.toString();
                       this.sendemail=email.text.toString();
                       this.senddate=date.text.toString();
                       this.gender=_selectedGender;
                       this.status=_selectedStatus;
                     });
                    },btnw: 331, btnh: 50.79, btntext: 'Save', btnbgcolor: Color(0xff5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10,tm: 54.5,)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
