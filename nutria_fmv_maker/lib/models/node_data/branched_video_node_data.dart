import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'video_node_overrides.dart';
import '../converters/offset_converter.dart';
import 'output.dart';
import 'video_node_data.dart';
import '../../utilities/get_text_height.dart';
import '../../static_data/ui_static_properties.dart';
import '../app_theme.dart';
import '../enums_data.dart';
import 'input.dart';

part 'branched_video_node_data.g.dart';

@JsonSerializable()
class BranchedVideoNodeData extends VideoNodeData {
  final bool hasMaxedOutOutputs;

  const BranchedVideoNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    super.videoDataId,
    super.overrides,
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
  BranchedVideoNodeData copyWith({
    String? id,
    Offset? position,
    Offset? intendedPosition,
    String? videoDataId,
    List<VideoNodeOverride>? overrides,
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
    return BranchedVideoNodeData(
      position: position ?? this.position,
      intendedPosition: intendedPosition ?? this.intendedPosition,
      id: id ?? this.id,
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

//TODO document
  @override
  Map<String, Map<String, dynamic>>? toJsonExport() {
    // Build the list of choices
    final List<Map<String, String>> choicesList = [];

    for (final output in outputs) {
      if (output.outputData != null && output.outputData is! String) {
        throw Exception('Output data must be a String or null');
      }

      final String option = output.outputData as String? ?? '';
      final String? targetId = output.targetNodeId;

      if (targetId != null) {
        choicesList.add({
          'option': option,
          'target': targetId,
        });
      }
    }

    // Convert overrides using the new architecture
    final Map<String, dynamic> overridesMap = {
      for (final override in overrides)
        override.videoOverrideType.name: override.jsonValue
    };

    return {
      id: {
        'video': videoDataId,
        if (choicesList.isNotEmpty) 'choices': choicesList,
        if (overridesMap.isNotEmpty) 'overrides': overridesMap,
      }
    };
  }

  @override
  Offset outputPosition(AppTheme theme, int index) {
    double x = nodeWidth;
    double baseY = theme.dSwatchHeight +
        (nodeName != null
            ? getTextHeight(nodeName!, theme.swatchTextStyle)
            : 0) +
        (UiStaticProperties.nodeDefaultWidth * 9 / 16) +
        getTextHeight(videoDataId ?? 'No Video File', theme.filenameTextStyle) +
        (theme.dPanelPadding * 4) +
        (theme.dButtonHeight / 2);
    double extraY = index * (theme.dButtonHeight + theme.dPanelPadding);
    return Offset(x, baseY + extraY) + paddingOffset;
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
        getTextHeight(videoDataId ?? 'No Video File', theme.filenameTextStyle) +
        (theme.dPanelPadding * (2 + outputs.length)) +
        (theme.dButtonHeight * outputs.length);
    return height;
  }

//JsonSerializable encode and decode methods
  factory BranchedVideoNodeData.fromJson(Map<String, dynamic> json) =>
      _$BranchedVideoNodeDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BranchedVideoNodeDataToJson(this);
}
