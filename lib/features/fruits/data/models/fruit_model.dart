import 'package:flutter/material.dart';

class FruitModel {
  final String name;
  final String emoji;
  final Color color;

  const FruitModel({
    required this.name,
    required this.emoji,
    required this.color,
  });

  factory FruitModel.fromJson(Map<String, dynamic> json) {
    return FruitModel(
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      color: Color(int.parse(json['color'] as String)),
    );
  }
}
