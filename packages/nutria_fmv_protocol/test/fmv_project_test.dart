import 'dart:convert';

import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:test/test.dart';

/// A file as Nutria FMV Maker exports it.
const _exported = r'''
{
  "ProjectInfo": {"title": "Τα 88 Ντολμαδάκια", "description": "Ένα διαδραστικό παραμύθι"},
  "ProjectSettings": {"selectionTime": 6000, "pauseOnEnd": false, "showTimer": true,
                      "videoFit": "fit", "defaultSelection": "first"},
  "Nodes": {
    "001": {"video": "C:\\videos\\a.mp4",
            "choices": [{"option": "Yes", "target": "002"}, {"option": "No", "target": "003"}],
            "overrides": {"showTimer": false}},
    "002": {"video": "C:\\videos\\b.mp4", "target": "003"},
    "003": {"video": "C:\\videos\\c.mp4"}
  }
}
''';

void main() {
  test('reads an exported file', () {
    final project = FmvProject.decode(_exported);
    expect(project.info.title, 'Τα 88 Ντολμαδάκια');
    expect(project.settings.selectionTimeMs, 6000);
    expect(project.startNodeId, '001');

    final first = project.nodes['001']!;
    expect(first.isBranched, isTrue);
    expect(first.choices!.map((c) => (c.text, c.target)),
        [('Yes', '002'), ('No', '003')]);
    expect(first.overrides.showTimer, isFalse);
    expect(project.settings.withOverrides(first.overrides).showTimer, isFalse);

    expect(project.nodes['002']!.target, '003');
    expect(project.nodes['003']!.target, isNull, reason: 'the story ends');
  });

  test('writes back exactly what it read, in the same order', () {
    final original = jsonDecode(_exported);
    final project = FmvProject.decode(_exported);
    expect(project.toJson(), original);
    expect(jsonEncode(project.toJson()), jsonEncode(original),
        reason: 'key order matters: playback starts at the first node');
    expect(FmvProject.decode(project.encode()).toJson(), original);
  });

  test('reads the older spellings of setting values', () {
    final project = FmvProject.fromJson({
      'ProjectSettings': {'videoFit': 'fill width', 'defaultSelection': 'LastSelected'},
      'Nodes': {
        '001': {'video': 'a.mp4', 'overrides': {'videoFit': 'Fit_Height'}},
      },
    });
    expect(project.settings.videoFit, FmvVideoFit.fillWidth);
    expect(project.settings.defaultSelection, FmvDefaultSelection.lastSelected);
    expect(project.nodes['001']!.overrides.videoFit, FmvVideoFit.fitHeight);
    // Written with the enum names.
    expect(project.settings.toJson()['videoFit'], 'fillWidth');
  });

  test('missing or unknown values fall back to the defaults', () {
    final project = FmvProject.fromJson({
      'ProjectSettings': {'videoFit': 'sideways', 'selectionTime': 'soon'},
      'Nodes': <String, Object?>{},
    });
    expect(project.settings.videoFit, FmvVideoFit.fit);
    expect(project.settings.selectionTimeMs, FmvSettings.defaultSelectionTimeMs);
    expect(project.info.title, isNull);
    expect(project.startNodeId, isNull);
  });

  test('text that is not a .fmv project is rejected clearly', () {
    expect(() => FmvProject.decode('not json'),
        throwsA(isA<FmvFormatException>()));
    expect(() => FmvProject.decode('[1, 2]'),
        throwsA(isA<FmvFormatException>()));
    expect(() => FmvProject.decode('{"ProjectInfo": {}}'),
        throwsA(isA<FmvFormatException>()));
  });
}
