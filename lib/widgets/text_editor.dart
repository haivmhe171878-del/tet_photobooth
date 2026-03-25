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

  // 20 GỢI Ý LỜI CHÚC TẾT HAY NHẤT
  final List<String> aiSuggestions = [
    "Chúc mừng năm mới 2026! 🧧",
    "Vạn sự như ý - Tỷ sự như mơ 🌸",
    "Tết Bính Ngọ - Mã đáo thành công 🐎",
    "An khang thịnh vượng - Phát tài phát lộc",
    "Sức khỏe dồi dào - Tiền vào như nước 🏮",
    "Tết đến xuân về - Tràn trề hạnh phúc",
    "Năm mới thắng lợi mới! ✨",
    "Cung chúc tân xuân - Vạn sự cát tường",
    "Phát lộc phát tài - Gia đình êm ấm",
    "Tiền vô như nước - Sức khỏe vô biên",
    "Tấn tài tấn lộc - Công thành danh toại",
    "Xuân sang rạng rỡ - Hạnh phúc đong đầy",
    "Mọi điều bình an - Xuân này đầm ấm",
    "Công việc hanh thông - Sự nghiệp thăng tiến",
    "Tình duyên phơi phới - Hạnh phúc ngất ngây",
    "Chúc năm mới sang - Bình an vĩnh cửu",
    "Phúc lộc đầy nhà - Xuân vui gõ cửa",
    "Tiền đầy túi - Tim đầy tình - Xăng đầy bình",
    "Ngũ phúc lâm môn - Trọn đời an vui",
    "Ngựa về may mắn - Tết đến thành công 🐎",
  ];

  // 25 MÀU SẮC ĐA DẠNG
  final List<Color> colors = [
    Colors.red, Colors.yellow, Colors.orange, Colors.amber, 
    Colors.white, Colors.black, Colors.green, Colors.teal, 
    Colors.blue, Colors.indigo, Colors.purple, Colors.pink, 
    Colors.brown, Colors.grey, Colors.cyan, Colors.deepOrange,
    Colors.lightGreen, Colors.lime, Colors.blueGrey, Colors.deepPurple,
    const Color(0xFFD4AF37), // Metallic Gold
    const Color(0xFFC0C0C0), // Silver
    const Color(0xFFE6E6FA), // Lavender
    const Color(0xFFF5F5DC), // Beige
    const Color(0xFF008080), // Teal Dark
  ];

  // 20 PHÔNG CHỮ NGHỆ THUẬT MỀM MẠI
  final List<String> fonts = [
    'Dancing Script', 'Pacifico', 'Lobster', 'Great Vibes',
    'Satisfy', 'Courgette', 'Kaushan Script', 'Pattaya',
    'Cookie', 'Sacramento', 'Yellowtail', 'Parisienne',
    'Alex Brush', 'Allura', 'Grand Hotel', 'Leckerli One',
    'Rochester', 'Bad Script', 'Caveat', 'Playball',
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: const Text("Tùy chỉnh chữ 🧧", 
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),

                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          TextField(
                            controller: controller,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: "Nhập nội dung hoặc chọn gợi ý bên dưới...",
                              hintStyle: const TextStyle(fontSize: 14),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          
                          const Text("🤖 Lời chúc gợi ý:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 45,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: aiSuggestions.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => controller.text = aiSuggestions[index]);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(aiSuggestions[index], style: const TextStyle(fontSize: 13, color: Colors.red)),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 25),
                          const Text("🎨 Màu sắc:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: colors.map((color) {
                              return GestureDetector(
                                onTap: () => setState(() => selectedColor = color),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: selectedColor == color ? 3 : 1,
                                      color: selectedColor == color ? Colors.red : Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 25),
                          const Text("🖋️ Phông chữ nghệ thuật:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ListView.builder(
                              itemCount: fonts.length,
                              itemBuilder: (context, index) {
                                final font = fonts[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(font, style: GoogleFonts.getFont(font, fontSize: 16)),
                                  leading: Radio<String>(
                                    value: font,
                                    groupValue: selectedFont,
                                    activeColor: Colors.red,
                                    onChanged: (value) => setState(() => selectedFont = value!),
                                  ),
                                  onTap: () => setState(() => selectedFont = font),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  actions: [
                    TextButton(
                      child: const Text("HỦY", style: TextStyle(color: Colors.grey)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("THÊM CHỮ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          provider.addText(controller.text, selectedColor, selectedFont);
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
