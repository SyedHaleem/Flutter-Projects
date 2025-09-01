import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FamilyCard extends StatelessWidget {
  final String relation;
  final String imgpath;
  final String name;
  const FamilyCard({Key? key, required this.relation, required this.imgpath, required this.name}) : super(key: key);
  Widget buildColumn1(String relation)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Paraghraph_Text(text: 'Relation ($relation)', fs: 8.5, fc: Color(0xff5B7FFF), ls: 0.2, tp: 0, isunderline: false),
        Heading_Text(text: 'Relation ($relation)', fw: FontWeight.w500, fs: 8.5, fc: Color(0xff5B7FFF), ls: 0.2, tp: 0),
        Container(
          margin: EdgeInsets.only(top: 13.91),
          alignment: Alignment.center,
          width: 121.17,
          height: 32.17,
          decoration: BoxDecoration(color: Color(0xffF7F8F8),
          borderRadius: BorderRadius.circular(9.59),
          ),
          child: Heading_Text(text: 'Book Appointment', fw: FontWeight.w500, fs: 8.5, fc: Color(0xff222E54), ls: 0.2, tp: 0),
        )
      ],
    );
  }
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
        leading: Image.asset(imgpath,width: 54.86,height: 57.51,),
        title: Transform.translate(offset: Offset(0, 7),child: Heading_Text(text: name, fw: FontWeight.w600, fs: 14, fc: Color(0xff263257), ls: 0.2, tp: 0)),
        subtitle: Transform.translate(offset: Offset(0, 8),child: buildColumn1(relation)),
        trailing: Transform.translate(offset: Offset(0, 30.48),child: InkWell(onTap: (){},child: Image.asset('assets/images/deleteicon.png',width: 15.5,height: 18.46,))),
      ),
    );
  }
}
