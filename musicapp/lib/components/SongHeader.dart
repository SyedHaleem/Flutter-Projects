import 'package:flutter/material.dart';

class SongHeader extends StatelessWidget {
  const SongHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/icons/bag.png", width: 40,),
        const SizedBox(width: 15,),
        const Text("Music Bag", style: TextStyle(fontSize: 30, fontWeight:FontWeight.bold, fontFamily: "Poppins"),)
      ],
    );
  }
}
