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
      child: Container(
        color: provider.image == null ? const Color(0xFFFFFDE7) : Colors.black, // Màu kem nhẹ cho placeholder
        child: Stack(
          children: [

            /// PLACEHOLDER (TRẠNG THÁI TRỐNG)
            if (provider.image == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 80,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "CHÚC MỪNG NĂM MỚI",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Chụp ảnh hoặc chọn từ thư viện\nđể tạo kỷ niệm Tết nhé! 🧧",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Trang trí thêm góc
                    const Text("🌸", style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),

            /// IMAGE (ẢNH ĐÃ CHỌN)
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
                  onScaleUpdate: (details) {
                    sticker.position += details.focalPointDelta;
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
                      GestureDetector(
                        onTap: () => provider.removeSticker(sticker),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
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
                  onScaleUpdate: (details) {
                    text.position += details.focalPointDelta;
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
                      GestureDetector(
                        onTap: () => provider.removeText(text),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
