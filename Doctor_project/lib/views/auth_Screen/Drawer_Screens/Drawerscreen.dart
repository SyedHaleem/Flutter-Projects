import 'package:doctor_project/models/DrawerPageContent.dart';
import 'package:doctor_project/models/DrawerPageContent.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawer_Screen_Widgets/DrawerScreenElevatedButton.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/login_Screen.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class Drawerscreen extends StatefulWidget {
  const Drawerscreen({Key? key}) : super(key: key);

  @override
  State<Drawerscreen> createState() => _DrawerscreenState();
}

class _DrawerscreenState extends State<Drawerscreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width - 70,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children:[
              Container(
              width: 300,
              height: 244,
              decoration: BoxDecoration(
              image: DecorationImage(image:  AssetImage('assets/images/drawerframe.png',),fit: BoxFit.cover),),),
                  Padding(
                    padding: const EdgeInsets.only(top: 75,left: 22,),
                    child: Container(
                    width: 138,
                    height: 143,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      CircleAvatar(
                      radius: 44,
                        backgroundImage: AssetImage('assets/images/Myimage .png'),
                        backgroundColor: Colors.transparent, //0xFF5B7FFF
                      ),
                        Heading_Text(text: 'Syed Haleem', fw: FontWeight.w700, fs: 13, fc: Colors.white, ls: -0.1, tp: 12),
                        Heading_Text(text: 'syedhaleem899@gmail.com', fw: FontWeight.w400, fs: 8, fc: Colors.white, ls: -0.1, tp: 4),
                      ],
                    ),
                ),
                  ),],
          ),
          SizedBox(height: 20,),
          Container(
            width: 258,
            height: 535,
            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(int i=0;i<drawerContents.length;i++)
                  ListTile(
                     splashColor: Colors.grey,
                     onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => drawerContents[i].screen,));
                     },
                    leading: Icon(drawerContents[i].icon,color: Color(0xFFD2D2D2),size: 24),
                    title: Transform.translate(offset: Offset(-13, 0),child: Heading_Text(text: drawerContents[i].pagename, fw: FontWeight.w700, fs: 12, fc: Colors.black, ls: -0.1, tp: 0)),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 22,top: 15),
                  child: DrawerScreenElevatedButton(buttonwidth: 148, buttonheight: 48, icon: Icons.logout, text: 'Log Out',islogout: true,fontsize: 12,color: Color(0xff5B7FFF),iconsize: 20,toppadding: 0,textColor: Colors.white,borderColor: Color(0xff5B7FFF),onPressed: () {
                    showDialog(context: context, builder: (context) =>
                        AlertDialog(shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                          content: Container(
                            width: 345,
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/logouticon.png', width: 71, height: 71,),
                                Padding(padding: const EdgeInsets.only(top: 10),
                                  child: Divider(color: Color(0xffCBD5E1),),),
                                Heading_Text(text: 'Are you sure you want to',
                                    fw: FontWeight.w600, fs: 12, fc: Colors.black, ls: 0.29, tp: 0),
                                Heading_Text(text: 'Log Out!',
                                    fw: FontWeight.w600, fs: 12, fc: Colors.black, ls: 0.29, tp: 0),
                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    custom_ElevatedButton(onPressed: () {Navigator.pop(context);
                                    },
                                      btnw: 100, btnh: 43, btntext: 'No', btnbgcolor: Colors.white,
                                      btnfgcolor: Color(0xff5B7FFF), btnbordercolor: Color(0xff5B7FFF), btnradius: 8, tm: 48, textsize: 12,),
                                    SizedBox(width: 18,),
                                    custom_ElevatedButton(onPressed: () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login_Screen(),));
                                      },
                                      btnw: 100, btnh: 43, btntext: 'Yes', btnbgcolor: Color(0xff5B7FFF),
                                      btnfgcolor: Colors.white, btnbordercolor: Color(0xff5B7FFF),
                                      btnradius: 8, tm: 48, textsize: 12,),
                                  ],),
                              ],
                            ),
                          ),
                        ),);
                  },),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}