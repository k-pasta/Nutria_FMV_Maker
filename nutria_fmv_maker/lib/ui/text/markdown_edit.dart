// Ctrl+B / Ctrl+I in story text: wrapping a selection in style markers, or
// taking them away again.

/// A text and its selection, from [start] to [end].
typedef TextEdit = ({String text, int start, int end});

/// Makes the selection of [text] from [start] to [end] bold ([bold]) or
/// italic, or plain again if it already is.
///
/// - With nothing selected, inserts an empty pair of markers and puts the
///   cursor between them.
/// - Spaces at the ends of the selection stay outside the markers, since
///   markers next to spaces don't style anything.
/// - A selection right inside markers of that style, or one that includes
///   them, loses them.
TextEdit toggleMarkdown(
  String text,
  int start,
  int end, {
  required bool bold,
}) {
  final marker = bold ? '**' : '*';
  final n = marker.length;
  if (start > end) (start, end) = (end, start);
  if (start == end) {
    return (
      text: text.replaceRange(start, start, '$marker$marker'),
      start: start + n,
      end: start + n,
    );
  }
  while (start < end && text[start].trim().isEmpty) {
    start++;
  }
  while (end > start && text[end - 1].trim().isEmpty) {
    end--;
  }
  if (start == end) return (text: text, start: start, end: end);

  // How many asterisks touch each end, outside and inside the selection.
  int starsBefore(int i) {
    var count = 0;
    while (i - count > 0 && text[i - count - 1] == '*') {
      count++;
    }
    return count;
  }

  int starsAfter(int i) {
    var count = 0;
    while (i + count < text.length && text[i + count] == '*') {
      count++;
    }
    return count;
  }

  // A run of 3 is bold and italic together; 2 is bold; 1 is italic.
  bool hasStyle(int stars) => bold ? stars >= 2 : stars.isOdd;

  final outsideBefore = starsBefore(start);
  final outsideAfter = starsAfter(end);
  if (hasStyle(outsideBefore) && hasStyle(outsideAfter)) {
    final unwrapped = text
        .replaceRange(end, end + n, '')
        .replaceRange(start - n, start, '');
    return (text: unwrapped, start: start - n, end: end - n);
  }
  final insideStart = starsAfter(start);
  final insideEnd = starsBefore(end);
  if (end - start > 2 * n &&
      hasStyle(insideStart) &&
      hasStyle(insideEnd)) {
    final unwrapped = text
        .replaceRange(end - n, end, '')
        .replaceRange(start, start + n, '');
    return (text: unwrapped, start: start, end: end - 2 * n);
  }
  final wrapped = text
      .replaceRange(end, end, marker)
      .replaceRange(start, start, marker);
  return (text: wrapped, start: start + n, end: end + n);
}
