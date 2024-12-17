import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controller/SongDataController.dart';
import 'package:quiz_app/controller/SongPlayerController.dart';
import '../config/Colors.dart';

class SongButton extends StatelessWidget {
  const SongButton({super.key});

  @override
  Widget build(BuildContext context) {
    SongPlayerController songPlayerController = Get.put(SongPlayerController());
    SongDataController songDataController=Get.put(SongDataController());

    return Column(
      children: [
        Obx(
              () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${songPlayerController.currentTime}'),
              Expanded(
                child: Obx(
                      () => Slider(
                    value: songPlayerController.sliderValue.value.clamp(0.0, songPlayerController.sliderValue.value),
                    onChanged: (value) {
                      // Update the slider value
                      songPlayerController.sliderValue.value = value;
                    },
                    onChangeEnd: (value) {
                      // Update the song's position when the slider is released
                      songPlayerController.seekTo(value);
                    },
                    min: 0,
                    max: songPlayerController.songMaxValue.value,
                  ),
                ),
              ),
              Text('${songPlayerController.totalTime}',
                  style: const TextStyle(
                      color: labelColor,
                      fontFamily: "Poppins",
                      fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                songDataController.playPreviousSong();
              },
                child: Image.asset('assets/icons/previous.png', width: 25)),
            const SizedBox(width: 60),
            Obx(
                  () => InkWell(
                onTap: () {
                  songPlayerController.isPlaying.value
                      ? songPlayerController.pausePlaying()
                      : songPlayerController.resumePlaying();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: songPlayerController.isPlaying.value
                        ? const Icon(Icons.pause,
                        size: 25, color: Colors.white) // Pause icon
                        : Image.asset('assets/icons/play1.png',
                        width: 25), // Play icon
                  ),
                ),
              ),
            ),
            const SizedBox(width: 60),
            InkWell(
                onTap: (){
                  songDataController.playNextSong();
                },
                child: Image.asset('assets/icons/next.png', width: 25)),
          ],
        ),
      ],
    );
  }
}
