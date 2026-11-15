// The imported videos: click to preview, drag onto the canvas or a node.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/video_library/providers/video_library_providers.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/painters/diagonal_stripes_painter.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// Width of a video's thumbnail in the library.
const kLibraryThumbnailWidth = 120.0;

/// A grid of the imported videos with an import (+) button.
class VideoLibraryPanel extends ConsumerWidget {
  const VideoLibraryPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final videos = ref.watch(videoAssetsProvider);
    final previewed =
        ref.watch(videoPreviewProvider.select((p) => p?.videoId));
    return Stack(children: [
      Positioned.fill(
        bottom: theme.dButtonHeight + theme.dSectionPadding,
        child: NutriaScrollArea(
          padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
          child: Wrap(children: [
            for (final video in videos)
              VideoLibraryEntry(
                key: ValueKey(video.id),
                video: video,
                isPreviewed: video.id == previewed,
              ),
          ]),
        ),
      ),
      Positioned(
        right: theme.dSectionPadding,
        bottom: theme.dSectionPadding,
        child: NutriaButton.icon(
          icon: Icons.add,
          isAccented: true,
          onTap: () => ref.read(graphEditorProvider).pickAndImportVideos(),
        ),
      ),
    ]);
  }
}

/// One video: thumbnail and file name. Click previews it; dragging it onto
/// the canvas creates a node, onto a node sets that node's video.
class VideoLibraryEntry extends ConsumerStatefulWidget {
  const VideoLibraryEntry(
      {super.key, required this.video, required this.isPreviewed});

  final VideoAsset video;
  final bool isPreviewed;

  @override
  ConsumerState<VideoLibraryEntry> createState() => _VideoLibraryEntryState();
}

class _VideoLibraryEntryState extends ConsumerState<VideoLibraryEntry> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final highlighted = _hovered || widget.isPreviewed;
    final thumbnail = LibraryThumbnail(path: widget.video.path);
    return Draggable<String>(
      data: widget.video.id,
      // The pointer is at the drop position; the thumbnail is centered on it.
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: FractionalTranslation(
          translation: const Offset(-0.5, -0.5), child: thumbnail),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => ref
              .read(videoPreviewProvider.notifier)
              .showVideo(widget.video.id),
          child: Container(
            padding: EdgeInsets.all(theme.dPanelPadding),
            decoration: BoxDecoration(
              color: widget.isPreviewed
                  ? theme.cButton
                  : (_hovered ? theme.cButtonHovered : null),
              borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
              border: Border.all(
                color: highlighted ? theme.cOutlines : Colors.transparent,
                width: theme.dOutlinesWidth,
              ),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              thumbnail,
              SizedBox(height: theme.dPanelPadding),
              SizedBox(
                width: kLibraryThumbnailWidth,
                child: NutriaText(
                  text: widget.video.fileName,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// A 16:9 thumbnail, striped while it loads or if there is none.
class LibraryThumbnail extends ConsumerWidget {
  const LibraryThumbnail({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final thumbnail = ref.watch(videoThumbnailProvider(path));
    return SizedBox(
      width: kLibraryThumbnailWidth,
      height: kLibraryThumbnailWidth * 9 / 16,
      child: ClipRect(
        child: switch (thumbnail) {
          AsyncData(value: final bytes?) =>
            Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true),
          _ => CustomPaint(
              painter: DiagonalStripesPainter(
                  stripeWidth: 2.5, stripeSpacing: 5, color: theme.cOutlines),
              child: thumbnail is AsyncLoading
                  ? null
                  : Center(
                      child: NutriaText(
                          text:
                              AppLocalizations.of(context).nodeThumbnailError),
                    ),
            ),
        },
      ),
    );
  }
}
