// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_view_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single canvas view of the app.

@ProviderFor(canvasView)
final canvasViewProvider = CanvasViewProvider._();

/// The single canvas view of the app.

final class CanvasViewProvider
    extends
        $FunctionalProvider<
          CanvasViewController,
          CanvasViewController,
          CanvasViewController
        >
    with $Provider<CanvasViewController> {
  /// The single canvas view of the app.
  CanvasViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canvasViewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canvasViewHash();

  @$internal
  @override
  $ProviderElement<CanvasViewController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CanvasViewController create(Ref ref) {
    return canvasView(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CanvasViewController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CanvasViewController>(value),
    );
  }
}

String _$canvasViewHash() => r'0ea4f437147234e1f9c15af1d2a272578e8b95e4';
