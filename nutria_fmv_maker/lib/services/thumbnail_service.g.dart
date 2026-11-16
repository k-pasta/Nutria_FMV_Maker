// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumbnail_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [ThumbnailService].

@ProviderFor(thumbnailService)
final thumbnailServiceProvider = ThumbnailServiceProvider._();

/// The app's [ThumbnailService].

final class ThumbnailServiceProvider
    extends
        $FunctionalProvider<
          ThumbnailService,
          ThumbnailService,
          ThumbnailService
        >
    with $Provider<ThumbnailService> {
  /// The app's [ThumbnailService].
  ThumbnailServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'thumbnailServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$thumbnailServiceHash();

  @$internal
  @override
  $ProviderElement<ThumbnailService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThumbnailService create(Ref ref) {
    return thumbnailService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThumbnailService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThumbnailService>(value),
    );
  }
}

String _$thumbnailServiceHash() => r'36d9619b5f06c7f64a467d216b3847f7868a9d61';
