import 'package:cofee_shop/config/Colors.dart';
import 'package:flutter/material.dart';

class SizeOptionBtn extends StatelessWidget {
  final String btntext;
  final VoidCallback? onPressed;
  final bool isSelected;
  const SizeOptionBtn({super.key, required this.btntext, this.onPressed, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 71,
      height: 32,
      margin: const EdgeInsets.only(top: 26),

      decoration:  BoxDecoration(
        color: searchBgColor,
          borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
          side: BorderSide(color: isSelected ? CofeeBox : Colors.grey.shade500,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
           ),
        ),
        child: Text(btntext,style:  TextStyle(fontSize: 18,color: isSelected ? CofeeBox: Colors.grey.shade500 )),
        ),
    );
  }
}
