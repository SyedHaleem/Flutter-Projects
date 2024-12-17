import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Pages/PlaySongPage.dart';
import 'package:quiz_app/components/SongDetails.dart';
import 'package:quiz_app/components/SongHeader.dart';
import 'package:quiz_app/components/SongTile.dart';
import 'package:quiz_app/components/TrendingSongSlider.dart';
import 'package:quiz_app/config/Colors.dart';
import 'package:quiz_app/controller/SongDataController.dart';
import 'package:quiz_app/controller/SongPlayerController.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context) {
    SongDataController songDataController = Get.put(SongDataController());
    SongPlayerController songPlayerController=Get.put(SongPlayerController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const SongHeader(),
                const SizedBox(height: 20),
                const TrendingSongSlider(),
                const SizedBox(height: 20),

                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          songDataController.isDeviceSong.value = false;
                        },
                        child: Text(
                          'Cloud Song',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: songDataController.isDeviceSong.value
                                ? labelColor
                                : primaryColor,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          songDataController.isDeviceSong.value = true;
                        },
                        child: Text(
                          'Device Song',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: songDataController.isDeviceSong.value
                                ? primaryColor
                                : labelColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Obx(
                      () => songDataController.isDeviceSong.value
                      ? Column(
                    // For device songs
                    children: songDataController.localSongList.value.map((song) {
                      songDataController.findCurrentIndex(song.id);
                      return SongTile(songName: song.title,onPress: (){
                        songPlayerController.playLocalAudio(song);
                        Get.to( PlaySongPage(songImage: song.album!,));
                      },);
                    }).toList()
                  )
                      : const Column(
                    // For cloud songs (assuming you handle this separately)
                    children: [
                      // SongTile(songName: "Kuch bhi",),
                      // SongTile(songName: "Kuch bhi",),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
