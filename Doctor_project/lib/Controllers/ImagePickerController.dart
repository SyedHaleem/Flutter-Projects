import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController
{
  RxString imagePath=''.obs;
  Future getImage(ImageSource source)  async{
        final pickedFile = await ImagePicker().getImage(source:source);
    if (pickedFile != null) {
      // Get the image path
      String imagePath = pickedFile.path;

      // Convert the image to a PNG file
      await _convertToPng(imagePath);

      // Set the converted image path
      this.imagePath.value = imagePath.replaceAll('.jpg', '.png');
  }
}
  Future<void> _convertToPng(String imagePath) async {
    // Read the image file
    final File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();

    // Write the image bytes to a new PNG file
    final File pngFile = File(imagePath.replaceAll('.jpg', '.png'));
    await pngFile.writeAsBytes(imageBytes);
  }
}
