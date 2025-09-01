import 'package:get/get.dart';

class AddressController extends GetxController {
  var address = "Press to select address".obs;
  void updateAddress(String newAddress) {
    address.value = newAddress;
  }
}
