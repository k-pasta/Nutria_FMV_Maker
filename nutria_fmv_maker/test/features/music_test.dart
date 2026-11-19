import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/music.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/fragment.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/video_library/widgets/video_library_panel.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

import '../core/fixtures.dart';
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
  final doc = ProjectDocument.empty()
      .copyWith(
        media: const [
          MediaAsset(id: 'v', path: r'C:\m\a.mp4'),
          MediaAsset(id: 's', path: r'C:\m\theme.mp3'),
          MediaAsset(id: 'p', path: r'C:\m\tick.wav'),
        ],
      )
      .putNode(
        const BranchedVideoNode(
          id: 'b',
          position: Position(300, 0),
          videoId: 'v',
          choices: [Choice(id: 'c1', text: 'Go')],
        ),
      )
      .connect(
        const PortRef(nodeId: kOriginNodeId, port: kNextPortKey),
        PortRef.input('b'),
      )
      .setMusic('b', 's')
      .updateMusic('b', (c) => c!.copyWith(end: FmvMusicEnd.laterNodeChanges))
      .setPauseMusic('b', 'p')
      .setMenuMusic('s');

  test('fade lengths step a quarter second, onto whole quarters', () {
    expect(stepFade(1000, 1), 1250);
    expect(stepFade(1000, -1), 750);
    expect(stepFade(1100, 1), 1250);
    expect(stepFade(1100, -1), 1000);
    expect(stepFade(0, -1), 0);
    expect(stepFade(kMaxMusicFadeMs, 1), kMaxMusicFadeMs);
    expect(fadeFromSeconds(1.5), 1500);
    expect(fadeFromSeconds(-1), isNull);
  });

  test('music is exported with paths and settings', () {
    final project = exportFmv(doc).project;
    expect(project.info.menuMusic!.track, r'C:\m\theme.mp3');
    final node = project.nodes['001']!;
    expect(node.music!.track, r'C:\m\theme.mp3');
    expect(node.music!.end, FmvMusicEnd.laterNodeChanges);
    expect(node.pauseMusic!.track, r'C:\m\tick.wav');
  });

  test('converting keeps the music; copying brings the audio along', () {
    final simple = doc.convertVideoNode('b', newId: sequentialIds('n'));
    expect(simple.node('b').musicOrNull?.audioId, 's');
    final fragment = doc.copyFragment(['b']);
    expect(fragment.media.map((m) => m.id), containsAll(['v', 's', 'p']));
    final (pasted, ids) = ProjectDocument.empty().pasteFragment(
      fragment,
      offset: Position.zero,
      newId: sequentialIds('x'),
    );
    final copy = pasted.node(ids.single) as BranchedVideoNode;
    expect(pasted.mediaById(copy.music!.audioId)!.path, r'C:\m\theme.mp3');
    expect(pasted.mediaById(copy.pauseMusicId)!.path, r'C:\m\tick.wav');
  });

  testWidgets('dropping audio: menu music on the origin; on a branched node '
      'a menu asks which music', (tester) async {
    final c = await pumpApp(tester);
    c.read(preferencesProvider.notifier).setLibraryView(LibraryView.list);
    final editor = c.read(graphEditorProvider);
    editor.importFiles([r'C:\m\song.mp3']);
    final node = editor.addVideoNode(
      const Position(150, -100),
      type: DefaultNodeType.branchedVideo,
    );
    await tester.pumpAndSettle();
    final librarySong = find.descendant(
      of: find.byType(VideoLibraryEntry),
      matching: find.text('song.mp3'),
    );

    await _drag(
      tester,
      tester.getCenter(librarySong),
      tester.getCenter(find.text('Origin Node')) + const Offset(0, 60),
    );
    ProjectDocument read(ProviderContainer c) =>
        c.read(projectDocumentProvider);
    expect(read(c).origin.menuMusicId, isNotNull);
    expect(find.text('Menu Music'), findsOneWidget);

    await _drag(
      tester,
      tester.getCenter(librarySong),
      tester.getCenter(find.text(kNoVideo)),
    );
    await tester.tap(find.text('Pause Music (While Choosing)'));
    await tester.pumpAndSettle();
    expect((read(c).nodes[node] as BranchedVideoNode).pauseMusicId, isNotNull);
    expect(read(c).nodes[node]!.musicOrNull, isNull);
  });

  testWidgets('menu music is picked from the imported audio', (tester) async {
    final c = await pumpApp(tester);
    c.read(graphEditorProvider).importFiles([r'C:\m\song.mp3']);
    // Up, so the row at its bottom is in the window.
    c
        .read(documentProvider.notifier)
        .apply(
          'up',
          (d) => d.moveNodes({d.origin.id: const Position(-100, -400)}),
        );
    await tester.pumpAndSettle();
    final row = find.ancestor(
      of: find.text('Menu Music'),
      matching: find.byType(NutriaSettingRow),
    );
    await tester.tap(
      find.descendant(of: row.first, matching: find.text('None')).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('song.mp3'), findsNWidgets(2));
    await tester.tap(find.text('song.mp3').last);
    await tester.pumpAndSettle();
    final doc = c.read(projectDocumentProvider);
    expect(doc.origin.menuMusicId, doc.media.single.id);
  });
}
