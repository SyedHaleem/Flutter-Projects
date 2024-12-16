import 'package:doctor_project/widgets/custom_ElevatedButton.dart';
import 'package:doctor_project/widgets/heading_Text.dart';
import 'package:flutter/material.dart';

class DrawerScreenElevatedButton extends StatefulWidget {
  final double buttonwidth;
  final double buttonheight;
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final bool islogout;
  final double fontsize;
  final double iconsize;
  final Color color ;
  final Color borderColor ;
  final Color textColor ;
  final double toppadding;
  const DrawerScreenElevatedButton({Key? key, required this.buttonwidth, required this.buttonheight, required this.icon, required this.text, this.onPressed, required this.islogout, required this.fontsize, required this.iconsize, required this.color, required this.toppadding, required this.borderColor, required this.textColor}) : super(key: key);

  @override
  State<DrawerScreenElevatedButton> createState() => _DrawerScreenElevatedButtonState();
}

class _DrawerScreenElevatedButtonState extends State<DrawerScreenElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.buttonwidth, //148
        height: widget.buttonheight, //48
      decoration: BoxDecoration(border: Border.all(color: widget.borderColor),borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(top: widget.toppadding),
        child: ElevatedButton(onPressed: widget.onPressed,
    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(widget.color),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(widget.icon,color: widget.textColor,size: widget.iconsize,),
    Text('\t'+widget.text,style: TextStyle(color: widget.textColor,fontSize: widget.fontsize,fontWeight: FontWeight.w600,),),
    ],
    ),
        ),
    );
  }
}
