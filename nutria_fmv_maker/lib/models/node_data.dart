import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/models/video_metadata.dart';
import '../static_data/ui_static_properties.dart';
import 'package:collection/collection.dart';

import 'app_theme.dart';

abstract class NodeData {
  final Offset position;
  final String id;
  final Offset intendedPosition; // Always initialized and non-null
  final bool isSelected;
  final bool isBeingHovered;
  Map<String, dynamic>? toJsonSave();
  Map<String, dynamic>? toJsonExport();

  double _getTextHeight(String text, TextStyle style) {
    //todo allow for multiple lines
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      // maxLines: 1,
    )..layout();

    return textPainter.height;
  }

  //padding offset used for getters of input and output positions and height
  Offset get _paddingOffset {
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

abstract class BaseNodeData extends NodeData {
  final String? nodeName;
  final double nodeWidth;
  final double intendedNodeWidth; //Used by functions like snap to default size
  final bool isExpanded;
  final List<Output> outputs; // Must also be immutable
  final Input input;
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

// /// Set an override for a property
// void setOverride(String key, dynamic value) {
//   overrides[key] = value;
// }

// /// Remove an override (revert to default)
// void removeOverride(String key) {
//   overrides.remove(key);
// }

// ///Get the video data for this node
// VideoData? getVideoData(List<VideoData> videoList) {
//   return videoList.firstWhereOrNull((element) => element.id == videoDataId);
// }
class originNodeData extends BaseNodeData {

  const originNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    super.outputs,
    super.nodeName,
    super.isExpanded = false,
    super.nodeWidth = UiStaticProperties.nodeDefaultWidth,
    super.intendedNodeWidth,
    super.swatch = 0,
    super.isSelected = false,
    super.isBeingHovered = false,
  });

  @override
  BaseNodeData copyWith(
      {Offset? position,
      Offset? intendedPosition,
      String? nodeName,
      double? nodeWidth,
      bool? isExpanded,
      List<Output>? outputs,
      Input? input,
      int? swatch,
      double? intendedNodeWidth,
      bool? isSelected,
      bool? isBeingHovered}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  Offset inputPosition(AppTheme theme) {
    // TODO: implement inputPosition
    throw UnimplementedError();
  }

  @override
  double nodeHeight(AppTheme theme) {
    // TODO: implement nodeHeight
    throw UnimplementedError();
  }

  @override
  Offset outputPosition(AppTheme theme, int index) {
    // TODO: implement outputPosition
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJsonExport() {
    // TODO: implement toJsonExport
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJsonSave() {
    // TODO: implement toJsonSave
    throw UnimplementedError();
  }
}

class VideoNodeData extends BaseNodeData {
  final String videoDataId;
  final bool hasMaxedOutOutputs;
  final Map<String, dynamic> overrides;

//TODO document
  @override
  Map<String, Map<String, dynamic>>? toJsonExport() {
    Map<String, dynamic> outputMap = {};
    for (int i = 0; i < outputs.length; i++) {
      if (outputs[i].outputData != null && outputs[i].outputData is! String) {
        throw Exception('Output data must be a String or null');
      }
      String option = outputs[i].outputData as String? ?? '';
      String? id = outputs[i].targetNodeId;

      if (id != null) {
        outputMap[option] = id;
      }
    }
    return {
      id: {
        'video': videoDataId,
        if (outputMap.isNotEmpty) 'choices': outputMap,
        if (overrides.isNotEmpty)
          'overrides': overrides.map((key, value) {
            final overrideValue = getOverrideString(key, value);
            return MapEntry(key, overrideValue);
          }),
      }
    };
  }

  Map<String, dynamic>? toJsonSave() {
    return null;
  }

  const VideoNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    required this.videoDataId,
    this.overrides = const <String, dynamic>{},
    this.hasMaxedOutOutputs = false,
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
  }) {
    return VideoNodeData(
      position: position ?? this.position,
      intendedPosition: intendedPosition ?? this.intendedPosition,
      id: id,
      videoDataId: videoDataId ?? this.videoDataId,
      hasMaxedOutOutputs: hasMaxedOutOutputs ?? this.hasMaxedOutOutputs,
      overrides: overrides ?? this.overrides,
      nodeName: nodeName ?? this.nodeName,
      nodeWidth: nodeWidth ?? this.nodeWidth,
      intendedNodeWidth: intendedNodeWidth ?? this.intendedNodeWidth,
      isExpanded: isExpanded ?? this.isExpanded,
      swatch: swatch ?? this.swatch,
      outputs: outputs ?? this.outputs,
      input: input ?? this.input,
      isBeingHovered: isBeingHovered ?? this.isBeingHovered,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  Offset outputPosition(AppTheme theme, int index) {
    double x = nodeWidth;
    double baseY = theme.dSwatchHeight +
        (nodeName != null
            ? _getTextHeight(nodeName!, theme.swatchTextStyle)
            : 0) +
        (UiStaticProperties.nodeDefaultWidth * 9 / 16) +
        _getTextHeight(videoDataId, theme.filenameTextStyle) +
        (theme.dPanelPadding * 4) +
        (theme.dButtonHeight / 2);
    double extraY = index * (theme.dButtonHeight + theme.dPanelPadding);
    return Offset(x, baseY + extraY) + _paddingOffset;
  }

  @override
  Offset inputPosition(AppTheme theme) {
    double x = 0;
    double y = theme.dSwatchHeight +
        (nodeName != null
            ? _getTextHeight(nodeName!, theme.swatchTextStyle)
            : 0) +
        (UiStaticProperties.nodeDefaultWidth * 9 / 16);
    return Offset(x, y) + _paddingOffset;
  }

  @override
  double nodeHeight(AppTheme theme) {
    double height = theme.dSwatchHeight +
        (nodeName != null
            ? _getTextHeight(nodeName!, theme.swatchTextStyle)
            : 0) +
        (UiStaticProperties.nodeDefaultWidth * 9 / 16) +
        _getTextHeight(videoDataId, theme.filenameTextStyle) +
        (theme.dPanelPadding * (2 + outputs.length)) +
        (theme.dButtonHeight * outputs.length);
    return height;
  }
}

class Output {
  final String? targetNodeId;
  final Object? outputData;
  final bool isBeingTargeted;
  final bool isBeingDragged;

  const Output({
    this.targetNodeId,
    this.outputData,
    this.isBeingTargeted = false,
    this.isBeingDragged = false,
  });

  Output copyWith({
    String? Function()? targetNodeId,
    Object? Function()? outputData,
    bool? isBeingTargeted,
    bool? isBeingDragged,
  }) {
    return Output(
      targetNodeId: targetNodeId != null ? targetNodeId() : this.targetNodeId,
      outputData: outputData != null ? outputData() : this.outputData,
      isBeingTargeted: isBeingTargeted ?? this.isBeingTargeted,
      isBeingDragged: isBeingDragged ?? this.isBeingDragged,
    );
  }
}

class Input {
  final bool isBeingTargeted;
  final bool isBeingDragged;

  const Input({
    this.isBeingTargeted = false,
    this.isBeingDragged = false,
  });

  Input copyWith({
    bool? isBeingTargeted,
    bool? isBeingDragged,
  }) {
    return Input(
      isBeingTargeted: isBeingTargeted ?? this.isBeingTargeted,
      isBeingDragged: isBeingDragged ?? this.isBeingDragged,
    );
  }
}

class VideoData {
  final String id;
  final String videoPath;
  final String? thumbnailPath;
  final List<MetadataEntry>? metadata;
  String get fileName => '${Uri.file(videoPath).pathSegments.last}';

  VideoData({
    required this.videoPath,
    required this.id,
    this.thumbnailPath,
    this.metadata = const <MetadataEntry>[],
  });

  VideoData copyWith({
    String? id,
    String? videoDataPath,
    String? thumbnailPath,
    List<MetadataEntry>? metadata,
  }) {
    return VideoData(
      id: id ?? this.id,
      videoPath: videoDataPath ?? this.videoPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      metadata: metadata ?? this.metadata,
    );
  }
}
