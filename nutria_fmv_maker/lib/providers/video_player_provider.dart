import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerProvider extends ChangeNotifier {
  VideoPlayerProvider() {
    _videoController = VideoController(_player);
    // print('initialized video player');
    // Set initial volume
    _player.setVolume(100);
  }

  Player _player = Player();
  late VideoController _videoController;

  Player get player => _player;
  VideoController get videoController => _videoController;

  String? _currentVideoPath;
  String? _currentNodeId;
  // bool _isVideoPlaying = false;
  
  bool get isVideoPlaying {print(player.state.playing); return player.state.playing;}

  void loadVideo({required String path, String? NodeId}) {
    bool updated = _currentVideoPath != path || _currentNodeId != NodeId;
    if (updated) {
      _currentVideoPath = path;
      _currentNodeId = NodeId;
      player.open(Media(path), play: false);
    }
    // notifyListeners();
  }
}
