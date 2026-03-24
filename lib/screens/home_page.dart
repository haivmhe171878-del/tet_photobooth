import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../providers/editor_provider.dart';
import '../providers/auth_provider.dart';
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
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text("🧧 TẾT PHOTOBOOTH 🧧", overflow: TextOverflow.ellipsis),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.yellow, size: 20),
          onPressed: () {
            _showLogoutDialog(context, authProvider, provider);
          },
        ),
        actions: [
          if (provider.image != null)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.yellow, size: 20),
              onPressed: () {
                _showClearDialog(context, provider);
              },
            ),
        ],
      ),

      body: Stack(
        children: [
          /// 1. LỚP NỀN GRADIENT CHÍNH
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFB71C1C),
                  Color(0xFFD32F2F),
                  Color(0xFFF44336),
                ],
              ),
            ),
          ),

          /// 2. HỌA TIẾT TRANG TRÍ NỀN (PATTERN CHÌM)
          Opacity(
            opacity: 0.1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) => const Center(
                child: Text("🧧", style: TextStyle(fontSize: 60)),
              ),
            ),
          ),

          /// 3. CÀNH HOA VÀ CHI TIẾT TRANG TRÍ GÓC
          Positioned(
            top: -20,
            right: -20,
            child: Opacity(
              opacity: 0.6,
              child: Transform.rotate(
                angle: 0.5,
                child: const Text("🌸🌸\n🌸🌸🌸", style: TextStyle(fontSize: 50)),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -10,
            child: Opacity(
              opacity: 0.5,
              child: const Text("🏮", style: TextStyle(fontSize: 80)),
            ),
          ),

          /// 4. GIAO DIỆN CHÍNH
          SafeArea(
            child: Column(
              children: [
                /// CANVAS AREA (PHOTOBOOTH BOX)
                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.yellow, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 20,
                            color: Colors.black45,
                            spreadRadius: 2,
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
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 1),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildToolButton(
                        context,
                        icon: Icons.camera_alt,
                        color: Colors.white,
                        onTap: () => provider.takePhoto(),
                      ),
                      _buildToolButton(
                        context,
                        icon: Icons.photo_library,
                        color: Colors.white,
                        onTap: () => provider.pickImage(),
                      ),
                      const StickerPanel(),
                      const TextEditor(),
                      const FramePanel(),
                      _buildToolButton(
                        context,
                        icon: Icons.save_alt,
                        color: Colors.yellow,
                        onTap: () async {
                          bool success = await provider.saveImage(screenshotController);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("📸 Ảnh đã lưu vào máy!"),
                                backgroundColor: Colors.orangeAccent,
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
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(BuildContext context, {required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider, EditorProvider editorProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              authProvider.logout();
              editorProvider.resetEditor(); 
            },
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, EditorProvider editorProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Làm mới ảnh"),
        content: const Text("Xóa hết hiệu ứng để làm lại từ đầu?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              editorProvider.resetEditor(); 
            },
            child: const Text("Làm mới", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
