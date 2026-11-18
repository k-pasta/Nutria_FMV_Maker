// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alt_drag_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether Alt is held, updated on every key press and release (so knots
/// react without the pointer moving).

@ProviderFor(AltPressedNotifier)
final altPressedProvider = AltPressedNotifierProvider._();

/// Whether Alt is held, updated on every key press and release (so knots
/// react without the pointer moving).
final class AltPressedNotifierProvider
    extends $NotifierProvider<AltPressedNotifier, bool> {
  /// Whether Alt is held, updated on every key press and release (so knots
  /// react without the pointer moving).
  AltPressedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'altPressedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$altPressedNotifierHash();

  @$internal
  @override
  AltPressedNotifier create() => AltPressedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$altPressedNotifierHash() =>
    r'2a0b07b34555b86f4ea1920fb0062461de3df249';

/// Whether Alt is held, updated on every key press and release (so knots
/// react without the pointer moving).

abstract class _$AltPressedNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The knot shown enlarged while Alt is held over a node: the output an
/// Alt+drag would pull, or `null`.

@ProviderFor(altPreviewPort)
final altPreviewPortProvider = AltPreviewPortProvider._();

/// The knot shown enlarged while Alt is held over a node: the output an
/// Alt+drag would pull, or `null`.

final class AltPreviewPortProvider
    extends $FunctionalProvider<PortRef?, PortRef?, PortRef?>
    with $Provider<PortRef?> {
  /// The knot shown enlarged while Alt is held over a node: the output an
  /// Alt+drag would pull, or `null`.
  AltPreviewPortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'altPreviewPortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$altPreviewPortHash();

  @$internal
  @override
  $ProviderElement<PortRef?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PortRef? create(Ref ref) {
    return altPreviewPort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PortRef? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PortRef?>(value),
    );
  }
}

String _$altPreviewPortHash() => r'113f1b356a9c57804f0ff2362b3c1ce5bcc3edbb';
