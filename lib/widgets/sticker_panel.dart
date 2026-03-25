import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editor_provider.dart';

class StickerPanel extends StatelessWidget {
  const StickerPanel({super.key});

  static final List<String> stickers = List.generate(12, (index) => "assets/stickers/sticker${index + 1}.png");

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditorProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFFFFFDE7),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text("CHỌN STICKER TẾT 🧧", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: stickers.length,
                      itemBuilder: (context, index) {
                        final sticker = stickers[index];
                        return GestureDetector(
                          onTap: () {
                            provider.addSticker(sticker);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(sticker),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
        child: const Icon(Icons.emoji_emotions, color: Colors.white, size: 20),
      ),
    );
  }
}
