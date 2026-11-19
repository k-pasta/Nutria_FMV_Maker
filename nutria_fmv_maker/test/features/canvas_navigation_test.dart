import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show MatrixUtils;
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/canvas_view.dart';
import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';

import 'app_tester.dart';

/// Where canvas position [point] is on screen.
Offset screenPoint(WidgetTester tester, ProviderContainer c, Offset point) =>
    tester.getTopLeft(find.byType(CanvasView)) +
    MatrixUtils.transformPoint(
      c.read(canvasViewProvider).value,
      point + kCanvasCenter,
    );

Set<String> selected(ProviderContainer c) => c.read(selectionProvider).selected;

void main() {
  // Two nodes side by side below the origin, away from it.
  Future<(ProviderContainer, String, String)> twoNodes(
    WidgetTester tester,
  ) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final a = editor.addVideoNode(const Position(-300, -100));
    final b = editor.addVideoNode(const Position(100, -100));
    await tester.pumpAndSettle();
    return (c, a, b);
  }

  Future<void> drag(
    WidgetTester tester,
    Offset from,
    Offset to, {
    int buttons = kPrimaryButton,
  }) async {
    final gesture = await tester.startGesture(
      from,
      kind: PointerDeviceKind.mouse,
      buttons: buttons,
    );
    for (var i = 1; i <= 10; i++) {
      await gesture.moveTo(Offset.lerp(from, to, i / 10)!);
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
  }

  testWidgets('dragging on empty canvas selects the nodes the box touches', (
    tester,
  ) async {
    final (c, a, b) = await twoNodes(tester);
    // From empty space above-left of node a to inside it.
    await drag(
      tester,
      screenPoint(tester, c, const Offset(-350, -150)),
      screenPoint(tester, c, const Offset(-200, 0)),
    );
    expect(selected(c), {a});

    // A new box replaces the selection; with Ctrl it adds to it.
    await drag(
      tester,
      screenPoint(tester, c, const Offset(50, -150)),
      screenPoint(tester, c, const Offset(200, 0)),
    );
    expect(selected(c), {b});
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await drag(
      tester,
      screenPoint(tester, c, const Offset(-350, -150)),
      screenPoint(tester, c, const Offset(-200, 0)),
    );
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    expect(selected(c), {a, b});
  });

  testWidgets('Shift-drag and middle-drag pan instead of selecting', (
    tester,
  ) async {
    final (c, _, _) = await twoNodes(tester);
    final view = c.read(canvasViewProvider);
    final before = view.center;
    final from = screenPoint(tester, c, const Offset(-350, -150));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await drag(tester, from, from + const Offset(100, 0));
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(view.center.dx, moreOrLessEquals(before.dx - 100, epsilon: 1));
    expect(selected(c), isEmpty);

    // The middle button pans even when it starts on a node.
    final onNode = screenPoint(tester, c, const Offset(-200, 0));
    await drag(
      tester,
      onNode,
      onNode + const Offset(0, 100),
      buttons: kMiddleMouseButton,
    );
    expect(view.center.dy, moreOrLessEquals(before.dy - 100, epsilon: 1));
    expect(selected(c), isEmpty);
  });

  testWidgets('F glides to the selection, Home to every node', (tester) async {
    final c = await pumpApp(tester);
    final far = c
        .read(graphEditorProvider)
        .addVideoNode(const Position(5000, 4000));
    await tester.pumpAndSettle();
    final bounds = c.read(nodeBoundsProvider);
    final view = c.read(canvasViewProvider);

    c.read(selectionProvider.notifier).selectOnly(far);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.pumpAndSettle();
    final rect = bounds.rectOf(c.read(projectDocumentProvider).nodes[far]!);
    expect(view.center.dx, moreOrLessEquals(rect.center.dx, epsilon: 1));
    expect(view.center.dy, moreOrLessEquals(rect.center.dy, epsilon: 1));
    expect(view.scale, 1, reason: 'framing never zooms in past 100%');

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pumpAndSettle();
    final all = bounds.boundsOf(c.read(projectDocumentProvider))!;
    expect(view.center.dx, moreOrLessEquals(all.center.dx, epsilon: 1));
    expect(view.scale, lessThan(1), reason: 'zoomed out to fit both');
  });

  testWidgets('a new project centers the origin again', (tester) async {
    final c = await pumpApp(tester);
    c.read(canvasViewProvider).panBy(const Offset(400, 300));
    c.read(documentProvider.notifier).newProject();
    await tester.pumpAndSettle();
    final origin = c.read(projectDocumentProvider).origin;
    final rect = c.read(nodeBoundsProvider).rectOf(origin);
    final center = c.read(canvasViewProvider).center;
    expect(center.dx, moreOrLessEquals(rect.center.dx, epsilon: 1e-6));
    expect(center.dy, moreOrLessEquals(rect.center.dy, epsilon: 1e-6));
  });
}
