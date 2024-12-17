import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controller/SongPlayerController.dart';

class TabBarr extends StatelessWidget {
  final SongPlayerController songPlayerController = Get.put(SongPlayerController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (songPlayerController.selectedTabIndex.value == 1) {
        songPlayerController.setLooping();
      }
      else if(songPlayerController.selectedTabIndex.value==0)
        {
          songPlayerController.playRandomSong();
        }

      return TabBar(
        onTap: (index) {
          songPlayerController.selectedTabIndex.value = index; // Update the tab index in the controller
        },
        dividerColor: Colors.transparent,
        indicatorColor: const Color(0xFFFF9900), // Primary color
        indicatorWeight: 3.0,
        tabs: const [
           Tab(
            child: Image(
              image: AssetImage('assets/icons/tab1.png'),
              height: 24,
              width: 24,
            ),
          ),
           Tab(
            child: Image(
              image: AssetImage('assets/icons/tab2.png'),
              height: 24,
              width: 24,
            ),
          ),
           Tab(
            child: Image(
              image: AssetImage('assets/icons/tab3.png'),
              height: 24,
              width: 24,
            ),
          ),
           Tab(
            child: Image(
              image: AssetImage('assets/icons/tab4.png'),
              height: 24,
              width: 24,
            ),
          ),
        ],
      );
    });
  }
}
