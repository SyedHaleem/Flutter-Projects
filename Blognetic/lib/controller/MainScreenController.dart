import 'package:get/get.dart';

class MainScreenController extends GetxController {
  final selectedIndex = 0.obs;
  bool tabInitialized = false;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}