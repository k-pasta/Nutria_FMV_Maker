import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:test/test.dart';

void main() {
  test('reads cues, with several lines of text', () {
    const source = '﻿1\r\n00:00:01,500 --> 00:00:03,000\r\nHello\r\n\r\n'
        '2\r\n00:01:02,250 --> 00:01:05,000\r\nTwo\r\nlines\r\n';
    expect(parseSrt(source), [
      const FmvSubtitleCue(
        start: Duration(milliseconds: 1500),
        end: Duration(seconds: 3),
        text: 'Hello',
      ),
      const FmvSubtitleCue(
        start: Duration(minutes: 1, seconds: 2, milliseconds: 250),
        end: Duration(minutes: 1, seconds: 5),
        text: 'Two\nlines',
      ),
    ]);
  });

  test('is lenient about numbers, separators and stray text', () {
    const source = 'garbage first\n\n'
        '00:00:01.5 --> 00:00:02.25\nNo number, dots\n\n\n'
        '7\n1:02:03,004 --> 1:02:04,000\nLate\n';
    final cues = parseSrt(source);
    expect(cues, hasLength(2));
    expect(cues[0].start, const Duration(milliseconds: 1500));
    expect(cues[0].end, const Duration(milliseconds: 2250));
    expect(cues[1].start,
        const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4));
    expect(subtitlesEnd(cues),
        const Duration(hours: 1, minutes: 2, seconds: 4));
    expect(parseSrt('not subtitles at all'), isEmpty);
    expect(subtitlesEnd(const []), Duration.zero);
  });
}
