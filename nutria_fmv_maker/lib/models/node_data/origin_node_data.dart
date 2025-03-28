
import 'dart:ui';

import 'package:nutria_fmv_maker/models/node_data/output.dart';
import '../../static_data/ui_static_properties.dart';
import '../app_theme.dart';
import 'input.dart';
import 'node_data.dart';

class OriginNodeData extends BaseNodeData {
  const OriginNodeData({
    required super.position,
    super.intendedPosition,
    required super.id,
    super.outputs,
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
      {Offset? position,
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
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  Offset inputPosition(AppTheme theme) {
    // TODO: implement inputPosition
    throw UnimplementedError();
  }

  @override
  double nodeHeight(AppTheme theme) {
    // TODO: implement nodeHeight
    throw UnimplementedError();
  }

  @override
  Offset outputPosition(AppTheme theme, int index) {
    // TODO: implement outputPosition
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJsonExport() {
    // TODO: implement toJsonExport
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJsonSave() {
    // TODO: implement toJsonSave
    throw UnimplementedError();
  }
}