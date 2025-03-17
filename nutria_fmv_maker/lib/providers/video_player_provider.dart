import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'dart:async';

import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/models/node_data.dart';

class VideoPlayerProvider extends ChangeNotifier {
  VideoPlayerProvider() {
    _videoController = VideoController(_player);
    _player.setVolume(100);
  }

  final Player _player = Player();
  late final VideoController _videoController;

  Player get player => _player;
  VideoController get videoController => _videoController;

  VideoData? _currentVideoData;
  VideoData? get currentVideoData => _currentVideoData;

  String? _currentNodeId;

  bool get isVideoPlaying {
    print(player.state.playing);
    return player.state.playing;
  }

  void loadVideo({required VideoData videoData, String? nodeId}) {
    bool updated = _currentVideoData != videoData || _currentNodeId != nodeId;
    if (updated) {
      _currentVideoData = videoData;
      _currentNodeId = nodeId;
      notifyListeners();
      // Load the new video without autoplay
      player.open(Media(videoData.videoPath), play: false);
    }
  }

  @override
  void dispose() {
    // Dispose of subscriptions to avoid memory leaks
    _player.dispose();
    super.dispose();
  }
}
