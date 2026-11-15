// Pumps the whole app with fake services, for widget tests.
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/app/app.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/services/media_info_service.dart';
import 'package:nutria_fmv_maker/services/thumbnail_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

/// A point on the canvas that no panel covers (window 1600x900).
const kCanvasPoint = Offset(800, 450);

/// Pumps [NutriaApp] in a 1600x900 window and returns its container.
Future<ProviderContainer> pumpApp(WidgetTester tester,
    {List<Override> overrides = const []}) async {
  tester.view.physicalSize = const Size(1600, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer.test(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    previewPlayerProvider.overrideWithValue(FakePlayer()),
    thumbnailServiceProvider.overrideWithValue(const _NoThumbnails()),
    mediaInfoServiceProvider.overrideWithValue(const _NoMediaInfo()),
    ...overrides,
  ]);
  await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const NutriaApp()));
  await tester.pumpAndSettle();
  return container;
}

/// Turns the mouse wheel one notch at [position] (up zooms in).
Future<void> scrollAt(WidgetTester tester, Offset position,
    {required bool up}) async {
  await tester.sendEventToBinding(PointerScrollEvent(
    kind: PointerDeviceKind.mouse,
    position: position,
    scrollDelta: Offset(0, up ? -20 : 20),
  ));
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
