import 'package:get/get.dart';

class AddressController extends GetxController {
  // Reactive variable for the address
  var address = "Press to select address".obs;

  // Method to update the address
  void updateAddress(String newAddress) {
    address.value = newAddress;
  }
}
