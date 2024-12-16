import 'package:doctor_project/models/SearchScreenCOntent.dart';
import 'package:doctor_project/views/auth_Screen/Search_Tab_Screens/Search_Tab_Widgets/SearchCard.dart';
import 'package:doctor_project/widgets/customSearchandButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreens extends StatefulWidget {
  const SearchScreens({Key? key}) : super(key: key);

  @override
  State<SearchScreens> createState() => _SearchScreensState();
}

class _SearchScreensState extends State<SearchScreens> {
  List<String> items=[
    'Doctors',
    'Specialist',
    'Hospitals',
    'Labs',
    'Diseases',
    'Surgery',
  ];
  int current=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(foregroundColor: Colors.black,elevation: 0,backgroundColor: Colors.white,title: Heading_Text(text: 'Profile', fw: FontWeight.w700, fs: 16, fc: Colors.black, ls: -0.19, tp: 0),centerTitle: true,),
        body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
          children:
          [
          Container(
          height: 27.8,
          width: double.infinity,
          margin: EdgeInsets.only(left: 8,bottom: 30),
          child: ListView.builder(physics: const BouncingScrollPhysics(),itemCount: items.length,
            scrollDirection: Axis.horizontal,itemBuilder: (context, index)
          => GestureDetector(
            onTap: () {
              setState(() {
                current=index;
              });
            },
            child: AnimatedContainer(
              width: 78.25,
              height: 27.8,
              margin: EdgeInsets.only(left: 7.97),
              decoration: BoxDecoration(
                color: current==index?Color(0xff5B7FFF):Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: current==index?Colors.transparent: Color(0xffCCCCCC),
                ),
              ),
              duration: Duration(milliseconds: 400),
              child: Center(child: Text(items[index],style: GoogleFonts.nunito(fontSize: 8,fontWeight: FontWeight.w500,color: current==index?Colors.white:Color(0xffCCCCCC)))),
            ),
          ),),
              ),
            Center(child: customSearchandButton()),
            Container(
              width: 331,
              height: 600,
              margin: EdgeInsets.only(top: 30),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: (searchContent.length / 6).ceil(),
                itemBuilder: (context, index) {
                  int startIndex = current * 6; // Calculate start index
                  int endIndex = (current + 1) * 6 - 1; // Calculate end index
                  if (endIndex >= searchContent.length) {
                    endIndex = searchContent.length - 1; // Adjust endIndex if it exceeds the length of searchContent
                  }
                  int contentIndex = startIndex + index;
                  if (contentIndex <= endIndex) {
                    return SearchCard(
                      imgpath: searchContent[contentIndex].imgpath,
                      title: searchContent[contentIndex].title,
                      location: searchContent[contentIndex].location,
                    );
                  } else {
                    return SizedBox(); // Return an empty SizedBox if contentIndex exceeds endIndex
                  }
                },
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}

// DefaultTabController(length: 6, child: Column(
// children: [
// Container(
// height: 27.8,
// color: Colors.white,
// child: TabBar(physics: ClampingScrollPhysics(),
// padding: EdgeInsets.only(top: 0,left: 0,right: 0,bottom: 0),
// unselectedLabelColor: Color(0xffCCCCCC),
// indicatorSize: TabBarIndicatorSize.label,
// indicator: BoxDecoration(
// borderRadius: BorderRadius.circular(8),
// border: Border.all(color: Color(0xff5B7FFF)),
// color: Color(0xff5B7FFF),
// ),
// tabs: [
// Tab(
// child: Container(
// height: 40.8,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(8),
// border: Border.all(color: Color(0xffCCCCCC)),
// ),
// child: Align(alignment: Alignment.center,
// child: Text('Doctors',style: TextStyle(fontSize: 8.59)),),
// ),
// ),
// Tab(
// child: Container(
// height: 27.8,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(8),
// border: Border.all(color: Color(0xffCCCCCC)),
// ),
// child: Align(alignment: Alignment.center,
// child: Text('Specialists',style: TextStyle(fontSize: 8.59)),),
// ),
// ),
// Tab(
// child: Container(
// width: 78.25,
// height: 27.8,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(8),
// border: Border.all(color: Color(0xffCCCCCC)),
// ),
// child: Align(alignment: Alignment.center,
// child: Text('Hospitals',style: TextStyle(fontSize: 8.59)),),
// ),
// ),
// Tab(
// child: Container(
// height: 27.8,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(8),
// border: Border.all(color: Color(0xffCCCCCC)),
// ),
// child: Align(alignment: Alignment.center,
// child: Text('Labs',style: TextStyle(fontSize: 8.59)),),
// ),
// ),
// Tab(
// child: Container(
// height: 27.8,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(8),
// border: Border.all(color: Color(0xffCCCCCC)),
// ),
// child: Align(alignment: Alignment.center,
// child: Text('Labs',style: TextStyle(fontSize: 8.59)),),
// ),
// ),
//
// ],
// ),
// )
// ],
// )
