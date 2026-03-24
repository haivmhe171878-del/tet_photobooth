import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editor_provider.dart';

class FramePanel extends StatelessWidget {

  const FramePanel({super.key});

  // Danh sách frame tự động sinh ra cho 10 file png
  static final List<String> frames = List.generate(10, (index) => "assets/frames/frame${index + 1}.png");

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EditorProvider>(context, listen: false);

    return IconButton(
      icon: const Icon(Icons.crop_square, color: Colors.white),
      onPressed: () {

        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFFFFFDE7),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {

            return Container(
              height: 350,
              padding: const EdgeInsets.all(15),

              child: Column(
                children: [
                  const Text("CHỌN KHUNG ẢNH TẾT 🧧", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: frames.length,
                      itemBuilder: (context, index) {
                        final frame = frames[index];
                        return GestureDetector(
                          onTap: () {
                            provider.setFrame(frame);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                frame,
                                fit: BoxFit.cover,
                              ),
                            ),
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
    );
  }
}
