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

/// Imported file [id], or `null`.

@ProviderFor(mediaAsset)
final mediaAssetProvider = MediaAssetFamily._();

/// Imported file [id], or `null`.

final class MediaAssetProvider
    extends $FunctionalProvider<MediaAsset?, MediaAsset?, MediaAsset?>
    with $Provider<MediaAsset?> {
  /// Imported file [id], or `null`.
  MediaAssetProvider._({
    required MediaAssetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mediaAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaAssetHash();

  @override
  String toString() {
    return r'mediaAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MediaAsset?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaAsset? create(Ref ref) {
    final argument = this.argument as String;
    return mediaAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaAsset? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaAsset?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MediaAssetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaAssetHash() => r'1fa31dc8ac7edbd79372e77853682fc377f210d6';

/// Imported file [id], or `null`.

final class MediaAssetFamily extends $Family
    with $FunctionalFamilyOverride<MediaAsset?, String> {
  MediaAssetFamily._()
    : super(
        retry: null,
        name: r'mediaAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Imported file [id], or `null`.

  MediaAssetProvider call(String id) =>
      MediaAssetProvider._(argument: id, from: this);

  @override
  String toString() => r'mediaAssetProvider';
}

/// All imported videos, in import order.

@ProviderFor(mediaAssets)
final mediaAssetsProvider = MediaAssetsProvider._();

/// All imported videos, in import order.

final class MediaAssetsProvider
    extends
        $FunctionalProvider<
          List<MediaAsset>,
          List<MediaAsset>,
          List<MediaAsset>
        >
    with $Provider<List<MediaAsset>> {
  /// All imported videos, in import order.
  MediaAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaAssetsHash();

  @$internal
  @override
  $ProviderElement<List<MediaAsset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<MediaAsset> create(Ref ref) {
    return mediaAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MediaAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MediaAsset>>(value),
    );
  }
}

String _$mediaAssetsHash() => r'd9cca2d07d2470e5728b3cf37a99ffa6e91b6bf8';

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

/// Variable names shown as errors: invalid or used twice.

@ProviderFor(invalidVariableNames)
final invalidVariableNamesProvider = InvalidVariableNamesProvider._();

/// Variable names shown as errors: invalid or used twice.

final class InvalidVariableNamesProvider
    extends $FunctionalProvider<Set<String>, Set<String>, Set<String>>
    with $Provider<Set<String>> {
  /// Variable names shown as errors: invalid or used twice.
  InvalidVariableNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invalidVariableNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invalidVariableNamesHash();

  @$internal
  @override
  $ProviderElement<Set<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<String> create(Ref ref) {
    return invalidVariableNames(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$invalidVariableNamesHash() =>
    r'aa5241cf8a721ccd73b30eb650d5e6b6d0759122';

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

/// Defaults for other colors than the first, by swatch index.

@ProviderFor(colorDefaults)
final colorDefaultsProvider = ColorDefaultsProvider._();

/// Defaults for other colors than the first, by swatch index.

final class ColorDefaultsProvider
    extends
        $FunctionalProvider<
          Map<int, VideoSettings>,
          Map<int, VideoSettings>,
          Map<int, VideoSettings>
        >
    with $Provider<Map<int, VideoSettings>> {
  /// Defaults for other colors than the first, by swatch index.
  ColorDefaultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorDefaultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorDefaultsHash();

  @$internal
  @override
  $ProviderElement<Map<int, VideoSettings>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<int, VideoSettings> create(Ref ref) {
    return colorDefaults(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, VideoSettings> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, VideoSettings>>(value),
    );
  }
}

String _$colorDefaultsHash() => r'5ee47809d7f79f71b39fd3e76ae9aa421b737f91';

/// The settings node [nodeId] actually plays with: its color's defaults with
/// the node's overrides applied.

@ProviderFor(effectiveSettings)
final effectiveSettingsProvider = EffectiveSettingsFamily._();

/// The settings node [nodeId] actually plays with: its color's defaults with
/// the node's overrides applied.

final class EffectiveSettingsProvider
    extends $FunctionalProvider<VideoSettings, VideoSettings, VideoSettings>
    with $Provider<VideoSettings> {
  /// The settings node [nodeId] actually plays with: its color's defaults with
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

String _$effectiveSettingsHash() => r'474802a11b468153b7608b51ff3a517efdff4be4';

/// The settings node [nodeId] actually plays with: its color's defaults with
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

  /// The settings node [nodeId] actually plays with: its color's defaults with
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
