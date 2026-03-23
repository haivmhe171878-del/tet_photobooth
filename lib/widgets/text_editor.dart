import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editor_provider.dart';

class TextEditor extends StatefulWidget {

  const TextEditor({super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {

  Color selectedColor = Colors.red;

  final List<Color> colors = [
    Colors.red,
    Colors.yellow,
    Colors.white,
    Colors.black,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EditorProvider>(context);

    return IconButton(
      icon: const Icon(Icons.text_fields),

      onPressed: () {

        TextEditingController controller = TextEditingController();

        showDialog(
          context: context,

          builder: (_) {

            return StatefulBuilder(
              builder: (context, setState) {

                return AlertDialog(

                  title: const Text("Nhập chữ"),

                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      TextField(
                        controller: controller,
                        decoration:
                        const InputDecoration(
                          hintText: "Nhập nội dung",
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// COLOR PICKER
                      Wrap(
                        spacing: 10,
                        children: colors.map((color) {

                          return GestureDetector(

                            onTap: (){
                              setState(() {
                                selectedColor = color;
                              });
                            },

                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: selectedColor == color ? 3 : 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );

                        }).toList(),
                      )
                    ],
                  ),

                  actions: [

                    TextButton(
                      child: const Text("OK"),

                      onPressed: () {

                        provider.addText(
                          controller.text,
                          selectedColor,
                        );

                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}