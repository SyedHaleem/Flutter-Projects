import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class secondCard extends StatelessWidget {
  const secondCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 140,
      margin: EdgeInsets.only(top: 10), //15
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/frame1.png'),fit: BoxFit.cover,),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(top: 19,left: 20),
            leading: CircleAvatar(radius: 25,backgroundImage: AssetImage('assets/images/williem.png',),),
            title: Text('DR Williem Smith',style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.white,letterSpacing: 0.8)),
            subtitle: Text('Dentist | Royal Hospital ',style: GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.w400,color: Colors.white,letterSpacing: 0.4),),
            trailing: Transform.translate(
              offset: Offset(0,-13), // Adjust the offset values as needed
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: Colors.white),
              ), ),),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Container(
                  width: 104,
                  height: 38,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                    color:Color(0xFF000000).withOpacity(0.09),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/images/calendar.png',width: 18,height: 18,),
                     Text('Sep 10, 2023',style: GoogleFonts.poppins(fontSize: 7,fontWeight: FontWeight.w400,color: Colors.white,)),
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  width: 104,
                  height: 38,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Color(0xFF000000).withOpacity(0.09),),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/images/clock.png',width: 18,height: 18,),
                      Text('05:00 PM',style: GoogleFonts.poppins(fontSize: 7,fontWeight: FontWeight.w400,color: Colors.white,)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
        
      ),
    );
  }
}
