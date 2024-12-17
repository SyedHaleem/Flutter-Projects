import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/config/Colors.dart';
import 'package:quiz_app/controller/SongPlayerController.dart';  // Import your controller

class PlaySongAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlaySongAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String songTitle;
    final String artist;
    SongPlayerController songPlayerController = Get.find<SongPlayerController>();

    return AppBar(
      elevation: 0, // Remove shadow
      leading: InkWell(
        onTap: (){
          songPlayerController.pausePlaying();
          Get.back();
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset('assets/icons/backbtn.png'),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              color: labelColor,
            ),
            onPressed: () {
              // Add functionality for settings button
              print('Settings button pressed');
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
