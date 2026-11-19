// Shrinks the window with every panel section open and fails on any
// layout overflow (the yellow-black stripes).
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/services/media_info_service.dart';

import 'app_tester.dart';

class _FullInfo implements MediaInfoService {
  @override
  Future<VideoInfo?> read(String path) async => VideoInfo(
    path: path,
    fileSizeBytes: 1800000,
    created: DateTime(2026, 4, 1, 12, 54),
    duration: const Duration(seconds: 8, milliseconds: 160),
    width: 638,
    height: 670,
    frameRate: 30,
  );
}

void main() {
  for (final section in LeftPanelSection.values) {
    testWidgets('no overflow while shrinking the window (${section.name})', (
      tester,
    ) async {
      final container = await pumpApp(tester, mediaInfo: _FullInfo());
      final editor = container.read(graphEditorProvider);
      final ids = editor.importFiles([
        r'C:\Users\someone\Videos\Recording 2026-04-01 12-54-49.mp4',
        r'C:\v\2022-09-10 19-56-23.mp4',
      ]);
      final node = editor.addVideoNode(
        const Position(-100, -300),
        videoId: ids.first,
        type: DefaultNodeType.branchedVideo,
      );
      container.read(videoPreviewProvider.notifier).showNode(node);
      container.read(panelLayoutProvider.notifier).showSection(section);
      await tester.pumpAndSettle();

      final problems = <String>[];
      final previous = FlutterError.onError;
      FlutterError.onError = (details) {
        // "file:///.../lib/<file>:<line>:<col>" of the widget that failed.
        final text = details.toString();
        final start = text.indexOf('/lib/');
        final where = start == -1
            ? '?'
            : text.substring(start + 5, text.indexOf('\n', start));
        problems.add(
          'width ${tester.view.physicalSize.width.round()}: '
          '${details.exceptionAsString().split('\n').first} at $where',
        );
      };
      addTearDown(() => FlutterError.onError = previous);

      for (var width = 1600.0; width >= 300; width -= 50) {
        tester.view.physicalSize = Size(width, width * 9 / 16);
        await tester.pump();
      }
      await tester.pumpAndSettle();
      FlutterError.onError = previous;
      expect(problems.toSet().toList(), isEmpty);
    });
  }
}
