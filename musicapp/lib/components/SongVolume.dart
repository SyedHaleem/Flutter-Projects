import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/config/Colors.dart';
import 'package:quiz_app/controller/SongPlayerController.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
class Songvolume extends StatelessWidget {
  final String songImage;
  const Songvolume({super.key, required this.songImage,});



  @override
  Widget build(BuildContext context) {
    var value=30.0;
    SongPlayerController songPlayerController = Get.put(SongPlayerController());

    return Stack(
      children:[ Obx(()=> SfRadialGauge(
          animationDuration: 1,
          enableLoadingAnimation: true,
          axes: [
            RadialAxis(
              useRangeColorForAxis: true,
              startAngle: 0,
              endAngle: 180,
              canRotateLabels: false,
              interval: 10,
              isInversed: true,
              maximum: 1,
              minimum: 0,

              showAxisLine: false,
              showLabels: false,
              showTicks: true,
              ranges: [
                GaugeRange(
                  startValue: 0,
                  endValue: songPlayerController.volumeLevel.value,
                  color: primaryColor,
                )
              ],
              pointers: [
                MarkerPointer(
                  color: primaryColor,
                  borderWidth: 20,
                  value: songPlayerController.volumeLevel.value,
                  onValueChanged: (valuee){
                    songPlayerController.changeVolume(valuee);

                  },
                  enableAnimation: true,
                  enableDragging: true,
                  markerType: MarkerType.circle,
                  markerWidth: 10,
                  markerHeight: 10,
                )
              ],
              annotations: [
                songImage=='' ? GaugeAnnotation(horizontalAlignment: GaugeAlignment.center,
                  widget: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: containerColor,
                      image: DecorationImage(
                        image: AssetImage(songImage,),
                      fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ):
                GaugeAnnotation(horizontalAlignment: GaugeAlignment.center,
                  widget: Container(
                    padding: EdgeInsets.only(top: 100),
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/love.png',),),
                      borderRadius: BorderRadius.circular(1000),
                      color: Colors.transparent,

                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
         Positioned(
          left: 25,
          top: 130,
          child: InkWell(
            child: Image.asset('assets/icons/highVolume.png'),
            onTap: (){},
          ),
        ),
         Positioned(
          right: 20,
          top: 130,
          child: InkWell(
           child: Image.asset('assets/icons/highVolume.png'),
            onTap: (){},
          ),
        ),
    ]
    );
  }
}
