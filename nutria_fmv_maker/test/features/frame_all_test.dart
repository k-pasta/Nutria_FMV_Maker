import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';

import 'app_tester.dart';

void main() {
  testWidgets('Home frames far-apart nodes, logic nodes and comments', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c
        .read(documentProvider.notifier)
        .apply(
          'setup',
          (d) => d
              .putNode(
                const ChangeVariableNode(id: 'a', position: Position(-1500, 0)),
              )
              .putNode(const CompareNode(id: 'b', position: Position(1500, 0)))
              .putNode(
                const CommentNode(
                  id: 'k',
                  position: Position.zero,
                  attachedTo: 'a',
                ),
              ),
        );
    await tester.pumpAndSettle();
    expect(c.read(canvasViewProvider).scale, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pumpAndSettle();
    expect(c.read(canvasViewProvider).scale, lessThan(0.6));
  });

  testWidgets('framing keeps the nodes clear of the side panels', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    // Only the left panel open: the visible part is off-center.
    c.read(panelLayoutProvider.notifier).toggle(PanelSide.right, 1600);
    final layout = c.read(panelLayoutProvider);
    expect((layout.leftClosed, layout.rightClosed), (false, true));
    final editor = c.read(graphEditorProvider);
    editor.addChangeNode(const Position(-700, 0));
    editor.addCompareNode(const Position(700, 0));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pumpAndSettle();
    final left = layout.left + kPanelHandleWidth;
    const right = 1600;
    for (final title in ['Set Variable', 'Compare']) {
      final rect = tester.getRect(find.text(title));
      expect(rect.left, greaterThan(left), reason: title);
      expect(rect.right, lessThan(right), reason: title);
    }
  });
}
