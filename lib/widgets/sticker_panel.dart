import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editor_provider.dart';

class StickerPanel extends StatelessWidget {
  const StickerPanel({super.key});

  // Danh sách sticker
  static const List<String> stickers = [
    "assets/stickers/sticker1.png",
    "assets/stickers/sticker2.jpg",
    "assets/stickers/sticker3.png",
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditorProvider>(context, listen: false);

    return IconButton(
      icon: const Icon(Icons.emoji_emotions),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: stickers.length,
                itemBuilder: (context, index) {
                  final sticker = stickers[index];

                  return GestureDetector(
                    onTap: () {
                      provider.addSticker(sticker);
                      Navigator.pop(context);
                    },
                    child: Image.asset(sticker),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}