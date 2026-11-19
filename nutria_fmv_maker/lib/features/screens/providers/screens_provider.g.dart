// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screens_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditorViewNotifier)
final editorViewProvider = EditorViewNotifierProvider._();

final class EditorViewNotifierProvider
    extends $NotifierProvider<EditorViewNotifier, EditorView> {
  EditorViewNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editorViewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editorViewNotifierHash();

  @$internal
  @override
  EditorViewNotifier create() => EditorViewNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditorView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditorView>(value),
    );
  }
}

String _$editorViewNotifierHash() =>
    r'29913b801e45e487b8d3a2d147bc81ce20dbbe74';

abstract class _$EditorViewNotifier extends $Notifier<EditorView> {
  EditorView build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EditorView, EditorView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EditorView, EditorView>,
              EditorView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The selected element of the menu screen, or `null`.

@ProviderFor(SelectedScreenElement)
final selectedScreenElementProvider = SelectedScreenElementProvider._();

/// The selected element of the menu screen, or `null`.
final class SelectedScreenElementProvider
    extends $NotifierProvider<SelectedScreenElement, String?> {
  /// The selected element of the menu screen, or `null`.
  SelectedScreenElementProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedScreenElementProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedScreenElementHash();

  @$internal
  @override
  SelectedScreenElement create() => SelectedScreenElement();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedScreenElementHash() =>
    r'59d478e77f73011b72cbcc2a89cf68bee4fe70bb';

/// The selected element of the menu screen, or `null`.

abstract class _$SelectedScreenElement extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Dragging an element on the stage: one undo step per drag, snapping to
/// the middle and to other elements.

@ProviderFor(ScreenDragNotifier)
final screenDragProvider = ScreenDragNotifierProvider._();

/// Dragging an element on the stage: one undo step per drag, snapping to
/// the middle and to other elements.
final class ScreenDragNotifierProvider
    extends $NotifierProvider<ScreenDragNotifier, ScreenGuides?> {
  /// Dragging an element on the stage: one undo step per drag, snapping to
  /// the middle and to other elements.
  ScreenDragNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenDragProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenDragNotifierHash();

  @$internal
  @override
  ScreenDragNotifier create() => ScreenDragNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenGuides? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenGuides?>(value),
    );
  }
}

String _$screenDragNotifierHash() =>
    r'f1b15117e8419c4ea1d1509975ff4397e37ed372';

/// Dragging an element on the stage: one undo step per drag, snapping to
/// the middle and to other elements.

abstract class _$ScreenDragNotifier extends $Notifier<ScreenGuides?> {
  ScreenGuides? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ScreenGuides?, ScreenGuides?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScreenGuides?, ScreenGuides?>,
              ScreenGuides?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
