// Rows shared by the video nodes: thumbnail, file name, expand button.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/video_library/providers/video_library_providers.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/painters/diagonal_stripes_painter.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// The video's thumbnail, or a button to pick a video if there is none.
/// Shows a play mark while the node is in the preview.
class NodeThumbnail extends ConsumerWidget {
  const NodeThumbnail({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final height = NodeMetrics.of(context).thumbnailHeight;
    final videoId = node.videoIdOrNull;
    final path = videoId == null
        ? null
        : ref.watch(videoAssetProvider(videoId).select((v) => v?.path));
    if (path == null) {
      return SizedBox(
        height: height,
        child: Padding(
          padding: EdgeInsets.all(theme.dPanelPadding),
          child: NutriaButton.icon(
            icon: Icons.add,
            tooltip: AppLocalizations.of(context).tooltipPickVideo,
            onTap: () => ref.read(graphEditorProvider).pickVideoFor(node.id),
          ),
        ),
      );
    }
    final previewed = ref.watch(
      videoPreviewProvider.select((p) => p?.nodeId == node.id),
    );
    final thumbnail = ref.watch(videoThumbnailProvider(path));
    return SizedBox(
      height: height,
      // The stripes painter draws past its bounds.
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            switch (thumbnail) {
              AsyncData(value: final bytes?) => Image.memory(
                bytes,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
              AsyncLoading() => const SizedBox.shrink(),
              _ => CustomPaint(
                painter: DiagonalStripesPainter(
                  stripeWidth: 2.5,
                  stripeSpacing: 5,
                  color: theme.cOutlines,
                ),
                child: Center(
                  child: NutriaText(
                    text: AppLocalizations.of(context).nodeThumbnailError,
                  ),
                ),
              ),
            },
            if (previewed)
              Positioned(
                left: theme.dPanelPadding * 2,
                top: theme.dPanelPadding * 2,
                child: Icon(
                  Icons.play_arrow,
                  size: theme.dButtonHeight * 1.5,
                  color: theme.swatch(node.swatch),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The video's file name under the thumbnail. It wraps (anywhere, up to
/// [kFileNameMaxLines] lines), and its height comes from [NodeMetrics] so the
/// knots below it stay in place.
class NodeFileName extends ConsumerWidget {
  const NodeFileName({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = NodeMetrics.of(context);
    final videoId = node.videoIdOrNull;
    final name = videoId == null
        ? null
        : ref.watch(videoAssetProvider(videoId).select((v) => v?.fileName));
    return Padding(
      padding: EdgeInsets.all(metrics.panelPadding),
      child: SizedBox(
        height: metrics.fileNameHeight(name, node.width),
        child: Text(
          NodeMetrics.wrappable(name ?? metrics.noVideoText),
          style: metrics.fileNameStyle,
          textAlign: TextAlign.center,
          maxLines: kFileNameMaxLines,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }
}

/// Opens or closes the node's settings.
class NodeExpandButton extends ConsumerWidget {
  const NodeExpandButton({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) => NutriaButton.icon(
    icon: node.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
    tooltip: AppLocalizations.of(context).tooltipNodeSettings,
    onTap: () => ref.read(graphEditorProvider).toggleExpanded(node.id),
  );
}

/// A row of the node, exactly one button high (so knots line up with it).
class NodeRow extends StatelessWidget {
  const NodeRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: context.appTheme.dButtonHeight,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}
