// The video shown in the preview panel and the player that plays it.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_preview_provider.freezed.dart';
part 'video_preview_provider.g.dart';

/// A snapshot of the player, for the transport controls.
typedef PlaybackStatus = ({
  Duration position,
  Duration duration,
  bool playing,

  /// 0 to 100.
  double volume,
});

const PlaybackStatus kStoppedStatus = (
  position: Duration.zero,
  duration: Duration.zero,
  playing: false,
  volume: 100,
);

/// Plays one file at a time. An interface so tests don't need native video.
abstract interface class PreviewPlayer {
  /// Loads [path] paused.
  Future<void> open(String path);
  Future<void> stop();
  Future<void> playOrPause();

  /// Jumps to [position], clamped to the video.
  Future<void> seek(Duration position);

  /// [volume] from 0 to 100.
  Future<void> setVolume(double volume);

  /// Updates while the video plays.
  ValueListenable<PlaybackStatus> get status;
  void dispose();
}

/// [PreviewPlayer] backed by media_kit. Widgets render [controller].
class MediaKitPreviewPlayer implements PreviewPlayer {
  MediaKitPreviewPlayer() : player = Player() {
    controller = VideoController(player);
    final stream = player.stream;
    _subscriptions = [
      stream.position.listen(
        (v) => _update(
          (s) => (
            position: v,
            duration: s.duration,
            playing: s.playing,
            volume: s.volume,
          ),
        ),
      ),
      stream.duration.listen(
        (v) => _update(
          (s) => (
            position: s.position,
            duration: v,
            playing: s.playing,
            volume: s.volume,
          ),
        ),
      ),
      stream.playing.listen(
        (v) => _update(
          (s) => (
            position: s.position,
            duration: s.duration,
            playing: v,
            volume: s.volume,
          ),
        ),
      ),
      stream.volume.listen(
        (v) => _update(
          (s) => (
            position: s.position,
            duration: s.duration,
            playing: s.playing,
            volume: v,
          ),
        ),
      ),
    ];
  }

  final Player player;
  late final VideoController controller;
  late final List<StreamSubscription<Object>> _subscriptions;
  final _status = ValueNotifier<PlaybackStatus>(kStoppedStatus);

  void _update(PlaybackStatus Function(PlaybackStatus s) change) =>
      _status.value = change(_status.value);

  @override
  ValueListenable<PlaybackStatus> get status => _status;

  @override
  Future<void> open(String path) => player.open(Media(path), play: false);

  @override
  Future<void> stop() => player.stop();

  @override
  Future<void> playOrPause() => player.playOrPause();

  @override
  Future<void> seek(Duration position) {
    final end = player.state.duration;
    return player.seek(
      position < Duration.zero
          ? Duration.zero
          : (position > end ? end : position),
    );
  }

  @override
  Future<void> setVolume(double volume) =>
      player.setVolume(volume.clamp(0, 100));

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _status.dispose();
    unawaited(player.dispose());
  }
}

/// The app's preview player. Requires `MediaKit.ensureInitialized()`.
@Riverpod(keepAlive: true)
PreviewPlayer previewPlayer(Ref ref) {
  final player = MediaKitPreviewPlayer();
  ref.onDispose(player.dispose);
  return player;
}

/// What the preview shows: a node's video, or a file from the library.
@freezed
abstract class PreviewTarget with _$PreviewTarget {
  const factory PreviewTarget({
    /// The imported file shown; the player plays it if it is a video or
    /// audio.
    required String mediaId,

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
    // Documents are compared by identity: comparing them field by field on
    // every frame of a drag is slow.
    ref.listen(documentProvider, (previous, next) {
      if (identical(previous?.document, next.document)) return;
      final doc = next.document;
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
    _show(PreviewTarget(mediaId: videoId, nodeId: nodeId));
  }

  /// Previews library file [mediaId], not tied to a node.
  void showMedia(String mediaId) => _show(PreviewTarget(mediaId: mediaId));

  void clear() => _show(null);

  PreviewTarget? _retarget(PreviewTarget target, ProjectDocument doc) {
    final nodeId = target.nodeId;
    if (nodeId == null) {
      return doc.mediaById(target.mediaId) == null ? null : target;
    }
    final videoId = doc.nodes[nodeId]?.videoIdOrNull;
    return videoId == null ? null : target.copyWith(mediaId: videoId);
  }

  void _show(PreviewTarget? target) {
    if (target == state) return;
    final previous = state?.mediaId;
    state = target;
    final player = ref.read(previewPlayerProvider);
    final asset = target == null
        ? null
        : ref.read(documentProvider).document.mediaById(target.mediaId);
    if (asset == null || !asset.isPlayable) {
      unawaited(player.stop());
    } else if (asset.id != previous) {
      unawaited(player.open(asset.path));
    }
  }
}

/// Whether the preview shows something the player plays (a video or audio),
/// so the transport controls and player shortcuts apply.
@riverpod
bool previewIsPlayable(Ref ref) {
  final id = ref.watch(videoPreviewProvider.select((p) => p?.mediaId));
  return ref.watch(
    documentProvider.select(
      (s) => s.document.mediaById(id)?.isPlayable ?? false,
    ),
  );
}
