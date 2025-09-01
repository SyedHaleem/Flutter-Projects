import 'package:doctor_project/models/doctordetailcontent.dart';
import 'package:doctor_project/models/hospitalcardcontent.dart';
import 'package:doctor_project/models/mainScreenRowcontent.dart';
import 'package:doctor_project/models/mainscreencontent.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawerscreen.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/Doctorpage.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/Hospitalpage.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/Doctordetailcard.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/Headingtext.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/Hospitalcard.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/MainScreencontainer.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/Thirdcard.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/customIcon.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/firstCard.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/MainScreencard1.dart';
import 'package:doctor_project/views/auth_Screen/Main_Screen/MainScreen_Widgets/secondCard.dart';
import 'package:doctor_project/widgets/bottomNavigationBar.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
      drawer: Drawerscreen(),
      appBar: AppBar(
        leading: Padding(
        padding: const EdgeInsets.only(left: 19), // Add left padding
        child: InkWell(onTap: (){_scaffoldKey.currentState?.openDrawer();},child: customIcon(path: 'assets/images/menu.png')),
      ),
        leadingWidth: 39.49,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Row(
            children: [
              InkWell(onTap: (){},child: customIcon(path: 'assets/images/bell.png',width: 22,height: 22,)),
              SizedBox(width: 10,),
              InkWell(onTap: (){},child: customIcon(path: 'assets/images/bag.png',width: 30,height: 30,)),
              SizedBox(width: 20,),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: firstCard()),
              Center(child: Container(
                width: 335,
                height: 193,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Heading_Text(text: 'Upcoming Appointment ', fw: FontWeight.w600, fs: 15, fc: Color(0xFF101828), ls: 0.19, tp: 15),
                    secondCard(),
                  ],
                ),
              ),),
              Center(
                child: Container(
                  width: 337.25,
                  height: 673.19,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Heading_Text(text: 'How can we help you today?', fw: FontWeight.w600, fs: 15, fc: Color(0xFF101828), ls: 0.19, tp: 20),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for(int i=0;i<contents.length;i++)
                            Mainscreencard1(imagepath: contents[i].imagepath,text: contents[i].text,headingtext: contents[i].heading),
                        ],
                      ),
                      Thirdcard(),
                      Headingtext(headingtxt: 'symptoms ❓',toppadding: 18,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for(int i=0;i<container_contents.length-4;i++) //disease container
                              MainScreencontainer(imagepath: container_contents[i].imagepath, disease: container_contents[i].disease),
                          ],
                        ),
                      ),
                     Headingtext(headingtxt: 'Disease 😷',toppadding: 18,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for(int i=4;i<container_contents.length;i++)
                              MainScreencontainer(imagepath: container_contents[i].imagepath, disease: container_contents[i].disease),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 336.9,
                  height: 335.45,
                  child: Column(
                    children: [
                      Headingtext(headingtxt: 'Doctors in Kohat',toppadding: 10,onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Doctorpage(),));}),
                      for(int j=0;j<doctorcontent.length-2;j++)
                        Doctordetailcard(doctorname: doctorcontent[j].docname,imgpath: doctorcontent[j].imagepath),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: 337.25,
                    height: 180.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Headingtext(headingtxt: 'Hospitals in Kohat', toppadding: 0,onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Hospitalpage(),));},),
                        Container(
                          width: double.infinity,
                          height: 139.35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: hospitalcontents.length-5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: Hospitalcard(
                                  imgpath: hospitalcontents[index].imagepath,
                                  headingtext: hospitalcontents[index].heading,
                                  address: hospitalcontents[index].address,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }
}