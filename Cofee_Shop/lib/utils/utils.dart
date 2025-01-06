import 'package:cofee_shop/config/Colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils
{
  void toastMessage(String msg){
    Fluttertoast.showToast(msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: CofeeBox,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}