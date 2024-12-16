import 'package:flutter/cupertino.dart';

class Image_Container extends StatelessWidget {
final double Width;
final double height;
final double tmargin;
final String asset;
const Image_Container({Key? key, required this.Width, required this.height,required this.tmargin,required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
    margin: EdgeInsets.only(top: this.tmargin),
width: this.Width,
height: this.height,
child: Image.asset(asset),
);
  }
}
