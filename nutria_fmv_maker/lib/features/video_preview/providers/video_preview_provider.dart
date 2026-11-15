// The video shown in the preview panel and the player that plays it.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_preview_provider.freezed.dart';
part 'video_preview_provider.g.dart';

/// Plays one file at a time. An interface so tests don't need native video.
abstract interface class PreviewPlayer {
  /// Loads [path] paused.
  Future<void> open(String path);
  Future<void> stop();
  void dispose();
}

/// [PreviewPlayer] backed by media_kit. Widgets render [controller].
class MediaKitPreviewPlayer implements PreviewPlayer {
  MediaKitPreviewPlayer() : player = Player() {
    controller = VideoController(player);
  }

  final Player player;
  late final VideoController controller;

  @override
  Future<void> open(String path) => player.open(Media(path), play: false);

  @override
  Future<void> stop() => player.stop();

  @override
  void dispose() => unawaited(player.dispose());
}

/// The app's preview player. Requires `MediaKit.ensureInitialized()`.
@Riverpod(keepAlive: true)
PreviewPlayer previewPlayer(Ref ref) {
  final player = MediaKitPreviewPlayer();
  ref.onDispose(player.dispose);
  return player;
}

/// What the preview shows: a node's video, or a video from the library.
@freezed
abstract class PreviewTarget with _$PreviewTarget {
  const factory PreviewTarget({
    required String videoId,

    /// The node being previewed, if the preview came from a node.
    String? nodeId,
  }) = _PreviewTarget;
}

/// The preview's target (`null` when empty). Follows the document: if the
/// previewed node gets another video (also via undo) the preview switches, and
/// if the node or video disappears the preview clears.
@Riverpod(keepAlive: true)
class VideoPreviewNotifier extends _$VideoPreviewNotifier {
  @override
  PreviewTarget? build() {
    ref.watch(documentProvider.select((s) => s.generation));
    ref.listen(documentProvider.select((s) => s.document), (_, doc) {
      final target = state;
      if (target != null) _show(_retarget(target, doc));
    });
    return null;
  }

  /// Previews node [nodeId]'s video, if it has one.
  void showNode(String nodeId) {
    final doc = ref.read(documentProvider).document;
    final videoId = doc.nodes[nodeId]?.videoIdOrNull;
    if (videoId == null) return;
    _show(PreviewTarget(videoId: videoId, nodeId: nodeId));
  }

  /// Previews library video [videoId], not tied to a node.
  void showVideo(String videoId) => _show(PreviewTarget(videoId: videoId));

  void clear() => _show(null);

  PreviewTarget? _retarget(PreviewTarget target, ProjectDocument doc) {
    final nodeId = target.nodeId;
    if (nodeId == null) {
      return doc.videoById(target.videoId) == null ? null : target;
    }
    final videoId = doc.nodes[nodeId]?.videoIdOrNull;
    return videoId == null ? null : target.copyWith(videoId: videoId);
  }

  void _show(PreviewTarget? target) {
    if (target == state) return;
    final previousVideo = state?.videoId;
    state = target;
    final player = ref.read(previewPlayerProvider);
    if (target == null) {
      unawaited(player.stop());
    } else if (target.videoId != previousVideo) {
      final path = ref.read(documentProvider).document.videoById(target.videoId)?.path;
      if (path != null) unawaited(player.open(path));
    }
  }
}
