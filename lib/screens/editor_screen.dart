import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:provider/provider.dart';

import '../providers/editor_provider.dart';
import '../widgets/photo_canvas.dart';
import '../widgets/sticker_panel.dart';
import '../widgets/frame_panel.dart';
import '../widgets/text_editor.dart';
import '../widgets/filter_panel.dart';

class EditorScreen extends StatefulWidget {
  final File image;
  const EditorScreen({super.key, required this.image});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditorProvider>(context, listen: false).setImage(widget.image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditorProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: const Text("CHỈNH SỬA 🧧", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.yellow),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.yellow, size: 28),
            onPressed: () => _showSaveOptions(context, provider),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B0000), Color(0xFF4A0000)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.yellow, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
                      ),
                      child: AspectRatio(
                        aspectRatio: 3/4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: PhotoCanvas(controller: screenshotController),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 30,
                    right: 35,
                    child: Row(
                      children: [
                        /// NÚT CHỌN LAYOUT (STRIP)
                        _buildFloatingBtn(
                          icon: Icons.view_day, 
                          color: provider.isStripMode ? Colors.blue : Colors.grey,
                          onTap: () => _showStripMenu(context, provider),
                        ),
                        const SizedBox(width: 10),
                        if (provider.canUndo)
                          _buildFloatingBtn(icon: Icons.undo, color: Colors.orange, onTap: () => provider.undo()),
                        const SizedBox(width: 10),
                        _buildFloatingBtn(icon: Icons.delete_forever, color: Colors.red, onTap: () => provider.resetEditor()),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.yellow.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterPanel(),
                  StickerPanel(),
                  TextEditor(),
                  FramePanel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBtn({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.yellow, width: 1.5),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  void _showStripMenu(BuildContext context, EditorProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFFDE7),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("CHỌN KIỂU ẢNH GHÉP 🎞️", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLayoutOption(context, provider, StripLayout.none, Icons.photo, "1 Ảnh"),
                  _buildLayoutOption(context, provider, StripLayout.vertical4, Icons.view_day, "Dọc 4"),
                  _buildLayoutOption(context, provider, StripLayout.square4, Icons.grid_view, "Vuông 4"),
                  _buildLayoutOption(context, provider, StripLayout.grid6, Icons.apps, "Lưới 6"),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLayoutOption(BuildContext context, EditorProvider provider, StripLayout layout, IconData icon, String label) {
    final isSelected = provider.stripLayout == layout;
    return GestureDetector(
      onTap: () {
        provider.setStripLayout(layout);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red),
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.red),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showSaveOptions(BuildContext context, EditorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFB71C1C),
        title: const Text("🧧 LÌ XÌ ẢNH TẾT", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        content: const Text("Bạn muốn lưu ảnh vào máy hay chia sẻ ngay?", style: TextStyle(color: Colors.white, fontFamily: 'Serif')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("HỦY", style: TextStyle(color: Colors.white70))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.saveImage(screenshotController);
            },
            child: const Text("LƯU MÁY"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.shareImage(screenshotController);
            },
            child: const Text("CHIA SẺ"),
          ),
        ],
      ),
    );
  }
}
