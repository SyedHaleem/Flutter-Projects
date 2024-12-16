import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class custom_TextformField extends StatefulWidget {
  final TextEditingController textController;
  final TextInputType keytype;
  final String text;
  final String regx;
  IconData? sicon1;
  final  bool isPassword;
  final bool readonly;
  final bool isDateofBirth;
  final double fieldw;
  final double fieldh;
  final double tmrgin;
  final String? check;
   custom_TextformField({Key? key, required this.textController, required this.keytype, required this.text, required this.regx, required this.isPassword, required this.isDateofBirth, required this.readonly, required this.fieldw, required this.fieldh, required this.tmrgin, this.check,}) : super(key: key);

  @override
  State<custom_TextformField> createState() => _custom_TextformFieldState();
}

class _custom_TextformFieldState extends State<custom_TextformField> {
  bool obscureText=true;
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2034),
    );

    if (picked != null && picked != widget.textController.text) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        widget.textController.text = formattedDate; // You can format the date as needed
      });
    }}
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
        obscureText: widget.isPassword?obscureText:false,
        readOnly: widget.readonly,
        obscuringCharacter: '.',
        style: TextStyle(color: Colors.black,fontSize: 13),

        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 15,top: widget.isDateofBirth||widget.isPassword?10:0),hintText: widget.text,hintStyle: TextStyle(color: Colors.grey,fontSize: 13),border: InputBorder.none,
          suffixIcon: widget.isPassword?IconButton(onPressed: (){
            setState(() {
              obscureText = !obscureText;
            });
          },
            icon: Icon(obscureText?Icons.visibility:Icons.visibility_off_outlined),)
              :(widget.isDateofBirth?IconButton(onPressed: _selectDate, icon: Icon(Icons.calendar_month_outlined),):null),),
        validator: (value){
      if (value!.isEmpty) {
      return 'Enter Your '+widget.text;
      } else if (!RegExp(widget.regx).hasMatch(value)) {
      return 'Enter a Valid '+widget.text;
      }
      else if(widget.check!=null &&widget.check != value )
        {
          return 'Incorrect '+widget.text;
        }
      return null;
      },
      ),
    );
  }
}
//r'^[a-zA-Z ]+$'