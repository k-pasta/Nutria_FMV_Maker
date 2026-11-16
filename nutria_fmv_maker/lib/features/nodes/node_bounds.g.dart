// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_bounds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's node size registry.

@ProviderFor(nodeBounds)
final nodeBoundsProvider = NodeBoundsProvider._();

/// The app's node size registry.

final class NodeBoundsProvider
    extends $FunctionalProvider<NodeBounds, NodeBounds, NodeBounds>
    with $Provider<NodeBounds> {
  /// The app's node size registry.
  NodeBoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeBoundsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeBoundsHash();

  @$internal
  @override
  $ProviderElement<NodeBounds> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NodeBounds create(Ref ref) {
    return nodeBounds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodeBounds value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodeBounds>(value),
    );
  }
}

String _$nodeBoundsHash() => r'911dfcca1209b11cf3bef18edbea55048c2c828a';
