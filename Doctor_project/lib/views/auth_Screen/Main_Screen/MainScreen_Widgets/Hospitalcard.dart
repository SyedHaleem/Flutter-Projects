import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Hospitalcard extends StatelessWidget {
  final String imgpath;
  final String headingtext;
  final String address;
  const Hospitalcard({Key? key, required this.imgpath, required this.headingtext, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        width: 153,
        height: 139.35,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(borderRadius: BorderRadius.only(topRight: Radius.circular(8),topLeft: Radius.circular(8)),
                  child: Image.asset(imgpath,width: 153,height: 92,fit: BoxFit.cover,)),

                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Row( children: [Image.asset('assets/images/hospitallogo.png',width: 13,height: 13,),SizedBox(width: 5,),Heading_Text(text: headingtext, fw: FontWeight.bold, fs: 7.5, fc: Colors.black, ls: .2, tp: 2)],),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Row(children: [Icon(Icons.location_on_outlined,size: 13,color: Color(0xFF02C782),),SizedBox(width: 4,),Heading_Text(text: address, fw: FontWeight.w500, fs: 7, fc: Color(0xFF8A96BC), ls: .2, tp: 2)],),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
