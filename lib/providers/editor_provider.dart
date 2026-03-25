import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../models/sticker_model.dart';
import '../models/text_model.dart';

enum StripLayout { none, vertical4, square4, grid6 }

class EditorState {
  final String? frame;
  final List<double>? selectedFilter;
  final List<StickerModel> stickers;
  final List<TextModel> texts;
  final StripLayout stripLayout;

  EditorState({
    this.frame,
    this.selectedFilter,
    required this.stickers,
    required this.texts,
    this.stripLayout = StripLayout.none,
  });

  EditorState copy() {
    return EditorState(
      frame: frame,
      selectedFilter: selectedFilter != null ? List<double>.from(selectedFilter!) : null,
      stripLayout: stripLayout,
      stickers: stickers.map((s) => StickerModel(
        asset: s.asset,
        position: s.position,
        scale: s.scale,
      )).toList(),
      texts: texts.map((t) => TextModel(
        text: t.text,
        position: t.position,
        scale: t.scale,
        color: t.color,
        fontFamily: t.fontFamily,
      )).toList(),
    );
  }
}

class EditorProvider extends ChangeNotifier {
  File? image;
  String? frame;
  List<double>? selectedFilter;
  List<StickerModel> stickers = [];
  List<TextModel> texts = [];
  StripLayout stripLayout = StripLayout.none;

  final List<EditorState> _history = [];

  void _saveHistory() {
    _history.add(EditorState(
      frame: frame,
      selectedFilter: selectedFilter,
      stickers: List.from(stickers),
      texts: List.from(texts),
      stripLayout: stripLayout,
    ).copy());
    if (_history.length > 20) _history.removeAt(0);
  }

  bool get isStripMode => stripLayout != StripLayout.none;

  void setStripLayout(StripLayout layout) {
    _saveHistory();
    stripLayout = layout;
    notifyListeners();
  }

  void setImage(File img) {
    image = img;
    notifyListeners();
  }

  void undo() {
    if (_history.isNotEmpty) {
      final prevState = _history.removeLast();
      frame = prevState.frame;
      selectedFilter = prevState.selectedFilter;
      stickers = prevState.stickers;
      texts = prevState.texts;
      stripLayout = prevState.stripLayout;
      notifyListeners();
    }
  }

  bool get canUndo => _history.isNotEmpty;

  void resetEditor() {
    _saveHistory();
    image = null;
    frame = null;
    selectedFilter = null;
    stickers.clear();
    texts.clear();
    stripLayout = StripLayout.none;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      resetEditor(); 
      image = File(picked.path);
      _history.clear();
      notifyListeners();
    }
  }

  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      resetEditor(); 
      image = File(picked.path);
      _history.clear();
      notifyListeners();
    }
  }

  void setFilter(List<double>? filterMatrix) {
    _saveHistory();
    selectedFilter = filterMatrix;
    notifyListeners();
  }

  void setFrame(String framePath) {
    _saveHistory();
    frame = framePath;
    notifyListeners();
  }

  void addSticker(String asset) {
    _saveHistory();
    stickers.add(StickerModel(asset: asset));
    notifyListeners();
  }

  void addText(String text, Color color, String? fontFamily) {
    _saveHistory();
    texts.add(TextModel(text: text, color: color, fontFamily: fontFamily));
    notifyListeners();
  }

  void removeSticker(StickerModel sticker){
    _saveHistory();
    stickers.remove(sticker);
    notifyListeners();
  }

  void removeText(TextModel text){
    _saveHistory();
    texts.remove(text);
    notifyListeners();
  }

  Future<void> shareImage(ScreenshotController controller) async {
    try {
      final Uint8List? imageBytes = await controller.capture();
      if (imageBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/tet_share_${DateTime.now().millisecondsSinceEpoch}.png').create();
        await imagePath.writeAsBytes(imageBytes);
        await Share.shareXFiles([XFile(imagePath.path)], text: 'Chúc mừng năm mới 2026! 🧧🐎');
      }
    } catch (e) {
      debugPrint("Lỗi chia sẻ: $e");
    }
  }

  Future<bool> saveImage(ScreenshotController controller) async {
    try {
      await Permission.photos.request();
      await Permission.storage.request();
      Uint8List? imageBytes = await controller.capture();
      if (imageBytes != null) {
        await Gal.putImageBytes(imageBytes, name: "photobooth_${DateTime.now().millisecondsSinceEpoch}");
        
        final directory = await getApplicationDocumentsDirectory();
        final albumDir = Directory('${directory.path}/tet_album');
        if (!await albumDir.exists()) await albumDir.create();
        
        final file = File('${albumDir.path}/IMG_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(imageBytes);
        
        return true; 
      }
      return false;
    } catch (e) {
      return false; 
    }
  }

  Future<List<File>> getAlbumPhotos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final albumDir = Directory('${directory.path}/tet_album');
      if (!await albumDir.exists()) return [];
      
      final files = albumDir.listSync().whereType<File>().toList();
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      return files;
    } catch (e) {
      return [];
    }
  }
  
  Future<void> deleteFromAlbum(File file) async {
    if (await file.exists()) {
      await file.delete();
      notifyListeners();
    }
  }
}
