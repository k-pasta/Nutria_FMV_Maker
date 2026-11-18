// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Technical information about the video at [path]. Not saved in the
/// project; read once per session. `null` if the file is missing.

@ProviderFor(videoInfo)
final videoInfoProvider = VideoInfoFamily._();

/// Technical information about the video at [path]. Not saved in the
/// project; read once per session. `null` if the file is missing.

final class VideoInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<VideoInfo?>,
          VideoInfo?,
          FutureOr<VideoInfo?>
        >
    with $FutureModifier<VideoInfo?>, $FutureProvider<VideoInfo?> {
  /// Technical information about the video at [path]. Not saved in the
  /// project; read once per session. `null` if the file is missing.
  VideoInfoProvider._({
    required VideoInfoFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'videoInfoProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$videoInfoHash();

  @override
  String toString() {
    return r'videoInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VideoInfo?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<VideoInfo?> create(Ref ref) {
    final argument = this.argument as String;
    return videoInfo(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$videoInfoHash() => r'a5fd53017b67678398bbdbcb1e4a66cbd3ee2b51';

/// Technical information about the video at [path]. Not saved in the
/// project; read once per session. `null` if the file is missing.

final class VideoInfoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VideoInfo?>, String> {
  VideoInfoFamily._()
    : super(
        retry: null,
        name: r'videoInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Technical information about the video at [path]. Not saved in the
  /// project; read once per session. `null` if the file is missing.

  VideoInfoProvider call(String path) =>
      VideoInfoProvider._(argument: path, from: this);

  @override
  String toString() => r'videoInfoProvider';
}

/// The library groups the user has collapsed this session (see
/// `LibraryGroup.key`). Not saved.

@ProviderFor(CollapsedLibraryGroups)
final collapsedLibraryGroupsProvider = CollapsedLibraryGroupsProvider._();

/// The library groups the user has collapsed this session (see
/// `LibraryGroup.key`). Not saved.
final class CollapsedLibraryGroupsProvider
    extends $NotifierProvider<CollapsedLibraryGroups, Set<Object>> {
  /// The library groups the user has collapsed this session (see
  /// `LibraryGroup.key`). Not saved.
  CollapsedLibraryGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collapsedLibraryGroupsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collapsedLibraryGroupsHash();

  @$internal
  @override
  CollapsedLibraryGroups create() => CollapsedLibraryGroups();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<Object> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<Object>>(value),
    );
  }
}

String _$collapsedLibraryGroupsHash() =>
    r'7795e9ceff11bcea19bf33411f3f4631b01cc9b3';

/// The library groups the user has collapsed this session (see
/// `LibraryGroup.key`). Not saved.

abstract class _$CollapsedLibraryGroups extends $Notifier<Set<Object>> {
  Set<Object> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<Object>, Set<Object>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<Object>, Set<Object>>,
              Set<Object>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Thumbnail image bytes for the video at [path], or `null` if none could be
/// made. Kept for the session so scrolling the library doesn't regenerate.

@ProviderFor(videoThumbnail)
final videoThumbnailProvider = VideoThumbnailFamily._();

/// Thumbnail image bytes for the video at [path], or `null` if none could be
/// made. Kept for the session so scrolling the library doesn't regenerate.

final class VideoThumbnailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List?>,
          Uint8List?,
          FutureOr<Uint8List?>
        >
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  /// Thumbnail image bytes for the video at [path], or `null` if none could be
  /// made. Kept for the session so scrolling the library doesn't regenerate.
  VideoThumbnailProvider._({
    required VideoThumbnailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'videoThumbnailProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$videoThumbnailHash();

  @override
  String toString() {
    return r'videoThumbnailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as String;
    return videoThumbnail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoThumbnailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$videoThumbnailHash() => r'bca519d5855cf17d0f2a549a31e49693aaf0e58b';

/// Thumbnail image bytes for the video at [path], or `null` if none could be
/// made. Kept for the session so scrolling the library doesn't regenerate.

final class VideoThumbnailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List?>, String> {
  VideoThumbnailFamily._()
    : super(
        retry: null,
        name: r'videoThumbnailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Thumbnail image bytes for the video at [path], or `null` if none could be
  /// made. Kept for the session so scrolling the library doesn't regenerate.

  VideoThumbnailProvider call(String path) =>
      VideoThumbnailProvider._(argument: path, from: this);

  @override
  String toString() => r'videoThumbnailProvider';
}
