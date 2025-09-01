import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData? icon;
  final String? imageUrl;
  final String jsonUrl;
  final Color? color;

  const CategoryModel({
    required this.name,
    this.icon,
    this.imageUrl,
    required this.jsonUrl,
    this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] ?? '',
      icon: json['icon'] != null ? IconData(json['icon'], fontFamily: 'MaterialIcons') : null,
      imageUrl: json['imageUrl'],
      jsonUrl: json['jsonUrl'] ?? '',
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon?.codePoint,
      'imageUrl': imageUrl,
      'jsonUrl': jsonUrl,
      'color': color?.value,
    };
  }

  @override
  String toString() {
    return 'CategoryModel(name: $name, icon: $icon, imageUrl: $imageUrl, jsonUrl: $jsonUrl)';
  }
}
