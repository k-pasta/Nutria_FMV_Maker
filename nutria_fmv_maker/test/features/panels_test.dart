import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/node_frame.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/video_library/widgets/video_library_panel.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';

import 'app_tester.dart';
import 'harness.dart';

const videos = [r'C:\videos\intro.mp4', r'C:\videos\ending.mp4'];

/// The app with [videos] offered by the "pick videos" dialog.
Future<ProviderContainer> pumpWithVideos(WidgetTester tester) {
  final files = MemoryProjectFiles()..nextVideos = videos;
  return pumpApp(tester,
      overrides: [projectFileServiceProvider.overrideWithValue(files)]);
}

Future<void> importFiles(WidgetTester tester) async {
  await tester.tap(find.descendant(
      of: find.byType(VideoLibraryPanel), matching: find.byIcon(Icons.add)));
  await tester.pumpAndSettle();
}

/// Drags library entry [fileName] to [to] with the mouse.
Future<void> dragEntry(WidgetTester tester, String fileName, Offset to) async {
  final from = tester.getCenter(find.text(fileName));
  final gesture =
      await tester.startGesture(from, kind: PointerDeviceKind.mouse);
  for (var i = 1; i <= 10; i++) {
    await gesture.moveTo(Offset.lerp(from, to, i / 10)!);
    await tester.pump();
  }
  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('importing videos lists them in the library', (tester) async {
    final container = await pumpWithVideos(tester);
    await importFiles(tester);
    expect(find.text('intro.mp4'), findsOneWidget);
    expect(find.text('ending.mp4'), findsOneWidget);
    expect(container.read(mediaAssetsProvider), hasLength(2));
  });

  testWidgets('clicking a library video previews it', (tester) async {
    final container = await pumpWithVideos(tester);
    await importFiles(tester);
    await tester.tap(find.text('ending.mp4'));
    await tester.pumpAndSettle();
    final previewed = container.read(videoPreviewProvider)!.videoId;
    expect(container.read(videoAssetProvider(previewed))!.path, videos[1]);
  });

  testWidgets('dropping a library video on the canvas creates a node',
      (tester) async {
    final container = await pumpWithVideos(tester);
    await importFiles(tester);
    final before = container.read(projectDocumentProvider).nodes.length;

    await dragEntry(tester, 'intro.mp4', const Offset(800, 200));

    final nodes = container.read(projectDocumentProvider).nodes.values;
    expect(nodes, hasLength(before + 1));
    final videoId = nodes.last.videoIdOrNull!;
    expect(container.read(videoAssetProvider(videoId))!.path, videos[0]);
  });

  testWidgets('dropping a library video on a node sets its video',
      (tester) async {
    final container = await pumpWithVideos(tester);
    await importFiles(tester);
    final id = container
        .read(graphEditorProvider)
        .addVideoNode(const Position(-100, -300),
            type: DefaultNodeType.simpleVideo);
    await tester.pumpAndSettle();

    await dragEntry(
        tester, 'ending.mp4', tester.getCenter(find.text(kNoVideo)));

    final node = container.read(projectDocumentProvider).nodes[id]!;
    expect(container.read(videoAssetProvider(node.videoIdOrNull!))!.path,
        videos[1]);
    // On the node, the file name replaces "No Video".
    expect(find.text(kNoVideo), findsNothing);
  });

  testWidgets('project settings change and undo from the panel',
      (tester) async {
    final container = await pumpApp(tester);
    container
        .read(panelLayoutProvider.notifier)
        .showSection(LeftPanelSection.projectSettings);
    await tester.pumpAndSettle();
    expect(find.text('Show Timer'), findsOneWidget);
    expect(container.read(projectSettingsProvider).showTimer, isTrue);

    await tester.tap(find.text('Yes').first); // Show Timer: Yes -> No
    await tester.pumpAndSettle();
    final settings = container.read(projectSettingsProvider);
    expect(settings, isNot(const VideoSettings()));

    container.read(documentProvider.notifier).undo();
    await tester.pumpAndSettle();
    expect(container.read(projectSettingsProvider), const VideoSettings());
  });

  testWidgets('preferences change from the panel and are kept',
      (tester) async {
    final container = await pumpApp(tester);
    container
        .read(panelLayoutProvider.notifier)
        .showSection(LeftPanelSection.preferences);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Branching Video')); // default node type
    await tester.pumpAndSettle();
    expect(container.read(preferencesProvider).defaultNodeType,
        DefaultNodeType.simpleVideo);
    expect(find.text('Simple Video'), findsOneWidget);
  });

  testWidgets('a node shows the file name of its video', (tester) async {
    final container = await pumpWithVideos(tester);
    final editor = container.read(graphEditorProvider);
    final ids = editor.importFiles(videos);
    editor.addVideoNode(Position.zero,
        videoId: ids.first, type: DefaultNodeType.branchedVideo);
    await tester.pumpAndSettle();
    expect(
        find.descendant(
            of: find.byType(NodeFrame),
            matching: find.text(NodeMetrics.wrappable('intro.mp4'))),
        findsOneWidget);
    expect(
        container
            .read(projectDocumentProvider)
            .nodes
            .values
            .whereType<BranchedVideoNode>(),
        hasLength(1));
  });
}
