import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../providers/editor_provider.dart';
import '../models/sticker_model.dart';

class PhotoCanvas extends StatelessWidget {

  final ScreenshotController controller;

  const PhotoCanvas({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EditorProvider>(context);

    return Screenshot(
      controller: controller,
      child: Stack(
        children: [

          /// PLACEHOLDER
          if (provider.image == null)
            const Center(
              child: Text(
                "Chọn ảnh để bắt đầu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          /// IMAGE
          if (provider.image != null)
            Positioned.fill(
              child: Image.file(
                provider.image!,
                fit: BoxFit.cover,
              ),
            ),

          /// FRAME
          if (provider.frame != null)
            Positioned.fill(
              child: Image.asset(
                provider.frame!,
                fit: BoxFit.cover,
              ),
            ),

          /// STICKERS
          ...provider.stickers.map((sticker) {

            return Positioned(
              left: sticker.position.dx,
              top: sticker.position.dy,

              child: GestureDetector(

                /// MOVE + RESIZE
                onScaleUpdate: (details) {

                  /// MOVE
                  sticker.position += details.focalPointDelta;

                  /// RESIZE
                  sticker.scale = details.scale;

                  provider.notifyListeners();
                },

                child: Stack(
                  alignment: Alignment.topRight,
                  children: [

                    Transform.scale(
                      scale: sticker.scale,
                      child: Image.asset(
                        sticker.asset,
                        width: 100,
                      ),
                    ),

                    /// DELETE
                    GestureDetector(
                      onTap: (){
                        provider.removeSticker(sticker);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

          }).toList(),

          /// TEXT
          ...provider.texts.map((text) {

            return Positioned(
              left: text.position.dx,
              top: text.position.dy,

              child: GestureDetector(

                /// MOVE + RESIZE
                onScaleUpdate: (details) {

                  /// MOVE
                  text.position += details.focalPointDelta;

                  /// RESIZE
                  text.scale = details.scale;

                  provider.notifyListeners();
                },

                child: Stack(
                  alignment: Alignment.topRight,
                  children: [

                    Transform.scale(
                      scale: text.scale,
                      child: Text(
                        text.text,
                        style: TextStyle(
                          fontSize: 32,
                          color: text.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// DELETE TEXT
                    GestureDetector(
                      onTap: (){
                        provider.removeText(text);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

          }).toList(),
        ],
      ),
    );
  }
}