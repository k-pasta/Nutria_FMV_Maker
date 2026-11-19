// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_overview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// How many files an export uses ([usedMediaIds]), their total size in
/// bytes, and how many of them couldn't be read.

@ProviderFor(usedMediaSize)
final usedMediaSizeProvider = UsedMediaSizeProvider._();

/// How many files an export uses ([usedMediaIds]), their total size in
/// bytes, and how many of them couldn't be read.

final class UsedMediaSizeProvider
    extends
        $FunctionalProvider<
          ({int bytes, int count, int unreadable}),
          ({int bytes, int count, int unreadable}),
          ({int bytes, int count, int unreadable})
        >
    with $Provider<({int bytes, int count, int unreadable})> {
  /// How many files an export uses ([usedMediaIds]), their total size in
  /// bytes, and how many of them couldn't be read.
  UsedMediaSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usedMediaSizeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usedMediaSizeHash();

  @$internal
  @override
  $ProviderElement<({int bytes, int count, int unreadable})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({int bytes, int count, int unreadable}) create(Ref ref) {
    return usedMediaSize(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int bytes, int count, int unreadable}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<({int bytes, int count, int unreadable})>(value),
    );
  }
}

String _$usedMediaSizeHash() => r'f265016474d93a6d270a277462448af1def3d7dd';

/// The shortest and longest ways through the story, once the lengths of
/// its videos are read.

@ProviderFor(storyLengthOverview)
final storyLengthOverviewProvider = StoryLengthOverviewProvider._();

/// The shortest and longest ways through the story, once the lengths of
/// its videos are read.

final class StoryLengthOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<StoryLength>,
          StoryLength,
          FutureOr<StoryLength>
        >
    with $FutureModifier<StoryLength>, $FutureProvider<StoryLength> {
  /// The shortest and longest ways through the story, once the lengths of
  /// its videos are read.
  StoryLengthOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyLengthOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyLengthOverviewHash();

  @$internal
  @override
  $FutureProviderElement<StoryLength> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StoryLength> create(Ref ref) {
    return storyLengthOverview(ref);
  }
}

String _$storyLengthOverviewHash() =>
    r'a3b108ee0beb54d041e0142bc75523c72156714f';
