// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_editor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [GraphEditor].

@ProviderFor(graphEditor)
final graphEditorProvider = GraphEditorProvider._();

/// The app's [GraphEditor].

final class GraphEditorProvider
    extends $FunctionalProvider<GraphEditor, GraphEditor, GraphEditor>
    with $Provider<GraphEditor> {
  /// The app's [GraphEditor].
  GraphEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphEditorHash();

  @$internal
  @override
  $ProviderElement<GraphEditor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphEditor create(Ref ref) {
    return graphEditor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphEditor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphEditor>(value),
    );
  }
}

String _$graphEditorHash() => r'2562a80d46dfbb91ac84a1205a9019f4fe851b1c';
