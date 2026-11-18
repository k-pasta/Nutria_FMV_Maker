import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/ui/text/markdown_edit.dart';

/// [text] with `[` and `]` marking the selection, toggled, written back the
/// same way.
String toggled(String text, {bool bold = true}) {
  final start = text.indexOf('[');
  final end = text.indexOf(']') - 1;
  final plain = text.replaceAll('[', '').replaceAll(']', '');
  final edit = toggleMarkdown(plain, start, end, bold: bold);
  return edit.text.replaceRange(edit.end, edit.end, ']').replaceRange(
        edit.start,
        edit.start,
        '[',
      );
}

void main() {
  test('wraps the selection, leaving spaces outside', () {
    expect(toggled('go [left] now'), 'go **[left]** now');
    expect(toggled('go[ left ]now', bold: false), 'go *[left]* now');
  });

  test('takes markers away again, from outside or inside the selection', () {
    expect(toggled('go **[left]** now'), 'go [left] now');
    expect(toggled('go [**left**] now'), 'go [left] now');
    expect(toggled('*[x]*', bold: false), '[x]');
  });

  test('bold and italic combine without breaking each other', () {
    // Italic inside bold markers adds its own pair.
    expect(toggled('**[x]**', bold: false), '***[x]***');
    expect(toggled('***[x]***', bold: false), '**[x]**');
    expect(toggled('***[x]***'), '*[x]*');
    // A bold marker isn't mistaken for italic.
    expect(toggled('**[x]**', bold: true), '[x]');
  });

  test('with nothing selected, an empty pair with the cursor inside', () {
    final edit = toggleMarkdown('ab', 1, 1, bold: true);
    expect(edit.text, 'a****b');
    expect((edit.start, edit.end), (3, 3));
  });
}
