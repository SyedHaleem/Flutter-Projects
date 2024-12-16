import 'package:doctor_project/models/FriendandFamilyContent.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawer_Screen_Widgets/DrawerScreenElevatedButton.dart';
import 'package:doctor_project/views/auth_Screen/Drawer_Screens/Drawer_Screen_Widgets/FamilyCard.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
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
                  itemCount: friendcontents.length,
                  itemBuilder: (context, index) {
                    return FamilyCard(
                      imgpath: friendcontents[index].imgpath,
                      name: friendcontents[index].name,
                      relation: friendcontents[index].relation,
                    );
                  },
                ),
              ),
            ),
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 62.17),
              child: DrawerScreenElevatedButton(buttonwidth: 327, buttonheight: 55, icon: Icons.add, text: 'Add New Member', islogout: true,color: Color(0xff5B7FFF),iconsize: 20,fontsize: 12,toppadding: 0,textColor: Colors.white,borderColor: Colors.transparent,),
            )),
          ],
        ),
      ),
    );
  }
}
