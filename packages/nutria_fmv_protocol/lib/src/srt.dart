// SubRip (.srt) subtitles, read leniently, for showing them in both apps.

/// One subtitle: [text] (possibly several lines) shown from [start] to [end].
class FmvSubtitleCue {
  const FmvSubtitleCue({
    required this.start,
    required this.end,
    required this.text,
  });

  final Duration start;
  final Duration end;
  final String text;

  @override
  bool operator ==(Object other) =>
      other is FmvSubtitleCue &&
      other.start == start &&
      other.end == end &&
      other.text == text;

  @override
  int get hashCode => Object.hash(start, end, text);

  @override
  String toString() => 'FmvSubtitleCue($start - $end: $text)';
}

final _timing = RegExp(
  r'(\d+):(\d{1,2}):(\d{1,2})[,.](\d{1,3})\s*-->\s*'
  r'(\d+):(\d{1,2}):(\d{1,2})[,.](\d{1,3})',
);

Duration _time(Match m, int first) {
  int part(int i) => int.parse(m.group(first + i)!);
  final millis = m.group(first + 3)!.padRight(3, '0');
  return Duration(
    hours: part(0),
    minutes: part(1),
    seconds: part(2),
    milliseconds: int.parse(millis),
  );
}

/// The cues of SubRip [source], in file order. Lenient: a missing or wrong
/// cue number, `.` instead of `,` before the milliseconds, Windows or old Mac
/// line endings and a byte order mark are all accepted. Blocks without a
/// timing line are skipped, so text that isn't SubRip gives no cues.
List<FmvSubtitleCue> parseSrt(String source) {
  final text = source
      .replaceFirst('﻿', '')
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n');
  final cues = <FmvSubtitleCue>[];
  for (final block in text.split(RegExp(r'\n\s*\n'))) {
    final lines = block.split('\n');
    final timingLine = lines.indexWhere(_timing.hasMatch);
    if (timingLine == -1) continue;
    final match = _timing.firstMatch(lines[timingLine])!;
    cues.add(FmvSubtitleCue(
      start: _time(match, 1),
      end: _time(match, 5),
      text: lines.sublist(timingLine + 1).join('\n').trim(),
    ));
  }
  return cues;
}

/// When the last of [cues] ends; zero for none.
Duration subtitlesEnd(List<FmvSubtitleCue> cues) => cues.fold(
      Duration.zero,
      (latest, cue) => cue.end > latest ? cue.end : latest,
    );
