import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'SongPlayerController.dart';

class TabBarController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;

  final SongPlayerController songPlayerController = Get.put(SongPlayerController());

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (tabController.index == 2 && tabController.indexIsChanging) {
      songPlayerController.isLooping.value = true;
      songPlayerController.setLooping();
    }
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.onClose();
  }
}
