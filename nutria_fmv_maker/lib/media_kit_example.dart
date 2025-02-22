import 'package:flutter/material.dart';

// Make sure to add following packages to pubspec.yaml:
// * media_kit
// * media_kit_video
// * media_kit_libs_video
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_slider.dart';
import 'package:provider/provider.dart';

import 'models/app_theme.dart';
import 'providers/theme_provider.dart'; // Provides [VideoController] & [Video] etc.

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});
  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  late final Player player;
  late final VideoController controller;
  double? _draggingPosition; // Used for preview while dragging

  static const int fps = 30; // Frames per second TODO: Get from video metadata

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);

    // Load video
    player.open(Media('c:/Users/cgbook/Desktop/Eykolo_anoigma_roughcut_4.mp4'));

    // Set initial volume
    player.setVolume(50);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  /// Format duration to HH:MM:SS:FF
  String formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final frames = ((duration.inMilliseconds % 1000) / (1000 / fps))
        .floor(); // Convert ms to frames

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}:'
        '${frames.toString().padLeft(2, '0')}';
  }

  /// Seeks safely within valid bounds
  void seekBy(int seconds) {
    final currentPosition = player.state.position.inSeconds;
    final duration = player.state.duration.inSeconds;

    // New seek position within valid range
    final newPosition = (currentPosition + seconds).clamp(0, duration);

    player.seek(Duration(seconds: newPosition));
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return SingleChildScrollView(
      child: Container(
        color: theme.cPanel,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            // Video Player View
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Video(
                controller: controller,
                controls: (state) => const SizedBox.shrink(),
              ),
            ),

            // Seek Bar (Fixed)
            StreamBuilder<Duration>(
              stream: player.stream.position,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = player.state.duration;

                final currentValue =
                    _draggingPosition ?? position.inMilliseconds.toDouble();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                          textAlign: TextAlign.center,
                          formatTime(Duration(
                              milliseconds: _draggingPosition?.toInt() ??
                                  position.inMilliseconds)),
                          style: TextStyle(color: theme.cText)),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: SliderComponentShape
                                .noThumb, // Disable the ball
                            overlayShape: SliderComponentShape
                                .noOverlay, // Disable the overlay shadow
                            trackHeight: 5,
                          ),
                          child: Slider(
                            min: 0,
                            value: currentValue.clamp(
                                0, duration.inMilliseconds.toDouble()),
                            max: duration.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _draggingPosition =
                                    value; // Preview dragging position
                              });
                            },
                            onChangeEnd: (value) {
                              player
                                  .seek(Duration(milliseconds: value.toInt()))
                                  .then((_) {
                                print(
                                    'Seek completed at: ${player.state.position}');
                                setState(() {
                                  _draggingPosition = null; // Reset preview
                                });
                              }); // Seek after release
                            },
                            activeColor: theme.cAccent,
                            inactiveColor: theme.cButton,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: Text(
                        formatTime(duration),
                        style: TextStyle(color: theme.cText),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),

            // Playback Controls (Fixed Seek)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NutriaButton.Icon(
                  icon: Icons.replay_5,
                  onTap: () => seekBy(-5), // Use safe seek
                ),
                SizedBox(
                  width: theme.dPanelPadding,
                ),
                StreamBuilder<bool>(
                  stream: player.stream.playing,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return NutriaButton.Icon(
                      icon: isPlaying ? Icons.pause : Icons.play_arrow,
                      // color: Colors.white,
                      // ),
                      onTap: () => player.playOrPause(),
                    );
                  },
                ),
                SizedBox(
                  width: theme.dPanelPadding,
                ),
                NutriaButton.Icon(
                  icon: Icons.forward_5,
                  onTap: () => seekBy(5), // Use safe seek
                ),
              ],
            ),

            // Volume Control
            SizedBox(
              width: theme.dButtonHeight * 5 + theme.dPanelPadding * 4,
              child: Row(
                children: [
                  SizedBox(
                    width: theme.dButtonHeight,
                    child: Icon(Icons.volume_down, color: theme.cTextInactive),
                  ),
                  SizedBox(
                    width: theme.dPanelPadding,
                  ),
                  Expanded(
                    child: StreamBuilder<double>(
                      stream: player.stream.volume,
                      builder: (context, snapshot) {
                        final volume = snapshot.data ?? 50.0;
                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: SliderComponentShape
                                .noThumb, // Disable the ball
                            overlayShape: SliderComponentShape
                                .noOverlay, // Disable the overlay shadow
                            trackHeight: 5,
                          ),
                          child: Slider(
                            divisions: 100,
                            label: '${volume.toInt()} %',
                            value: volume,
                            min: 0,
                            max: 100,
                            onChanged: (value) => player.setVolume(value),
                            activeColor: theme.cButtonPressed,
                            inactiveColor: theme.cButton,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: theme.dPanelPadding,
                  ),
                  SizedBox(
                      width: theme.dButtonHeight,
                      child: Icon(Icons.volume_up, color: theme.cTextInactive)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
