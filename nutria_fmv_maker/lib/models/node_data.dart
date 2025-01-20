import 'package:flutter/material.dart';
import '../static_data/ui_static_properties.dart';
import 'package:collection/collection.dart';

abstract class NodeData {
  final Offset position;
  final String id;
  final Offset intendedPosition; // Always initialized and non-null
  final bool isSelected;

  const NodeData({
    required this.position,
    required this.id,
    Offset? intendedPosition, // Nullable parameter
    this.isSelected = false,
  }) : intendedPosition = intendedPosition ?? position;

  // Copy method to create a new instance with updated fields
  NodeData copyWith({Offset? position, Offset? intendedPosition});

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
  final double intendedNodeWidth; //Used by functions like snap to default size
  final bool isExpanded;
  final List<Output> outputs; // Must also be immutable
  final int swatch;

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
  })  : outputs = outputs ?? const <Output>[],
        intendedNodeWidth = intendedNodeWidth ?? nodeWidth;

  @override
  BaseNodeData copyWith({
    Offset? position,
    Offset? intendedPosition,
    String? nodeName,
    double? nodeWidth,
    bool? isExpanded,
    List<Output>? outputs,
    int? swatch,
    double? intendedNodeWidth,
  });
}

class VideoNodeData extends BaseNodeData {
  final String videoDataId;
  Map<String, dynamic> overrides;

  /// Set an override for a property
  void setOverride(String key, dynamic value) {
    overrides[key] = value;
  }

  /// Remove an override (revert to default)
  void removeOverride(String key) {
    overrides.remove(key);
  }

  ///Get the video data for this node
  VideoData? getVideoData(List<VideoData> videoList) {
    return videoList.firstWhereOrNull((element) => element.id == videoDataId);
  }

  VideoNodeData(
      {required super.position,
      super.intendedPosition,
      required super.id,
      required this.videoDataId,
      this.overrides = const <String, dynamic>{},
      super.outputs,
      super.nodeName,
      super.isExpanded = false,
      super.nodeWidth = UiStaticProperties.nodeDefaultWidth,
      super.intendedNodeWidth,
      super.swatch = 0});

@override
VideoNodeData copyWith({
  Offset? position,
  Offset? intendedPosition, 
  String? videoDataId,
  Map<String, dynamic>? overrides,
  String? nodeName,
  double? nodeWidth,
  double? intendedNodeWidth,
  bool? isExpanded,
  int? swatch,
  List<Output>? outputs,
}) {
  return VideoNodeData(
    position: position ?? this.position,
    intendedPosition: intendedPosition ?? this.intendedPosition,
    id: id,
    videoDataId: videoDataId ?? this.videoDataId,
    overrides: overrides ?? this.overrides,
    nodeName: nodeName ?? this.nodeName,
    nodeWidth: nodeWidth ?? this.nodeWidth,
    intendedNodeWidth: intendedNodeWidth ?? this.intendedNodeWidth,
    isExpanded: isExpanded ?? this.isExpanded,
    swatch: swatch ?? this.swatch,
    outputs: outputs ?? this.outputs,
  );
}
}

class Output {
  final Offset outputOffsetFromTopLeft;
  final String? targetNodeId;
  final Object? outputData;

  const Output({
    this.outputOffsetFromTopLeft = const Offset(0, 0),
    this.targetNodeId,
    this.outputData
  });

  Output copyWith({Offset? outputOffsetFromTopLeft, String? targetNodeId, Object? outputData}) {
    return Output(
      outputOffsetFromTopLeft: outputOffsetFromTopLeft ?? this.outputOffsetFromTopLeft,
      targetNodeId: targetNodeId ?? this.targetNodeId,
      outputData: outputData ?? this.outputData,
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
