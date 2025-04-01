import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';

/// Custom converter to serialize and deserialize `Offset`
class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    return Offset(json['dx'] as double, json['dy'] as double);
  }

  @override
  Map<String, dynamic> toJson(Offset offset) {
    return {'dx': offset.dx, 'dy': offset.dy};
  }
}

