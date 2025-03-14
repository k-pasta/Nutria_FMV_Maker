import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'dart:async';

import 'package:nutria_fmv_maker/models/enums_data.dart';

class VideoPlayerProvider extends ChangeNotifier {
  VideoPlayerProvider() {
    _videoController = VideoController(_player);
    _player.setVolume(100);
    _setupMetadataListeners(); // Set up metadata listeners once
  }

  final Player _player = Player();
  late final VideoController _videoController;

  Player get player => _player;
  VideoController get videoController => _videoController;

  String? _currentVideoPath;
  String? _currentNodeId;

  bool get isVideoPlaying {
    print(player.state.playing);
    return player.state.playing;
  }

  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<int?>? _widthSubscription;
  StreamSubscription<int?>? _heightSubscription;
  StreamSubscription<List<VideoTrack>>? _videoTracksSubscription;
  StreamSubscription<List<AudioTrack>>? _audioTracksSubscription;

  void loadVideo({required String path, String? nodeId}) {
    bool updated = _currentVideoPath != path || _currentNodeId != nodeId;
    if (updated) {
      _currentVideoPath = path;
      _currentNodeId = nodeId;

      // Load the new video without autoplay
      player.open(Media(path), play: false);
    }
  }

  void _setupMetadataListeners() {
    // Cancel previous subscriptions if they exist
    _durationSubscription?.cancel();
    _widthSubscription?.cancel();
    _heightSubscription?.cancel();
    // _videoTracksSubscription?.cancel();
    // _audioTracksSubscription?.cancel();

    // Listen for duration updates
    _durationSubscription = player.stream.duration.listen((duration) {
      print("Duration: ${duration.inSeconds} seconds");
    });

    // Listen for video width
    _widthSubscription = player.stream.width.listen((width) {
      print("Width: $width pixels");
    });

    // Listen for video height
    _heightSubscription = player.stream.height.listen((height) {
      print("Height: $height pixels");
    });

    // // Listen for video track metadata
    // _videoTracksSubscription = player.stream.videoTracks.listen((videoTracks) {
    //   if (videoTracks.isNotEmpty) {
    //     print("Video Codec: ${videoTracks.first.codec}");
    //   }
    // });

    // // Listen for audio track metadata
    // _audioTracksSubscription = player.stream.audioTracks.listen((audioTracks) {
    //   if (audioTracks.isNotEmpty) {
    //     print("Audio Codec: ${audioTracks.first.codec}");
    //   }
    // });
  }

  @override
  void dispose() {
    // Dispose of subscriptions to avoid memory leaks
    _durationSubscription?.cancel();
    _widthSubscription?.cancel();
    _heightSubscription?.cancel();
    _videoTracksSubscription?.cancel();
    _audioTracksSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }
}

class VideoMetaData {
  final String? path;
  final String? filename;
  final MediaFileSource? source;
  final int? duration;
  final int? width;
  final int? height;

  const VideoMetaData({
    this.path,
    this.filename,
    this.source,
    this.duration,
    this.width,
    this.height,
  });
}
