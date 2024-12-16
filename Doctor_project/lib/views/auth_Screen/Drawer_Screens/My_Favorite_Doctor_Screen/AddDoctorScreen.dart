import 'package:doctor_project/models/FavoriteDoctorContent.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawer_Screen_Widgets/DoctorCard.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawer_Screen_Widgets/DrawerScreenElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  void deleteDoctor(int index) {
    setState(() {
      favdoctorcontents.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.black, elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Add Friend & Family', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
          centerTitle: true),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20.5),
                width: 331,
                height: 534,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 22),// Adjust the height as needed
                  scrollDirection: Axis.vertical,
                  itemCount: favdoctorcontents.length,
                  itemBuilder: (context, index) {
                    return DoctorCard(
                      onDelete: () => deleteDoctor(index),
                      imgpath: favdoctorcontents[index].imgpath,
                      name: favdoctorcontents[index].name,
                      specialistof: favdoctorcontents[index].specialistof,
                    );
                  },
                ),
              ),
            ),
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 62.17),
              child: DrawerScreenElevatedButton(buttonwidth: 327, buttonheight: 55, icon: Icons.add, text: 'Add New Member',islogout: false,color:Color(0xff5B7FFF),iconsize: 20,fontsize: 12,toppadding: 0,borderColor: Colors.transparent,textColor: Colors.white),
            )),
          ],
        ),
      ),
    );
  }
}
