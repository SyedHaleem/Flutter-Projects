import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class circular_Container extends StatefulWidget {
  final IconData icondata;
  final String text;
  final bool isSelected;
  const circular_Container({Key? key, required this.isSelected, required this.icondata, required this.text}) : super(key: key);

  @override
  State<circular_Container> createState() => _circular_ContainerState();
}

class _circular_ContainerState extends State<circular_Container> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
          color:widget.isSelected?Color(0xFF5B7FFF):Color(0xFFF5F5F5),

      ),
      margin: EdgeInsets.only(top: 40,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(widget.icondata,color: widget.isSelected?Colors.white:Color(0xFFC4C4C4),size: 48,),
          Text(widget.text,style: TextStyle(fontWeight: FontWeight.w500,color: widget.isSelected?Colors.white:Color(0xFFC4C4C4),fontSize: 12),),
        ],
      ),
    );
  }
}
