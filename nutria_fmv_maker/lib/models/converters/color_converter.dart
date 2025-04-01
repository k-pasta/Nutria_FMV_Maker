import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// Custom converter to serialize and deserialize `Color`
class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    return Color(int.parse(json.replaceFirst('#', '0xFF')));
  }

  @override
  String toJson(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}