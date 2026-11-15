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

/// The app's color theme.
enum ThemeChoice { dark, light, custom }

/// Languages the UI is translated to.
const kSupportedLanguages = ['en', 'el', 'fr'];

@freezed
abstract class Preferences with _$Preferences {
  const factory Preferences({
    /// Snap nodes to the grid while moving them (Shift does it temporarily).
    @Default(false) bool gridSnapping,
    @Default(kDefaultGridSize) double gridSize,
    @Default(DefaultNodeType.branchedVideo) DefaultNodeType defaultNodeType,
    @Default(ThemeChoice.dark) ThemeChoice theme,
    @Default('en') String languageCode,
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

  void setDefaultNodeType(DefaultNodeType type) =>
      _update(state.copyWith(defaultNodeType: type));

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
