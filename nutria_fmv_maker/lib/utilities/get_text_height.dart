import 'package:flutter/material.dart';

double getTextHeight(String text, TextStyle style) {
    //todo allow for multiple lines
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      // maxLines: 1,
    )..layout();

    return textPainter.height;
  }