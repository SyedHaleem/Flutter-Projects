import 'package:flutter/widgets.dart';

class customIcon extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  const customIcon({Key? key, required this.path, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(path,height: height,width: height,);
  }
}
