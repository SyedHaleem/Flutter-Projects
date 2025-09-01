import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchCard extends StatelessWidget {
  final String imgpath;
  final String title;
  final String location;
  const SearchCard({Key? key, required this.imgpath, required this.title, required this.location}) : super(key: key);

  Widget buildColumn2(String address) {
    return Row(
      children: [
        Row(children: [Icon(Icons.location_on_outlined,size: 13,color: Color(0xFF02C782),),SizedBox(width: 4,),Heading_Text(text: address, fw: FontWeight.w500, fs: 8, fc: Color(0xff02C782), ls: .2, tp: 2)],),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Container(
        margin: EdgeInsets.only(bottom: 7.5),
        width: 329,
        height: 81.2,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.12)),
          elevation: 1,
          child: ListTile(
            onTap: () {

            },
              leading: Image.asset(this.imgpath,width: 57.65,height: 61.65,),
              title: Heading_Text(text: this.title, fw: FontWeight.w600, fs: 10, fc: Colors.black, ls: 0, tp: 0),
              subtitle: buildColumn2(this.location)),
        ),
      ),

        Positioned(
          top: 45,
          left: 263,
          child: GestureDetector(
            onTap: () {
            },
            child: Container(
              width: 62,
              height: 32.71,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Color(0xff5B7FFF),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10),),
              ),
              child: Text('details',style: GoogleFonts.lato(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 8,),),
            ),
          ),
        ),
      ],
    );
  }
}
