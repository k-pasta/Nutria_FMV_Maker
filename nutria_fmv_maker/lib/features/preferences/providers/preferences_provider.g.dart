// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Preferences _$PreferencesFromJson(Map<String, dynamic> json) => _Preferences(
  gridSnapping: json['gridSnapping'] as bool? ?? false,
  gridSize: (json['gridSize'] as num?)?.toDouble() ?? kDefaultGridSize,
  defaultNodeType:
      $enumDecodeNullable(_$DefaultNodeTypeEnumMap, json['defaultNodeType']) ??
      DefaultNodeType.branchedVideo,
  theme:
      $enumDecodeNullable(_$ThemeChoiceEnumMap, json['theme']) ??
      ThemeChoice.dark,
  languageCode: json['languageCode'] as String? ?? 'en',
  noodleStyle:
      $enumDecodeNullable(_$NoodleStyleEnumMap, json['noodleStyle']) ??
      NoodleStyle.straight,
  libraryView:
      $enumDecodeNullable(_$LibraryViewEnumMap, json['libraryView']) ??
      LibraryView.thumbnails,
);

Map<String, dynamic> _$PreferencesToJson(_Preferences instance) =>
    <String, dynamic>{
      'gridSnapping': instance.gridSnapping,
      'gridSize': instance.gridSize,
      'defaultNodeType': _$DefaultNodeTypeEnumMap[instance.defaultNodeType]!,
      'theme': _$ThemeChoiceEnumMap[instance.theme]!,
      'languageCode': instance.languageCode,
      'noodleStyle': _$NoodleStyleEnumMap[instance.noodleStyle]!,
      'libraryView': _$LibraryViewEnumMap[instance.libraryView]!,
    };

const _$DefaultNodeTypeEnumMap = {
  DefaultNodeType.simpleVideo: 'simpleVideo',
  DefaultNodeType.branchedVideo: 'branchedVideo',
};

const _$ThemeChoiceEnumMap = {
  ThemeChoice.dark: 'dark',
  ThemeChoice.light: 'light',
  ThemeChoice.custom: 'custom',
};

const _$NoodleStyleEnumMap = {
  NoodleStyle.straight: 'straight',
  NoodleStyle.curved: 'curved',
};

const _$LibraryViewEnumMap = {
  LibraryView.largeThumbnails: 'largeThumbnails',
  LibraryView.thumbnails: 'thumbnails',
  LibraryView.smallThumbnails: 'smallThumbnails',
  LibraryView.listWithThumbnails: 'listWithThumbnails',
  LibraryView.list: 'list',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The platform preferences store. `main()` overrides this with an instance
/// loaded before the app starts, so reading preferences is synchronous.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// The platform preferences store. `main()` overrides this with an instance
/// loaded before the app starts, so reading preferences is synchronous.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// The platform preferences store. `main()` overrides this with an instance
  /// loaded before the app starts, so reading preferences is synchronous.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'bdf49748bece142c907bc28d050b90b97094eaa9';

/// Reads and persists [Preferences].

@ProviderFor(PreferencesNotifier)
final preferencesProvider = PreferencesNotifierProvider._();

/// Reads and persists [Preferences].
final class PreferencesNotifierProvider
    extends $NotifierProvider<PreferencesNotifier, Preferences> {
  /// Reads and persists [Preferences].
  PreferencesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesNotifierHash();

  @$internal
  @override
  PreferencesNotifier create() => PreferencesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Preferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Preferences>(value),
    );
  }
}

String _$preferencesNotifierHash() =>
    r'6c80a80d59b99edfa54d7b824773aca87eaa6cd4';

/// Reads and persists [Preferences].

abstract class _$PreferencesNotifier extends $Notifier<Preferences> {
  Preferences build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Preferences, Preferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Preferences, Preferences>,
              Preferences,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
