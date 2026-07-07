import 'package:flutter/material.dart';

class ColorModel {
  final String name;
  final Color color;

  const ColorModel({
    required this.name,
    required this.color,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      name: json['name'] as String,
      color: Color(int.parse(json['color'] as String)),
    );
  }
}
