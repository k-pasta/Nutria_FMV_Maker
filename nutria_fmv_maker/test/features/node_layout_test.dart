import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';

const metrics = NodeMetrics(
  swatchHeight: 10,
  textHeight: 14,
  panelPadding: 5,
  rowHeight: 25,
);

void main() {
  const branched = BranchedVideoNode(
    id: 'b',
    position: Position.zero,
    width: 300,
    choices: [
      Choice(id: 'c1'),
      Choice(id: 'c2'),
      Choice(id: 'c3'),
    ],
  );

  test('the input sits on the left edge, at the bottom of the thumbnail', () {
    final layout = NodeLayout(branched, metrics);
    expect(layout.input, Offset(30, 30 + 10 + metrics.thumbnailHeight));
  });

  test('choice knots are on the right edge, one row apart', () {
    final layout = NodeLayout(branched, metrics);
    final first = layout.output('c1')!;
    final second = layout.output('c2')!;
    expect(first.dx, 30 + 300);
    expect(second.dy - first.dy, 25 + 5);
    // Below the thumbnail, the file name row and the list padding.
    expect(
      first.dy,
      layout.input!.dy + metrics.fileNameRowHeight(null, 300) + 5 + 25 / 2,
    );
    expect(layout.output('missing'), isNull);
  });

  test('a long file name wraps and moves the choice knots down', () {
    final short = NodeLayout(branched, metrics, fileName: 'a.mp4');
    final long = NodeLayout(
      branched,
      metrics,
      fileName: 'Recording 2026-04-01 12-54-49 final final v2.mp4',
    );
    final lines = metrics.fileNameHeight('a.mp4', 300);
    expect(
      metrics.fileNameHeight(long.fileName, 300),
      greaterThan(lines * 1.5),
    );
    expect(long.output('c1')!.dy, greaterThan(short.output('c1')!.dy));
    // The input stays at the bottom of the thumbnail.
    expect(long.input, short.input);
  });

  test('file names wrap onto at most three lines', () {
    final one = metrics.fileNameHeight('a', 300);
    final huge = metrics.fileNameHeight('x' * 500, 300);
    expect(huge, moreOrLessEquals(one * kFileNameMaxLines, epsilon: 1));
  });

  test('a node name makes the strip taller and moves every knot down', () {
    final named = NodeLayout(branched.copyWith(name: 'Intro'), metrics);
    final plain = NodeLayout(branched, metrics);
    expect(named.input!.dy - plain.input!.dy, 14);
    expect(named.output('c3')!.dy - plain.output('c3')!.dy, 14);
  });

  test('knots lists the input, then every output port in order', () {
    final layout = NodeLayout(branched, metrics);
    expect(
      [for (final k in layout.knots) k.port],
      [
        PortRef.input('b'),
        for (final port in outputPortsOf(branched))
          PortRef(nodeId: 'b', port: port),
      ],
    );
  });

  test('the origin has no input and its output beside the preview', () {
    const origin = OriginNode(id: 'o', position: Position.zero);
    final layout = NodeLayout(origin, metrics);
    expect(layout.input, isNull);
    // The origin's strip always shows a name ("Origin Node" by default).
    expect(
      layout.output(kNextPortKey),
      Offset(30 + kDefaultNodeWidth, 30 + 10 + 14 + metrics.thumbnailHeight),
    );
  });

  test('a question takes the first row; the choice knots move down a row', () {
    final plain = NodeLayout(branched, metrics);
    final asking = NodeLayout(branched, metrics, showsQuestion: true);
    final port = branched.choices.first.id;
    expect(
      asking.output(port)!.dy - plain.output(port)!.dy,
      metrics.choiceStride,
    );
    expect(asking.input, plain.input, reason: 'the input stays put');
  });

  test('a branched node shows an empty row to type into until the maximum', () {
    expect(NodeLayout.choiceRowCount(branched), 4);
    final full = branched.copyWith(
      choices: [for (var i = 0; i < kMaxChoices; i++) Choice(id: '$i')],
    );
    expect(NodeLayout.choiceRowCount(full), kMaxChoices);
  });
}
