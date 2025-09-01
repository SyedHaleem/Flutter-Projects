import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:spotify_clone/core/configs/assets/app_images.dart';
import 'package:spotify_clone/core/configs/assets/app_vectors.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/presentation/home/widgets/news_songs.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../controller/tabBar/tabBarController.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.put(TabBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBackBtn: true,
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _homeArtistCard(),
          _tabs(context),
          Expanded(
            child: SizedBox(
              height: 250,
              child: TabBarView(
                controller: controller.tabController,
                children:  [
                  const NewsSongs(),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeArtistCard() {
    return Center(
      child: Container(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: const Alignment(0.5, 0.5),
              child: Image.asset(AppImages.home_artist),
            ),
            Align(
              alignment: const Alignment(0.8, 0.5),
              child: SvgPicture.asset(AppVectors.homeCardPattern),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs(BuildContext context) {
    return TabBar(
      controller: controller.tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 5),
      dividerColor: Colors.transparent,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: AppColors.primary,
      tabs: const [
        Text('News',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),),
        Text('Videos',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        Text('Artists',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        Text('Podcasts',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      ],
    );
  }
}
