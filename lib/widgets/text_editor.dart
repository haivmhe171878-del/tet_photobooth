import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/editor_provider.dart';

class TextEditor extends StatefulWidget {

  const TextEditor({super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {

  Color selectedColor = Colors.red;
  String selectedFont = 'Dancing Script';

  final List<Color> colors = [
    Colors.red,
    Colors.yellow,
    Colors.white,
    Colors.black,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  final List<String> fonts = [
    'Dancing Script',
    'Pacifico',
    'Lobster',
    'Great Vibes',
  ];

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EditorProvider>(context);

    return IconButton(
      icon: const Icon(Icons.text_fields, color: Colors.white),

      onPressed: () {

        TextEditingController controller = TextEditingController();

        showDialog(
          context: context,

          builder: (_) {

            return StatefulBuilder(
              builder: (context, setState) {

                return AlertDialog(
                  backgroundColor: const Color(0xFFFFFDE7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: const Text("Thêm chữ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),

                  content: SingleChildScrollView( // SỬA LỖI OVERFLOW TRONG DIALOG
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        TextField(
                          controller: controller,
                          autofocus: true,
                          decoration:
                          const InputDecoration(
                            hintText: "Nhập nội dung...",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),

                        const SizedBox(height: 25),
                        const Text("Chọn màu sắc:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),

                        /// COLOR PICKER
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
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
                                    color: selectedColor == color ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 25),
                        const Text("Chọn kiểu chữ mềm mại:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),

                        /// FONT PICKER (MỀM MẠI VỚI GOOGLE FONTS)
                        Column(
                          children: fonts.map((font) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                font, 
                                style: GoogleFonts.getFont(font, fontSize: 18, color: Colors.black)
                              ),
                              leading: Radio<String>(
                                value: font,
                                groupValue: selectedFont,
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  setState(() {
                                    selectedFont = value!;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  actions: [
                    TextButton(
                      child: const Text("HỦY", style: TextStyle(color: Colors.grey)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("THÊM", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          provider.addText(
                            controller.text,
                            selectedColor,
                            selectedFont,
                          );
                          Navigator.pop(context);
                        }
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
