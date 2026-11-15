// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_drag_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Knots and nodes report hovering here; knots start and end drags.
///
/// The whole drag is one undo transaction named "Connect": picking up a
/// connected output disconnects it, and dropping it on nothing leaves it
/// disconnected (which is how users delete a connection).

@ProviderFor(ConnectionDragNotifier)
final connectionDragProvider = ConnectionDragNotifierProvider._();

/// Knots and nodes report hovering here; knots start and end drags.
///
/// The whole drag is one undo transaction named "Connect": picking up a
/// connected output disconnects it, and dropping it on nothing leaves it
/// disconnected (which is how users delete a connection).
final class ConnectionDragNotifierProvider
    extends $NotifierProvider<ConnectionDragNotifier, CanvasInteraction> {
  /// Knots and nodes report hovering here; knots start and end drags.
  ///
  /// The whole drag is one undo transaction named "Connect": picking up a
  /// connected output disconnects it, and dropping it on nothing leaves it
  /// disconnected (which is how users delete a connection).
  ConnectionDragNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionDragProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionDragNotifierHash();

  @$internal
  @override
  ConnectionDragNotifier create() => ConnectionDragNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CanvasInteraction value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CanvasInteraction>(value),
    );
  }
}

String _$connectionDragNotifierHash() =>
    r'de93517e4d20ca424a2f2cd5b76c2982dbc8e4d7';

/// Knots and nodes report hovering here; knots start and end drags.
///
/// The whole drag is one undo transaction named "Connect": picking up a
/// connected output disconnects it, and dropping it on nothing leaves it
/// disconnected (which is how users delete a connection).

abstract class _$ConnectionDragNotifier extends $Notifier<CanvasInteraction> {
  CanvasInteraction build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CanvasInteraction, CanvasInteraction>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CanvasInteraction, CanvasInteraction>,
              CanvasInteraction,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The connection that would be made if the noodle were dropped now, so
/// knots can highlight it.

@ProviderFor(potentialConnection)
final potentialConnectionProvider = PotentialConnectionProvider._();

/// The connection that would be made if the noodle were dropped now, so
/// knots can highlight it.

final class PotentialConnectionProvider
    extends
        $FunctionalProvider<
          PotentialConnection?,
          PotentialConnection?,
          PotentialConnection?
        >
    with $Provider<PotentialConnection?> {
  /// The connection that would be made if the noodle were dropped now, so
  /// knots can highlight it.
  PotentialConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'potentialConnectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$potentialConnectionHash();

  @$internal
  @override
  $ProviderElement<PotentialConnection?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PotentialConnection? create(Ref ref) {
    return potentialConnection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PotentialConnection? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PotentialConnection?>(value),
    );
  }
}

String _$potentialConnectionHash() =>
    r'e1bf4ff053f3d777a1600e38dbd44a92bfedad13';

/// Whether [port] is the anchor or the target of the drag in progress, so its
/// knot is drawn enlarged. Inputs use [PortRef.input].

@ProviderFor(isKnotActive)
final isKnotActiveProvider = IsKnotActiveFamily._();

/// Whether [port] is the anchor or the target of the drag in progress, so its
/// knot is drawn enlarged. Inputs use [PortRef.input].

final class IsKnotActiveProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether [port] is the anchor or the target of the drag in progress, so its
  /// knot is drawn enlarged. Inputs use [PortRef.input].
  IsKnotActiveProvider._({
    required IsKnotActiveFamily super.from,
    required PortRef super.argument,
  }) : super(
         retry: null,
         name: r'isKnotActiveProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isKnotActiveHash();

  @override
  String toString() {
    return r'isKnotActiveProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as PortRef;
    return isKnotActive(ref, argument);
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
    return other is IsKnotActiveProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isKnotActiveHash() => r'cc29b14e4037f406723081d4d72fb400d1340dcd';

/// Whether [port] is the anchor or the target of the drag in progress, so its
/// knot is drawn enlarged. Inputs use [PortRef.input].

final class IsKnotActiveFamily extends $Family
    with $FunctionalFamilyOverride<bool, PortRef> {
  IsKnotActiveFamily._()
    : super(
        retry: null,
        name: r'isKnotActiveProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether [port] is the anchor or the target of the drag in progress, so its
  /// knot is drawn enlarged. Inputs use [PortRef.input].

  IsKnotActiveProvider call(PortRef port) =>
      IsKnotActiveProvider._(argument: port, from: this);

  @override
  String toString() => r'isKnotActiveProvider';
}
