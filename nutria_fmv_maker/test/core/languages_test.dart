import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/languages.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';

ProjectDocument _doc({List<String> languages = const []}) =>
    ProjectDocument.empty().copyWith(
      info: ProjectInfo(languages: languages),
      media: const [
        MediaAsset(id: 'v', path: r'C:\m\intro.mp4'),
        MediaAsset(id: 'w', path: r'C:\m\other.mp4'),
        MediaAsset(id: 'el', path: r'C:\m\intro.el.srt'),
        MediaAsset(id: 'en', path: r'C:\m\intro.en.srt'),
      ],
    );

void main() {
  test('languages show in their own name with the code', () {
    expect(languageLabel('el'), 'Ελληνικά (el)');
    expect(languageLabel('xx'), 'xx');
  });

  test('one subtitle file per language; a file links to one place', () {
    var doc = _doc(languages: ['el', 'en'])
        .linkSubtitle('v', 'el', language: 'el')
        .linkSubtitle('v', 'en', language: 'en');
    expect(doc.subtitlesOf('v'), {'el': 'el', 'en': 'en'});

    // Linking the Greek file elsewhere takes it away from here.
    doc = doc.linkSubtitle('w', 'el', language: 'el');
    expect(doc.subtitlesOf('v'), {'en': 'en'});
    expect(doc.subtitlesOf('w'), {'el': 'el'});

    doc = doc.unlinkSubtitle('v', language: 'en');
    expect(doc.subtitlesOf('v'), isEmpty);
  });

  test('links made without a language count as the main language', () {
    final before = _doc().linkSubtitle('v', 'el');
    expect(before.subtitlesOf('v'), {'': 'el'});
    final after = before.copyWith(
      info: const ProjectInfo(languages: ['el', 'en']),
    );
    expect(after.subtitlesOf('v'), {'el': 'el'});
    // Linking the main language replaces it, not adds a second one.
    expect(after.linkSubtitle('v', 'en', language: 'el').subtitlesOf('v'), {
      'el': 'en',
    });
  });

  test('choosing languages pins links without one to the main language', () {
    final doc = _doc().linkSubtitle('v', 'el').setLanguages(['el', 'en']);
    expect(doc.mediaById('v')!.subtitles, {'el': 'el'});
    // Now English becomes main: the Greek link stays Greek.
    final swapped = doc.setLanguages(['en', 'el']);
    expect(swapped.subtitlesOf('v'), {'el': 'el'});
  });
}
