import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

import 'output.dart';
import 'video_node_data.dart';
import '../../utilities/get_text_height.dart';
import '../../static_data/ui_static_properties.dart';
import '../app_theme.dart';
import '../enums_data.dart';
import 'input.dart';
import '../converters/offset_converter.dart';



part 'simple_video_node_data.g.dart';

@JsonSerializable()
class SimpleVideoNodeData extends VideoNodeData {
//TODO change
  @override
Map<String, Map<String, dynamic>>? toJsonExport() {
  Map<String, dynamic> outputMap = {};

  // Ensure the node has at least one output
  if (outputs.isNotEmpty) {
    var firstOutput = outputs[0];
    String? id = firstOutput.targetNodeId;

    if (id != null) {
      outputMap['target'] = id; // Set "target" if id is not null
    }
  }

  return {
    id: {
      'video': videoDataId,
      if (outputMap.isNotEmpty) ...outputMap, // Spread outputMap if it's not empty
      if (overrides.isNotEmpty)
        'overrides': overrides.map((key, value) {
          final overrideValue = getOverrideForJson(key, value);
          return MapEntry(key, overrideValue);
        }),
    }
  };
}

  @override
  List<Output> get outputs => [super.outputs.first];

  const SimpleVideoNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    super.videoDataId,
    super.overrides = const <String, dynamic>{},
    super.outputs = const [Output()],
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
  SimpleVideoNodeData copyWith({
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
  }) {
    return SimpleVideoNodeData(
      position: position ?? this.position,
      intendedPosition: intendedPosition ?? this.intendedPosition,
      id: id ?? this.id,
      videoDataId: videoDataId ?? this.videoDataId,
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
    double y = theme.dSwatchHeight +
        (nodeName != null
            ? getTextHeight(nodeName!, theme.swatchTextStyle)
            : 0) +
        (UiStaticProperties.nodeDefaultWidth * 9 / 16);
    return Offset(x, y) + paddingOffset;
  }

  @override
  Offset inputPosition(AppTheme theme) {
    double x = 0;
    double y = theme.dSwatchHeight +
        (nodeName != null
            ? getTextHeight(nodeName!, theme.swatchTextStyle)
            : 0) +
        (UiStaticProperties.nodeDefaultWidth * 9 / 16);
    return Offset(x, y) + paddingOffset;
  }

  @override
  double nodeHeight(AppTheme theme) {
    double height = theme.dSwatchHeight +
        (nodeName != null
            ? getTextHeight(nodeName!, theme.swatchTextStyle)
            : 0) +
        (UiStaticProperties.nodeDefaultWidth * 9 / 16) +
        getTextHeight(videoDataId?? 'No video file', theme.filenameTextStyle) +
        (theme.dPanelPadding * (2 + outputs.length)) +
        (theme.dButtonHeight * outputs.length);
    return height;
  }

  //JsonSerializable encode and decode methods
  factory SimpleVideoNodeData.fromJson(Map<String, dynamic> json) =>
      _$SimpleVideoNodeDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SimpleVideoNodeDataToJson(this);

}
