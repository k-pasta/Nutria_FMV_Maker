import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:nutria_fmv_maker/models/node_data/output.dart';
import 'package:nutria_fmv_maker/utilities/get_text_height.dart';
import '../../static_data/ui_static_properties.dart';
import '../app_theme.dart';
import '../enums_data.dart';
import 'input.dart';
import 'node_data.dart';

// @JsonSerializable()
abstract class VideoNodeData extends BaseNodeData {
  final String? videoDataId;
  @OverridesConverter()
  final Map<String, dynamic> overrides;

  const VideoNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    this.videoDataId,
    this.overrides = const <String, dynamic>{},
    super.outputs,
    super.input,
    super.nodeName,
    super.isExpanded = false,
    super.nodeWidth = UiStaticProperties.nodeDefaultWidth,
    super.intendedNodeWidth,
    super.swatch = 0,
    super.isSelected = false,
    super.isBeingHovered = false,
  });

  @override
  VideoNodeData copyWith({
    String? id,
    Offset? position,
    Offset? intendedPosition,
    String? videoDataId,
    Map<String, dynamic>? overrides,
    bool? hasMaxedOutOutputs,
    String? nodeName,
    double? nodeWidth,
    double? intendedNodeWidth,
    bool? isExpanded,
    int? swatch,
    List<Output>? outputs,
    Input? input,
    bool? isSelected,
    bool? isBeingHovered,
  });
}

class OverridesConverter
    implements JsonConverter<Map<String, dynamic>, Map<String, dynamic>> {
  const OverridesConverter();

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return json.map((key, value) {
      if (value is int) {
        return MapEntry(key, value); // Integers stay as is
      }
      if (value is double) {
        return MapEntry(key, value); // Doubles stay as is
      }
      if (value is bool) {
        return MapEntry(key, value); // Booleans stay as is
      }
      if (value is String) {
        // Handle Enums
        if (VideoFit.values.any((e) => e.name == value)) {
          return MapEntry(
              key, VideoFit.values.firstWhere((e) => e.name == value));
        }
        if (DefaultSelectionMethod.values.any((e) => e.name == value)) {
          return MapEntry(key,
              DefaultSelectionMethod.values.firstWhere((e) => e.name == value));
        }
        return MapEntry(key, value); // Regular strings stay as is
      }
      if (value is Map<String, dynamic> && value.containsKey('duration')) {
        return MapEntry(key, Duration(milliseconds: value['duration'] as int));
      }

      throw UnsupportedError('Unsupported type in overrides map: $value');
    });
  }

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> object) {
    return object.map((key, value) {
      if (value is String || value is int || value is double || value is bool) {
        return MapEntry(key, value); // Primitive types stay as is
      }
      if (value is Duration) {
        return MapEntry(key, {
          'duration': value.inMilliseconds
        }); // Store Duration as milliseconds
      }
      if (value is VideoFit) {
        return MapEntry(key, value.name); // Store Enum as String
      }
      if (value is DefaultSelectionMethod) {
        return MapEntry(key, value.name); // Store Enum as String
      }

      throw UnsupportedError(
          'Unsupported type in overrides map: ${value.runtimeType}');
    });
  }

}
