import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/config/Colors.dart';

class TrendingSongSlider extends StatelessWidget {
  const TrendingSongSlider({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> sliderItems = [
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
            image: AssetImage('assets/images/slider1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          // crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Image.asset("assets/icons/music.png"),
                            SizedBox(width: 10,),
                            Text('Trending',style: Theme.of(context).textTheme.labelSmall,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("JANE TAMANA ", style: TextStyle(fontFamily: "Poppins", fontSize: 20,fontWeight: FontWeight.w500),),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Pakistani singer", style: TextStyle(fontFamily: "Poppins", fontSize: 12,fontWeight: FontWeight.w500, color: labelColor),),

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ];

    return CarouselSlider(
      items: sliderItems,
      options: CarouselOptions(
        height: 320,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        onPageChanged: (index, value) {},
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
