// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_preview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's preview player. Requires `MediaKit.ensureInitialized()`.

@ProviderFor(previewPlayer)
final previewPlayerProvider = PreviewPlayerProvider._();

/// The app's preview player. Requires `MediaKit.ensureInitialized()`.

final class PreviewPlayerProvider
    extends $FunctionalProvider<PreviewPlayer, PreviewPlayer, PreviewPlayer>
    with $Provider<PreviewPlayer> {
  /// The app's preview player. Requires `MediaKit.ensureInitialized()`.
  PreviewPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'previewPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$previewPlayerHash();

  @$internal
  @override
  $ProviderElement<PreviewPlayer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PreviewPlayer create(Ref ref) {
    return previewPlayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreviewPlayer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreviewPlayer>(value),
    );
  }
}

String _$previewPlayerHash() => r'227bb6621575da4401142a1da6045ee780baa787';

/// The preview's target (`null` when empty). Follows the document: if the
/// previewed node gets another video (also via undo) the preview switches, and
/// if the node or video disappears the preview clears.

@ProviderFor(VideoPreviewNotifier)
final videoPreviewProvider = VideoPreviewNotifierProvider._();

/// The preview's target (`null` when empty). Follows the document: if the
/// previewed node gets another video (also via undo) the preview switches, and
/// if the node or video disappears the preview clears.
final class VideoPreviewNotifierProvider
    extends $NotifierProvider<VideoPreviewNotifier, PreviewTarget?> {
  /// The preview's target (`null` when empty). Follows the document: if the
  /// previewed node gets another video (also via undo) the preview switches, and
  /// if the node or video disappears the preview clears.
  VideoPreviewNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoPreviewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoPreviewNotifierHash();

  @$internal
  @override
  VideoPreviewNotifier create() => VideoPreviewNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreviewTarget? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreviewTarget?>(value),
    );
  }
}

String _$videoPreviewNotifierHash() =>
    r'9f7b865536a28647e9009bc858c9d52b6bd58df5';

/// The preview's target (`null` when empty). Follows the document: if the
/// previewed node gets another video (also via undo) the preview switches, and
/// if the node or video disappears the preview clears.

abstract class _$VideoPreviewNotifier extends $Notifier<PreviewTarget?> {
  PreviewTarget? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PreviewTarget?, PreviewTarget?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PreviewTarget?, PreviewTarget?>,
              PreviewTarget?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the preview shows something the player plays (a video or audio),
/// so the transport controls and player shortcuts apply.

@ProviderFor(previewIsPlayable)
final previewIsPlayableProvider = PreviewIsPlayableProvider._();

/// Whether the preview shows something the player plays (a video or audio),
/// so the transport controls and player shortcuts apply.

final class PreviewIsPlayableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the preview shows something the player plays (a video or audio),
  /// so the transport controls and player shortcuts apply.
  PreviewIsPlayableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'previewIsPlayableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$previewIsPlayableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return previewIsPlayable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$previewIsPlayableHash() => r'07a226201dda7f86674c1fad7fd1be1ceda4466f';
