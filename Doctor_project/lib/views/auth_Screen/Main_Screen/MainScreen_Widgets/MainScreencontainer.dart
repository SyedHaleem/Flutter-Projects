import 'package:flutter/material.dart';

class MainScreencontainer extends StatelessWidget {
  final String imagepath;
  final String disease;
  const MainScreencontainer({Key? key, required this.imagepath, required this.disease}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,right: 16),
      child: Container(
        width: 72,
        height: 98.05,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 72,
              height: 71.05,
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(imagepath,width: 24,height: 24,),
            ),
            Text(disease,style: TextStyle(color: Color(0xFF8696BB),fontWeight: FontWeight.w600,fontSize: 10,),)
          ],
        ),
      ),
    );
  }
}
