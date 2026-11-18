// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_layout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resizing rules: panels respect their min/max widths, push each other when
/// the window is too narrow, close when dragged well below their minimum, and
/// reopen when dragged back out.

@ProviderFor(PanelLayoutNotifier)
final panelLayoutProvider = PanelLayoutNotifierProvider._();

/// Resizing rules: panels respect their min/max widths, push each other when
/// the window is too narrow, close when dragged well below their minimum, and
/// reopen when dragged back out.
final class PanelLayoutNotifierProvider
    extends $NotifierProvider<PanelLayoutNotifier, PanelLayout> {
  /// Resizing rules: panels respect their min/max widths, push each other when
  /// the window is too narrow, close when dragged well below their minimum, and
  /// reopen when dragged back out.
  PanelLayoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'panelLayoutProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$panelLayoutNotifierHash();

  @$internal
  @override
  PanelLayoutNotifier create() => PanelLayoutNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanelLayout value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanelLayout>(value),
    );
  }
}

String _$panelLayoutNotifierHash() =>
    r'f808f725829caeaff19589cb3181a5f92baf55bb';

/// Resizing rules: panels respect their min/max widths, push each other when
/// the window is too narrow, close when dragged well below their minimum, and
/// reopen when dragged back out.

abstract class _$PanelLayoutNotifier extends $Notifier<PanelLayout> {
  PanelLayout build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PanelLayout, PanelLayout>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PanelLayout, PanelLayout>,
              PanelLayout,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
