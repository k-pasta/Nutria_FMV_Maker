// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marquee_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The selection box being dragged, in node coordinates (relative to the
/// canvas center), or `null`.

@ProviderFor(MarqueeNotifier)
final marqueeProvider = MarqueeNotifierProvider._();

/// The selection box being dragged, in node coordinates (relative to the
/// canvas center), or `null`.
final class MarqueeNotifierProvider
    extends $NotifierProvider<MarqueeNotifier, Rect?> {
  /// The selection box being dragged, in node coordinates (relative to the
  /// canvas center), or `null`.
  MarqueeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marqueeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marqueeNotifierHash();

  @$internal
  @override
  MarqueeNotifier create() => MarqueeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Rect? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Rect?>(value),
    );
  }
}

String _$marqueeNotifierHash() => r'674b545233f1b75161bb4355b567e82eb7e8aef9';

/// The selection box being dragged, in node coordinates (relative to the
/// canvas center), or `null`.

abstract class _$MarqueeNotifier extends $Notifier<Rect?> {
  Rect? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Rect?, Rect?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Rect?, Rect?>,
              Rect?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
