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

/// The problems the export would find in the main branch (the part of the
/// story the origin reaches): videos missing, answers leading nowhere,
/// logic that can't run.

@ProviderFor(storyProblems)
final storyProblemsProvider = StoryProblemsProvider._();

/// The problems the export would find in the main branch (the part of the
/// story the origin reaches): videos missing, answers leading nowhere,
/// logic that can't run.

final class StoryProblemsProvider
    extends
        $FunctionalProvider<
          List<ExportIssue>,
          List<ExportIssue>,
          List<ExportIssue>
        >
    with $Provider<List<ExportIssue>> {
  /// The problems the export would find in the main branch (the part of the
  /// story the origin reaches): videos missing, answers leading nowhere,
  /// logic that can't run.
  StoryProblemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyProblemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyProblemsHash();

  @$internal
  @override
  $ProviderElement<List<ExportIssue>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ExportIssue> create(Ref ref) {
    return storyProblems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ExportIssue> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ExportIssue>>(value),
    );
  }
}

String _$storyProblemsHash() => r'80b6b514b8e9095dfdcb7412e839a61048b6df15';

/// How many story nodes there are, and how many the origin reaches.

@ProviderFor(storyNodeCountsOverview)
final storyNodeCountsOverviewProvider = StoryNodeCountsOverviewProvider._();

/// How many story nodes there are, and how many the origin reaches.

final class StoryNodeCountsOverviewProvider
    extends
        $FunctionalProvider<
          ({int main, int total}),
          ({int main, int total}),
          ({int main, int total})
        >
    with $Provider<({int main, int total})> {
  /// How many story nodes there are, and how many the origin reaches.
  StoryNodeCountsOverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyNodeCountsOverviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyNodeCountsOverviewHash();

  @$internal
  @override
  $ProviderElement<({int main, int total})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({int main, int total}) create(Ref ref) {
    return storyNodeCountsOverview(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int main, int total}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int main, int total})>(value),
    );
  }
}

String _$storyNodeCountsOverviewHash() =>
    r'ca2b101f7199658ff9f68e9487bddd0b3a553aec';
