import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:nutria_fmv_maker/models/node_data/output.dart';
import '../../static_data/ui_static_properties.dart';
import '../../utilities/get_text_height.dart';
import '../app_theme.dart';
import 'input.dart';
import 'node_data.dart';
import '../converters/offset_converter.dart';

part 'origin_node_data.g.dart';

@JsonSerializable()
class OriginNodeData extends BaseNodeData {
  final String? projectTitle;
  final String? projectDescription;

  const OriginNodeData({
    this.projectTitle,
    this.projectDescription,
    required super.position,
    super.intendedPosition,
    required super.id,
    super.outputs = const [Output()],
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
      {String? Function()? projectTitle,
      String? Function()? projectDescription,
      String? id,
      Offset? position,
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
    return OriginNodeData(
      projectTitle: projectTitle != null ? projectTitle() : this.projectTitle,
      projectDescription: projectDescription != null
          ? projectDescription()
          : this.projectDescription,
      position: position ?? this.position,
      intendedPosition: intendedPosition ?? this.intendedPosition,
      id: id ?? this.id,
      nodeName: nodeName ?? this.nodeName,
      nodeWidth: nodeWidth ?? this.nodeWidth,
      isExpanded: isExpanded ?? this.isExpanded,
      outputs: outputs ?? this.outputs,
      swatch: swatch ?? this.swatch,
      intendedNodeWidth: intendedNodeWidth ?? this.intendedNodeWidth,
      isSelected: isSelected ?? this.isSelected,
      isBeingHovered: isBeingHovered ?? this.isBeingHovered,
    );
  }

  @override
// TODO: implement input
  Input? get input => null;

  @override
  Offset inputPosition(AppTheme theme) {
    return Offset(0, 0) + paddingOffset;
    // TODO: implement inputPosition
    throw UnimplementedError();
  }

  @override
  double nodeHeight(AppTheme theme) {
    return 100;
    // TODO: implement nodeHeight
    throw UnimplementedError();
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
    // TODO: implement outputPosition
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJsonExport() {
    // Initialize an empty map
    Map<String, dynamic> result = {};

    // Add the title and description only if they are not null
    if (projectTitle != null) {
      result['title'] = projectTitle;
    }
    if (projectDescription != null) {
      result['description'] = projectDescription;
    }

    // Return the map, which will only contain non-null key-value pairs
    return result.isNotEmpty ? result : null;
  }

//JsonSerializable encode and decode methods
  factory OriginNodeData.fromJson(Map<String, dynamic> json) =>
      _$OriginNodeDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OriginNodeDataToJson(this);
}
