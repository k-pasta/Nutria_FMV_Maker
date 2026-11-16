// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the clipboard holds copied nodes. The clipboard can change
/// outside the app at any time and can only be read asynchronously, so this
/// is refreshed at the moments it matters: after copying, when the window
/// regains focus, and when a menu is about to open.

@ProviderFor(ClipboardHasNodes)
final clipboardHasNodesProvider = ClipboardHasNodesProvider._();

/// Whether the clipboard holds copied nodes. The clipboard can change
/// outside the app at any time and can only be read asynchronously, so this
/// is refreshed at the moments it matters: after copying, when the window
/// regains focus, and when a menu is about to open.
final class ClipboardHasNodesProvider
    extends $NotifierProvider<ClipboardHasNodes, bool> {
  /// Whether the clipboard holds copied nodes. The clipboard can change
  /// outside the app at any time and can only be read asynchronously, so this
  /// is refreshed at the moments it matters: after copying, when the window
  /// regains focus, and when a menu is about to open.
  ClipboardHasNodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clipboardHasNodesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clipboardHasNodesHash();

  @$internal
  @override
  ClipboardHasNodes create() => ClipboardHasNodes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$clipboardHasNodesHash() => r'6eddf7b80e6bac30df83db79a809d061107e873d';

/// Whether the clipboard holds copied nodes. The clipboard can change
/// outside the app at any time and can only be read asynchronously, so this
/// is refreshed at the moments it matters: after copying, when the window
/// regains focus, and when a menu is about to open.

abstract class _$ClipboardHasNodes extends $Notifier<bool> {
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

/// Whether the selection has anything that can be copied or duplicated
/// (everything but the origin node can).

@ProviderFor(canCopySelection)
final canCopySelectionProvider = CanCopySelectionProvider._();

/// Whether the selection has anything that can be copied or duplicated
/// (everything but the origin node can).

final class CanCopySelectionProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the selection has anything that can be copied or duplicated
  /// (everything but the origin node can).
  CanCopySelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canCopySelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canCopySelectionHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canCopySelection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canCopySelectionHash() => r'c917580b1dfcb63e00d449bbce6e4383ab48ba7e';
