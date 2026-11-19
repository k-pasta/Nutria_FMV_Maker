// Pumps the whole app with fake services, for widget tests.
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/app/app.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/services/media_files_service.dart';
import 'package:nutria_fmv_maker/services/media_info_service.dart';
import 'package:nutria_fmv_maker/services/thumbnail_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

/// "No Video" as nodes draw it (with invisible wrap points between letters).
final kNoVideo = NodeMetrics.wrappable('No Video');

/// A point on the canvas that no panel covers (window 1600x900).
const kCanvasPoint = Offset(800, 450);

/// Pumps [NutriaApp] in a 1600x900 window and returns its container.
/// [mediaInfo] replaces the default, which knows nothing about any file;
/// [player] lets a test see what the preview player was asked to do;
/// [mediaFiles] says which files exist (by default, all of them).
///
/// The view is then reset to canvas (0, 0) in the middle at 100%, which
/// tests place their nodes around; with [startView] it stays as the app
/// starts (framed on the origin node).
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  List<Override> overrides = const [],
  MediaInfoService? mediaInfo,
  FakePlayer? player,
  MediaFiles? mediaFiles,
  bool startView = false,
}) async {
  tester.view.physicalSize = const Size(1600, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer.test(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      previewPlayerProvider.overrideWithValue(player ?? FakePlayer()),
      thumbnailServiceProvider.overrideWithValue(const _NoThumbnails()),
      mediaInfoServiceProvider.overrideWithValue(
        mediaInfo ?? const _NoMediaInfo(),
      ),
      mediaFilesProvider.overrideWithValue(mediaFiles ?? FakeMediaFiles()),
      ...overrides,
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const NutriaApp()),
  );
  await tester.pumpAndSettle();
  if (!startView) {
    container.read(canvasViewProvider).centerOn(Offset.zero, scale: 1);
    await tester.pumpAndSettle();
  }
  return container;
}

/// Turns the mouse wheel one notch at [position] (up zooms in).
Future<void> scrollAt(
  WidgetTester tester,
  Offset position, {
  required bool up,
}) async {
  await tester.sendEventToBinding(
    PointerScrollEvent(
      kind: PointerDeviceKind.mouse,
      position: position,
      scrollDelta: Offset(0, up ? -20 : 20),
    ),
  );
  await tester.pump();
}

/// Right-clicks at [position].
Future<void> rightClickAt(WidgetTester tester, Offset position) async {
  await tester.tapAt(position, buttons: kSecondaryButton);
  await tester.pumpAndSettle();
}

class _NoThumbnails implements ThumbnailService {
  const _NoThumbnails();

  @override
  Future<Uint8List?> thumbnailFor(String path) async => null;
}

class _NoMediaInfo implements MediaInfoService {
  const _NoMediaInfo();

  @override
  Future<VideoInfo?> read(String path) async => null;
}
