import 'package:flutter/material.dart';
import '../static_data/ui_static_properties.dart';
import 'knot_data.dart';

abstract class NodeData {
  Offset position;
  final String id;
  NodeData({required this.position, required this.id});
}

//TODO MAKE OBSOLETE
// class SimpleNodeData extends NodeData {
//   SimpleNodeData({
//     required super.position,
//     required super.id,
//     required String extra,
//   });
// }

abstract class BaseNodeData extends NodeData {
  String? nodeName;
  double nodeWidth;
  bool isExpanded;
  final List<Output> outputs = []; //final?
  int swatch;
  Offset get InputOffsetFromTopLeft;
  BaseNodeData(
      {required super.position,
      required super.id,
      this.nodeName,
      this.isExpanded = false,
      this.nodeWidth = UiStaticProperties.nodeDefaultWidth,
      this.swatch = 0});
}

class VideoNodeData extends BaseNodeData {
  final String videoDataId;
  Offset get InputOffsetFromTopLeft => Offset(UiStaticProperties.nodePadding, UiStaticProperties.nodePadding+);
  VideoNodeData({
    required super.position,
    required super.id,
    required this.videoDataId,
  });
}

class Output {
  double CurrentHeight;
  String OptionText;
  Offset OutputOffsetFromTopLeft;
  String? TargetNodeId;

  Output({
    required this.CurrentHeight,
    required this.OptionText,
    required this.OutputOffsetFromTopLeft,
    this.TargetNodeId,
  });
}

class VideoData {
  final String id;
  final String videoDataPath;
  final String? thumbnailPath;
  final String fileName;
  Duration duration;
  VideoData({
    required this.videoDataPath,
    required this.id,
    this.thumbnailPath,
    required this.fileName,
    required this.duration,
  });
}
