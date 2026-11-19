import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';

import 'harness.dart';

void main() {
  late Harness h;
  NodeGestureNotifier gestures() =>
      h.container.read(nodeGestureProvider.notifier);
  Set<String> selected() => h.container.read(selectionProvider).selected;

  setUp(() async => h = await Harness.create());

  group('tap', () {
    test('plain tap selects only that node and previews its video', () {
      gestures().tap('B', additive: false);
      gestures().tap('C', additive: false);
      expect(selected(), {'C'});
      expect(h.player.opened, [r'C:\videos\b.mp4', r'C:\videos\c.mp4']);
    });

    test('additive tap toggles', () {
      gestures().tap('B', additive: false);
      gestures().tap('C', additive: true);
      expect(selected(), {'B', 'C'});
      gestures().tap('B', additive: true);
      expect(selected(), {'C'});
    });

    test('tapped nodes are drawn on top', () {
      gestures().tap('A', additive: false);
      expect(h.container.read(nodePaintOrderProvider).last, 'A');
    });
  });

  group('move', () {
    test('dragging an unselected node moves only it, as one undo step', () {
      h.container.read(selectionProvider.notifier).selectOnly('C');
      gestures().beginMove('B', additive: false);
      gestures().updateMove(const Offset(10, 0), snap: false);
      gestures().updateMove(const Offset(5, 5), snap: false);
      gestures().end();

      expect(selected(), {'B'});
      expect(h.document.node('B').position, const Position(715, 105));
      expect(h.document.node('C').position, const Position(700, 400));
      expect(h.container.read(historyStatusProvider).undoLabel, 'Move nodes');
      h.container.read(documentProvider.notifier).undo();
      expect(h.document.node('B').position, const Position(700, 100));
    });

    test('dragging a selected node moves the whole selection', () {
      gestures().tap('B', additive: false);
      gestures().tap('C', additive: true);
      gestures().beginMove('B', additive: false);
      gestures().updateMove(const Offset(0, 20), snap: false);
      gestures().end();
      expect(h.document.node('C').position, const Position(700, 420));
    });

    test('snapping lands the visible corner on the grid without drift', () {
      gestures().beginMove('B', additive: false);
      for (var i = 0; i < 4; i++) {
        gestures().updateMove(const Offset(6, 0), snap: true);
      }
      gestures().end();
      // 700 + 24 = 724 → nearest grid line (offset -30, size 50) is 720.
      expect(h.document.node('B').position.x, 720);
    });
  });

  group('resize', () {
    test('from the left keeps the right edge in place', () {
      gestures().beginResize('B', fromLeft: true);
      gestures().updateResize(-100);
      gestures().end();
      final b = h.document.node('B');
      expect(b.width, kDefaultNodeWidth + 100);
      expect(b.position.x + b.width, 700 + kDefaultNodeWidth);
    });

    test('snaps to the default width when close', () {
      gestures().beginResize('B', fromLeft: false);
      gestures().updateResize(60);
      gestures().updateResize(-50);
      gestures().end();
      expect(h.document.node('B').width, kDefaultNodeWidth);
      expect(
        h.container.read(historyStatusProvider).canUndo,
        isFalse,
        reason: 'ended where it started',
      );
    });
  });
}
