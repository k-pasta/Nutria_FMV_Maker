// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_gesture_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Handles clicks and drags on nodes. Each widget callback calls exactly one
/// method here. Modifier keys are passed in by the widget.

@ProviderFor(NodeGestureNotifier)
final nodeGestureProvider = NodeGestureNotifierProvider._();

/// Handles clicks and drags on nodes. Each widget callback calls exactly one
/// method here. Modifier keys are passed in by the widget.
final class NodeGestureNotifierProvider
    extends $NotifierProvider<NodeGestureNotifier, NodeGesture?> {
  /// Handles clicks and drags on nodes. Each widget callback calls exactly one
  /// method here. Modifier keys are passed in by the widget.
  NodeGestureNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeGestureProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeGestureNotifierHash();

  @$internal
  @override
  NodeGestureNotifier create() => NodeGestureNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodeGesture? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodeGesture?>(value),
    );
  }
}

String _$nodeGestureNotifierHash() =>
    r'acb81f52b71efcc3efac625f920ffafca4f71bdf';

/// Handles clicks and drags on nodes. Each widget callback calls exactly one
/// method here. Modifier keys are passed in by the widget.

abstract class _$NodeGestureNotifier extends $Notifier<NodeGesture?> {
  NodeGesture? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NodeGesture?, NodeGesture?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NodeGesture?, NodeGesture?>,
              NodeGesture?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
