// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The node whose name is being edited in its strip, or `null`.
///
/// The whole edit is one undo transaction: the name is written as it's typed
/// (so the strip and the knots below it move together), [commit] keeps it
/// and [cancel] restores the old one.

@ProviderFor(RenamingNodeNotifier)
final renamingNodeProvider = RenamingNodeNotifierProvider._();

/// The node whose name is being edited in its strip, or `null`.
///
/// The whole edit is one undo transaction: the name is written as it's typed
/// (so the strip and the knots below it move together), [commit] keeps it
/// and [cancel] restores the old one.
final class RenamingNodeNotifierProvider
    extends $NotifierProvider<RenamingNodeNotifier, String?> {
  /// The node whose name is being edited in its strip, or `null`.
  ///
  /// The whole edit is one undo transaction: the name is written as it's typed
  /// (so the strip and the knots below it move together), [commit] keeps it
  /// and [cancel] restores the old one.
  RenamingNodeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'renamingNodeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$renamingNodeNotifierHash();

  @$internal
  @override
  RenamingNodeNotifier create() => RenamingNodeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$renamingNodeNotifierHash() =>
    r'e321d619c5adb025d776e2e1d54662417045f746';

/// The node whose name is being edited in its strip, or `null`.
///
/// The whole edit is one undo transaction: the name is written as it's typed
/// (so the strip and the knots below it move together), [commit] keeps it
/// and [cancel] restores the old one.

abstract class _$RenamingNodeNotifier extends $Notifier<String?> {
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
