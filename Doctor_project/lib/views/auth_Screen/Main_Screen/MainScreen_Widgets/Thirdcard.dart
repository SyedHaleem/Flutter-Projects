import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Thirdcard extends StatelessWidget {
  const Thirdcard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 140,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/frame2.png'),fit: BoxFit.fill)),
      child: Stack(
        children: [
                  Container(
                    width: 215,
                    height: 130,
                    // color: Colors.red,
                    margin: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Heading_Text(text: 'Get free medical advice by \nasking a doctor', fw: FontWeight.w600, fs: 11, fc: Colors.white, ls: 0.19, tp: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/tick.png',width: 9.63,height: 6.43,),
                          Text(' Ask a question anonomously',style: TextStyle(fontSize: 8,color: Colors.white,height: 2),),
                        ],),Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/tick.png',width: 9.63,height: 6.43,),
                            Text(' Get a reply from Qualified doctors',style: TextStyle(fontSize: 8,color: Colors.white,height: 2),),
                          ],),

                         Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            custom_ElevatedButton(onPressed: (){},textsize: 6,btnw: 103, btnh:21, btntext: 'View All Question', btnbgcolor: Colors.white, btnfgcolor: Colors.blue, btnbordercolor: Colors.white, btnradius: 4.84, tm: 10),
                            custom_ElevatedButton(onPressed: (){},textsize: 6,btnw: 88, btnh:21, btntext: 'As Question', btnbgcolor: Colors.white, btnfgcolor: Colors.blue, btnbordercolor: Colors.white, btnradius: 4.84, tm: 10,lm: 10),
                          ],
                        )
                      ],
                    ),
                  ),
                 Positioned(left: 185,child: Image.asset('assets/images/girl1.png',width: 140,height: 140,)),
            ],
      ),
    );
  }
}