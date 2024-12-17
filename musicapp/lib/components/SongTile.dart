import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/config/Colors.dart';

class SongTile extends StatelessWidget {
  final String songName;
  final VoidCallback onPress;
  const SongTile({super.key, required this.songName, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onPress,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: containerColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset("assets/icons/play1.png"),
              const SizedBox(width: 10), // Spacing between icon and text
               Flexible(
                 child: Text(
                   maxLines: 1,
                  songName, // Text
                  style: const TextStyle(
                    color: fontColor, // White text
                    fontSize: 16,
                  ),
                           ),
               ),

            ],
          ),
        ),
      ),
    );
  }
}
