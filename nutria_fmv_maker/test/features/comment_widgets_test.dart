import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField;
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/comment_frame.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';

import 'app_tester.dart';

CommentNode? _comment(ProviderContainer c) => c
    .read(projectDocumentProvider)
    .nodes
    .values
    .whereType<CommentNode>()
    .firstOrNull;

Future<void> _drag(WidgetTester tester, Offset from, Offset to) async {
  final gesture = await tester.startGesture(
    from,
    kind: PointerDeviceKind.mouse,
  );
  for (var i = 1; i <= 10; i++) {
    await gesture.moveTo(Offset.lerp(from, to, i / 10)!);
    await tester.pump();
  }
  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a comment from the canvas menu is edited in place and shows '
      'its formatting', (tester) async {
    final c = await pumpApp(tester);
    await rightClickAt(tester, kCanvasPoint);
    await tester.tap(find.text('Comment'));
    await tester.pumpAndSettle();
    final field = find.descendant(
      of: find.byType(CommentFrame),
      matching: find.byType(TextField),
    );
    expect(field, findsOneWidget);
    await tester.enterText(field, 'Fix the **door** scene');
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(_comment(c)!.text, 'Fix the **door** scene');
    expect(field, findsNothing);
    expect(
      find.text('Fix the door scene'),
      findsOneWidget,
      reason: 'shown without the markers',
    );

    // Typing was one undo step, and the comment is another.
    c.read(documentProvider.notifier).undo();
    expect(_comment(c)!.text, '');
  });

  testWidgets('dropping a comment on a node attaches it; it follows the node '
      'and comes off when dragged away', (tester) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final node = editor.addVideoNode(
      const Position(-100, 0),
      type: DefaultNodeType.simpleVideo,
    );
    editor.addComment(const Position(-450, -300));
    editor.setCommentText(_comment(c)!.id, 'Note');
    await tester.pumpAndSettle();

    await _drag(
      tester,
      tester.getCenter(find.text('Note')),
      tester.getCenter(find.text(kNoVideo)),
    );
    expect(_comment(c)!.attachedTo, node);
    // Right above the node, as wide as it.
    final commentRect = tester.getRect(find.byType(CommentFrame));
    final nodeRect = tester.getRect(find.text(kNoVideo));
    expect(commentRect.bottom, lessThan(nodeRect.top));
    expect(commentRect.width, moreOrLessEquals(230 + 60));

    // Moving the node moves the comment just as far (the drag threshold
    // eats the first few pixels of both).
    final before = tester.getTopLeft(find.text('Note'));
    final nodeBefore = tester.getTopLeft(find.text(kNoVideo));
    await _drag(
      tester,
      tester.getCenter(find.text(kNoVideo)),
      tester.getCenter(find.text(kNoVideo)) + const Offset(80, 40),
    );
    final moved = tester.getTopLeft(find.text(kNoVideo)) - nodeBefore;
    expect(moved.dx, greaterThan(50));
    expect(
      tester.getTopLeft(find.text('Note')) - before,
      offsetMoreOrLessEquals(moved, epsilon: 0.5),
    );

    // Dragging the comment away takes it off.
    await _drag(
      tester,
      tester.getCenter(find.text('Note')),
      tester.getCenter(find.text('Note')) + const Offset(-300, -200),
    );
    expect(_comment(c)!.attachedTo, isNull);
    expect(
      tester.getTopLeft(find.text(kNoVideo)) - nodeBefore,
      offsetMoreOrLessEquals(moved, epsilon: 0.5),
      reason: 'the node stayed',
    );
  });

  testWidgets('the node menu adds an attached comment', (tester) async {
    final c = await pumpApp(tester);
    final node = c
        .read(graphEditorProvider)
        .addVideoNode(
          const Position(-100, 0),
          type: DefaultNodeType.simpleVideo,
        );
    await tester.pumpAndSettle();
    await rightClickAt(tester, tester.getCenter(find.text(kNoVideo)));
    await tester.tap(find.text('Add Comment'));
    await tester.pumpAndSettle();
    expect(_comment(c)!.attachedTo, node);
    await rightClickAt(tester, tester.getCenter(find.text(kNoVideo)));
    expect(find.text('Add Comment'), findsNothing, reason: 'one per node');
  });
}
