import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/editor_provider.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("🧧 ALBUM TẾT 🧧"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<File>>(
        future: provider.getAlbumPhotos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("🧧", style: TextStyle(fontSize: 80)),
                  SizedBox(height: 20),
                  Text("Chưa có ảnh nào trong Album Tết", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            );
          }

          final photos = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 3/4,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final file = photos[index];
              return _buildPhotoCard(context, file, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context, File file, EditorProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.yellow, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              child: Image.file(file, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: const BoxDecoration(
              color: Color(0xFFB71C1C),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// SHARE
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.yellow, size: 20),
                  onPressed: () => Share.shareXFiles([XFile(file.path)], text: 'Ảnh Tết 2026 🧧'),
                ),
                /// DELETE
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white70, size: 20),
                  onPressed: () => _showDeleteDialog(context, file, provider),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, File file, EditorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xóa ảnh"),
        content: const Text("Bạn có chắc chắn muốn xóa ảnh này khỏi Album Tết không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () {
              provider.deleteFromAlbum(file);
              Navigator.pop(context);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
