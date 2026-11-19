// Logic node expressions while typing: coloured tokens, the mistake
// underlined, `*` shown as `×`, and the variable name Tab would complete
// shown faintly after the cursor.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// The name of [names] that the word ending at [cursor] in [text] starts,
/// as `(start of the word, the name)`, or `null` if there's none (or the
/// word already is a whole name).
(int, String)? completionAt(String text, int cursor, Iterable<String> names) {
  if (cursor < 0 || cursor > text.length) return null;
  var start = cursor;
  bool isNameChar(String c) =>
      RegExp(r'[\p{L}\p{N}_-]', unicode: true).hasMatch(c);
  while (start > 0 && isNameChar(text[start - 1])) {
    start--;
  }
  final word = text.substring(start, cursor);
  if (word.isEmpty || !RegExp(r'^\p{L}', unicode: true).hasMatch(word)) {
    return null;
  }
  final lower = word.toLowerCase();
  final candidates = [
    for (final name in names)
      if (name.toLowerCase().startsWith(lower) && name.length > word.length)
        name,
  ]..sort((a, b) => a.length.compareTo(b.length));
  return candidates.isEmpty ? null : (start, candidates.first);
}

/// A controller for expression fields. [types] are the variables, by name.
class ExpressionTextEditingController extends TextEditingController {
  ExpressionTextEditingController({super.text, this.types = const {}});

  Map<String, FmvValueType> types;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final composing = value.composing;
    if (withComposing && composing.isValid && !composing.isCollapsed) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    final theme = context.appTheme;
    final source = text;
    final parsed = FmvExpression.parse(source, types);
    final error = source.trim().isEmpty ? null : parsed.error;
    final colors = List<Color?>.filled(source.length, null);
    final bold = List<bool>.filled(source.length, false);
    for (final token in parsed.tokens) {
      for (var i = token.start; i < token.end; i++) {
        colors[i] = switch (token.kind) {
          FmvTokenKind.variable => theme.cTextActive,
          FmvTokenKind.operator || FmvTokenKind.paren => theme.cTextInactive,
          FmvTokenKind.unknown => theme.cAccent,
          FmvTokenKind.number || FmvTokenKind.boolean => null,
        };
        bold[i] = token.kind == FmvTokenKind.variable;
      }
    }
    bool underlined(int i) =>
        error != null &&
        (error.start == error.end
            ? i == source.length - 1
            : i >= error.start && i < error.end);

    final children = <InlineSpan>[];
    var start = 0;
    for (var i = 1; i <= source.length; i++) {
      final split =
          i == source.length ||
          colors[i] != colors[start] ||
          bold[i] != bold[start] ||
          underlined(i) != underlined(start);
      if (!split) continue;
      children.add(
        TextSpan(
          // Same length, so the cursor stays where it is.
          text: source.substring(start, i).replaceAll('*', '×'),
          style: TextStyle(
            color: colors[start],
            fontWeight: bold[start] ? FontWeight.bold : null,
            decoration: underlined(start) ? TextDecoration.underline : null,
            decorationStyle: TextDecorationStyle.wavy,
            decorationColor: theme.cAccent,
          ),
        ),
      );
      start = i;
    }
    // What Tab would add, faintly after the cursor (only at the end, so
    // every cursor position still maps to the typed text).
    final cursor = selection.isCollapsed ? selection.baseOffset : -1;
    if (cursor == source.length) {
      final completion = completionAt(source, cursor, types.keys);
      if (completion != null) {
        final (wordStart, name) = completion;
        children.add(
          TextSpan(
            text: name.substring(cursor - wordStart),
            style: TextStyle(color: theme.cTextInactive.withValues(alpha: 0.5)),
          ),
        );
      }
    }
    return TextSpan(style: style, children: children);
  }

  /// Completes the variable name being typed at the cursor; returns whether
  /// it did.
  bool complete() {
    final cursor = selection.isCollapsed ? selection.baseOffset : -1;
    final completion = completionAt(text, cursor, types.keys);
    if (completion == null) return false;
    final (start, name) = completion;
    value = TextEditingValue(
      text: text.replaceRange(start, cursor, name),
      selection: TextSelection.collapsed(offset: start + name.length),
    );
    return true;
  }
}
