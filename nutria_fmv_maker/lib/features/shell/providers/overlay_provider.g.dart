// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks [ShellOverlays], e.g. so canvas shortcuts pause while a menu is
/// open.

@ProviderFor(OverlayNotifier)
final overlayProvider = OverlayNotifierProvider._();

/// Tracks [ShellOverlays], e.g. so canvas shortcuts pause while a menu is
/// open.
final class OverlayNotifierProvider
    extends $NotifierProvider<OverlayNotifier, ShellOverlays> {
  /// Tracks [ShellOverlays], e.g. so canvas shortcuts pause while a menu is
  /// open.
  OverlayNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overlayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overlayNotifierHash();

  @$internal
  @override
  OverlayNotifier create() => OverlayNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShellOverlays value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShellOverlays>(value),
    );
  }
}

String _$overlayNotifierHash() => r'7a98428a5fe1bb1db85aac20120b4ef2d066b41d';

/// Tracks [ShellOverlays], e.g. so canvas shortcuts pause while a menu is
/// open.

abstract class _$OverlayNotifier extends $Notifier<ShellOverlays> {
  ShellOverlays build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ShellOverlays, ShellOverlays>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShellOverlays, ShellOverlays>,
              ShellOverlays,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
