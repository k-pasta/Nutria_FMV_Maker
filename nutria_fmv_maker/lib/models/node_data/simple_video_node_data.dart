import 'dart:ui';

import 'output.dart';
import 'video_node_data.dart';
import '../../utilities/get_text_height.dart';
import '../../static_data/ui_static_properties.dart';
import '../app_theme.dart';
import '../enums_data.dart';
import 'input.dart';

class SimpleVideoNodeData extends VideoNodeData {
//TODO change
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

  @override
  List<Output> get outputs => [super.outputs.first];

  const SimpleVideoNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    required super.videoDataId,
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
      id: id,
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
        getTextHeight(videoDataId, theme.filenameTextStyle) +
        (theme.dPanelPadding * (2 + outputs.length)) +
        (theme.dButtonHeight * outputs.length);
    return height;
  }
}
