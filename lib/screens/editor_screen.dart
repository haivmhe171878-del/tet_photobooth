import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:provider/provider.dart';

import '../providers/editor_provider.dart';
import '../widgets/photo_canvas.dart';
import '../widgets/sticker_panel.dart';
import '../widgets/frame_panel.dart';
import '../widgets/text_editor.dart';
import '../services/save_service.dart';

class EditorScreen extends StatelessWidget {

  final File image;

  EditorScreen({super.key, required this.image});

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EditorProvider>(context);
    provider.setImage(image);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa ảnh"),
        actions: [

          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {

              final imageBytes = await screenshotController.capture();

              if (imageBytes != null) {

                final path = await SaveService.saveImage(imageBytes);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved to: $path")),
                );
              }
            },
          )

        ],
      ),

      body: Column(
        children: [

          Expanded(
            child: PhotoCanvas(
              controller: screenshotController,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              StickerPanel(),
              FramePanel(),
              TextEditor(),
            ],
          )
        ],
      ),
    );
  }
}