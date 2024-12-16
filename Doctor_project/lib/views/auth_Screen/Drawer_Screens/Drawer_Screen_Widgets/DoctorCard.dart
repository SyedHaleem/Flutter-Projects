import 'package:doctor_project/views/auth_Screen/Registrations_Screen/RegistrationScreen_Widgets/RegScreenButton.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatefulWidget {
  final String specialistof;
  final String imgpath;
  final String name;
  final Function onDelete;
  const DoctorCard({Key? key, required this.specialistof, required this.imgpath, required this.name, required this.onDelete}) : super(key: key);

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

Widget buildColumn1(BuildContext context,String speacialistof,Function onDelete)
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       Heading_Text(text: '$speacialistof', fw: FontWeight.w600, fs: 8.5, fc: Color(0xff5B7FFF), ls: 0.2, tp: 0),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(top: 13.91),
          alignment: Alignment.center,
          width: 75.17,
          height: 32.17,
          decoration: BoxDecoration(color: Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(9.59),
          ),
          child: Heading_Text(text: 'Book Now', fw: FontWeight.w500, fs: 8.5, fc: Color(0xff222E54), ls: 0.2, tp: 0),
        ),
        Row(children: [
          InkWell(onTap: (){},child: Image.asset('assets/images/shareicon.png',width: 20.8,height: 16.8,)),
          SizedBox(width: 15,),
          InkWell(onTap: (){
            showDialog(context: context, builder: (context) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                content: Container(
              width: 345,
              height: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/delete.png',width: 71,height: 71,),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(color: Color(0xffCBD5E1),),
                      ),
                      Heading_Text(text: 'Are you sure you want to', fw: FontWeight.w600, fs: 12, fc: Colors.black, ls: 0.29, tp: 0),
                      Heading_Text(text: 'Delete', fw: FontWeight.w600, fs: 12, fc: Colors.black, ls: 0.29, tp: 0),
                      Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                        custom_ElevatedButton(onPressed: () {
                          Navigator.pop(context);
                        },btnw: 100, btnh: 43, btntext: 'No', btnbgcolor: Colors.white, btnfgcolor: Color(0xff5B7FFF), btnbordercolor: Color(0xff5B7FFF), btnradius: 8,tm: 48,textsize: 12,),
                        SizedBox(width: 18,),
                        custom_ElevatedButton(onPressed: () {
                          onDelete();
                          Navigator.pop(context);
                        },btnw: 100, btnh: 43, btntext: 'Yes', btnbgcolor: Color(0xff5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Color(0xff5B7FFF), btnradius: 8,tm: 48,textsize: 12,),
                      ],),
                    ],
                  ),
            ),
            ),);
          },child: Image.asset('assets/images/deleteicon.png',width: 15.5,height: 18.46,)),
          SizedBox(width: 5,),
        ],)
        ],
      ),
    ],
  );
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 331,
      height: 117,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.87),
        border: Border.all(color: Color(0xffF7F8F8),width: 1.92),
      ),
      child: ListTile(
        leading: Image.asset(widget.imgpath,width: 54.86,height: 57.51,),
        title: Transform.translate(offset: Offset(0, 7),child: Heading_Text(text: widget.name, fw: FontWeight.w600, fs: 14, fc: Color(0xff263257), ls: 0.2, tp: 0)),
        subtitle: Transform.translate(offset: Offset(0, 8),child: buildColumn1(context,widget.specialistof,widget.onDelete)),
       ),
    );
  }
}
