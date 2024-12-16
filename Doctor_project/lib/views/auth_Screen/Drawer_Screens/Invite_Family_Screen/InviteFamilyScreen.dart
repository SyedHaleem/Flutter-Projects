import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawer_Screen_Widgets/DrawerScreenElevatedButton.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Invite_Family_Screen/Invite_Family_Screen_Widgets/ServicesCard.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InviteFamilyScreen extends StatefulWidget {
  const InviteFamilyScreen({Key? key}) : super(key: key);

  @override
  State<InviteFamilyScreen> createState() => _InviteFamilyScreenState();
}

class _InviteFamilyScreenState extends State<InviteFamilyScreen> {
  final String urlToShare = 'https://www.figma.com/file/j6v69j1Xhl17UTomwmadC5/TEAM-WORK-APP-(Copy)?type=design&node-id=0-1&mode=design&t=XBL1abZ251JRSfYu-0'; // Replace with your URL

  void shareToWhatsApp() async {
    await FlutterShare.share(
      title: 'Share via WhatsApp',
      text: 'Check out this link: $urlToShare',
      linkUrl: urlToShare,
    );
  }
  void copyUrlToClipboard() {
    Clipboard.setData(ClipboardData(text: urlToShare));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: Duration(seconds: 1),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.all(16),content: Text('Url Copy to ClipBoard')),
    );
  }
  var serviceContent = [
    {"service": "Doctor Appointments", "img": "assets/images/service1.png"},
    {"service": "Online Consultation", "img": "assets/images/service2.png"},
    {"service": "Book Lab Test", "img": "assets/images/service3.png"},
    {"service": "Order Medicines", "img": "assets/images/service4.png"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.black, elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Invite Family and Friends', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),
          centerTitle: true),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 331,
          height: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Heading_Text(align: TextAlign.start,text: 'Services Of DoctorSpot', fw: FontWeight.w600, fs: 15, fc: Colors.black, ls: 0.29, tp: 30),
                Paraghraph_Text(align: TextAlign.start,text: 'DoctorSpot has served 1 Crore people in Pakistan & offer following services:', fs: 12, fc: Color(0xff6B7280), ls: 0.29, tp: 5, isunderline: false),
                Container(
                  width: 331,
                  height: 340,
                  margin: EdgeInsets.only(top: 20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 24.0,
                    ),
                    itemCount: serviceContent.length,
                    itemBuilder: (context, index) {
                      return ServicesCard(
                        imgpath: serviceContent[index]['img']!,
                        service: serviceContent[index]['service']!,
                      );
                    },
                  ),
                ),
                Heading_Text(text: 'Share DoctorSpot App with your fiends and family,', fw: FontWeight.w600, fs: 15, fc: Colors.black, ls: 0.29, tp: 35,align: TextAlign.center,),
               Paraghraph_Text(text: 'Your one share can help your friends & family to find, book or consuit veified doctors without any hassle. ', fs: 12, fc: Color(0xff6B7280), ls: .29, tp: 15, isunderline: false,align: TextAlign.center,),
                Center(child: DrawerScreenElevatedButton(onPressed: shareToWhatsApp,buttonwidth: 217, buttonheight: 50, icon: FontAwesomeIcons.whatsapp, text: '\t\t\tShare Via Whatsapp', islogout: false,fontsize: 9,iconsize: 26,color: Color(0xff02C782),toppadding: 30,borderColor: Colors.transparent,textColor: Colors.white,)),
                Center(child: DrawerScreenElevatedButton(onPressed: copyUrlToClipboard,buttonwidth: 217, buttonheight: 50, icon: FontAwesomeIcons.link, text: '\t\t\tCopy Link', islogout: false,fontsize: 9,iconsize: 20,color: Colors.white,toppadding: 12,borderColor: Color(0xffF7F8F8),textColor: Colors.black,)),
                SizedBox(height: 74,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
