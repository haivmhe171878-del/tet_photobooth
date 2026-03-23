import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editor_provider.dart';

class FramePanel extends StatelessWidget {

  const FramePanel({super.key});

  // Danh sách frame
  static const List<String> frames = [
    "assets/frames/frame1.png",
    "assets/frames/frame2.png",
    "assets/frames/frame3.png",
  ];

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EditorProvider>(context, listen: false);

    return IconButton(
      icon: const Icon(Icons.crop_square),
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
                        border: Border.all(color: Colors.grey),
                      ),

                      child: Image.asset(
                        frame,
                        fit: BoxFit.cover,
                      ),
                    ),
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