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
import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/models/enums_ui.dart';
import 'package:nutria_fmv_maker/models/node_data/node_data.dart';
import 'package:nutria_fmv_maker/models/video_metadata.dart';
import 'package:nutria_fmv_maker/providers/nodes_provider.dart';
import 'package:nutria_fmv_maker/providers/video_player_provider.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import 'models/app_theme.dart';
import 'models/node_data/video_data.dart';
import 'providers/theme_provider.dart'; // Provides [VideoController] & [Video] etc.

class VideoPlayerSection extends StatefulWidget {
  const VideoPlayerSection({super.key});
  @override
  State<VideoPlayerSection> createState() => VideoPlayerSectionState();
}

class VideoPlayerSectionState extends State<VideoPlayerSection> {
  late final Player player;
  late final VideoController controller;
  double? _draggingPosition; // Used for preview while dragging timeline
  static const int fps = 30; // Frames per second TODO: Get from video metadata

  late final Stream<
      ({
        Duration position,
        Duration duration,
        bool isPlaying,
        double volume
      })> combinedStream; // Declare here

  @override
  void initState() {
    VideoPlayerProvider videoPlayerProvider =
        context.read<VideoPlayerProvider>();
    super.initState();
    player = videoPlayerProvider.player;
    controller = videoPlayerProvider.videoController;

    // Need to initialize combinedStream with initial values using startWith, so it works at all
    combinedStream = Rx.combineLatest4(
      player.stream.position.startWith(Duration.zero),
      player.stream.duration.startWith(Duration.zero),
      player.stream.playing.startWith(false),
      player.stream.volume.startWith(100.0),
      (position, duration, isPlaying, volume) => (
        position: position,
        duration: duration,
        isPlaying: isPlaying,
        volume: volume,
      ),
    );
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
    NodesProvider nodesProvider = context.read<NodesProvider>();

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
              SizedBox(
                height: theme.dPanelPadding,
              ),
              //controls

              StreamBuilder<
                      ({
                        Duration position,
                        Duration duration,
                        bool isPlaying,
                        double volume
                      })>(
                  stream: combinedStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data ??
                        (
                          position: Duration.zero,
                          duration: Duration.zero,
                          isPlaying: false,
                          volume: 100.0
                        );

                    return Column(
                      children: [
                        // Seek Bar

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: theme.dTextfieldPadding,
                                  right: theme.dPanelPadding),
                              child: NutriaText(
                                text: formatTime(Duration(
                                    milliseconds: _draggingPosition?.toInt() ??
                                        data.position.inMilliseconds)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: SliderComponentShape.noThumb,
                                  overlayShape: SliderComponentShape.noOverlay,
                                  trackHeight: 6,
                                ),
                                child: Slider(
                                  min: 0,
                                  value: data.position.inMilliseconds
                                      .toDouble()
                                      .clamp(
                                          0,
                                          data.duration.inMilliseconds
                                              .toDouble()), // Ensure valid default when duration is zero
                                  max: data.duration.inMilliseconds.toDouble(),
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
                            Padding(
                              padding: EdgeInsets.only(
                                left: theme.dPanelPadding,
                                right: theme.dTextfieldPadding,
                              ),
                              child: NutriaText(
                                text: formatTime(data.duration),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: theme.dPanelPadding,
                        ),
                        // Playback Controls
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: theme.dPanelPadding,
                          runSpacing: theme.dPanelPadding,
                          children: [
                            NutriaButton.Icon(
                              icon: Icons.replay_5,
                              onTap: () => seekBy(-5), // Use safe seek
                            ),
                            StreamBuilder<bool>(
                              stream: player.stream.playing,
                              builder: (context, snapshot) {
                                final isPlaying = snapshot.data ?? false;
                                return NutriaButton.Icon(
                                  icon: isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  onTap: () => player.playOrPause(),
                                );
                              },
                            ),
                            NutriaButton.Icon(
                              icon: Icons.forward_5,
                              onTap: () => seekBy(5), // Use safe seek
                            ),
                            Selector<VideoPlayerProvider, String?>(
                              selector: (_, provider) => provider.currentNodeId,
                              builder: (_, currentNodeId, __) {
                                return NutriaButton.Icon(
                                  isAccented: true,
                                  isActive: currentNodeId != null,
                                  icon: Icons.timer,
                                  onTap: () => {
                                    nodesProvider.addOverride(
                                        currentNodeId!,
                                        VideoOverrides.selectionTime.name,
                                        data.duration -
                                            data.position) //TODO implement
                                  }, //TODO important Account for node deletion
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: theme.dPanelPadding,
                        ),
                        // Volume Control
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: theme.dButtonHeight * 4 +
                                  theme.dPanelPadding * 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: theme.dTextHeight,
                                child: Icon(Icons.volume_down,
                                    color: theme.cTextInactive),
                              ),
                              SizedBox(
                                width: theme.dPanelPadding,
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbShape: SliderComponentShape
                                        .noThumb, // Disable the ball
                                    overlayShape: SliderComponentShape
                                        .noOverlay, // Disable the overlay shadow
                                    trackHeight: 6,
                                    activeTickMarkColor: Colors
                                        .transparent, // Hide active division dots
                                    inactiveTickMarkColor: Colors
                                        .transparent, // Hide inactive division dots
                                  ),
                                  child: Slider(
                                    divisions: 100,
                                    label: '${data.volume.toInt()} %',
                                    value: data.volume,
                                    min: 0,
                                    max: 100,
                                    onChanged: (value) =>
                                        player.setVolume(value),
                                    activeColor: theme.cButtonPressed,
                                    inactiveColor: theme.cButton,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: theme.dPanelPadding,
                              ),
                              SizedBox(
                                  height: theme.dTextHeight,
                                  child: Icon(Icons.volume_up,
                                      color: theme.cTextInactive)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
              Selector<VideoPlayerProvider, VideoData?>(
                selector: (_, provider) => provider.currentVideoData,
                builder: (_, videoData, __) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      double maxWidth = constraints.maxWidth;
                      int columnCount = 1;

                      if (maxWidth > 600)
                        columnCount = 2; //TODO move to uistaticproperties
                      if (maxWidth > 900)
                        columnCount = 3; //TODO move to uistaticproperties

                      double itemWidth =
                          (maxWidth / columnCount); // Adjusting for spacing

                      return Wrap(
                        children: [
                          if (videoData != null && videoData.metadata != null)
                            ...videoData.metadata!
                                .map((entry) => SizedBox(
                                      width: itemWidth,
                                      child:
                                          MetaDataDisplayBox(metaData: entry),
                                    ))
                                .toList(),
                        ],
                      );
                    },
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
    final double verticalPadding =
        (theme.dButtonHeight - theme.dTextHeight) / 2;
    return Padding(
      padding: EdgeInsets.only(
        top: verticalPadding,
        bottom: verticalPadding,
        left: theme.dTextfieldPadding,
        right: theme.dTextfieldPadding,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100, //TODO move to uistaticproperties
            child: NutriaText(
              text: '${metaData.metadataTitle(t)}:',
              maxLines: 4,
              state: NutriaTextState.inactive,
              textStyle: NutriaTextStyle.italic,
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: NutriaText(
              text: metaData.metadataValue(t),
              maxLines: 4,
              textStyle: NutriaTextStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
