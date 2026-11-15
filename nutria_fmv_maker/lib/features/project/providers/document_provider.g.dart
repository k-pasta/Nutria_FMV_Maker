// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Makes unique ids for nodes, choices and videos. Override in tests.

@ProviderFor(idGenerator)
final idGeneratorProvider = IdGeneratorProvider._();

/// Makes unique ids for nodes, choices and videos. Override in tests.

final class IdGeneratorProvider
    extends
        $FunctionalProvider<
          String Function(),
          String Function(),
          String Function()
        >
    with $Provider<String Function()> {
  /// Makes unique ids for nodes, choices and videos. Override in tests.
  IdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idGeneratorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idGeneratorHash();

  @$internal
  @override
  $ProviderElement<String Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  String Function() create(Ref ref) {
    return idGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String Function()>(value),
    );
  }
}

String _$idGeneratorHash() => r'7ed9d637a85516609881508c6bd0e0b849c41c67';

/// Owns the open project. **Every** document change goes through [apply] (or a
/// transaction), which is what makes undo/redo work for every edit.

@ProviderFor(DocumentNotifier)
final documentProvider = DocumentNotifierProvider._();

/// Owns the open project. **Every** document change goes through [apply] (or a
/// transaction), which is what makes undo/redo work for every edit.
final class DocumentNotifierProvider
    extends $NotifierProvider<DocumentNotifier, DocumentState> {
  /// Owns the open project. **Every** document change goes through [apply] (or a
  /// transaction), which is what makes undo/redo work for every edit.
  DocumentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentNotifierHash();

  @$internal
  @override
  DocumentNotifier create() => DocumentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentState>(value),
    );
  }
}

String _$documentNotifierHash() => r'c8e006cb840ed32ba15259c6b27e9a2b140aefd7';

/// Owns the open project. **Every** document change goes through [apply] (or a
/// transaction), which is what makes undo/redo work for every edit.

abstract class _$DocumentNotifier extends $Notifier<DocumentState> {
  DocumentState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DocumentState, DocumentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DocumentState, DocumentState>,
              DocumentState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
