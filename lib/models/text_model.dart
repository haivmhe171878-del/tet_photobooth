import 'package:flutter/material.dart';

class TextModel {
  String text;
  Offset position;
  double scale;
  Color color;
  String? fontFamily; // Thêm trường phông chữ

  TextModel({
    required this.text,
    this.position = const Offset(120, 120),
    this.scale = 1,
    this.color = Colors.red,
    this.fontFamily,
  });
}
