import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';

import 'fixtures.dart';

void main() {
  group('exportFmv', () {
    test('matches the golden .fmv shared with the Player', () {
      final golden = jsonDecode(
        File('test/core/golden/story_export.fmv').readAsStringSync(),
      );
      final export = exportFmv(storyFixture());
      // Round-trip through JSON so we compare exactly what gets written.
      expect(jsonDecode(jsonEncode(export.json)), golden);
    });

    test('reports unconnected choices with text', () {
      final export = exportFmv(storyFixture());
      expect(export.issues, [
        (type: ExportIssueType.unconnectedChoice, nodeId: 'A'),
      ]);
    });

    test('reports reachable video nodes without a video', () {
      final doc = storyFixture().copyWith(videos: const []);
      final missing = exportFmv(doc)
          .issues
          .where((i) => i.type == ExportIssueType.missingVideo)
          .map((i) => i.nodeId);
      expect(missing, unorderedEquals(['A', 'B', 'C']));
    });

    test('an empty project exports no nodes', () {
      final export = exportFmv(ProjectDocument.empty());
      expect(export.json['Nodes'], isEmpty);
      expect(export.json['ProjectInfo'], isEmpty);
    });
  });
}
