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
    r'7208d43e663bbbd62f2229c0473b59fbec923204';

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

/// The node a dragged comment would be attached to if dropped now, so it
/// can light up.

@ProviderFor(CommentDropTarget)
final commentDropTargetProvider = CommentDropTargetProvider._();

/// The node a dragged comment would be attached to if dropped now, so it
/// can light up.
final class CommentDropTargetProvider
    extends $NotifierProvider<CommentDropTarget, String?> {
  /// The node a dragged comment would be attached to if dropped now, so it
  /// can light up.
  CommentDropTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commentDropTargetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentDropTargetHash();

  @$internal
  @override
  CommentDropTarget create() => CommentDropTarget();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$commentDropTargetHash() => r'45458b505694e155ffd3275801ebc82aaf17c22e';

/// The node a dragged comment would be attached to if dropped now, so it
/// can light up.

abstract class _$CommentDropTarget extends $Notifier<String?> {
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
