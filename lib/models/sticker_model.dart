import 'package:flutter/material.dart';

class StickerModel {

  String asset;
  Offset position;
  double scale;

  StickerModel({
    required this.asset,
    this.position = const Offset(100,100),
    this.scale = 1,
  });
}