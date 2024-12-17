import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controller/SongPlayerController.dart';
import '../config/Colors.dart';

class SongDetails extends StatelessWidget {

  const SongDetails({super.key,});

  @override
  Widget build(BuildContext context) {
    SongPlayerController songPlayerController =Get.put(SongPlayerController());
    return  Column(
      children: [
        Row(
          children: [
            Image.asset('assets/icons/play.png'),
            const SizedBox(width: 10,),
            const Text('100 Players', style: TextStyle(color: labelColor, fontFamily: "Poppins", fontSize: 12),),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(()=> Flexible(
                child: Text( maxLines: 1,"${songPlayerController.songTitle.value}",style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: fontColor,
                ),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/icons/favourite.png'),
                const SizedBox(width: 20,),
                Image.asset('assets/icons/download.png'),
              ],
            ),
          ],),
        const SizedBox(height: 10,),
        Obx(()=> Row(
              children: [
                Text('${songPlayerController.songArtist.value}', style: const TextStyle(color: labelColor, fontFamily: "Poppins", fontSize: 12))
              ]),
        ),
      ],
    );
  }
}