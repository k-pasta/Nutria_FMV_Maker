// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_selectors.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current document. Prefer the narrower providers below in widgets.
///
/// Compared by identity: every edit makes a new document, and comparing two
/// documents field by field on every frame of a drag is slow.

@ProviderFor(ProjectDocumentNotifier)
final projectDocumentProvider = ProjectDocumentNotifierProvider._();

/// The current document. Prefer the narrower providers below in widgets.
///
/// Compared by identity: every edit makes a new document, and comparing two
/// documents field by field on every frame of a drag is slow.
final class ProjectDocumentNotifierProvider
    extends $NotifierProvider<ProjectDocumentNotifier, ProjectDocument> {
  /// The current document. Prefer the narrower providers below in widgets.
  ///
  /// Compared by identity: every edit makes a new document, and comparing two
  /// documents field by field on every frame of a drag is slow.
  ProjectDocumentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectDocumentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectDocumentNotifierHash();

  @$internal
  @override
  ProjectDocumentNotifier create() => ProjectDocumentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectDocument value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectDocument>(value),
    );
  }
}

String _$projectDocumentNotifierHash() =>
    r'd843e5a187aad069ee586ecb130857b60d8c6585';

/// The current document. Prefer the narrower providers below in widgets.
///
/// Compared by identity: every edit makes a new document, and comparing two
/// documents field by field on every frame of a drag is slow.

abstract class _$ProjectDocumentNotifier extends $Notifier<ProjectDocument> {
  ProjectDocument build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProjectDocument, ProjectDocument>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProjectDocument, ProjectDocument>,
              ProjectDocument,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Node [id] without its position: it stays equal while the node is dragged,
/// so the node's content doesn't rebuild on every frame of a move.

@ProviderFor(nodeContent)
final nodeContentProvider = NodeContentFamily._();

/// Node [id] without its position: it stays equal while the node is dragged,
/// so the node's content doesn't rebuild on every frame of a move.

final class NodeContentProvider extends $FunctionalProvider<Node?, Node?, Node?>
    with $Provider<Node?> {
  /// Node [id] without its position: it stays equal while the node is dragged,
  /// so the node's content doesn't rebuild on every frame of a move.
  NodeContentProvider._({
    required NodeContentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'nodeContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nodeContentHash();

  @override
  String toString() {
    return r'nodeContentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Node?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Node? create(Ref ref) {
    final argument = this.argument as String;
    return nodeContent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Node? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Node?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NodeContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nodeContentHash() => r'5fec9a82d8fde8352b4e1e6cb66075a4b0497320';

/// Node [id] without its position: it stays equal while the node is dragged,
/// so the node's content doesn't rebuild on every frame of a move.

final class NodeContentFamily extends $Family
    with $FunctionalFamilyOverride<Node?, String> {
  NodeContentFamily._()
    : super(
        retry: null,
        name: r'nodeContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Node [id] without its position: it stays equal while the node is dragged,
  /// so the node's content doesn't rebuild on every frame of a move.

  NodeContentProvider call(String id) =>
      NodeContentProvider._(argument: id, from: this);

  @override
  String toString() => r'nodeContentProvider';
}

/// Node [id], or `null` once it has been removed.

@ProviderFor(node)
final nodeProvider = NodeFamily._();

/// Node [id], or `null` once it has been removed.

final class NodeProvider extends $FunctionalProvider<Node?, Node?, Node?>
    with $Provider<Node?> {
  /// Node [id], or `null` once it has been removed.
  NodeProvider._({
    required NodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'nodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nodeHash();

  @override
  String toString() {
    return r'nodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Node?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Node? create(Ref ref) {
    final argument = this.argument as String;
    return node(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Node? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Node?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nodeHash() => r'd2f7c952312f4543d866129c0fa0f17c6c37c68a';

/// Node [id], or `null` once it has been removed.

final class NodeFamily extends $Family
    with $FunctionalFamilyOverride<Node?, String> {
  NodeFamily._()
    : super(
        retry: null,
        name: r'nodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Node [id], or `null` once it has been removed.

  NodeProvider call(String id) => NodeProvider._(argument: id, from: this);

  @override
  String toString() => r'nodeProvider';
}

/// Node ids in drawing order: document order, with raised nodes on top.
/// Only notifies when the order actually changes, not on every edit.

@ProviderFor(NodePaintOrder)
final nodePaintOrderProvider = NodePaintOrderProvider._();

/// Node ids in drawing order: document order, with raised nodes on top.
/// Only notifies when the order actually changes, not on every edit.
final class NodePaintOrderProvider
    extends $NotifierProvider<NodePaintOrder, List<String>> {
  /// Node ids in drawing order: document order, with raised nodes on top.
  /// Only notifies when the order actually changes, not on every edit.
  NodePaintOrderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodePaintOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodePaintOrderHash();

  @$internal
  @override
  NodePaintOrder create() => NodePaintOrder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$nodePaintOrderHash() => r'a5773b85b2b05578e3895555913ad74e614b4a35';

/// Node ids in drawing order: document order, with raised nodes on top.
/// Only notifies when the order actually changes, not on every edit.

abstract class _$NodePaintOrder extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Every connection, for drawing noodles.

@ProviderFor(edges)
final edgesProvider = EdgesProvider._();

/// Every connection, for drawing noodles.

final class EdgesProvider
    extends $FunctionalProvider<List<Edge>, List<Edge>, List<Edge>>
    with $Provider<List<Edge>> {
  /// Every connection, for drawing noodles.
  EdgesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'edgesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$edgesHash();

  @$internal
  @override
  $ProviderElement<List<Edge>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Edge> create(Ref ref) {
    return edges(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Edge> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Edge>>(value),
    );
  }
}

String _$edgesHash() => r'45e379989df91b0d1b93eaaf13b00b0603c5bf9e';

/// Whether output [port] is connected.

@ProviderFor(isPortConnected)
final isPortConnectedProvider = IsPortConnectedFamily._();

/// Whether output [port] is connected.

final class IsPortConnectedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether output [port] is connected.
  IsPortConnectedProvider._({
    required IsPortConnectedFamily super.from,
    required PortRef super.argument,
  }) : super(
         retry: null,
         name: r'isPortConnectedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isPortConnectedHash();

  @override
  String toString() {
    return r'isPortConnectedProvider'
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
    return isPortConnected(ref, argument);
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
    return other is IsPortConnectedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isPortConnectedHash() => r'405355da0f871f6b5883780dd25b6c83bc2e6a97';

/// Whether output [port] is connected.

final class IsPortConnectedFamily extends $Family
    with $FunctionalFamilyOverride<bool, PortRef> {
  IsPortConnectedFamily._()
    : super(
        retry: null,
        name: r'isPortConnectedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether output [port] is connected.

  IsPortConnectedProvider call(PortRef port) =>
      IsPortConnectedProvider._(argument: port, from: this);

  @override
  String toString() => r'isPortConnectedProvider';
}

/// Imported video [id], or `null`.

@ProviderFor(videoAsset)
final videoAssetProvider = VideoAssetFamily._();

/// Imported video [id], or `null`.

final class VideoAssetProvider
    extends $FunctionalProvider<VideoAsset?, VideoAsset?, VideoAsset?>
    with $Provider<VideoAsset?> {
  /// Imported video [id], or `null`.
  VideoAssetProvider._({
    required VideoAssetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'videoAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$videoAssetHash();

  @override
  String toString() {
    return r'videoAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<VideoAsset?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VideoAsset? create(Ref ref) {
    final argument = this.argument as String;
    return videoAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoAsset? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoAsset?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VideoAssetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$videoAssetHash() => r'e67673b4d1af85cb276478eb0e4d86bd839b27b2';

/// Imported video [id], or `null`.

final class VideoAssetFamily extends $Family
    with $FunctionalFamilyOverride<VideoAsset?, String> {
  VideoAssetFamily._()
    : super(
        retry: null,
        name: r'videoAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Imported video [id], or `null`.

  VideoAssetProvider call(String id) =>
      VideoAssetProvider._(argument: id, from: this);

  @override
  String toString() => r'videoAssetProvider';
}

/// All imported videos, in import order.

@ProviderFor(videoAssets)
final videoAssetsProvider = VideoAssetsProvider._();

/// All imported videos, in import order.

final class VideoAssetsProvider
    extends
        $FunctionalProvider<
          List<VideoAsset>,
          List<VideoAsset>,
          List<VideoAsset>
        >
    with $Provider<List<VideoAsset>> {
  /// All imported videos, in import order.
  VideoAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoAssetsHash();

  @$internal
  @override
  $ProviderElement<List<VideoAsset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<VideoAsset> create(Ref ref) {
    return videoAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<VideoAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<VideoAsset>>(value),
    );
  }
}

String _$videoAssetsHash() => r'82f0cc1fae22de46b49398173998b2b281b3ceb8';

/// The project's variables, in the order they were added.

@ProviderFor(variables)
final variablesProvider = VariablesProvider._();

/// The project's variables, in the order they were added.

final class VariablesProvider
    extends $FunctionalProvider<List<Variable>, List<Variable>, List<Variable>>
    with $Provider<List<Variable>> {
  /// The project's variables, in the order they were added.
  VariablesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'variablesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$variablesHash();

  @$internal
  @override
  $ProviderElement<List<Variable>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Variable> create(Ref ref) {
    return variables(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Variable> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Variable>>(value),
    );
  }
}

String _$variablesHash() => r'fd405b21337284a28dd03bc629b8371ddc98c420';

/// Variable names that are empty or used twice.

@ProviderFor(conflictingVariableNames)
final conflictingVariableNamesProvider = ConflictingVariableNamesProvider._();

/// Variable names that are empty or used twice.

final class ConflictingVariableNamesProvider
    extends $FunctionalProvider<Set<String>, Set<String>, Set<String>>
    with $Provider<Set<String>> {
  /// Variable names that are empty or used twice.
  ConflictingVariableNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conflictingVariableNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conflictingVariableNamesHash();

  @$internal
  @override
  $ProviderElement<Set<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<String> create(Ref ref) {
    return conflictingVariableNames(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$conflictingVariableNamesHash() =>
    r'61ff37f013458097631de7cc97c1f28177b7cbf0';

/// Project title and description.

@ProviderFor(projectInfo)
final projectInfoProvider = ProjectInfoProvider._();

/// Project title and description.

final class ProjectInfoProvider
    extends $FunctionalProvider<ProjectInfo, ProjectInfo, ProjectInfo>
    with $Provider<ProjectInfo> {
  /// Project title and description.
  ProjectInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectInfoHash();

  @$internal
  @override
  $ProviderElement<ProjectInfo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProjectInfo create(Ref ref) {
    return projectInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectInfo>(value),
    );
  }
}

String _$projectInfoHash() => r'583a1bdc44647ba1e1def2152ebf94a260b6fe46';

/// Project-wide playback settings.

@ProviderFor(projectSettings)
final projectSettingsProvider = ProjectSettingsProvider._();

/// Project-wide playback settings.

final class ProjectSettingsProvider
    extends $FunctionalProvider<VideoSettings, VideoSettings, VideoSettings>
    with $Provider<VideoSettings> {
  /// Project-wide playback settings.
  ProjectSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectSettingsHash();

  @$internal
  @override
  $ProviderElement<VideoSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VideoSettings create(Ref ref) {
    return projectSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoSettings>(value),
    );
  }
}

String _$projectSettingsHash() => r'1364c118fdaeec3402fbfa5d903befe844536948';

/// The settings node [nodeId] actually plays with: the project settings with
/// the node's overrides applied.

@ProviderFor(effectiveSettings)
final effectiveSettingsProvider = EffectiveSettingsFamily._();

/// The settings node [nodeId] actually plays with: the project settings with
/// the node's overrides applied.

final class EffectiveSettingsProvider
    extends $FunctionalProvider<VideoSettings, VideoSettings, VideoSettings>
    with $Provider<VideoSettings> {
  /// The settings node [nodeId] actually plays with: the project settings with
  /// the node's overrides applied.
  EffectiveSettingsProvider._({
    required EffectiveSettingsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'effectiveSettingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$effectiveSettingsHash();

  @override
  String toString() {
    return r'effectiveSettingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<VideoSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VideoSettings create(Ref ref) {
    final argument = this.argument as String;
    return effectiveSettings(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoSettings>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EffectiveSettingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$effectiveSettingsHash() => r'b355fb231ea421d009a2a5f4ef726dc29e0ac446';

/// The settings node [nodeId] actually plays with: the project settings with
/// the node's overrides applied.

final class EffectiveSettingsFamily extends $Family
    with $FunctionalFamilyOverride<VideoSettings, String> {
  EffectiveSettingsFamily._()
    : super(
        retry: null,
        name: r'effectiveSettingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The settings node [nodeId] actually plays with: the project settings with
  /// the node's overrides applied.

  EffectiveSettingsProvider call(String nodeId) =>
      EffectiveSettingsProvider._(argument: nodeId, from: this);

  @override
  String toString() => r'effectiveSettingsProvider';
}

/// Undo/redo availability and the names of the steps, for menus.

@ProviderFor(historyStatus)
final historyStatusProvider = HistoryStatusProvider._();

/// Undo/redo availability and the names of the steps, for menus.

final class HistoryStatusProvider
    extends
        $FunctionalProvider<
          ({bool canRedo, bool canUndo, String? redoLabel, String? undoLabel}),
          ({bool canRedo, bool canUndo, String? redoLabel, String? undoLabel}),
          ({bool canRedo, bool canUndo, String? redoLabel, String? undoLabel})
        >
    with
        $Provider<
          ({bool canRedo, bool canUndo, String? redoLabel, String? undoLabel})
        > {
  /// Undo/redo availability and the names of the steps, for menus.
  HistoryStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyStatusHash();

  @$internal
  @override
  $ProviderElement<
    ({bool canRedo, bool canUndo, String? redoLabel, String? undoLabel})
  >
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ({bool canRedo, bool canUndo, String? redoLabel, String? undoLabel}) create(
    Ref ref,
  ) {
    return historyStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ({bool canRedo, bool canUndo, String? redoLabel, String? undoLabel}) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            ({bool canRedo, bool canUndo, String? redoLabel, String? undoLabel})
          >(value),
    );
  }
}

String _$historyStatusHash() => r'9d1cd229da0fa4d10c8b743a63c3dd58f69075b6';

/// Whether there are unsaved changes.

@ProviderFor(isDirty)
final isDirtyProvider = IsDirtyProvider._();

/// Whether there are unsaved changes.

final class IsDirtyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether there are unsaved changes.
  IsDirtyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isDirtyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isDirtyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isDirty(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isDirtyHash() => r'63378a00722763d5bf35354f85da04b2833ab004';

/// File name of the open project, or `null` if it has never been saved.

@ProviderFor(projectFileName)
final projectFileNameProvider = ProjectFileNameProvider._();

/// File name of the open project, or `null` if it has never been saved.

final class ProjectFileNameProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// File name of the open project, or `null` if it has never been saved.
  ProjectFileNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectFileNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectFileNameHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return projectFileName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$projectFileNameHash() => r'86f8a9762610227c8b2f797302f0e75cb208cf79';
