import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import '../models/app_theme.dart';
import '../models/node_data.dart';

class InputOutputOffsetCalculator {

static double _getTextHeight(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    // maxLines: 1,
  )..layout();

  return textPainter.height;
}

static Offset get _paddingOffset {
  return const Offset(UiStaticProperties.nodePadding, UiStaticProperties.nodePadding);
}

static Offset inputOffset(BaseNodeData nodeData, AppTheme theme) {
  double x = 0;
  double y = theme.dSwatchHeight +
      (nodeData.nodeName != null
          ? _getTextHeight(nodeData.nodeName!, theme.swatchTextStyle)
          : 0) +
      (UiStaticProperties.nodeDefaultWidth * 9 / 16);
  return Offset(x, y) + _paddingOffset;
}

static Offset outputOffset(VideoNodeData nodeData, AppTheme theme, int index) {
  double x = nodeData.nodeWidth;
  double baseY = theme.dSwatchHeight +
      (nodeData.nodeName != null
          ? _getTextHeight(nodeData.nodeName!, theme.swatchTextStyle)
          : 0) +
      (UiStaticProperties.nodeDefaultWidth * 9 / 16) +
      _getTextHeight(nodeData.videoDataId, theme.filenameTextStyle) +
      (theme.dPanelPadding * 2) +
      (theme.dButtonHeight / 2);
  double extraY = index * (theme.dButtonHeight + theme.dPanelPadding);
  return Offset(x, baseY + extraY) + _paddingOffset;
}
}
