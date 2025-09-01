import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegScreenButton extends StatefulWidget {
  final double btnw;
  final double btnh;
  final String btntext;
  final Color btnbgcolor;
  final Color btnfgcolor;
  final Color btnbordercolor;
  final double btnradius;
  final double tm;
  final VoidCallback? onPressed;
  final double fontsize;
  final bool isSelected;

  const RegScreenButton({Key? key, required this.btnw, required this.btnh, required this.btntext, required this.btnbgcolor, required this.btnfgcolor, required this.btnbordercolor, required this.btnradius, required this.tm, this.onPressed, this.isSelected=false, required this.fontsize}) : super(key: key);

  @override
  State<RegScreenButton> createState() => _RegScreenButtonState();
}

class _RegScreenButtonState extends State<RegScreenButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.btnw,
      height: widget.btnh,
      margin: EdgeInsets.only(top: widget.tm),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            widget.isSelected ? Color(0xFF5B7FFF) : widget.btnbgcolor,
          ),
          foregroundColor: MaterialStateProperty.all(
            widget.isSelected ? Colors.white : widget.btnfgcolor,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.btnradius),
              side: BorderSide(color: widget.isSelected ? Color(0xFF5B7FFF) : widget.btnbordercolor,),
            ),
          ),
        ),
        child: Text(widget.btntext,style: TextStyle(fontSize: widget.fontsize)),
      ),
    );

  }
}
