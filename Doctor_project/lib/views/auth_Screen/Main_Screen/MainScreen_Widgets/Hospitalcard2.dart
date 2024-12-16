import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Hospitalcard2 extends StatelessWidget {
  final String imgpath;
  final String title;
  final String subtitle;

  const Hospitalcard2({Key? key, required this.imgpath, required this.title, required this.subtitle}) : super(key: key);
  Widget buildColumn1(String heading) {
    return Row(
          children: [
            Row( children: [Image.asset('assets/images/hospitallogo.png',width: 13,height: 13,),SizedBox(width: 4,),Heading_Text(text: heading, fw: FontWeight.bold, fs: 11, fc: Colors.black, ls: .2, tp: 2)],),
          ],);

  }

  Widget buildColumn2(String address) {
    return Row(
          children: [
          Row(children: [Icon(Icons.location_on_outlined,size: 13,color: Color(0xFF02C782),),SizedBox(width: 4,),Heading_Text(text: address, fw: FontWeight.w500, fs: 8, fc: Color(0xFF8A96BC), ls: .2, tp: 2)],),
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Container(
        width: 335,
        height: 97,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: ListTile(contentPadding: EdgeInsets.all(10),
            leading: Image.asset(this.imgpath,width: 57.65,height: 61.58,),
            title: buildColumn1(this.title),
            subtitle: buildColumn2(this.subtitle)),
          ),
      ),
    );
  }
}