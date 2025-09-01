import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Doctordetailcard extends StatefulWidget {
  final String doctorname;
  final String imgpath;
  const Doctordetailcard({Key? key, required this.doctorname, required this.imgpath}) : super(key: key);

  @override
  State<Doctordetailcard> createState() => _DoctordetailcardState();
}

class _DoctordetailcardState extends State<Doctordetailcard> {
  bool isfill=false;
  Widget buildColumn1(String text,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontSize: 8,
          fontWeight: FontWeight.w400,
          color: Color(0xFF8A96BC),
          letterSpacing: 0.4,),),
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.star, size: 15.39, color: Color(0xFFEEB854),),
            Icon(Icons.star, size: 15.39, color: Color(0xFFEEB854),),
            Icon(Icons.star, size: 15.39, color: Color(0xFFEEB854),),
            Icon(Icons.star, size: 15.39, color: Color(0xFFEEB854),),
            Icon(Icons.star, size: 15.39, color: Color(0xFFD9D9D9),),
            Text(' 4.8', style: TextStyle(fontSize: 7,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 0.4,),),

          ],),

      ],
    );
  }

    Widget buildColumn2() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                this.isfill = !this.isfill;
                print('haleem');
              });
            },
            child: Icon(
              isfill ? Icons.favorite : Icons.favorite_border_outlined,
              size: 24,
              color: isfill ? Color(0xFF5B7FFF) : Color(0xFF98A3B3),
            ),
          ),
          Text(
            'Rs.1000',
            style: TextStyle(fontSize: 10.48, fontWeight: FontWeight.w600, color: Color(0xFF5B7FFF)),
          ),
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
          elevation: 2,
          child: ListTile(
            leading: Image.asset(widget.imgpath,width: 57.65,height: 61.58,),
            title: Transform.translate(
              offset: Offset(0, 13),
                child: Text(widget.doctorname,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600,color: Colors.black,letterSpacing: 0.8))),
            subtitle: Transform.translate(offset: Offset(0,13),
                child: buildColumn1('Dentist | Royal Hospital ')),
            trailing: buildColumn2(),
        ),),
      ),
    );
  }
}
