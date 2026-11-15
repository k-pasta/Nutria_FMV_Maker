// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The node selection. Resets when another project is opened.

@ProviderFor(SelectionNotifier)
final selectionProvider = SelectionNotifierProvider._();

/// The node selection. Resets when another project is opened.
final class SelectionNotifierProvider
    extends $NotifierProvider<SelectionNotifier, SelectionState> {
  /// The node selection. Resets when another project is opened.
  SelectionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectionNotifierHash();

  @$internal
  @override
  SelectionNotifier create() => SelectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectionState>(value),
    );
  }
}

String _$selectionNotifierHash() => r'96bd47fffe25e027975c2f9add625513f001e315';

/// The node selection. Resets when another project is opened.

abstract class _$SelectionNotifier extends $Notifier<SelectionState> {
  SelectionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SelectionState, SelectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SelectionState, SelectionState>,
              SelectionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether node [id] is selected.

@ProviderFor(isNodeSelected)
final isNodeSelectedProvider = IsNodeSelectedFamily._();

/// Whether node [id] is selected.

final class IsNodeSelectedProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether node [id] is selected.
  IsNodeSelectedProvider._({
    required IsNodeSelectedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isNodeSelectedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isNodeSelectedHash();

  @override
  String toString() {
    return r'isNodeSelectedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return isNodeSelected(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsNodeSelectedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isNodeSelectedHash() => r'1c4ecb7b45c2d0ea4d416e52af8c7f900d4767dc';

/// Whether node [id] is selected.

final class IsNodeSelectedFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  IsNodeSelectedFamily._()
    : super(
        retry: null,
        name: r'isNodeSelectedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether node [id] is selected.

  IsNodeSelectedProvider call(String id) =>
      IsNodeSelectedProvider._(argument: id, from: this);

  @override
  String toString() => r'isNodeSelectedProvider';
}
