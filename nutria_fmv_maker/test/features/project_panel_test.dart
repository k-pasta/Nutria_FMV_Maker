import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField;
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/video_library/widgets/video_library_panel.dart';

import 'app_tester.dart';

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
  testWidgets('languages are added in the Project section; linking subtitles '
      'then asks which language', (tester) async {
    final c = await pumpApp(tester);
    final layout = c.read(panelLayoutProvider.notifier);
    layout.showSection(LeftPanelSection.project);
    await tester.pumpAndSettle();
    expect(find.text('Shortest Way'), findsOneWidget, reason: 'the overview');

    for (final search in ['ελλ', 'english']) {
      await tester.tap(find.text('Add a Language…'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, search);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
    }
    expect(c.read(projectDocumentProvider).info.languages, ['el', 'en']);
    expect(find.text('Main'), findsOneWidget);

    // Drop a subtitle file on a video in the library: pick English.
    c.read(preferencesProvider.notifier).setLibraryView(LibraryView.list);
    c.read(preferencesProvider.notifier).setAutoLinkSubtitles(false);
    c.read(graphEditorProvider).importFiles([
      r'C:\m\intro.mp4',
      r'C:\m\intro.en.srt',
    ]);
    layout.showSection(LeftPanelSection.media);
    await tester.pumpAndSettle();
    Finder entry(String name) => find.descendant(
      of: find.byType(VideoLibraryEntry),
      matching: find.text(name),
    );
    await _drag(
      tester,
      tester.getCenter(entry('intro.en.srt')),
      tester.getCenter(entry('intro.mp4')),
    );
    expect(find.text('English (en)'), findsOneWidget, reason: 'the question');
    await tester.tap(find.text('English (en)'));
    await tester.pumpAndSettle();
    final doc = c.read(projectDocumentProvider);
    final video = doc.media.firstWhere((m) => m.fileName == 'intro.mp4');
    final srt = doc.media.firstWhere((m) => m.fileName == 'intro.en.srt');
    expect(video.subtitles, {'en': srt.id});
  });
}
