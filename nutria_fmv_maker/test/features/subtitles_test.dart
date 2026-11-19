import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/media_library/widgets/media_library_panel.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/notifications_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/services/media_info_service.dart';

import 'app_tester.dart';
import 'harness.dart';

const _srt =
    '1\n00:00:01,000 --> 00:00:02,000\nHello there\n\n'
    '2\n00:00:09,000 --> 00:00:12,500\nGoodbye\n';

/// Every video is 10 seconds long.
class _TenSeconds implements MediaInfoService {
  const _TenSeconds();
  @override
  Future<VideoInfo?> read(String path) async =>
      VideoInfo(path: path, duration: const Duration(seconds: 10));
}

void main() {
  group('linking', () {
    final doc = ProjectDocument.empty().copyWith(
      media: const [
        MediaAsset(id: 'v', path: r'C:\m\Intro.mp4'),
        MediaAsset(id: 'w', path: r'C:\m\other.mp4'),
        MediaAsset(id: 's', path: r'C:\m\intro.srt'),
        MediaAsset(id: 'a', path: r'C:\m\intro.mp3'),
      ],
    );

    test('a video links one subtitle file; other kinds are refused', () {
      final linked = doc.linkSubtitle('v', 's');
      expect(linked.mediaById('v')!.subtitleId, 's');
      expect(linked.linkedSubtitleIds, {'s'});
      expect(doc.linkSubtitle('v', 'a'), same(doc));
      expect(doc.linkSubtitle('s', 'v'), same(doc));
      // Linking it to another video moves it.
      final moved = linked.linkSubtitle('w', 's');
      expect(moved.mediaById('v')!.subtitleId, isNull);
      expect(moved.mediaById('w')!.subtitleId, 's');
      expect(moved.unlinkSubtitle('w').linkedSubtitleIds, isEmpty);
    });

    test('same-named files link automatically, ignoring case', () {
      final auto = doc.autoLinkSubtitles();
      expect(auto.mediaById('v')!.subtitleId, 's');
      expect(auto.mediaById('w')!.subtitleId, isNull);
      expect(auto.autoLinkSubtitles(), same(auto));
    });

    test('a node exports the subtitles of its video', () {
      final withNode = doc
          .linkSubtitle('v', 's')
          .putNode(
            const Node.simpleVideo(
              id: 'n',
              position: Position.zero,
              videoId: 'v',
            ),
          )
          .connect(
            const PortRef(nodeId: kOriginNodeId, port: kNextPortKey),
            PortRef.input('n'),
          );
      final node = exportFmv(withNode).project.nodes['001']!;
      expect(node.subtitles, r'C:\m\intro.srt');
    });
  });

  testWidgets('importing links same-named subtitles; they show with the '
      'video and can be unlinked', (tester) async {
    final c = await pumpApp(tester);
    c.read(graphEditorProvider).importFiles([
      r'C:\m\intro.mp4',
      r'C:\m\intro.srt',
    ]);
    await tester.pumpAndSettle();
    expect(find.byType(MediaLibraryEntry), findsOneWidget);
    expect(find.byIcon(Icons.closed_caption), findsOneWidget);

    await rightClickAt(tester, tester.getCenter(find.text('intro.mp4')));
    await tester.tap(find.text('Unlink Subtitles'));
    await tester.pumpAndSettle();
    expect(find.byType(MediaLibraryEntry), findsNWidgets(2));
    expect(find.byIcon(Icons.closed_caption), findsNothing);
  });

  testWidgets('a subtitle file previews its dialogue; audio plays', (
    tester,
  ) async {
    final disk = FakeMediaFiles()..contents[r'C:\m\talk.srt'] = _srt;
    final player = FakePlayer();
    final c = await pumpApp(tester, mediaFiles: disk, player: player);
    c.read(graphEditorProvider).importFiles([
      r'C:\m\talk.srt',
      r'C:\m\song.mp3',
    ]);
    await tester.pumpAndSettle();

    await tester.tap(find.text('talk.srt'));
    await tester.pumpAndSettle();
    expect(find.text('Hello there'), findsOneWidget);
    expect(find.text('0:09.000 – 0:12.500'), findsOneWidget);
    expect(c.read(previewIsPlayableProvider), isFalse);
    expect(player.opened, isEmpty);

    await tester.tap(find.text('song.mp3'));
    await tester.pumpAndSettle();
    expect(player.opened, [r'C:\m\song.mp3']);
    expect(c.read(previewIsPlayableProvider), isTrue);
    expect(find.text('Hello there'), findsNothing);
  });

  testWidgets('dropping subtitles on a video links them, with a notice when '
      'they run longer', (tester) async {
    final disk = FakeMediaFiles()..contents[r'C:\m\talk.srt'] = _srt;
    final c = await pumpApp(
      tester,
      mediaFiles: disk,
      mediaInfo: const _TenSeconds(),
    );
    c.read(preferencesProvider.notifier).setLibraryView(LibraryView.list);
    c.read(graphEditorProvider).importFiles([
      r'C:\m\clip.mp4',
      r'C:\m\talk.srt',
    ]);
    await tester.pumpAndSettle();

    final from = tester.getCenter(find.text('talk.srt'));
    final to = tester.getCenter(find.text('clip.mp4'));
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

    final video = c
        .read(projectDocumentProvider)
        .media
        .firstWhere((m) => m.fileName == 'clip.mp4');
    expect(video.subtitleId, isNotNull);
    expect(find.text('talk.srt'), findsNothing, reason: 'listed with it');
    expect(
      c.read(notificationHistoryProvider).last.message,
      'The subtitles go on 0:03 longer than the video',
    );
    await tester.pump(const Duration(seconds: 5)); // the notice fades
  });
}
