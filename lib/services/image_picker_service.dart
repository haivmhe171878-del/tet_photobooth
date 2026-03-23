import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {

  static Future<File?> pickImage() async {

    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return null;

    return File(image.path);
  }
}