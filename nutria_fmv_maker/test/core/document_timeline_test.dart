import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/history/document_timeline.dart';

import 'fixtures.dart';

void main() {
  ProjectDocument moveB(ProjectDocument d, double x) =>
      d.moveNodes({'B': Position(x, 0)});

  test('apply records an undo step and undo/redo restore documents', () {
    final start = storyFixture();
    var timeline = DocumentTimeline.start(start)
        .apply('Move', (d) => moveB(d, 1))
        .apply('Move', (d) => moveB(d, 2));

    expect(timeline.undoStack, hasLength(2));
    timeline = timeline.undo();
    expect(timeline.current.node('B').position, const Position(1, 0));
    timeline = timeline.undo();
    expect(timeline.current, same(start));
    expect(timeline.canUndo, isFalse);

    timeline = timeline.redo().redo();
    expect(timeline.current.node('B').position, const Position(2, 0));
  });

  test('a new edit clears the redo stack', () {
    final timeline = DocumentTimeline.start(storyFixture())
        .apply('Move', (d) => moveB(d, 1))
        .undo()
        .apply('Move', (d) => moveB(d, 5));
    expect(timeline.canRedo, isFalse);
  });

  test('edits that change nothing are not recorded', () {
    final timeline =
        DocumentTimeline.start(storyFixture()).apply('No-op', (d) => d);
    expect(timeline.canUndo, isFalse);
  });

  test('a transaction coalesces many edits into one undo step', () {
    final start = storyFixture();
    var timeline = DocumentTimeline.start(start).beginTransaction('Drag');
    for (var x = 1.0; x <= 30; x++) {
      timeline = timeline.apply('ignored', (d) => moveB(d, x));
    }
    expect(timeline.canUndo, isFalse, reason: 'undo is blocked mid-gesture');
    timeline = timeline.commit();

    expect(timeline.undoStack, hasLength(1));
    expect(timeline.undoLabel, 'Drag');
    expect(timeline.undo().current, same(start));
  });

  test('cancelling a transaction restores the starting document', () {
    final start = storyFixture();
    final timeline = DocumentTimeline.start(start)
        .beginTransaction('Drag')
        .apply('x', (d) => moveB(d, 9))
        .cancel();
    expect(timeline.current, same(start));
    expect(timeline.canUndo, isFalse);
  });

  test('a transaction that ends where it started records nothing', () {
    final timeline = DocumentTimeline.start(storyFixture())
        .beginTransaction('Drag')
        .apply('x', (d) => moveB(d, 9))
        .apply('x', (d) => moveB(d, 700)) // B's original x
        .apply('x', (d) => d.moveNodes({'B': const Position(700, 100)}))
        .commit();
    expect(timeline.canUndo, isFalse);
  });

  test('history is capped', () {
    var timeline = DocumentTimeline.start(storyFixture(), capacity: 3);
    for (var x = 1.0; x <= 10; x++) {
      timeline = timeline.apply('Move', (d) => moveB(d, x));
    }
    expect(timeline.undoStack, hasLength(3));
  });

  group('merge keys', () {
    test('consecutive edits with the same key are one undo step', () {
      final start = storyFixture();
      var timeline = DocumentTimeline.start(start);
      for (var x = 1.0; x <= 5; x++) {
        timeline = timeline.apply('Type', (d) => moveB(d, x), mergeKey: 'k');
      }
      expect(timeline.undoStack, hasLength(1));
      expect(timeline.undo().current, same(start));
    });

    test('a different key or an undo starts a new step', () {
      var timeline = DocumentTimeline.start(storyFixture())
          .apply('Type', (d) => moveB(d, 1), mergeKey: 'a')
          .apply('Type', (d) => moveB(d, 2), mergeKey: 'b');
      expect(timeline.undoStack, hasLength(2));

      timeline = timeline
          .undo()
          .apply('Type', (d) => moveB(d, 3), mergeKey: 'a');
      expect(timeline.undoStack, hasLength(2));
    });
  });
}
