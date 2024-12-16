import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class custom_ElevatedButton extends StatefulWidget {
  final double btnw;
  final double btnh;
  final String btntext;
  final Color btnbgcolor;
  final Color btnfgcolor;
  final Color btnbordercolor;
  final double btnradius;
  final double? tm;
  final double? lm;
  final double? textsize;
  final VoidCallback? onPressed;
  const custom_ElevatedButton({Key? key, required this.btnw, required this.btnh, required this.btntext, required this.btnbgcolor, required this.btnfgcolor, required this.btnbordercolor, required this.btnradius, this.tm, this.onPressed, this.textsize, this.lm}) : super(key: key);

  @override
  State<custom_ElevatedButton> createState() => _custom_ElevatedButtonState();
}

class _custom_ElevatedButtonState extends State<custom_ElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.btnw,
        height: widget.btnh,
        margin:EdgeInsets.only(top: widget.tm ?? 0.0, left: widget.lm ?? 0.0),
        child: ElevatedButton(onPressed: widget.onPressed,
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(widget.btnbgcolor),
    foregroundColor: MaterialStatePropertyAll(widget.btnfgcolor),
    shape:MaterialStateProperty.all(
    RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(widget.btnradius),
    side: BorderSide(color: widget.btnbordercolor,), )),),
            child: Text(widget.btntext,style: TextStyle(fontSize: widget.textsize),)));
  }
}
