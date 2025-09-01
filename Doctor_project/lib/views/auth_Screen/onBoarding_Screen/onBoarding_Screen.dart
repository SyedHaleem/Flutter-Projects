import 'package:doctor_project/models/onBoarding_Content.dart';
import 'package:doctor_project/views/auth_Screen/login_Screen/login_Screen.dart';
import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:doctor_project/widgets/paragraph_Text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
class onBoarding_Screen extends StatefulWidget {
  const onBoarding_Screen({Key? key}) : super(key: key);
  @override
  State<onBoarding_Screen> createState() => _onBoarding_ScreenState();
}

class _onBoarding_ScreenState extends State<onBoarding_Screen> {
  int currentindex=0;
  late PageController _controller;
  @override
  void initState() {
    _controller =PageController(initialPage: 0);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: contents.length,
          onPageChanged: (int index)
        {
          setState(() {
            currentindex=index;
          });
        },
          itemBuilder: (_,i) {
            return Stack(
            children: [
            Container(
            width: double.infinity,
            height: Get.height*0.8,
            color: Color(0xFF5B7FFF),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
            padding: const EdgeInsets.only(top: 59,left: 24),
            child: GradientText('DOCTORSPOT', style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            ),
            gradientType: GradientType.linear,
            gradientDirection: GradientDirection.ltr,
            colors: const [
            Colors.white, Colors.white, Colors.white,
            Colors.white38,
            ],
            ),
            ),
            Padding(
            padding: EdgeInsets.only(top: currentindex == 1 ? 2 : 23,left: 64),
            child: Image.asset(contents[i].image,width: 246.36,height: 371,),
            ),
            ],
            ),
            ),
            Container(
            width: 375,
            height: 340,
            margin: EdgeInsets.only(top: 480,),
            decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.only( topLeft: Radius.circular(24),topRight: Radius.circular(24),),
            ),
            child: Container(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(
            width:323,
            height: 160,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Heading_Text(tp: 20,text: contents[i].heading, fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.5),
            Paraghraph_Text(text: contents[i].paragraph,
            fs: 12.5, fc: Colors.black45, ls: -0.41, tp: 15,isunderline: false),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(contents.length, (index) => buildDot(index, context)
              ),
            ),
            ),
            ],
            ),
            ),
            custom_ElevatedButton(onPressed:() {
              if (currentindex == contents.length - 1) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login_Screen(),));
              } else {
                _controller.nextPage(duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,);
              }
            }, tm: 45,btnw: 327, btnh: 50, btntext: currentindex==contents.length-1 ?'Continue': 'Next', btnbgcolor: Color(0xFF5B7FFF), btnfgcolor: Colors.white, btnbordercolor: Colors.transparent, btnradius: 10),
            Paraghraph_Text(text: 'Quickly explore the app? Tap here',fc: Color(0xFF5B7FFF),fs: 11,ls: -0.25,tp: 25,isunderline: true,),
            ],
            ),
            ),
            ),
            ],
            );
          },
      ),
    );
  }
  Container buildDot(int index,BuildContext context)
  {
    return Container(
  height: 10,width: currentindex==index?25:10,
  margin: EdgeInsets.only(right: 5,top: 25),
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: currentindex==index?Color(0xFF5B7FFF):Color(0xFFE5E5E5)));
  }
}