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

/// The screen being designed.

@ProviderFor(SelectedScreen)
final selectedScreenProvider = SelectedScreenProvider._();

/// The screen being designed.
final class SelectedScreenProvider
    extends $NotifierProvider<SelectedScreen, ScreenKind> {
  /// The screen being designed.
  SelectedScreenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedScreenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedScreenHash();

  @$internal
  @override
  SelectedScreen create() => SelectedScreen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenKind value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenKind>(value),
    );
  }
}

String _$selectedScreenHash() => r'7e0991adf852c5a0cc39489f8c8d770ff408c8d6';

/// The screen being designed.

abstract class _$SelectedScreen extends $Notifier<ScreenKind> {
  ScreenKind build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ScreenKind, ScreenKind>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScreenKind, ScreenKind>,
              ScreenKind,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The style being edited when no element is selected (picked from the
/// style list), or `null`.

@ProviderFor(SelectedScreenStyle)
final selectedScreenStyleProvider = SelectedScreenStyleProvider._();

/// The style being edited when no element is selected (picked from the
/// style list), or `null`.
final class SelectedScreenStyleProvider
    extends $NotifierProvider<SelectedScreenStyle, String?> {
  /// The style being edited when no element is selected (picked from the
  /// style list), or `null`.
  SelectedScreenStyleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedScreenStyleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedScreenStyleHash();

  @$internal
  @override
  SelectedScreenStyle create() => SelectedScreenStyle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedScreenStyleHash() =>
    r'cfe0daaada034302c213354050836aa0cb99d57d';

/// The style being edited when no element is selected (picked from the
/// style list), or `null`.

abstract class _$SelectedScreenStyle extends $Notifier<String?> {
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

@ProviderFor(ChoiceScenarioNotifier)
final choiceScenarioProvider = ChoiceScenarioNotifierProvider._();

final class ChoiceScenarioNotifierProvider
    extends $NotifierProvider<ChoiceScenarioNotifier, ChoiceScenario> {
  ChoiceScenarioNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'choiceScenarioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$choiceScenarioNotifierHash();

  @$internal
  @override
  ChoiceScenarioNotifier create() => ChoiceScenarioNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChoiceScenario value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChoiceScenario>(value),
    );
  }
}

String _$choiceScenarioNotifierHash() =>
    r'29df82d057cfd2ee2ecaf54336fa16cbfac7fccd';

abstract class _$ChoiceScenarioNotifier extends $Notifier<ChoiceScenario> {
  ChoiceScenario build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ChoiceScenario, ChoiceScenario>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChoiceScenario, ChoiceScenario>,
              ChoiceScenario,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The selected element of the screen being designed, or `null`.

@ProviderFor(SelectedScreenElement)
final selectedScreenElementProvider = SelectedScreenElementProvider._();

/// The selected element of the screen being designed, or `null`.
final class SelectedScreenElementProvider
    extends $NotifierProvider<SelectedScreenElement, String?> {
  /// The selected element of the screen being designed, or `null`.
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
    r'cf9cff705b97c339ee7af46c25562cf829e43dd2';

/// The selected element of the screen being designed, or `null`.

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
    r'f524db68f6ef9f154c54b83fb878ed9c6929987d';

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
