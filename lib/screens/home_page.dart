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
        title: const Text("🧧 TẾT PHOTOBOOTH 🧧"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.yellow),
          onPressed: () {
            _showLogoutDialog(context, authProvider);
          },
        ),
      ),

      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB71C1C), /// ĐỎ ĐẬM
              Color(0xFFD32F2F), /// ĐỎ TƯƠI
              Color(0xFFF44336), /// ĐỎ SÁNG
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              /// CANVAS AREA (PHOTOBOOTH BOX)
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.yellow, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black45,
                          spreadRadius: 5,
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

              /// TOOLBAR (MODERN CIRCULAR BUTTONS)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(40),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    /// CAMERA BUTTON
                    _buildToolButton(
                      context,
                      icon: Icons.camera_alt,
                      color: Colors.white,
                      onTap: () => provider.takePhoto(),
                    ),

                    /// GALLERY BUTTON
                    _buildToolButton(
                      context,
                      icon: Icons.photo_library,
                      color: Colors.white,
                      onTap: () => provider.pickImage(),
                    ),

                    /// STICKER PANEL (CUSTOM WIDGETS NEED TO BE ADAPTED)
                    const StickerPanel(),

                    /// TEXT EDITOR
                    const TextEditor(),

                    /// FRAME PANEL
                    const FramePanel(),

                    /// SAVE BUTTON
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

                        } else {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lưu ảnh thất bại!"),
                              backgroundColor: Colors.black,
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
      ),
    );
  }

  /// HELPER FOR BUTTONS
  Widget _buildToolButton(BuildContext context, {required IconData icon, required Color color, required VoidCallback onTap}) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }

  /// LOGOUT DIALOG
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              authProvider.logout();
            },
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
