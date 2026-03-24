import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/editor_provider.dart';
import '../models/sticker_model.dart';
import '../models/text_model.dart';

class PhotoCanvas extends StatefulWidget {
  final ScreenshotController controller;

  const PhotoCanvas({super.key, required this.controller});

  @override
  State<PhotoCanvas> createState() => _PhotoCanvasState();
}

class _PhotoCanvasState extends State<PhotoCanvas> {
  // Biến để lưu đối tượng đang được chọn để hiển thị dấu X
  dynamic selectedItem;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditorProvider>(context);

    return Screenshot(
      controller: widget.controller,
      child: Container(
        color: provider.image == null ? const Color(0xFFFFFDE7) : Colors.black,
        child: GestureDetector(
          onTap: () {
            // Khi nhấn ra ngoài (vào canvas), ẩn dấu X đi
            setState(() {
              selectedItem = null;
            });
          },
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
                    onLongPress: () {
                      setState(() {
                        selectedItem = sticker;
                      });
                    },
                    onScaleUpdate: (details) {
                      sticker.position += details.focalPointDelta;
                      sticker.scale = details.scale;
                      provider.notifyListeners();
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      clipBehavior: Clip.none,
                      children: [
                        Transform.scale(
                          scale: sticker.scale,
                          child: Image.asset(
                            sticker.asset,
                            width: 100,
                          ),
                        ),
                        if (selectedItem == sticker)
                          Positioned(
                            top: -10,
                            right: -10,
                            child: GestureDetector(
                              onTap: () {
                                provider.removeSticker(sticker);
                                setState(() {
                                  selectedItem = null;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.close, color: Colors.white, size: 20),
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
                    behavior: HitTestBehavior.opaque,
                    onLongPress: () {
                      setState(() {
                        selectedItem = text;
                      });
                    },
                    onScaleUpdate: (details) {
                      text.position += details.focalPointDelta;
                      text.scale = details.scale;
                      provider.notifyListeners();
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      clipBehavior: Clip.none,
                      children: [
                        Transform.scale(
                          scale: text.scale,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              text.text,
                              style: GoogleFonts.getFont(
                                text.fontFamily ?? 'Dancing Script',
                                fontSize: 32,
                                color: text.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (selectedItem == text)
                          Positioned(
                            top: -15,
                            right: -15,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                provider.removeText(text);
                                setState(() {
                                  selectedItem = null;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(Icons.close, color: Colors.white, size: 24),
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
        ),
      ),
    );
  }
}
