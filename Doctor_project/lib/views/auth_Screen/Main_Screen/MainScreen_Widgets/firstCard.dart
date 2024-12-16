import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/RegScreenTextFormfield.dart';
import 'package:doctor_project/views/auth_Screen/Search_Tab_Screens/SearchScreens.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/loginScreen_Widgets/custom_TextformField.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class firstCard extends StatefulWidget {
  const firstCard({Key? key}) : super(key: key);

  @override
  State<firstCard> createState() => _firstCardState();
}

class _firstCardState extends State<firstCard> {
  TextEditingController search=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 337,
        height: 117.83,
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 0,),
              leading: CircleAvatar(radius: 20,backgroundImage: AssetImage('assets/images/b.png')),
              title: Text("Baksi Lana",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Color(0xFF221E1E))),
              subtitle: Row(
                children: [
                  Icon(Icons.location_on_rounded,color: Color(0xFF4C4DDC),size: 13.87,),
                  Text('\tWallace, Australia',style: GoogleFonts.plusJakartaSans(fontSize: 9.71,color: Color(0xFF101010)),),
                  Icon(Icons.arrow_drop_down_outlined,color: Color(0xFF4C4DDC),size: 13.87,),

                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                    width: 337,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: TextField(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreens(),)),
                      controller: search,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 15,bottom: 5),
                        border: InputBorder.none,
                        hintText: "Search by Doctors, hospitals, specialist ...",
                        hintStyle: TextStyle(color: Color(0xFFAFAEAE),fontSize: 11),
                      ),
                    )),
                Container(width: 44,height: 45,child: ElevatedButton(style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),backgroundColor: MaterialStatePropertyAll(Color(0xFF5B7FFF),),),onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreens(),));

                }, child: Center(child: Icon(Icons.search_outlined,color: Colors.white,)))),
              ],
            )
             ],
        ));
  }
}
