// Bold and italic in story text (`**bold**`, `*italic*`, `***both***`), read
// the same way by both apps.

/// A stretch of text in one style. Markers are the `*` characters that
/// switch styles on and off: editors show them faintly, players hide them.
class FmvTextRun {
  const FmvTextRun(
    this.text, {
    this.bold = false,
    this.italic = false,
    this.isMarker = false,
  });

  final String text;
  final bool bold;
  final bool italic;
  final bool isMarker;

  @override
  bool operator ==(Object other) =>
      other is FmvTextRun &&
      other.text == text &&
      other.bold == bold &&
      other.italic == italic &&
      other.isMarker == isMarker;

  @override
  int get hashCode => Object.hash(text, bold, italic, isMarker);

  @override
  String toString() {
    final styles = [
      if (bold) 'bold',
      if (italic) 'italic',
      if (isMarker) 'marker',
    ];
    return 'FmvTextRun(${styles.join(' ')} "$text")';
  }
}

/// Part of a run of asterisks: [length] 2 is a bold marker, 1 an italic one.
class _Marker {
  const _Marker(this.start, this.length);

  final int start;
  final int length;
}

bool _isSpace(String c) => c.trim().isEmpty;

/// Splits [text] into styled runs, in order; joining their texts gives
/// [text] back. `**` makes bold, `*` italic and `***` both.
///
/// A marker opens only before non-space text and closes only after it, and
/// markers without a partner stay plain text, so `2 * 3 * 4` and a lone `*`
/// are unchanged. Runs of four or more asterisks are plain text.
List<FmvTextRun> parseInlineMarkdown(String text) {
  final bold = List<bool>.filled(text.length, false);
  final italic = List<bool>.filled(text.length, false);
  final marker = List<bool>.filled(text.length, false);
  // Open markers of each kind (2 or 1), innermost last.
  final open = <int, List<_Marker>>{1: [], 2: []};

  void pair(_Marker opener, _Marker closer) {
    final styled = opener.length == 2 ? bold : italic;
    for (var i = opener.start + opener.length; i < closer.start; i++) {
      styled[i] = true;
    }
    for (final m in [opener, closer]) {
      for (var i = m.start; i < m.start + m.length; i++) {
        marker[i] = true;
      }
    }
  }

  for (var i = 0; i < text.length;) {
    if (text[i] != '*') {
      i++;
      continue;
    }
    var end = i;
    while (end < text.length && text[end] == '*') {
      end++;
    }
    final length = end - i;
    final canOpen = end < text.length && !_isSpace(text[end]);
    final canClose = i > 0 && !_isSpace(text[i - 1]);
    if (length <= 3) {
      final closes = canClose &&
          (length == 3
              ? open[1]!.isNotEmpty || open[2]!.isNotEmpty
              : open[length]!.isNotEmpty);
      // `***` opens bold then italic, and closes italic then bold, so the
      // styles nest.
      final parts = length < 3
          ? [_Marker(i, length)]
          : closes
              ? [_Marker(i, 1), _Marker(i + 1, 2)]
              : [_Marker(i, 2), _Marker(i + 2, 1)];
      for (final part in parts) {
        final stack = open[part.length]!;
        if (closes && stack.isNotEmpty) {
          pair(stack.removeLast(), part);
        } else if (canOpen) {
          stack.add(part);
        }
      }
    }
    i = end;
  }

  // Markers are never styled themselves, so neighbouring ones form one run.
  bool isBold(int i) => bold[i] && !marker[i];
  bool isItalic(int i) => italic[i] && !marker[i];
  final runs = <FmvTextRun>[];
  var start = 0;
  for (var i = 1; i <= text.length; i++) {
    final split = i == text.length ||
        isBold(i) != isBold(start) ||
        isItalic(i) != isItalic(start) ||
        marker[i] != marker[start];
    if (!split) continue;
    runs.add(FmvTextRun(
      text.substring(start, i),
      bold: isBold(start),
      italic: isItalic(start),
      isMarker: marker[start],
    ));
    start = i;
  }
  return runs;
}

/// [text] without its style markers, as a player shows it.
String plainTextOf(String text) => [
      for (final run in parseInlineMarkdown(text))
        if (!run.isMarker) run.text,
    ].join();
