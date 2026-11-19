// User preferences that persist across sessions (snapping, theme, language…).
import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/core/graph/snapping.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_provider.freezed.dart';
part 'preferences_provider.g.dart';

/// The node type created when a video is dropped on the canvas.
enum DefaultNodeType { simpleVideo, branchedVideo }

/// How connections between nodes are drawn.
enum NoodleStyle {
  /// A straight line with a short horizontal piece at each knot.
  straight,

  /// A smooth curve.
  curved,
}

/// How the video library shows videos, from largest to most compact.
enum LibraryView {
  largeThumbnails,
  thumbnails,
  smallThumbnails,

  /// One video per row: a small thumbnail and the name.
  listWithThumbnails,

  /// One name per row.
  list,
}

/// The order of the media library.
enum LibrarySort {
  /// Import order.
  dateAdded,
  name,

  /// By kind (videos, audio, …), then extension, then name.
  type,
}

/// How the media library is split into titled groups.
enum LibraryGrouping { none, kind, fileType }

/// The app's color theme.
enum ThemeChoice { dark, light, custom }

/// Languages the UI is translated to.
const kSupportedLanguages = ['en', 'el', 'fr'];

/// Language names in their own language (so they're never translated).
const kLanguageNames = {'en': 'English', 'el': 'Ελληνικά', 'fr': 'Français'};

/// Grid sizes offered in the preferences, in canvas units.
const kGridSizes = [25.0, 50.0, 100.0, 200.0];

/// The editor preferences of this user, saved on this computer (not in
/// projects).
@freezed
abstract class Preferences with _$Preferences {
  const factory Preferences({
    /// Snap nodes to the grid while moving them (Shift does it temporarily).
    @Default(false) bool gridSnapping,
    @Default(kDefaultGridSize) double gridSize,
    @Default(DefaultNodeType.branchedVideo) DefaultNodeType defaultNodeType,
    @Default(ThemeChoice.dark) ThemeChoice theme,
    @Default('en') String languageCode,
    @Default(NoodleStyle.straight) NoodleStyle noodleStyle,
    @Default(LibraryView.thumbnails) LibraryView libraryView,
    @Default(LibrarySort.dateAdded) LibrarySort librarySort,
    @Default(LibraryGrouping.none) LibraryGrouping libraryGrouping,

    /// Link a video and a subtitle file of the same name when importing.
    @Default(true) bool autoLinkSubtitles,

    /// Logic nodes take one number, true/false or variable as a value, and
    /// offer no power, absolute, and/or/xor or expressions.
    @Default(true) bool simpleMath,
  }) = _Preferences;

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
}

/// The platform preferences store. `main()` overrides this with an instance
/// loaded before the app starts, so reading preferences is synchronous.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()');

/// Reads and persists [Preferences].
@Riverpod(keepAlive: true)
class PreferencesNotifier extends _$PreferencesNotifier {
  static const _storageKey = 'preferences';

  @override
  Preferences build() {
    final stored = ref.watch(sharedPreferencesProvider).getString(_storageKey);
    if (stored == null) return const Preferences();
    try {
      return Preferences.fromJson(jsonDecode(stored) as Map<String, dynamic>);
    } on Object {
      // Corrupt or from an incompatible version: start from the defaults.
      return const Preferences();
    }
  }

  void toggleGridSnapping() =>
      _update(state.copyWith(gridSnapping: !state.gridSnapping));

  void setGridSize(double size) {
    if (kGridSizes.contains(size)) _update(state.copyWith(gridSize: size));
  }

  /// Picks the next ([direction] 1) or previous (-1) of [kGridSizes].
  void stepGridSize(int direction) {
    final current = kGridSizes.indexOf(state.gridSize);
    final next = current == -1
        ? kGridSizes.indexOf(kDefaultGridSize)
        : (current + direction).clamp(0, kGridSizes.length - 1);
    _update(state.copyWith(gridSize: kGridSizes[next]));
  }

  void setDefaultNodeType(DefaultNodeType type) =>
      _update(state.copyWith(defaultNodeType: type));

  void setNoodleStyle(NoodleStyle style) =>
      _update(state.copyWith(noodleStyle: style));

  void setLibraryView(LibraryView view) =>
      _update(state.copyWith(libraryView: view));

  /// The next more compact ([direction] 1) or larger (-1) library view.
  void stepLibraryView(int direction) => setLibraryView(LibraryView.values[
      (state.libraryView.index + direction)
          .clamp(0, LibraryView.values.length - 1)]);

  void setLibrarySort(LibrarySort sort) =>
      _update(state.copyWith(librarySort: sort));

  void setLibraryGrouping(LibraryGrouping grouping) =>
      _update(state.copyWith(libraryGrouping: grouping));

  void setSimpleMath(bool on) => _update(state.copyWith(simpleMath: on));

  void setAutoLinkSubtitles(bool on) =>
      _update(state.copyWith(autoLinkSubtitles: on));

  void setTheme(ThemeChoice theme) => _update(state.copyWith(theme: theme));

  void setLanguage(String languageCode) {
    if (kSupportedLanguages.contains(languageCode)) {
      _update(state.copyWith(languageCode: languageCode));
    }
  }

  void _update(Preferences next) {
    if (next == state) return;
    state = next;
    unawaited(ref
        .read(sharedPreferencesProvider)
        .setString(_storageKey, jsonEncode(next.toJson())));
  }
}
