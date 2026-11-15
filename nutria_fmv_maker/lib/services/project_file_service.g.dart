// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_file_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [ProjectFileService].

@ProviderFor(projectFileService)
final projectFileServiceProvider = ProjectFileServiceProvider._();

/// The app's [ProjectFileService].

final class ProjectFileServiceProvider
    extends
        $FunctionalProvider<
          ProjectFileService,
          ProjectFileService,
          ProjectFileService
        >
    with $Provider<ProjectFileService> {
  /// The app's [ProjectFileService].
  ProjectFileServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectFileServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectFileServiceHash();

  @$internal
  @override
  $ProviderElement<ProjectFileService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectFileService create(Ref ref) {
    return projectFileService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectFileService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectFileService>(value),
    );
  }
}

String _$projectFileServiceHash() =>
    r'7b8d1d7d7fb668d8038a650d28119495df37b373';
