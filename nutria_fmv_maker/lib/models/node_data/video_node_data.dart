import 'dart:ui';

import 'package:nutria_fmv_maker/models/node_data/output.dart';
import 'package:nutria_fmv_maker/utilities/get_text_height.dart';
import '../../static_data/ui_static_properties.dart';
import '../app_theme.dart';
import '../enums_data.dart';
import 'input.dart';
import 'node_data.dart';

abstract class VideoNodeData extends BaseNodeData {
  final String? videoDataId;
  final Map<String, dynamic> overrides;

  const VideoNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    this.videoDataId,
    this.overrides = const <String, dynamic>{},
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
  });
}
