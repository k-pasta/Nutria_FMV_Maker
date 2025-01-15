import 'package:flutter/material.dart';
import '../static_data/ui_static_properties.dart';
import 'package:collection/collection.dart';

abstract class NodeData {
  Offset position;
  final String id;
  NodeData({
    required this.position,
    required this.id,
  });
}

abstract class BaseNodeData extends NodeData {
  String? nodeName;
  double nodeWidth;
  bool isExpanded;
  final List<Output> outputs; //final?
  int swatch;
  Offset get inputOffsetFromTopLeft;
  BaseNodeData(
      {required super.position,
      required super.id,
      this.outputs = const <Output>[],
      this.nodeName,
      this.isExpanded = false,
      this.nodeWidth = UiStaticProperties.nodeDefaultWidth,
      this.swatch = 0});
}

class VideoNodeData extends BaseNodeData {
  final String videoDataId;
  Map<String, dynamic> overrides;

  Offset get inputOffsetFromTopLeft => Offset(UiStaticProperties.nodePadding,
      UiStaticProperties.nodePadding + nodeWidth * 9 / 16 + 10);

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
      super.outputs = const <VideoOutput>[],
      super.nodeName,
      super.isExpanded = false,
      super.nodeWidth = UiStaticProperties.nodeDefaultWidth,
      super.swatch = 0});
}

abstract class Output {
  // double currentHeight;
  // String optionText;
  Offset outputOffsetFromTopLeft;
  String? targetNodeId;

  Output({
    // required this.currentHeight,
    // required this.optionText,
    required this.outputOffsetFromTopLeft,
    this.targetNodeId,
  });
}

class VideoOutput extends Output {
  final String outputText;

  VideoOutput({
    required super.outputOffsetFromTopLeft,
    this.outputText = '',
    super.targetNodeId,
  });
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
