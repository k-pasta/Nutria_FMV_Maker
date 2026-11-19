import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/features/media_library/library_order.dart';
import 'package:nutria_fmv_maker/features/media_library/widgets/media_library_panel.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';

import 'app_tester.dart';

const _files = [
  r'C:\m\b.mp4',
  r'C:\m\song.mp3',
  r'C:\m\a.mkv',
  r'C:\m\b.srt',
  r'C:\m\Title.ttf',
  r'C:\m\cover.png',
];

void main() {
  group('libraryGroups', () {
    final media = [
      for (final (i, path) in _files.indexed) MediaAsset(id: '$i', path: path),
    ];
    List<String> names(List<MediaAsset> list) => [
      for (final m in list) m.fileName,
    ];

    test('sorts by date added, name or type', () {
      List<String> sorted(LibrarySort sort) =>
          names(libraryGroups(media, sort, LibraryGrouping.none).single.media);
      expect(sorted(LibrarySort.dateAdded), [
        'b.mp4',
        'song.mp3',
        'a.mkv',
        'b.srt',
        'Title.ttf',
        'cover.png',
      ]);
      expect(sorted(LibrarySort.name), [
        'a.mkv',
        'b.mp4',
        'b.srt',
        'cover.png',
        'song.mp3',
        'Title.ttf',
      ]);
      expect(sorted(LibrarySort.type), [
        'a.mkv',
        'b.mp4',
        'song.mp3',
        'cover.png',
        'b.srt',
        'Title.ttf',
      ]);
    });

    test('groups by kind or by file type, leaving out empty groups', () {
      final byKind = libraryGroups(
        media,
        LibrarySort.name,
        LibraryGrouping.kind,
      );
      expect([for (final g in byKind) g.key], MediaKind.values);
      expect(names(byKind.first.media), ['a.mkv', 'b.mp4']);

      final byType = libraryGroups(
        media,
        LibrarySort.name,
        LibraryGrouping.fileType,
      );
      expect(
        [for (final g in byType) g.key],
        ['mkv', 'mp4', 'mp3', 'png', 'srt', 'ttf'],
      );

      final videosOnly = libraryGroups(
        media.where((m) => m.isVideo).toList(),
        LibrarySort.name,
        LibraryGrouping.kind,
      );
      expect([for (final g in videosOnly) g.key], [MediaKind.video]);
    });
  });

  test('the kind comes from the extension; unknown ones are videos', () {
    expect(mediaKindOf(r'C:\a\b.SRT'), MediaKind.subtitle);
    expect(mediaKindOf('/a/b.otf'), MediaKind.font);
    expect(mediaKindOf('/a/b.weird'), MediaKind.video);
    expect(const MediaAsset(id: 'x', path: r'C:\x\Clip.MP4').extension, 'mp4');
  });

  testWidgets('the library groups by kind; a group collapses', (tester) async {
    final c = await pumpApp(tester);
    // b.srt would be linked to b.mp4 and listed with it.
    c.read(preferencesProvider.notifier).setAutoLinkSubtitles(false);
    c.read(graphEditorProvider).importFiles(_files);
    await tester.pumpAndSettle();
    expect(find.byType(MediaLibraryEntry), findsNWidgets(_files.length));

    final library = tester.getRect(find.byType(MediaLibraryPanel));
    await rightClickAt(tester, library.center + const Offset(0, 200));
    await tester.tap(find.text('Group by Kind'));
    await tester.pumpAndSettle();
    expect(c.read(preferencesProvider).libraryGrouping, LibraryGrouping.kind);
    for (final title in ['Videos', 'Audio', 'Images', 'Subtitles', 'Fonts']) {
      expect(find.widgetWithText(LibraryGroupHeader, title), findsOneWidget);
    }

    await tester.tap(find.widgetWithText(LibraryGroupHeader, 'Videos'));
    await tester.pumpAndSettle();
    expect(find.byType(MediaLibraryEntry), findsNWidgets(_files.length - 2));
    expect(
      find.byType(LibraryThumbnail),
      findsNothing,
      reason: 'only the videos have video thumbnails',
    );
  });

  testWidgets('only videos can be dropped on the canvas', (tester) async {
    final c = await pumpApp(tester);
    c.read(graphEditorProvider).importFiles([r'C:\m\b.srt', r'C:\m\a.mp4']);
    await tester.pumpAndSettle();
    final before = c.read(projectDocumentProvider).nodes.length;

    Future<void> dragToCanvas(String name) async {
      final from = tester.getCenter(find.text(name));
      final gesture = await tester.startGesture(
        from,
        kind: PointerDeviceKind.mouse,
      );
      for (var i = 1; i <= 10; i++) {
        await gesture.moveTo(from + Offset(60.0 * i, 0));
        await tester.pump();
      }
      await gesture.up();
      await tester.pumpAndSettle();
    }

    await dragToCanvas('b.srt');
    expect(c.read(projectDocumentProvider).nodes.length, before);
    await dragToCanvas('a.mp4');
    expect(c.read(projectDocumentProvider).nodes.length, before + 1);
  });

  testWidgets('a long menu opened near the bottom stays in the window', (
    tester,
  ) async {
    await pumpApp(tester);
    final library = tester.getRect(find.byType(MediaLibraryPanel));
    await rightClickAt(tester, library.bottomCenter - const Offset(0, 70));
    final last = find.text('Group by File Type');
    expect(last, findsOneWidget);
    expect(tester.getRect(last).bottom, lessThanOrEqualTo(900));
    expect(
      tester.getRect(find.text('Large Thumbnails')).top,
      greaterThanOrEqualTo(0),
    );
  });
}
