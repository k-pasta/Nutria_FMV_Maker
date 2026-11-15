// Single-style text in the app's font, sized and colored from the theme.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// Which theme color the text uses.
enum NutriaTextState { normal, accented, inactive }

enum NutriaTextStyle { normal, bold, italic, boldItalic }

/// Text in the app's font, colored from the theme. Ellipsizes past [maxLines].
class NutriaText extends StatelessWidget {
  const NutriaText({
    required this.text,
    this.state = NutriaTextState.normal,
    this.textStyle = NutriaTextStyle.normal,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    this.sizeMultiplier = 1.0,
    super.key,
  });

  final String text;
  final NutriaTextState state;
  final NutriaTextStyle textStyle;
  final int maxLines;
  final TextAlign textAlign;

  /// Scales the theme's base text size.
  final double sizeMultiplier;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final bold = textStyle == NutriaTextStyle.bold ||
        textStyle == NutriaTextStyle.boldItalic;
    final italic = textStyle == NutriaTextStyle.italic ||
        textStyle == NutriaTextStyle.boldItalic;
    return Text(
      text,
      textAlign: textAlign,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(
        height: 1.0,
        color: switch (state) {
          NutriaTextState.accented => theme.cTextActive,
          NutriaTextState.inactive => theme.cTextInactive,
          NutriaTextState.normal => theme.cText,
        },
        fontSize: theme.dTextHeight * sizeMultiplier,
        fontFamily: 'SourceSans',
        fontVariations: [FontVariation('wght', bold ? 700 : 100)],
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }
}
