import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerX extends GetxController {
  late TabController tabController;
  var isInitialized = false.obs;

  void initializeTabController(TickerProvider vsync) {
    tabController = TabController(length: 4, vsync: vsync);
    isInitialized.value = true; // Set as initialized
  }

  @override
  void onClose() {
    if (isInitialized.value) {
      tabController.dispose();
    }
    super.onClose();
  }
}