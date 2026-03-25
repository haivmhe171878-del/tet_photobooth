import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../providers/editor_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/photo_canvas.dart';
import '../widgets/sticker_panel.dart';
import '../widgets/frame_panel.dart';
import '../widgets/text_editor.dart';
import '../widgets/filter_panel.dart';
import 'album_screen.dart';

class HomePage extends StatelessWidget {

  HomePage({super.key});

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EditorProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        toolbarHeight: 80,
        title: const Column(
          children: [
            Text("🧧 TẾT BÍNH NGỌ 🧧", 
              style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 18)),
            Text("2026", 
              style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFFFFD700))),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Color(0xFFFFD700), size: 22),
          onPressed: () => _showLogoutDialog(context, authProvider, provider),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library, color: Color(0xFFFFD700), size: 24),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AlbumScreen()));
            },
          ),
          const SizedBox(width: 5),
        ],
      ),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [Color(0xFFB71C1C), Color(0xFF640D14), Color(0xFF38040E)],
              ),
            ),
          ),

          Center(
            child: Opacity(
              opacity: 0.25,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.3), blurRadius: 100, spreadRadius: 50),
                  ],
                ),
                child: const Text(
                  "🐎", 
                  style: TextStyle(fontSize: 200, color: Color(0xFFFFD700)),
                ),
              ),
            ),
          ),

          Positioned(top: 150, right: 30, child: _buildDecorItem("🪙", 40, 0.4)),
          Positioned(bottom: 250, left: 20, child: _buildDecorItem("🪙", 60, -0.2)),
          Positioned(top: 120, left: 50, child: _buildDecorItem("🧧", 50, -0.3)),
          Positioned(bottom: 180, right: 40, child: _buildDecorItem("🧧", 70, 0.5)),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFFFD700), width: 4),
                            boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 40, spreadRadius: 5)],
                          ),
                          child: AspectRatio(
                            aspectRatio: 3/4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: PhotoCanvas(controller: screenshotController),
                            ),
                          ),
                        ),
                      ),

                      if (provider.image != null)
                        Positioned(
                          top: 20,
                          right: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// NÚT CHỌN LAYOUT (STRIP)
                              GestureDetector(
                                onTap: () => _showStripMenu(context, provider),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: provider.isStripMode ? Colors.blue : Colors.grey.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.yellow, width: 2),
                                  ),
                                  child: const Icon(Icons.view_day, color: Colors.white, size: 24),
                                ),
                              ),

                              if (provider.canUndo)
                                GestureDetector(
                                  onTap: () => provider.undo(),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.yellow, width: 2),
                                    ),
                                    child: const Icon(Icons.undo, color: Colors.white, size: 24),
                                  ),
                                ),

                              GestureDetector(
                                onTap: () => _showClearDialog(context, provider),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.yellow, width: 2),
                                  ),
                                  child: const Icon(Icons.delete_forever, color: Colors.white, size: 24),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToolButton(context, icon: Icons.camera_alt, color: Colors.white, onTap: () => provider.takePhoto()),
                      _buildToolButton(context, icon: Icons.photo_library, color: Colors.white, onTap: () => provider.pickImage()),
                      const FilterPanel(),
                      const StickerPanel(),
                      const TextEditor(),
                      const FramePanel(),
                      _buildToolButton(
                        context,
                        icon: Icons.save_alt,
                        color: const Color(0xFFFFD700),
                        onTap: () {
                          if (provider.image != null) {
                            _showLiXiDialog(context, provider);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Hãy chọn hoặc chụp ảnh trước nhé! 🧧")),
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorItem(String emoji, double size, double angle) {
    return Opacity(
      opacity: 0.6,
      child: Transform.rotate(angle: angle, child: Text(emoji, style: TextStyle(fontSize: size))),
    );
  }

  Widget _buildToolButton(BuildContext context, {required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
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

  void _showLiXiDialog(BuildContext context, EditorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFB71C1C), Color(0xFF4A0404)]),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFFFD700), width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("🧧 LÌ XÌ ẢNH TẾT 🧧", style: TextStyle(color: Color(0xFFFFD700), fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                _buildLiXiButton(context, title: "LƯU VÀO MÁY", icon: Icons.download, onTap: () async {
                  Navigator.pop(context);
                  await provider.saveImage(screenshotController);
                }),
                const SizedBox(height: 15),
                _buildLiXiButton(context, title: "CHIA SẺ NGAY", icon: Icons.share, onTap: () async {
                  Navigator.pop(context);
                  await provider.shareImage(screenshotController);
                }),
                const SizedBox(height: 20),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Đóng", style: TextStyle(color: Colors.white54))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiXiButton(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFF4A0404)),
        label: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A0404))),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider, EditorProvider editorProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận Đăng xuất"),
        content: const Text("Bạn có muốn đăng xuất không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(onPressed: () {
            Navigator.pop(context);
            authProvider.logout();
            editorProvider.resetEditor();
          }, child: const Text("Đăng xuất", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, EditorProvider editorProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Làm mới"),
        content: const Text("Xóa sạch tất cả các chỉnh sửa?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(onPressed: () {
            Navigator.pop(context);
            editorProvider.resetEditor();
          }, child: const Text("Đồng ý", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
