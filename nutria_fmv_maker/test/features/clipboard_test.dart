import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/services/clipboard_service.dart';

import 'app_tester.dart';

class MemoryClipboard implements ClipboardService {
  String? text;
  @override
  Future<String?> read() async => text;
  @override
  Future<bool> write(String text) async {
    this.text = text;
    return true;
  }
}

void main() {
  testWidgets('Ctrl+C / Ctrl+V / Ctrl+D copy, paste and duplicate nodes', (
    tester,
  ) async {
    final clipboard = MemoryClipboard();
    final c = await pumpApp(
      tester,
      overrides: [clipboardServiceProvider.overrideWithValue(clipboard)],
    );
    final id = c.read(graphEditorProvider).addVideoNode(Position.zero);
    c.read(selectionProvider.notifier).selectOnly(id);
    await tester.pumpAndSettle();
    List<Node> videoNodes() => c
        .read(projectDocumentProvider)
        .nodes
        .values
        .where((n) => n.isVideoNode)
        .toList();

    Future<void> ctrl(LogicalKeyboardKey key) async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(key);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
    }

    await ctrl(LogicalKeyboardKey.keyC);
    expect(clipboard.text, contains(id));

    await ctrl(LogicalKeyboardKey.keyV);
    expect(videoNodes(), hasLength(2));
    final pasted = c.read(selectionProvider).selected.single;
    expect(pasted, isNot(id), reason: 'the copy is selected');

    await ctrl(LogicalKeyboardKey.keyD);
    expect(videoNodes(), hasLength(3));
    final duplicate = c.read(selectionProvider).selected.single;
    final from = c.read(projectDocumentProvider).nodes[pasted]!.position;
    final to = c.read(projectDocumentProvider).nodes[duplicate]!.position;
    expect(to.x, greaterThan(from.x), reason: 'offset, not on top');
    expect(to.y, greaterThan(from.y));

    c.read(documentProvider.notifier).undo();
    await tester.pumpAndSettle();
    expect(videoNodes(), hasLength(2), reason: 'duplicate is one undo step');
  });

  testWidgets('Ctrl+X cuts nodes: copied, then deleted in one undo step', (
    tester,
  ) async {
    final clipboard = MemoryClipboard();
    final c = await pumpApp(
      tester,
      overrides: [clipboardServiceProvider.overrideWithValue(clipboard)],
    );
    final id = c.read(graphEditorProvider).addVideoNode(Position.zero);
    c.read(graphEditorProvider).selectAll();
    await tester.pumpAndSettle();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    final doc = c.read(projectDocumentProvider);
    expect(clipboard.text, contains(id));
    expect(doc.nodes.containsKey(id), isFalse);
    expect(doc.nodes, hasLength(1), reason: 'the origin stays');
    expect(c.read(selectionProvider).selected, isEmpty);

    c.read(documentProvider.notifier).undo();
    expect(c.read(projectDocumentProvider).nodes.containsKey(id), isTrue);
  });

  testWidgets('Ctrl+A selects every node', (tester) async {
    final c = await pumpApp(tester);
    c.read(graphEditorProvider).addVideoNode(Position.zero);
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    expect(c.read(selectionProvider).selected, hasLength(2));
  });
}
