import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editor_provider.dart';

class FilterPanel extends StatelessWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditorProvider>(context);

    final List<Map<String, dynamic>> filters = [
      {"name": "Gốc", "filter": null},
      {"name": "Cổ điển", "filter": [0.393, 0.769, 0.189, 0, 0, 0.349, 0.686, 0.168, 0, 0, 0.272, 0.534, 0.131, 0, 0, 0, 0, 0, 1, 0]},
      {"name": "Trắng đen", "filter": [0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]},
      {"name": "Hoài niệm", "filter": [0.9, 0.5, 0.1, 0, 0, 0.3, 0.8, 0.1, 0, 0, 0.2, 0.3, 0.5, 0, 0, 0, 0, 0, 1, 0]},
      {"name": "Phim ảnh", "filter": [1.2, -0.1, -0.1, 0, 0, -0.1, 1.3, -0.1, 0, 0, -0.1, -0.1, 1.4, 0, 0, 0, 0, 0, 1, 0]},
      {"name": "Ấm áp", "filter": [1.06, 0, 0, 0, 0, 0, 1.01, 0, 0, 0, 0, 0, 0.93, 0, 0, 0, 0, 0, 1, 0]},
      {"name": "Lạnh lẽo", "filter": [0.9, 0, 0, 0, 0, 0, 0.9, 0, 0, 0, 0, 0, 1.2, 0, 0, 0, 0, 0, 1, 0]},
    ];

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFFFFFDE7),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return Container(
              height: 220,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text("CHỈNH MÀU NGHỆ THUẬT 🧧", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        return GestureDetector(
                          onTap: () {
                            final List<double>? matrix = filter['filter'] != null 
                                ? List<double>.from(filter['filter'].map((e) => e.toDouble())) 
                                : null;
                            provider.setFilter(matrix);
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (provider.selectedFilter == filter['filter']) ? Colors.red : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.style, color: Colors.redAccent),
                                const SizedBox(height: 8),
                                Text(filter['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
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
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
        child: const Icon(Icons.filter_hdr, color: Colors.white, size: 20),
      ),
    );
  }
}
