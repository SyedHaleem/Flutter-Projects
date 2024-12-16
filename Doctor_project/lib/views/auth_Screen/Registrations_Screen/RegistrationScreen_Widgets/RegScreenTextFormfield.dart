import 'package:flutter/material.dart';

class RegScreenTextFormfield extends StatefulWidget {
  final TextEditingController textController;
  final TextInputType keytype;
  final String text;
  final String validatetext;
  final double fieldw;
  final double fieldh;
  final double tmrgin;
  const RegScreenTextFormfield({Key? key, required this.textController, required this.keytype, required this.text, required this.validatetext, required this.fieldw, required this.fieldh, required this.tmrgin}) : super(key: key);

  @override
  State<RegScreenTextFormfield> createState() => _RegScreenTextFormfieldState();
}

class _RegScreenTextFormfieldState extends State<RegScreenTextFormfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.fieldw,
      height: widget.fieldh,
      margin: EdgeInsets.only(top: widget.tmrgin),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(11.48),
      ),
      child: TextFormField(
        controller: widget.textController,
        keyboardType: widget.keytype,
        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 15),
          border: InputBorder.none,
          hintText: widget.text,
          hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
            ),
        validator: (value){
          if (value!.isEmpty) {
            return 'Please enter your '+widget.validatetext;
          }
        },
      ),
    );
  }
}
