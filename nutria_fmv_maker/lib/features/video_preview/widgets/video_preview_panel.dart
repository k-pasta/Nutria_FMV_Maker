// The right panel: the previewed video, its transport controls and details.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/features/media_library/providers/media_library_providers.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/video_info_format.dart';
import 'package:nutria_fmv_maker/features/video_preview/widgets/media_details.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_slider.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';

/// Seconds skipped by the rewind / fast-forward buttons.
const _kSkip = Duration(seconds: 5);

/// The right panel: the previewed video with transport controls and its
/// file information.
class VideoPreviewPanel extends ConsumerWidget {
  const VideoPreviewPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final player = ref.watch(previewPlayerProvider);
    final target = ref.watch(videoPreviewProvider);
    final asset = target == null
        ? null
        : ref.watch(mediaAssetProvider(target.mediaId));
    if (asset != null && !asset.isPlayable) {
      return NutriaScrollArea(
        padding: EdgeInsets.all(theme.dSectionPadding),
        child: MediaDetails(asset: asset),
      );
    }
    final path = asset?.path;
    final info = path == null ? null : ref.watch(videoInfoProvider(path)).value;
    return NutriaScrollArea(
      padding: EdgeInsets.all(theme.dSectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ColoredBox(
              color: theme.cBackground,
              child: asset?.kind == MediaKind.audio
                  ? Icon(
                      Icons.music_note,
                      size: theme.dButtonHeight * 1.5,
                      color: theme.cTextInactive,
                    )
                  : player is MediaKitPreviewPlayer
                  ? Video(
                      controller: player.controller,
                      controls: NoVideoControls,
                      fill: theme.cBackground,
                    )
                  : null,
            ),
          ),
          SizedBox(height: theme.dPanelPadding),
          ValueListenableBuilder(
            valueListenable: player.status,
            builder: (context, status, _) => _Transport(
              player: player,
              status: status,
              frameRate: info?.frameRate ?? kFallbackFrameRate,
              nodeId: target?.nodeId,
            ),
          ),
          if (info != null) ...[
            SizedBox(height: theme.dPanelPadding * 2),
            for (final (label, value) in videoInfoRows(
              info,
              AppLocalizations.of(context),
            ))
              _InfoRow(label: label, value: value),
          ],
        ],
      ),
    );
  }
}

/// Timeline, play/skip buttons and volume.
class _Transport extends ConsumerStatefulWidget {
  const _Transport({
    required this.player,
    required this.status,
    required this.frameRate,
    required this.nodeId,
  });

  final PreviewPlayer player;
  final PlaybackStatus status;
  final double frameRate;

  /// The previewed node, if the preview came from one.
  final String? nodeId;

  @override
  ConsumerState<_Transport> createState() => _TransportState();
}

class _TransportState extends ConsumerState<_Transport> {
  /// Where the timeline is being dragged to; shown until the seek lands.
  double? _scrubMs;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final status = widget.status;
    final player = widget.player;
    final nodeId = widget.nodeId;
    final isBranched =
        nodeId != null &&
        ref.watch(nodeProvider(nodeId).select((n) => n is BranchedVideoNode));
    final positionMs = _scrubMs ?? status.position.inMilliseconds.toDouble();
    final gap = SizedBox(width: theme.dPanelPadding);
    final t = AppLocalizations.of(context);
    return Column(
      children: [
        // Full width; the panel can be too narrow for timecodes beside it.
        NutriaSlider(
          value: positionMs,
          max: status.duration.inMilliseconds.toDouble(),
          isAccented: true,
          onChanged: (ms) => setState(() => _scrubMs = ms),
          onChangeEnd: (ms) async {
            await player.seek(Duration(milliseconds: ms.round()));
            if (mounted) setState(() => _scrubMs = null);
          },
        ),
        SizedBox(height: theme.dPanelPadding),
        Row(
          children: [
            Expanded(
              child: NutriaText(
                text: formatTimecode(
                  Duration(milliseconds: positionMs.round()),
                  frameRate: widget.frameRate,
                ),
              ),
            ),
            Expanded(
              child: NutriaText(
                text: formatTimecode(
                  status.duration,
                  frameRate: widget.frameRate,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: theme.dPanelPadding),
        // Wraps onto more lines when the panel is narrow.
        Wrap(
          alignment: WrapAlignment.center,
          spacing: theme.dPanelPadding,
          runSpacing: theme.dPanelPadding,
          children: [
            NutriaButton.icon(
              icon: Icons.replay_5,
              tooltip: t.tooltipBack5,
              onTap: () => player.seek(status.position - _kSkip),
            ),
            NutriaButton.icon(
              icon: status.playing ? Icons.pause : Icons.play_arrow,
              tooltip: t.tooltipPlayPause,
              onTap: player.playOrPause,
            ),
            NutriaButton.icon(
              icon: Icons.forward_5,
              tooltip: t.tooltipForward5,
              onTap: () => player.seek(status.position + _kSkip),
            ),
            // The choices appear for the rest of the video from here on.
            NutriaButton.icon(
              icon: Icons.timer,
              isAccented: true,
              tooltip: t.tooltipChoicesFromHere,
              isActive: isBranched,
              onTap: () {
                if (!isBranched) return;
                final remaining = status.duration - status.position;
                ref
                    .read(graphEditorProvider)
                    .editOverrides(
                      nodeId,
                      (o) =>
                          o.copyWith(selectionTimeMs: remaining.inMilliseconds),
                    );
              },
            ),
          ],
        ),
        SizedBox(height: theme.dPanelPadding),
        // The hint is on the icons, not around the row: a Tooltip around a
        // Slider crashes the Windows engine when the window is resized.
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: theme.dButtonHeight * 4 + theme.dPanelPadding * 3,
          ),
          child: Row(
            children: [
              NutriaTooltip(
                message: t.tooltipVolume,
                child: Icon(
                  Icons.volume_down,
                  color: theme.cTextInactive,
                  size: theme.dTextHeight,
                ),
              ),
              gap,
              Expanded(
                child: NutriaSlider(
                  value: status.volume,
                  max: 100,
                  onChanged: player.setVolume,
                ),
              ),
              gap,
              NutriaTooltip(
                message: t.tooltipVolume,
                child: Icon(
                  Icons.volume_up,
                  color: theme.cTextInactive,
                  size: theme.dTextHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: (theme.dButtonHeight - theme.dTextHeight) / 2,
        horizontal: theme.dTextfieldPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: NutriaText(
              text: '$label:',
              maxLines: 4,
              state: NutriaTextState.inactive,
              textStyle: NutriaTextStyle.italic,
            ),
          ),
          Expanded(
            flex: 3,
            child: NutriaText(
              text: value,
              maxLines: 4,
              textStyle: NutriaTextStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
