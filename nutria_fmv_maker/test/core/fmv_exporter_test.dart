import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

import 'fixtures.dart';

void main() {
  group('exportFmv', () {
    test('matches the golden .fmv shared with the Player', () {
      final golden = jsonDecode(
        File('test/core/golden/story_export.fmv').readAsStringSync(),
      );
      final export = exportFmv(storyFixture());
      // Round-trip through JSON so we compare exactly what gets written.
      expect(jsonDecode(jsonEncode(export.project.toJson())), golden);
    });

    test('reads back unchanged through the shared protocol package', () {
      // What the Player reads: the written text, parsed by the package.
      final written = exportFmv(storyFixture()).project.encode();
      final read = FmvProject.decode(written);
      expect(read.encode(), written);
      expect(read.startNodeId, '001');
      expect(read.nodes['001']!.choices!.map((c) => c.target), ['002', '003']);
    });

    test('reports unconnected choices with text', () {
      final export = exportFmv(storyFixture());
      expect(export.issues, [
        (type: ExportIssueType.unconnectedChoice, nodeId: 'A'),
      ]);
    });

    test('reports reachable video nodes without a video', () {
      final doc = storyFixture().copyWith(media: const []);
      final missing = exportFmv(doc).issues
          .where((i) => i.type == ExportIssueType.missingVideo)
          .map((i) => i.nodeId);
      expect(missing, unorderedEquals(['A', 'B', 'C']));
    });

    test('a question with a single answer warns unless allowed', () {
      var doc = ProjectDocument.empty()
          .putNode(
            newBranchedVideoNode(
              id: 'N',
              position: Position.zero,
              newId: sequentialIds('c'),
            ),
          )
          .putNode(const SimpleVideoNode(id: 'T', position: Position.zero));
      final only = (doc.node('N') as BranchedVideoNode).choices.first;
      doc = doc
          .connect(
            PortRef(nodeId: doc.origin.id, port: kNextPortKey),
            PortRef.input('N'),
          )
          .connect(PortRef(nodeId: 'N', port: only.id), PortRef.input('T'));
      bool warns(FmvExport e) =>
          e.issues.any((i) => i.type == ExportIssueType.singleChoice);
      expect(warns(exportFmv(doc)), isTrue);
      expect(warns(exportFmv(doc, allowSingleChoice: true)), isFalse);
    });

    test('an empty project exports no nodes', () {
      final export = exportFmv(ProjectDocument.empty());
      expect(export.project.toJson()['Nodes'], isEmpty);
      expect(export.project.toJson()['ProjectInfo'], isEmpty);
    });
  });
}
