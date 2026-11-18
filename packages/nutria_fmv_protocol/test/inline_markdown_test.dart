import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:test/test.dart';

/// The runs of [text] as `text:styles` strings, e.g. `bold:b`, `**:m`.
List<String> runs(String text) => [
      for (final run in parseInlineMarkdown(text))
        '${run.text}:${run.isMarker ? 'm' : ''}${run.bold ? 'b' : ''}'
            '${run.italic ? 'i' : ''}',
    ];

void main() {
  test('bold, italic and both', () {
    expect(runs('a **b** c'), ['a :', '**:m', 'b:b', '**:m', ' c:']);
    expect(runs('*i*'), ['*:m', 'i:i', '*:m']);
    expect(runs('***x***'), ['***:m', 'x:bi', '***:m']);
    expect(runs('**bold *both* bold**'), [
      '**:m', 'bold :b', '*:m', 'both:bi', '*:m', ' bold:b', '**:m',
    ]);
  });

  test('unpaired or spaced markers stay plain text', () {
    expect(runs('2 * 3 * 4'), ['2 * 3 * 4:']);
    expect(runs('a * b'), ['a * b:']);
    expect(runs('**open'), ['**open:']);
    expect(runs('lone*'), ['lone*:']);
    expect(runs('****'), ['****:']);
    expect(runs(''), isEmpty);
  });

  test('the runs give the text back; players show it without markers', () {
    const text = 'Go **left** or *right*?';
    expect(parseInlineMarkdown(text).map((r) => r.text).join(), text);
    expect(plainTextOf(text), 'Go left or right?');
    expect(plainTextOf('2 * 3'), '2 * 3');
  });
}
