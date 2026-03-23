import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../providers/editor_provider.dart';
import '../widgets/photo_canvas.dart';
import '../widgets/sticker_panel.dart';
import '../widgets/frame_panel.dart';
import '../widgets/text_editor.dart';

class HomePage extends StatelessWidget {

  HomePage({super.key});

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EditorProvider>(context);

    return Scaffold(

      backgroundColor: const Color(0xfff4f4f4),

      appBar: AppBar(
        title: const Text("Tết Photobooth"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: Column(
        children: [

          /// CANVAS AREA
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0,4),
                    )
                  ],
                ),

                child: AspectRatio(
                  aspectRatio: 3/4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: PhotoCanvas(
                      controller: screenshotController,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// TOOLBAR
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                )
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                /// PICK IMAGE
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  iconSize: 30,

                  onPressed: (){
                    provider.pickImage();
                  },
                ),

                /// STICKER
                const StickerPanel(),

                /// TEXT
                const TextEditor(),

                /// FRAME
                const FramePanel(),

                /// SAVE
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {

                    bool success = await provider.saveImage(screenshotController);

                    if (success) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lưu ảnh thành công!"),
                          backgroundColor: Colors.green,
                        ),
                      );

                    } else {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lưu ảnh thất bại!"),
                          backgroundColor: Colors.red,
                        ),
                      );

                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}