import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../models/sticker_model.dart';
import '../models/text_model.dart';

class EditorProvider extends ChangeNotifier {

  File? image;

  String? frame;

  List<StickerModel> stickers = [];

  List<TextModel> texts = [];

  /// RESET EDITOR
  void resetEditor() {
    image = null;
    frame = null;
    stickers.clear();
    texts.clear();
    notifyListeners();
  }

  /// SET IMAGE
  void setImage(File img) {
    image = img;
    notifyListeners();
  }

  /// PICK IMAGE FROM GALLERY
  Future<void> pickImage() async {

    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {
      resetEditor(); // Xóa các hiệu ứng cũ khi chọn ảnh mới
      image = File(picked.path);
      notifyListeners();
    }
  }

  /// TAKE PHOTO FROM CAMERA
  Future<void> takePhoto() async {

    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (picked != null) {
      resetEditor(); // Xóa các hiệu ứng cũ khi chụp ảnh mới
      image = File(picked.path);
      notifyListeners();
    }
  }

  /// SET FRAME
  void setFrame(String framePath) {
    frame = framePath;
    notifyListeners();
  }

  /// ADD STICKER
  void addSticker(String asset) {
    stickers.add(StickerModel(asset: asset));
    notifyListeners();
  }

  /// ADD TEXT
  void addText(String text, Color color, String? fontFamily) {
    texts.add(
      TextModel(
        text: text,
        color: color,
        fontFamily: fontFamily,
      ),
    );
    notifyListeners();
  }

  /// REMOVE STICKER
  void removeSticker(StickerModel sticker){
    stickers.remove(sticker);
    notifyListeners();
  }

  /// REMOVE TEXT
  void removeText(TextModel text){
    texts.remove(text);
    notifyListeners();
  }

  /// SAVE IMAGE
  Future<bool> saveImage(ScreenshotController controller) async {

    try {

      await Permission.photos.request();
      await Permission.storage.request();

      Uint8List? imageBytes = await controller.capture();

      if (imageBytes != null) {

        await Gal.putImageBytes(
          imageBytes,
          name: "photobooth_${DateTime.now().millisecondsSinceEpoch}",
        );

        return true; /// SUCCESS
      }

      return false;

    } catch (e) {

      return false; /// FAIL
    }
  }
}
