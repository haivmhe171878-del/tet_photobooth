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
  dynamic selectedItem;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditorProvider>(context);

    return Screenshot(
      controller: widget.controller,
      child: Container(
        color: provider.image == null ? const Color(0xFFFFFDE7) : Colors.black,
        child: GestureDetector(
          onTap: () => setState(() => selectedItem = null),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  /// 1. LỚP NỀN (ẢNH ĐƠN HOẶC ẢNH GHÉP)
                  if (provider.image != null)
                    Positioned.fill(
                      child: _buildMainContent(provider),
                    ),

                  /// 2. LỚP KHUNG ẢNH (FRAME)
                  if (provider.frame != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Image.asset(provider.frame!, fit: BoxFit.cover),
                      ),
                    ),

                  /// 3. HIỆU ỨNG (STICKERS)
                  ..._buildStickers(provider),

                  /// 4. VĂN BẢN (TEXTS)
                  ..._buildTexts(provider),

                  /// 5. CHỈ DẪN KHI TRỐNG
                  if (provider.image == null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.add_a_photo_outlined, size: 80, color: Colors.red),
                          ),
                          const SizedBox(height: 20),
                          const Text("CHÚC MỪNG NĂM MỚI", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  /// QUẢN LÝ HIỂN THỊ NỘI DUNG CHÍNH
  Widget _buildMainContent(EditorProvider provider) {
    if (provider.stripLayout == StripLayout.none) {
      return provider.selectedFilter != null 
          ? ColorFiltered(colorFilter: ColorFilter.matrix(provider.selectedFilter!), child: Image.file(provider.image!, fit: BoxFit.contain))
          : Image.file(provider.image!, fit: BoxFit.contain);
    }

    // CÁC BỘ LỌC CHO TỪNG Ô TRONG ẢNH GHÉP
    final List<List<double>?> stripFilters = [
      null, 
      [0.393, 0.769, 0.189, 0, 0, 0.349, 0.686, 0.168, 0, 0, 0.272, 0.534, 0.131, 0, 0, 0, 0, 0, 1, 0],
      [0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0],
      [1.2, -0.1, -0.1, 0, 0, -0.1, 1.3, -0.1, 0, 0, -0.1, -0.1, 1.4, 0, 0, 0, 0, 0, 1, 0],
      [1.06, 0, 0, 0, 0, 0, 1.01, 0, 0, 0, 0, 0, 0.93, 0, 0, 0, 0, 0, 1, 0],
      [0.9, 0, 0, 0, 0, 0, 0.9, 0, 0, 0, 0, 0, 1.2, 0, 0, 0, 0, 0, 1, 0],
    ];

    int crossAxisCount = 1;
    int totalCount = 4;

    if (provider.stripLayout == StripLayout.vertical4) {
      crossAxisCount = 1; totalCount = 4;
    } else if (provider.stripLayout == StripLayout.square4) {
      crossAxisCount = 2; totalCount = 4;
    } else if (provider.stripLayout == StripLayout.grid6) {
      crossAxisCount = 2; totalCount = 6;
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: (provider.stripLayout == StripLayout.vertical4) ? 3 : 1, // TỐI ƯU TỶ LỆ Ô ẢNH
        ),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          final matrix = stripFilters[index % stripFilters.length];
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: matrix != null 
                ? ColorFiltered(colorFilter: ColorFilter.matrix(List<double>.from(matrix.map((e) => e.toDouble()))), child: Image.file(provider.image!, fit: BoxFit.cover))
                : Image.file(provider.image!, fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  List<Widget> _buildStickers(EditorProvider provider) {
    return provider.stickers.map((sticker) {
      return Positioned(
        left: sticker.position.dx, top: sticker.position.dy,
        child: GestureDetector(
          onLongPress: () => setState(() => selectedItem = sticker),
          onScaleUpdate: (details) {
            sticker.position += details.focalPointDelta;
            sticker.scale = details.scale;
            provider.notifyListeners();
          },
          child: Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            children: [
              Transform.scale(scale: sticker.scale, child: Image.asset(sticker.asset, width: 80)),
              if (selectedItem == sticker)
                Positioned(top: -10, right: -10, child: GestureDetector(onTap: () { provider.removeSticker(sticker); setState(() => selectedItem = null); }, child: _buildCloseIcon())),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildTexts(EditorProvider provider) {
    return provider.texts.map((text) {
      return Positioned(
        left: text.position.dx, top: text.position.dy,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: () => setState(() => selectedItem = text),
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
                  child: Text(text.text, textAlign: TextAlign.center, style: GoogleFonts.getFont(text.fontFamily ?? 'Dancing Script', fontSize: 24, color: text.color, fontWeight: FontWeight.bold)),
                ),
              ),
              if (selectedItem == text)
                Positioned(top: -15, right: -15, child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () { provider.removeText(text); setState(() => selectedItem = null); }, child: _buildCloseIcon(size: 24))),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCloseIcon({double size = 20}) {
    return Container(
      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      padding: const EdgeInsets.all(4),
      child: Icon(Icons.close, color: Colors.white, size: size),
    );
  }
}
