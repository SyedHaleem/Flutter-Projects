import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customSearchandButton extends StatefulWidget {
  const customSearchandButton({Key? key}) : super(key: key);

  @override
  State<customSearchandButton> createState() => _customSearchandButtonState();
}

class _customSearchandButtonState extends State<customSearchandButton> {
  TextEditingController search=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
                width: 337,
                height: 45,
                decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8),),
                ),

                child: TextField(
                  controller: search,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 15,bottom: 5),
                    border: InputBorder.none,
                    hintText: "Search by Doctors, hospitals, specialist ...",
                    hintStyle: TextStyle(color: Color(0xFFAFAEAE),fontSize: 11),
                  ),
                )),
            Container(width: 44,height: 45,child: ElevatedButton(style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),))),backgroundColor: MaterialStatePropertyAll(Color(0xFF5B7FFF),),),
                onPressed: (){}, child: Center(child: Icon(Icons.search_outlined,color: Colors.white,)))),
          ],
    );
  }
}
