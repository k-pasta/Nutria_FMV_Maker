// Story text with bold and italic shown: in text fields (markers visible but
// faint) and in plain display (markers hidden).
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// [text] as styled spans on top of [style]. With [markerColor] the `*`
/// markers are kept, in that color (for editing, so the text and the
/// cursor positions stay the same); without it they are left out.
TextSpan markdownSpan(String text, TextStyle style, {Color? markerColor}) =>
    TextSpan(
      style: style,
      children: [
        for (final run in parseInlineMarkdown(text))
          if (!run.isMarker)
            TextSpan(
              text: run.text,
              style: TextStyle(
                fontWeight: run.bold ? FontWeight.bold : null,
                fontStyle: run.italic ? FontStyle.italic : null,
              ),
            )
          else if (markerColor != null)
            TextSpan(
              text: run.text,
              style: TextStyle(color: markerColor),
            ),
      ],
    );

/// A text field controller that shows bold and italic while typing, with
/// the markers in the theme's inactive text color.
class MarkdownTextEditingController extends TextEditingController {
  MarkdownTextEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // While an input method composes text, keep its own underlining.
    final composing = value.composing;
    if (withComposing && composing.isValid && !composing.isCollapsed) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    return markdownSpan(
      text,
      style ?? const TextStyle(),
      markerColor: context.appTheme.cTextInactive,
    );
  }
}
