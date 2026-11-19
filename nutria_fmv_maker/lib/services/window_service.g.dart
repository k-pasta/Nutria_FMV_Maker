// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'window_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(windowControls)
final windowControlsProvider = WindowControlsProvider._();

final class WindowControlsProvider
    extends $FunctionalProvider<WindowControls, WindowControls, WindowControls>
    with $Provider<WindowControls> {
  WindowControlsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'windowControlsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$windowControlsHash();

  @$internal
  @override
  $ProviderElement<WindowControls> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WindowControls create(Ref ref) {
    return windowControls(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WindowControls value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WindowControls>(value),
    );
  }
}

String _$windowControlsHash() => r'e9e1361965dc2398503f58660deace3d85610fe0';
