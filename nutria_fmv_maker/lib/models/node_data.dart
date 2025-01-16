import 'package:flutter/material.dart';
import '../static_data/ui_static_properties.dart';
import 'package:collection/collection.dart';

abstract class NodeData {
  final Offset position;
  final String id;

  const NodeData({
    required this.position,
    required this.id,
  });

  // Copy method to create a new instance with updated fields
  NodeData copyWith({Offset? position});

// @override
// bool operator ==(Object other) {
//   if (identical(this, other)) return true;

//   return other is NodeData &&
//       other.id == id &&
//       other.position == position; // Add other properties if necessary.
// }

// @override
// int get hashCode => id.hashCode ^ position.hashCode; //
}

abstract class BaseNodeData extends NodeData {
  final String? nodeName;
  final double nodeWidth;
  final bool isExpanded;
  final List<Output> outputs; // Must also be immutable
  final int swatch;

  const BaseNodeData({
    required super.position,
    required super.id,
    this.nodeName,
    this.nodeWidth = UiStaticProperties.nodeDefaultWidth,
    this.isExpanded = false,
    this.swatch = 0,
    List<Output>? outputs,
  }) : outputs = outputs ?? const <Output>[];

  @override
  BaseNodeData copyWith({
    Offset? position,
    String? nodeName,
    double? nodeWidth,
    bool? isExpanded,
    List<Output>? outputs,
    int? swatch,
  });
}

class VideoNodeData extends BaseNodeData {
  final String videoDataId;
  Map<String, dynamic> overrides;

  Offset get inputOffsetFromTopLeft => Offset(UiStaticProperties.nodePadding,
      UiStaticProperties.nodePadding + UiStaticProperties.nodeDefaultWidth * 9 / 16 + 10);

  /// Set an override for a property
  void setOverride(String key, dynamic value) {
    overrides[key] = value;
  }

  /// Remove an override (revert to default)
  void removeOverride(String key) {
    overrides.remove(key);
  }

  

  /// Get the effective value of a property
// dynamic getProperty(String key) {
// return overrides.containsKey(key) ? overrides[key] : projectSettings.getDefault(key);
// }

  ///Get the video data for this node
  VideoData? getVideoData(List<VideoData> videoList) {
    return videoList.firstWhereOrNull((element) => element.id == videoDataId);
  }

  VideoNodeData(
      {required super.position,
      required super.id,
      required this.videoDataId,
      this.overrides = const <String, dynamic>{},
      super.outputs,
      super.nodeName,
      super.isExpanded = false,
      super.nodeWidth = UiStaticProperties.nodeDefaultWidth,
      super.swatch = 0});

       @override
  VideoNodeData copyWith({
    Offset? position,
    String? videoDataId,
    Map<String, dynamic>? overrides,
    String? nodeName,
    double? nodeWidth,
    bool? isExpanded,
    int? swatch,
    List<Output>? outputs,
  }) {
    return VideoNodeData(
      position: position ?? this.position,
      id: id,
      videoDataId: videoDataId ?? this.videoDataId,
      overrides: overrides ?? this.overrides,
      nodeName: nodeName ?? this.nodeName,
      nodeWidth: nodeWidth ?? this.nodeWidth,
      isExpanded: isExpanded ?? this.isExpanded,
      swatch: swatch ?? this.swatch,
      outputs: outputs ?? this.outputs,
    );
  }
}

abstract class Output {
  final Offset outputOffsetFromTopLeft;
  final String? targetNodeId;

  const Output({
    this.outputOffsetFromTopLeft = const Offset(0, 0),
    this.targetNodeId,
  });

  Output copyWith({Offset? outputOffsetFromTopLeft, String? targetNodeId});
}

class VideoOutput extends Output {
  final String outputText;

  const VideoOutput({
    super.outputOffsetFromTopLeft,
    super.targetNodeId,
    this.outputText = '',
  });

  @override
  VideoOutput copyWith({
    Offset? outputOffsetFromTopLeft,
    String? targetNodeId,
    String? outputText,
  }) {
    return VideoOutput(
      outputOffsetFromTopLeft: outputOffsetFromTopLeft ?? this.outputOffsetFromTopLeft,
      targetNodeId: targetNodeId ?? this.targetNodeId,
      outputText: outputText ?? this.outputText,
    );
  }
}

class VideoData {
  final String id;
  final String videoDataPath;
  final String? thumbnailPath;
  String get fileName => videoDataPath.split('/').last;
  Duration get duration =>
      const Duration(seconds: 10); //TODO make work with videoplayer plugin
  VideoData({
    required this.videoDataPath,
    required this.id,
    this.thumbnailPath,
  });
}
