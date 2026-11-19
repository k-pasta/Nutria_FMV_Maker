import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/media_library/providers/media_library_providers.dart';
import 'package:nutria_fmv_maker/features/media_library/widgets/missing_files_window.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/shell/providers/notifications_provider.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';

import 'app_tester.dart';
import 'harness.dart';

const _gone = r'C:\old\intro.mp4';
const _here = r'C:\m\song.mp3';

ProjectDocument _project() => ProjectDocument.empty().copyWith(
  media: const [
    MediaAsset(id: 'v', path: _gone),
    MediaAsset(id: 'a', path: _here),
  ],
);

String? _lastNotice(ProviderContainer c) {
  final history = c.read(notificationHistoryProvider);
  return history.isEmpty ? null : history.last.message;
}

void main() {
  test('relinkByName matches file names, ignoring case', () {
    final (doc, found) = _project().relinkByName(
      {'v', 'a'},
      [r'D:\new\INTRO.mp4', r'D:\new\other.mp3'],
    );
    expect(found, {'v'});
    expect(doc.mediaById('v')!.path, r'D:\new\INTRO.mp4');
    expect(doc.mediaById('a')!.path, _here);
    final (same, none) = _project().relinkByName({'v'}, const []);
    expect(none, isEmpty);
    expect(same.media, _project().media);
  });

  testWidgets('opening a project with missing files lists them; a folder '
      'scan finds them', (tester) async {
    final files = MemoryProjectFiles()
      ..files['story.nfmv'] = _project()
      ..nextOpenPath = 'story.nfmv'
      ..nextFolder = r'D:\new';
    final disk = FakeMediaFiles()
      ..missing.add(_gone)
      ..folders[r'D:\new'] = [r'D:\new\Intro.MP4', r'D:\new\x.png'];
    final c = await pumpApp(
      tester,
      overrides: [projectFileServiceProvider.overrideWithValue(files)],
      mediaFiles: disk,
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyO);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    final window = find.byType(MissingFilesWindow);
    expect(window, findsOneWidget);
    expect(
      find.descendant(of: window, matching: find.text('intro.mp4')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: window, matching: find.text('song.mp3')),
      findsNothing,
    );

    await tester.tap(find.text('Look in a Folder…'));
    await tester.pumpAndSettle();
    expect(
      c.read(projectDocumentProvider).mediaById('v')!.path,
      r'D:\new\Intro.MP4',
    );
    expect(c.read(missingMediaProvider), isEmpty);
    expect(find.text('Every file was found.'), findsOneWidget);
    expect(_lastNotice(c), 'Found 1 of 1 missing files');
    await tester.pump(const Duration(seconds: 5)); // the notice fades
  });

  testWidgets('right-click: find a missing file, or replace any file', (
    tester,
  ) async {
    final files = MemoryProjectFiles()..nextFile = r'D:\other\renamed.mp4';
    final disk = FakeMediaFiles()..missing.add(_gone);
    final c = await pumpApp(
      tester,
      overrides: [projectFileServiceProvider.overrideWithValue(files)],
      mediaFiles: disk,
    );
    c.read(documentProvider.notifier).apply('setup', (_) => _project());
    await tester.pumpAndSettle();
    expect(c.read(missingMediaProvider), {'v'});

    await rightClickAt(tester, tester.getCenter(find.text('intro.mp4')));
    await tester.tap(find.text('Find Missing File…'));
    await tester.pumpAndSettle();
    expect(
      c.read(projectDocumentProvider).mediaById('v')!.path,
      r'D:\other\renamed.mp4',
    );
    expect(_lastNotice(c), 'The chosen file has another name: renamed.mp4');
    c.read(documentProvider.notifier).undo();
    expect(c.read(projectDocumentProvider).mediaById('v')!.path, _gone);
    await tester.pumpAndSettle();

    // Every file can be replaced; there is no "find" for files that exist.
    files.nextFile = r'D:\other\tune.mp3';
    await rightClickAt(tester, tester.getCenter(find.text('song.mp3')));
    expect(find.text('Find Missing File…'), findsNothing);
    await tester.tap(find.text('Replace…'));
    await tester.pumpAndSettle();
    expect(
      c.read(projectDocumentProvider).mediaById('a')!.path,
      r'D:\other\tune.mp3',
    );
    await tester.pump(const Duration(seconds: 5)); // the notice fades
  });

  testWidgets('files are checked again when the window regains focus', (
    tester,
  ) async {
    final disk = FakeMediaFiles();
    final c = await pumpApp(tester, mediaFiles: disk);
    c.read(documentProvider.notifier).apply('Import', (_) => _project());
    await tester.pumpAndSettle();
    final sub = c.listen(missingMediaProvider, (_, _) {});
    expect(sub.read(), isEmpty);

    disk.missing.add(_here);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(c.read(missingMediaProvider), {'a'});
    sub.close();
  });
}
