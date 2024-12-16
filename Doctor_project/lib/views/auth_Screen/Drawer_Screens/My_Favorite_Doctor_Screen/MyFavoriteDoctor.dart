import 'package:doctor_project/views/auth_Screen/Drawer_Screens/My_Favorite_Doctor_Screen/AddDoctorScreen.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class MyFavoriteDoctor extends StatefulWidget {
  const MyFavoriteDoctor({Key? key}) : super(key: key);

  @override
  State<MyFavoriteDoctor> createState() => _MyFavoriteDoctorState();
}

class _MyFavoriteDoctorState extends State<MyFavoriteDoctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBodyBehindAppBar: true,
      appBar: AppBar(foregroundColor: Colors.black, elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'My Favorite Doctors', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
          centerTitle: true),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 146),
              child: Image.asset('assets/images/doctors.png',width: 296.33,height: 251.84,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 61.16),
              child: ListTile(
                leading: Image.asset('assets/images/cursoricon.png',width: 29.4,height: 29.24,),
              title: Transform.translate(offset:Offset(-12.37, 0),child: Heading_Text(text: 'Include Doctors in your list for Hassle-free Booking.', fw: FontWeight.w500, fs: 11.74, fc: Color(0xFF6B7280), ls: 0, tp: 0)),
              ),
            ),
            ListTile(
              leading: Image.asset('assets/images/groupicon.png',width: 29.4,height: 29.24,),
              title: Transform.translate(offset:Offset(-12.37, 0),child: Heading_Text(text: 'Recommend the Added Doctors to your Friends & Family', fw: FontWeight.w500, fs: 11.74, fc: Color(0xFF6B7280), ls: 0, tp: 0)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 103.38),
              child: custom_ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddDoctorScreen(),));
              },btnw: 327, btnh: 50, btntext: 'Add a Doctor', btnbgcolor: Color(0xff5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Color(0xff5B7FFF), btnradius: 10),
            ),
          ],
        ),
      ),
    );
  }
}
