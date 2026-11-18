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

/// The ids of imported files that can't be found on disk. Checked again
/// whenever the media list changes (import, relink, undo).

@ProviderFor(missingMedia)
final missingMediaProvider = MissingMediaProvider._();

/// The ids of imported files that can't be found on disk. Checked again
/// whenever the media list changes (import, relink, undo).

final class MissingMediaProvider
    extends $FunctionalProvider<Set<String>, Set<String>, Set<String>>
    with $Provider<Set<String>> {
  /// The ids of imported files that can't be found on disk. Checked again
  /// whenever the media list changes (import, relink, undo).
  MissingMediaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'missingMediaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$missingMediaHash();

  @$internal
  @override
  $ProviderElement<Set<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<String> create(Ref ref) {
    return missingMedia(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$missingMediaHash() => r'dd3e1f798400ba2cf43df483d5f5b50528c81d5a';

/// The cues of the subtitle file at [path], or `null` if it can't be read.

@ProviderFor(subtitleCues)
final subtitleCuesProvider = SubtitleCuesFamily._();

/// The cues of the subtitle file at [path], or `null` if it can't be read.

final class SubtitleCuesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FmvSubtitleCue>?>,
          List<FmvSubtitleCue>?,
          FutureOr<List<FmvSubtitleCue>?>
        >
    with
        $FutureModifier<List<FmvSubtitleCue>?>,
        $FutureProvider<List<FmvSubtitleCue>?> {
  /// The cues of the subtitle file at [path], or `null` if it can't be read.
  SubtitleCuesProvider._({
    required SubtitleCuesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'subtitleCuesProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subtitleCuesHash();

  @override
  String toString() {
    return r'subtitleCuesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<FmvSubtitleCue>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FmvSubtitleCue>?> create(Ref ref) {
    final argument = this.argument as String;
    return subtitleCues(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubtitleCuesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subtitleCuesHash() => r'5bf52e5142a4c1e2d87df8b8c4f629031f4ce9a9';

/// The cues of the subtitle file at [path], or `null` if it can't be read.

final class SubtitleCuesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<FmvSubtitleCue>?>, String> {
  SubtitleCuesFamily._()
    : super(
        retry: null,
        name: r'subtitleCuesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The cues of the subtitle file at [path], or `null` if it can't be read.

  SubtitleCuesProvider call(String path) =>
      SubtitleCuesProvider._(argument: path, from: this);

  @override
  String toString() => r'subtitleCuesProvider';
}

/// The font family name under which the font file at [path] is loaded for
/// the app (to preview it), or `null` if it can't be loaded.

@ProviderFor(mediaFontFamily)
final mediaFontFamilyProvider = MediaFontFamilyFamily._();

/// The font family name under which the font file at [path] is loaded for
/// the app (to preview it), or `null` if it can't be loaded.

final class MediaFontFamilyProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The font family name under which the font file at [path] is loaded for
  /// the app (to preview it), or `null` if it can't be loaded.
  MediaFontFamilyProvider._({
    required MediaFontFamilyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mediaFontFamilyProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaFontFamilyHash();

  @override
  String toString() {
    return r'mediaFontFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return mediaFontFamily(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaFontFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaFontFamilyHash() => r'db34e8f7333938dc649f7c6b8e16fe23869ce4cf';

/// The font family name under which the font file at [path] is loaded for
/// the app (to preview it), or `null` if it can't be loaded.

final class MediaFontFamilyFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  MediaFontFamilyFamily._()
    : super(
        retry: null,
        name: r'mediaFontFamilyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The font family name under which the font file at [path] is loaded for
  /// the app (to preview it), or `null` if it can't be loaded.

  MediaFontFamilyProvider call(String path) =>
      MediaFontFamilyProvider._(argument: path, from: this);

  @override
  String toString() => r'mediaFontFamilyProvider';
}

/// The ids of the subtitle files linked to a video.

@ProviderFor(linkedSubtitleIds)
final linkedSubtitleIdsProvider = LinkedSubtitleIdsProvider._();

/// The ids of the subtitle files linked to a video.

final class LinkedSubtitleIdsProvider
    extends $FunctionalProvider<Set<String>, Set<String>, Set<String>>
    with $Provider<Set<String>> {
  /// The ids of the subtitle files linked to a video.
  LinkedSubtitleIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkedSubtitleIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkedSubtitleIdsHash();

  @$internal
  @override
  $ProviderElement<Set<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<String> create(Ref ref) {
    return linkedSubtitleIds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$linkedSubtitleIdsHash() => r'2d30826c9fbbe176dcfd00d4c37284dd3e9c3a04';

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
