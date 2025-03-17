import 'package:flutter/material.dart';

// Make sure to add following packages to pubspec.yaml:
// * media_kit
// * media_kit_video
// * media_kit_libs_video
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_slider.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/models/enums_ui.dart';
import 'package:nutria_fmv_maker/models/node_data.dart';
import 'package:nutria_fmv_maker/models/video_metadata.dart';
import 'package:nutria_fmv_maker/providers/video_player_provider.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'models/app_theme.dart';
import 'providers/theme_provider.dart'; // Provides [VideoController] & [Video] etc.

class VideoSection extends StatefulWidget {
  const VideoSection({super.key});
  @override
  State<VideoSection> createState() => VideoSectionState();
}

class VideoSectionState extends State<VideoSection> {
  late final Player player;
  late final VideoController controller;
  double? _draggingPosition; // Used for preview while dragging timeline

  static const int fps = 30; // Frames per second TODO: Get from video metadata

  @override
  void initState() {
    VideoPlayerProvider videoPlayerProvider =
        context.read<VideoPlayerProvider>();
    super.initState();
    player = videoPlayerProvider.player;
    //Player();
    controller = videoPlayerProvider.videoController;
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
    VideoPlayerProvider videoPlayerProvider =
        context.read<VideoPlayerProvider>();

    return Padding(
      padding: EdgeInsets.only(
          top: theme.dSectionPadding,
          right: theme.dSectionPadding,
          left: theme.dSectionPadding -
              UiStaticProperties.splitViewDragWidgetSize),
      child: SingleChildScrollView(
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

              // Seek Bar
              StreamBuilder<Duration>(
                stream: player.stream.position, // Listen for position updates
                builder: (context, positionSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;
                  final currentValue =
                      _draggingPosition ?? position.inMilliseconds.toDouble();

                  return StreamBuilder<Duration>(
                    stream:
                        player.stream.duration, // Listen for duration updates
                    builder: (context, durationSnapshot) {
                      final duration = durationSnapshot.data ?? Duration.zero;

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
                              style: TextStyle(color: theme.cText),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: SliderComponentShape.noThumb,
                                  overlayShape: SliderComponentShape.noOverlay,
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
                                        .seek(Duration(
                                            milliseconds: value.toInt()))
                                        .then((_) {
                                      print(
                                          'Seek completed at: ${player.state.position}');
                                      setState(() {
                                        _draggingPosition =
                                            null; // Reset preview
                                      });
                                    });
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
                      child:
                          Icon(Icons.volume_down, color: theme.cTextInactive),
                    ),
                    SizedBox(
                      width: theme.dPanelPadding,
                    ),
                    Expanded(
                      child: StreamBuilder<double>(
                        stream: player.stream.volume,
                        builder: (context, snapshot) {
                          final volume = snapshot.data ?? 100.0;
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
                        child:
                            Icon(Icons.volume_up, color: theme.cTextInactive)),
                  ],
                ),
              ),
              Selector<VideoPlayerProvider, VideoData?>(
                selector: (_, provider) => provider.currentVideoData,
                builder: (_, videoData, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (videoData != null && videoData.metadata != null)
                        ...videoData.metadata!
                            .map((entry) => MetaDataDisplayBox(metaData: entry))
                            .toList(),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MetaDataDisplayBox extends StatelessWidget {
  final MetadataEntry metaData;
  const MetaDataDisplayBox({required this.metaData});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final AppLocalizations t = AppLocalizations.of(context)!;
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: theme.dButtonHeight,
          child: NutriaText(
            text: '${metaData.metadataTitle(t)}:',
            maxLines: 1,
            state: NutriaTextState.inactive,
            textStyle: NutriaTextStyle.italic,
          ),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: SizedBox(
            height: theme.dButtonHeight,
            child: NutriaText(
              text: metaData.metadataValue(t),
              maxLines: 1,
              textStyle: NutriaTextStyle.italic,
            ),
          ),
        )
      ],
    );
  }
}
