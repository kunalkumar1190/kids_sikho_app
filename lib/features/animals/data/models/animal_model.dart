import 'package:flutter/material.dart';

class AnimalModel {
  final String name;
  final String emoji;
  final Color color;

  const AnimalModel({
    required this.name,
    required this.emoji,
    required this.color,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      color: Color(int.parse(json['color'] as String)),
    );
  }
}
