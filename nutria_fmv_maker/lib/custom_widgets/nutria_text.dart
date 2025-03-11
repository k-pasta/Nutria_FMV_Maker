import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../models/enums_ui.dart';
import '../providers/theme_provider.dart';

class NutriaText extends StatelessWidget {
  final String text;
  final NutriaTextState state;
  final NutriaTextStyle textStyle;
  final int maxLines;
  final TextAlign textAlign;
  const NutriaText(
      {required this.text,
      this.state = NutriaTextState.normal,
      this.textStyle = NutriaTextStyle.normal,
      this.maxLines = 1,
      this.textAlign = TextAlign.left,
      super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        height: 1.0,
        color: theme.cText,
        fontSize: theme.dTextHeight,
        fontFamily: 'SourceSans', // Ensure the correct family is used
        fontVariations: textStyle == NutriaTextStyle.boldItalic
            ? [FontVariation('wght', 700)]
            : textStyle == NutriaTextStyle.bold
                ? [FontVariation('wght', 700)]
                : [FontVariation('wght', 100)],
        fontStyle: textStyle == NutriaTextStyle.italic ||
                textStyle == NutriaTextStyle.boldItalic
            ? FontStyle.italic
            : FontStyle.normal,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
