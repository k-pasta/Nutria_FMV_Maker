// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_dialogs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's file dialogs. Override in tests.

@ProviderFor(fileDialogs)
final fileDialogsProvider = FileDialogsProvider._();

/// The app's file dialogs. Override in tests.

final class FileDialogsProvider
    extends $FunctionalProvider<FileDialogs, FileDialogs, FileDialogs>
    with $Provider<FileDialogs> {
  /// The app's file dialogs. Override in tests.
  FileDialogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileDialogsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileDialogsHash();

  @$internal
  @override
  $ProviderElement<FileDialogs> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FileDialogs create(Ref ref) {
    return fileDialogs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileDialogs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileDialogs>(value),
    );
  }
}

String _$fileDialogsHash() => r'b28f6f12d2d4a65737738598ab5b3c54cf420812';
