import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class SaveService {

  static Future<String> saveImage(Uint8List bytes) async {

    final directory = await getApplicationDocumentsDirectory();

    final filePath =
        "${directory.path}/tet_photo_${DateTime.now().millisecondsSinceEpoch}.png";

    final file = File(filePath);

    await file.writeAsBytes(bytes);

    return filePath;
  }
}