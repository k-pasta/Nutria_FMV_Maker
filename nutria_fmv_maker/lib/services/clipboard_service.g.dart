// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's clipboard.

@ProviderFor(clipboardService)
final clipboardServiceProvider = ClipboardServiceProvider._();

/// The app's clipboard.

final class ClipboardServiceProvider
    extends
        $FunctionalProvider<
          ClipboardService,
          ClipboardService,
          ClipboardService
        >
    with $Provider<ClipboardService> {
  /// The app's clipboard.
  ClipboardServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clipboardServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clipboardServiceHash();

  @$internal
  @override
  $ProviderElement<ClipboardService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClipboardService create(Ref ref) {
    return clipboardService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClipboardService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClipboardService>(value),
    );
  }
}

String _$clipboardServiceHash() => r'7797f1a1f458eb07e37cb7d798d16b1b4c7bb9c6';
