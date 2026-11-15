// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_info_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [MediaInfoService].

@ProviderFor(mediaInfoService)
final mediaInfoServiceProvider = MediaInfoServiceProvider._();

/// The app's [MediaInfoService].

final class MediaInfoServiceProvider
    extends
        $FunctionalProvider<
          MediaInfoService,
          MediaInfoService,
          MediaInfoService
        >
    with $Provider<MediaInfoService> {
  /// The app's [MediaInfoService].
  MediaInfoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaInfoServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaInfoServiceHash();

  @$internal
  @override
  $ProviderElement<MediaInfoService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaInfoService create(Ref ref) {
    return mediaInfoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaInfoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaInfoService>(value),
    );
  }
}

String _$mediaInfoServiceHash() => r'0368c909150c77e515b4b0adf6d1b038090c4000';
