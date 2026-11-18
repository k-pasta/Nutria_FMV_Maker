import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';

import 'fixtures.dart';

void main() {
  test('a color gets its own defaults, a copy of the first color', () {
    final doc = storyFixture().copyWith(
      settings: const VideoSettings(selectionTimeMs: 3000),
    );
    expect(doc.nextColorWithoutDefaults, 1);
    final added = doc.addColorDefaults(1);
    expect(added.colorDefaults[1]!.selectionTimeMs, 3000);
    expect(added.nextColorWithoutDefaults, 2);
    expect(added.defaultsFor(1), same(added.colorDefaults[1]));
    expect(
      added.defaultsFor(4),
      same(added.settings),
      reason: 'colors without their own use the first',
    );

    // Editing one color's defaults leaves the first color's alone.
    final edited = added.editDefaults(
      1,
      (s) => s.copyWith(selectionTimeMs: 9000),
    );
    expect(edited.defaultsFor(1).selectionTimeMs, 9000);
    expect(edited.settings.selectionTimeMs, 3000);
    expect(
      edited
          .editDefaults(3, (s) => s.copyWith(showTimer: false))
          .settings
          .showTimer,
      isFalse,
      reason: 'a color without its own edits the first',
    );

    expect(edited.removeColorDefaults(1).colorDefaults, isEmpty);
  });

  test('only colors 2 to 6 can have their own defaults', () {
    var doc = storyFixture();
    expect(doc.addColorDefaults(0), same(doc));
    expect(doc.addColorDefaults(kMaxColorDefaults + 1), same(doc));
    for (var i = 1; i <= kMaxColorDefaults; i++) {
      doc = doc.addColorDefaults(i);
    }
    expect(doc.nextColorWithoutDefaults, isNull);
  });

  test('a node exports its color defaults as overrides; its own win', () {
    final base = storyFixture();
    final a = base.node('A');
    final doc = base
        .addColorDefaults(2)
        .editDefaults(
          2,
          (s) => s.copyWith(
            selectionTimeMs: 1500,
            videoFit: VideoFit.stretch,
            showTimer: base.settings.showTimer,
          ),
        )
        .setSwatch('A', 2)
        .updateNode(
          'A',
          (n) => (n as BranchedVideoNode).copyWith(
            overrides: n.overrides.copyWith(
              selectionTimeMs: 4000,
              videoFit: null,
            ),
          ),
        );
    expect(a.swatch, isNot(2));

    final exported = exportFmv(doc).project.nodes['001']!.overrides;
    expect(exported.selectionTimeMs, 4000, reason: 'the node overrides it');
    expect(exported.videoFit?.name, 'stretch', reason: 'from color 3');
    expect(
      exported.showTimer,
      a.overridesOrNull!.showTimer,
      reason: 'same as the project: nothing added',
    );
  });

  test('color defaults are saved; older files without them load', () {
    final doc = storyFixture()
        .addColorDefaults(3)
        .editDefaults(3, (s) => s.copyWith(pauseOnEnd: true));
    final read = NfmvCodec.decode(NfmvCodec.encode(doc));
    expect(read.colorDefaults[3]!.pauseOnEnd, isTrue);
    expect(read, doc);

    final json = jsonDecode(NfmvCodec.encode(storyFixture())) as Map;
    json.remove('colorDefaults');
    expect(NfmvCodec.decode(jsonEncode(json)).colorDefaults, isEmpty);
  });
}
