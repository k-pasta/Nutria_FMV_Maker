import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/fragment.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';

import 'fixtures.dart';

void main() {
  final story = storyFixture()
      .putNode(const CommentNode(id: 'c', position: Position(0, -300)))
      .putNode(const CommentNode(id: 'd', position: Position(0, -500)));

  test('a comment attaches to a node that has none, not to a comment', () {
    final attached = story.attachComment('c', 'A');
    expect((attached.node('c') as CommentNode).attachedTo, 'A');
    expect(attached.commentOf('A')?.id, 'c');
    expect(
      attached.attachComment('d', 'A'),
      same(attached),
      reason: 'one comment per node',
    );
    expect(story.attachComment('c', 'd'), same(story));
    expect(story.attachComment('A', 'B'), same(story), reason: 'not a comment');

    final detached = attached.detachComment('c', const Position(5, 6), 300);
    final comment = detached.node('c') as CommentNode;
    expect(comment.attachedTo, isNull);
    expect(comment.position, const Position(5, 6));
    expect(comment.width, 300);
  });

  test('deleting a node deletes its comment', () {
    final doc = story.attachComment('c', 'A').removeNodes(['A']);
    expect(doc.nodes.containsKey('c'), isFalse);
    expect(doc.nodes.containsKey('d'), isTrue);
  });

  test('copying a node brings its comment; pasting attaches the copy', () {
    final doc = story.attachComment('c', 'A');
    final fragment = doc.copyFragment(['A']);
    expect(fragment.nodes.map((n) => n.id), unorderedEquals(['A', 'c']));
    final (pasted, ids) = doc.pasteFragment(
      fragment,
      offset: const Position(10, 10),
      newId: sequentialIds('p'),
    );
    final newNode = ids.firstWhere((id) => pasted.node(id) is! CommentNode);
    final newComment =
        pasted.node(ids.firstWhere((id) => pasted.node(id) is CommentNode))
            as CommentNode;
    expect(newComment.attachedTo, newNode);

    // A comment copied without its node stands on its own.
    final alone = doc.copyFragment(['c']).nodes.single as CommentNode;
    expect(alone.attachedTo, isNull);
  });

  test('comments are saved but never exported', () {
    final doc = story
        .attachComment('c', 'A')
        .setCommentText('c', 'Remember **this**');
    expect(NfmvCodec.decode(NfmvCodec.encode(doc)), doc);
    expect(
      exportFmv(doc).project.nodes.length,
      exportFmv(storyFixture()).project.nodes.length,
    );
  });
}
