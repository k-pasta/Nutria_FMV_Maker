// Frame timings of dragging and hovering on a large project. Run in profile
// mode on the desktop (numbers in debug mode mean nothing):
//   flutter drive --profile -d windows --driver=test_driver/perf_driver.dart \
//     --target=integration_test/drag_performance_test.dart
// Results: build/integration_response_data.json.
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/knot.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/video_node_parts.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/services/file_dialogs.dart';
import 'package:nutria_fmv_maker/services/media_info_service.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:nutria_fmv_maker/services/thumbnail_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'large_project.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('dragging and hovering on 300 nodes', (tester) async {
    final container = await _openLargeProject(tester);
    final controller = container.read(canvasViewProvider);
    // Zoomed out so many nodes are on screen at once.
    for (var i = 0; i < 6; i++) {
      controller.zoomCentered(zoomIn: false);
    }
    await _settle(tester);
    debugPrint('zoom ${controller.scale.toStringAsFixed(2)}, '
        '${find.byType(NodeThumbnail).evaluate().length} nodes built, '
        '${_visibleThumbnails(tester).length} in the middle of the screen');

    final thumbnails = _visibleThumbnails(tester);

    // 1. Grab nodes that are not selected (selection changes on press).
    await binding.watchPerformance(() async {
      for (final at in thumbnails.take(6)) {
        await _drag(tester, at, const Offset(3, 2), steps: 40);
      }
    }, reportKey: 'drag_unselected');

    // 2. Move a selection of 20.
    final selection = container.read(selectionProvider.notifier);
    final ids = container
        .read(documentProvider)
        .document
        .nodes
        .keys
        .where((id) => id.startsWith('n'))
        .take(20);
    for (final id in ids) {
      selection.add(id);
    }
    await _settle(tester);
    final selectedAt = _visibleThumbnails(tester).first;
    await binding.watchPerformance(() async {
      await _drag(tester, selectedAt, const Offset(-3, 1), steps: 60);
    }, reportKey: 'drag_selection');

    // 3. Sweep the mouse over knots (they grow on hover).
    final knots = find
        .byType(Knot)
        .evaluate()
        .map((e) => tester.getCenter(find.byWidget(e.widget)))
        .where(_onCanvas(tester))
        .take(40)
        .toList();
    await binding.watchPerformance(() async {
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: knots.first);
      for (final at in knots) {
        await mouse.moveTo(at);
        await tester.pump(const Duration(milliseconds: 16));
        await mouse.moveTo(at + const Offset(40, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await mouse.removePointer();
    }, reportKey: 'hover_knots');
  });
}

Future<ProviderContainer> _openLargeProject(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    projectFileServiceProvider
        .overrideWithValue(_OneProject(buildLargeDocument())),
    previewPlayerProvider.overrideWithValue(_SilentPlayer()),
    thumbnailServiceProvider
        .overrideWithValue(_GeneratedThumbnails(await _thumbnailPng())),
    mediaInfoServiceProvider.overrideWithValue(const _NoMediaInfo()),
  ]);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const NutriaApp()),
  );
  await container.read(documentProvider.notifier).openPath('large.nfmv');
  await _settle(tester);
  return container;
}

/// Lets thumbnails load and animations finish.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 33));
  }
}

/// The middle of the window, away from the side panels and bars.
bool Function(Offset) _onCanvas(WidgetTester tester) {
  final size = tester.view.physicalSize / tester.view.devicePixelRatio;
  final area = Rect.fromLTRB(size.width * 0.3, size.height * 0.15,
      size.width * 0.7, size.height * 0.85);
  return area.contains;
}

List<Offset> _visibleThumbnails(WidgetTester tester) => find
    .byType(NodeThumbnail)
    .evaluate()
    .map((e) => tester.getCenter(find.byWidget(e.widget)))
    .where(_onCanvas(tester))
    .toList();

Future<void> _drag(WidgetTester tester, Offset from, Offset step,
    {required int steps}) async {
  final gesture =
      await tester.startGesture(from, kind: PointerDeviceKind.mouse);
  await tester.pump(const Duration(milliseconds: 16));
  for (var i = 0; i < steps; i++) {
    await gesture.moveBy(step);
    await tester.pump(const Duration(milliseconds: 16));
  }
  await gesture.up();
  await tester.pump(const Duration(milliseconds: 16));
}

/// A 320x180 gradient, encoded like a real thumbnail.
Future<Uint8List> _thumbnailPng() async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(
    const Rect.fromLTWH(0, 0, 320, 180),
    Paint()
      ..shader = ui.Gradient.linear(Offset.zero, const Offset(320, 180),
          [const Color(0xff336699), const Color(0xffcc6633)]),
  );
  final image = await recorder.endRecording().toImage(320, 180);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

class _OneProject extends ProjectFileService {
  _OneProject(this.document) : super(const _NoDialogs());
  final ProjectDocument document;
  @override
  Future<ProjectDocument> readProject(String path) async => document;
}

class _NoDialogs implements FileDialogs {
  const _NoDialogs();
  @override
  Future<String?> pickFile({required List<String> extensions}) async => null;
  @override
  Future<List<String>> pickVideos() async => const [];
  @override
  Future<String?> saveFile(
          {required String fileName, required Uint8List bytes}) async =>
      null;
}

class _GeneratedThumbnails implements ThumbnailService {
  const _GeneratedThumbnails(this.png);
  final Uint8List png;
  @override
  Future<Uint8List?> thumbnailFor(String path) async => png;
}

class _NoMediaInfo implements MediaInfoService {
  const _NoMediaInfo();
  @override
  Future<VideoInfo?> read(String path) async => null;
}

class _SilentPlayer implements PreviewPlayer {
  @override
  final ValueNotifier<PlaybackStatus> status = ValueNotifier(kStoppedStatus);
  @override
  Future<void> open(String path) async {}
  @override
  Future<void> stop() async {}
  @override
  Future<void> playOrPause() async {}
  @override
  Future<void> seek(Duration position) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  void dispose() {}
}
