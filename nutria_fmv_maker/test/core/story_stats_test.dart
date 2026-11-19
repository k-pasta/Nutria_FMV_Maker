import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/core/graph/story_stats.dart';

/// origin → A (10s) → branch: B (5s, end) or C (20s, end); D unconnected.
ProjectDocument _story() {
  var doc = ProjectDocument.empty().copyWith(
    media: const [
      MediaAsset(id: 'a', path: 'a.mp4'),
      MediaAsset(id: 'b', path: 'b.mp4'),
      MediaAsset(id: 'c', path: 'c.mp4'),
      MediaAsset(id: 'd', path: 'd.mp4'),
      MediaAsset(id: 'song', path: 'song.mp3'),
    ],
  );
  doc = doc
      .putNode(
        const BranchedVideoNode(
          id: 'A',
          position: Position.zero,
          videoId: 'a',
          choices: [
            Choice(id: 'x'),
            Choice(id: 'y'),
          ],
          pauseMusicId: 'song',
        ),
      )
      .putNode(
        const SimpleVideoNode(id: 'B', position: Position.zero, videoId: 'b'),
      )
      .putNode(
        const SimpleVideoNode(id: 'C', position: Position.zero, videoId: 'c'),
      )
      .putNode(
        const SimpleVideoNode(id: 'D', position: Position.zero, videoId: 'd'),
      );
  return doc
      .connect(
        PortRef(nodeId: doc.origin.id, port: kNextPortKey),
        PortRef.input('A'),
      )
      .connect(const PortRef(nodeId: 'A', port: 'x'), PortRef.input('B'))
      .connect(const PortRef(nodeId: 'A', port: 'y'), PortRef.input('C'));
}

const _lengths = {
  'a': Duration(seconds: 10),
  'b': Duration(seconds: 5),
  'c': Duration(seconds: 20),
  'd': Duration(seconds: 99),
};

void main() {
  test('files used: reachable nodes only, with their music', () {
    expect(usedMediaIds(_story()), {'a', 'b', 'c', 'song'});
  });

  test('the shortest and longest ways through', () {
    final length = storyLength(_story(), (id) => _lengths[id]);
    expect(length.shortest, const Duration(seconds: 15));
    expect(length.longest, const Duration(seconds: 30));
    expect(length.hasLoops, isFalse);
    expect(length.unknown, 0);
  });

  test('a loop leaves the longest open; unknown lengths are counted', () {
    final looped = _story().connect(
      const PortRef(nodeId: 'C', port: kNextPortKey),
      PortRef.input('A'),
    );
    final length = storyLength(looped, (id) => id == 'b' ? null : _lengths[id]);
    expect(length.hasLoops, isTrue);
    expect(length.longest, isNull);
    expect(length.shortest, const Duration(seconds: 10), reason: 'A then B');
    expect(length.unknown, 1);
  });
}
