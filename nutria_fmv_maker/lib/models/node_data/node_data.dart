import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nutria_fmv_maker/models/converters/offset_converter.dart';
import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/models/video_metadata.dart';
import 'package:nutria_fmv_maker/utilities/get_text_height.dart';
import '../../static_data/ui_static_properties.dart';

import '../app_theme.dart';
import 'input.dart';
import 'output.dart';


// @JsonSerializable()
abstract class NodeData {
  @OffsetConverter()
  final Offset position;
  final String id;
  @OffsetConverter()
  final Offset intendedPosition; // Always initialized and non-null
  final bool isSelected;
  final bool isBeingHovered;

  Map<String, dynamic>? toJsonExport();

  //padding offset used for getters of input and output positions and height
  Offset get paddingOffset {
    return const Offset(
        UiStaticProperties.nodePadding, UiStaticProperties.nodePadding);
  }

  const NodeData({
    required this.position,
    required this.id,
    Offset? intendedPosition, // Nullable parameter
    this.isSelected = false,
    this.isBeingHovered = false,
  }) : intendedPosition = intendedPosition ?? position;

  // Copy method to create a new instance with updated fields
  NodeData copyWith(
      {Offset? position,
      Offset? intendedPosition,
      bool? isSelected,
      bool? isBeingHovered});

}

// @JsonSerializable()
abstract class BaseNodeData extends NodeData {
  final String? nodeName;
  final double nodeWidth;
  final double intendedNodeWidth; //Used by functions like snap to default size
  final bool isExpanded;
  final List<Output> outputs; // Must also be immutable
  final Input? input;
  final int swatch;

  Offset inputPosition(AppTheme theme);
  Offset outputPosition(AppTheme theme, int index);
  double nodeHeight(AppTheme theme);

  const BaseNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    this.nodeName,
    this.nodeWidth = UiStaticProperties.nodeDefaultWidth,
    this.isExpanded = false,
    this.swatch = 0,
    double? intendedNodeWidth,
    List<Output>? outputs,
    this.input = const Input(),
    super.isSelected = false,
    super.isBeingHovered = false,
  })  : outputs = outputs ?? const <Output>[],
        intendedNodeWidth = intendedNodeWidth ?? nodeWidth;

  @override
  BaseNodeData copyWith({
    String? id,
    Offset? position,
    Offset? intendedPosition, //used for grid snapping calculations
    String? nodeName,
    double? nodeWidth,
    bool? isExpanded,
    List<Output>? outputs,
    Input? input,
    int? swatch,
    double? intendedNodeWidth, //used for default width snapping calculations
    bool? isSelected,
    bool? isBeingHovered,
  });

}
