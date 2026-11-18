// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_files_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [MediaFiles]. Override in tests.

@ProviderFor(mediaFiles)
final mediaFilesProvider = MediaFilesProvider._();

/// The app's [MediaFiles]. Override in tests.

final class MediaFilesProvider
    extends $FunctionalProvider<MediaFiles, MediaFiles, MediaFiles>
    with $Provider<MediaFiles> {
  /// The app's [MediaFiles]. Override in tests.
  MediaFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaFilesHash();

  @$internal
  @override
  $ProviderElement<MediaFiles> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaFiles create(Ref ref) {
    return mediaFiles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaFiles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaFiles>(value),
    );
  }
}

String _$mediaFilesHash() => r'740e18bc941b3a5f5c21af99a1034b81004f399b';
