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
  String? nodeName;
  double nodeWidth;
  bool isExpanded;
  List<Output> outputs; //final?
  int swatch;
  Offset get inputOffsetFromTopLeft;
  BaseNodeData(
      {required super.position,
      required super.id,
      List<Output>? outputs,
      this.nodeName,
      this.isExpanded = false,
      this.nodeWidth = UiStaticProperties.nodeDefaultWidth,
      this.swatch = 0})
      : outputs = outputs ?? <Output>[];
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

  void initializeOutputs() {
    if (outputs.isEmpty) {
      outputs.add(VideoOutput());
      outputs.add(VideoOutput());
      outputs.add(VideoOutput());
      print('no error');
    }
    if (outputs.length < 3) {
      while (outputs.length < 3) {
        outputs.add(VideoOutput());
      }
    }
    if (!(outputs[outputs.length - 1] as VideoOutput).outputText.isEmpty) {
      outputs.add(VideoOutput());
    }
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
}

abstract class Output {
  // double currentHeight;
  // String optionText;
  // GlobalKey? outputKey;
  Offset outputOffsetFromTopLeft;
  String? targetNodeId;

  Output({
    // required this.currentHeight,
    // required this.optionText,
    this.outputOffsetFromTopLeft = const Offset(0, 0),
    this.targetNodeId,
    // this.outputKey,
  });
}

class VideoOutput extends Output {
  final String outputText;

  VideoOutput({
    super.outputOffsetFromTopLeft,
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
