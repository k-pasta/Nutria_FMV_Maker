import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/video_library/widgets/video_library_panel.dart';

import 'app_tester.dart';

void main() {
  testWidgets('Ctrl+wheel over the library changes the video size',
      (tester) async {
    final c = await pumpApp(tester);
    c.read(graphEditorProvider).importVideos(['C:/v/a.mp4', 'C:/v/b.mp4']);
    await tester.pumpAndSettle();
    LibraryView view() => c.read(preferencesProvider).libraryView;
    final library = tester.getCenter(find.byType(VideoLibraryPanel));
    expect(view(), LibraryView.thumbnails);

    // A plain wheel scrolls; it doesn't resize.
    await scrollAt(tester, library, up: false);
    expect(view(), LibraryView.thumbnails);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await scrollAt(tester, library, up: false);
    expect(view(), LibraryView.smallThumbnails);
    await scrollAt(tester, library, up: false);
    await scrollAt(tester, library, up: false);
    await scrollAt(tester, library, up: false);
    expect(view(), LibraryView.list, reason: 'stops at the most compact');
    await scrollAt(tester, library, up: true);
    expect(view(), LibraryView.listWithThumbnails);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.byType(LibraryThumbnail), findsNWidgets(2));
  });

  testWidgets('the library context menu picks the view', (tester) async {
    final c = await pumpApp(tester);
    c.read(graphEditorProvider).importVideos(['C:/v/a.mp4']);
    await tester.pumpAndSettle();
    final library = tester.getRect(find.byType(VideoLibraryPanel));

    await rightClickAt(tester, library.center + const Offset(0, 100));
    await tester.tap(find.text('List'));
    await tester.pumpAndSettle();
    expect(c.read(preferencesProvider).libraryView, LibraryView.list);
    expect(find.byType(LibraryThumbnail), findsNothing);
    expect(find.text('a.mp4'), findsOneWidget);
  });
}
