import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';

import 'app_tester.dart';
import 'harness.dart';

void main() {
  testWidgets('problems in the main branch: listed in the Project section, '
      'and a warning before exporting', (tester) async {
    final files = MemoryProjectFiles()..nextSavePath = 'story.fmv';
    final c = await pumpApp(
      tester,
      overrides: [projectFileServiceProvider.overrideWithValue(files)],
    );
    final editor = c.read(graphEditorProvider);
    final id = editor.addVideoNode(
      const Position(-100, -300),
      type: DefaultNodeType.simpleVideo,
    );
    c
        .read(documentProvider.notifier)
        .apply(
          'Connect',
          (d) => d.connect(
            PortRef(nodeId: d.origin.id, port: kNextPortKey),
            PortRef.input(id),
          ),
        );
    // One more, not reached from the origin: not a problem, but counted.
    final stray = editor.addVideoNode(const Position(300, 300));
    c.read(panelLayoutProvider.notifier).showSection(LeftPanelSection.project);
    await tester.pumpAndSettle();
    expect(find.text('Untitled node: No video'), findsOneWidget);
    expect(
      find.text('2 (1 in the main branch, 1 not reached)'),
      findsOneWidget,
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyE);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.text('Export Anyway'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(files.lastExport, isNull, reason: 'cancelled');

    c.read(graphEditorProvider).selectOutsideMainBranch();
    expect(c.read(selectionProvider).selected, {stray});
  });
}
