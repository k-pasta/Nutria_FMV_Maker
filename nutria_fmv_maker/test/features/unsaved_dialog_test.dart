import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/video_node_views.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';

import 'app_tester.dart';
import 'harness.dart';

void main() {
  testWidgets('New with unsaved changes: Cancel, Don\'t Save or Save', (
    tester,
  ) async {
    final files = MemoryProjectFiles();
    final c = await pumpApp(
      tester,
      overrides: [projectFileServiceProvider.overrideWithValue(files)],
    );
    int nodes() => c.read(projectDocumentProvider).nodes.length;
    Future<void> newProject() async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
    }

    c.read(graphEditorProvider).addVideoNode(Position.zero);
    await tester.pumpAndSettle();

    await newProject();
    expect(find.text('Save the changes to this project?'), findsOneWidget);
    await tester.tap(find.text('Cancel'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(nodes(), 2, reason: 'cancel keeps the project');

    await newProject();
    await tester.tap(find.text("Don't Save"), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(nodes(), 1, reason: 'a new project has only the origin');

    c.read(graphEditorProvider).addVideoNode(Position.zero);
    await tester.pumpAndSettle();
    files.nextSavePath = r'C:\stories\mine.nfmv';
    await newProject();
    await tester.tap(find.text('Save'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(files.files[r'C:\stories\mine.nfmv']?.nodes, hasLength(2));
    expect(nodes(), 1, reason: 'saved, then started a new project');

    // The new project has no file yet, so Save asks where; cancelling that
    // keeps the project instead of losing it.
    c.read(graphEditorProvider).addVideoNode(Position.zero);
    await tester.pumpAndSettle();
    files.nextSavePath = null;
    await newProject();
    await tester.tap(find.text('Save'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(nodes(), 2);
    // Let the "saved" notification time out.
    await tester.pump(const Duration(seconds: 30));
  });

  testWidgets('a node\'s settings panel resizes and has the node menu', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    // High up, so the settings panel below it is on screen.
    final id = c
        .read(graphEditorProvider)
        .addVideoNode(
          const Position(-100, -420),
          type: DefaultNodeType.branchedVideo,
        );
    c.read(graphEditorProvider).toggleExpanded(id);
    await tester.pumpAndSettle();
    // The color squares are the last row of the settings panel.
    final settings = tester.getRect(find.byType(SwatchPicker));

    // The right edge of the settings panel, level with its convert button.
    final nodeRight =
        tester.getCenter(find.text(kNoVideo)).dx + kDefaultNodeWidth / 2 - 2;
    await tester.dragFrom(
      Offset(nodeRight, settings.center.dy),
      const Offset(80, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(
      c.read(projectDocumentProvider).nodes[id]!.width,
      greaterThan(kDefaultNodeWidth + 40),
    );

    // The panel's padding just right of the color squares.
    final squares = tester.getRect(find.byType(SwatchPicker));
    await rightClickAt(tester, squares.centerRight + const Offset(3, 0));
    expect(find.text('Delete Selected Node(s)'), findsOneWidget);
  });
}
