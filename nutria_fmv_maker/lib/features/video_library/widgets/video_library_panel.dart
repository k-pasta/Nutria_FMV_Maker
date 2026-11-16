// The imported videos: click to preview, drag onto the canvas or a node.
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/video_library/providers/video_library_providers.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/painters/diagonal_stripes_painter.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// Thumbnail width of each library view; `null` for views without one.
double? libraryThumbnailWidth(LibraryView view) => switch (view) {
      LibraryView.largeThumbnails => 180,
      LibraryView.thumbnails => 120,
      LibraryView.smallThumbnails => 80,
      LibraryView.listWithThumbnails => 48,
      LibraryView.list => null,
    };

/// The imported videos as a grid or a list, with an import (+) button that
/// floats over them. Ctrl+wheel, or the right-click menu, changes the size.
class VideoLibraryPanel extends ConsumerWidget {
  const VideoLibraryPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final videos = ref.watch(videoAssetsProvider);
    final previewed = ref.watch(videoPreviewProvider.select((p) => p?.videoId));
    final view = ref.watch(preferencesProvider.select((p) => p.libraryView));
    final preferences = ref.read(preferencesProvider.notifier);
    final grid = view.index <= LibraryView.smallThumbnails.index;

    final entries = [
      for (final video in videos)
        VideoLibraryEntry(
          key: ValueKey(video.id),
          video: video,
          view: view,
          isPreviewed: video.id == previewed,
        ),
    ];

    return Stack(
      children: [
        // The list runs the full height; the import button floats over it,
        // and the bottom padding lets the last row scroll clear of it.
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) => NutriaScrollArea(
              padding: EdgeInsets.fromLTRB(
                theme.dSectionPadding,
                0,
                theme.dSectionPadding,
                theme.dButtonHeight + theme.dSectionPadding * 2,
              ),
              child: NutriaContextMenuArea(
                onOpenChanged:
                    ref.read(overlayProvider.notifier).setContextMenuOpen,
                behavior: HitTestBehavior.opaque,
                itemsAt: (_) => [
                  for (final (option, label, icon) in [
                    (LibraryView.largeThumbnails, t.libraryLargeThumbnails,
                        Icons.photo_size_select_large),
                    (LibraryView.thumbnails, t.libraryThumbnails,
                        Icons.grid_view),
                    (LibraryView.smallThumbnails, t.librarySmallThumbnails,
                        Icons.apps),
                    (LibraryView.listWithThumbnails,
                        t.libraryListWithThumbnails, Icons.view_list),
                    (LibraryView.list, t.libraryList, Icons.list),
                  ])
                    NutriaContextMenuItem(
                      icon: option == view ? Icons.check : icon,
                      label: label,
                      onSelected: () => preferences.setLibraryView(option),
                    ),
                ],
                // Inside the scroll view, so it claims Ctrl+wheel before the
                // scroll view does (the deepest listener is asked first).
                child: Listener(
                  // Also over the empty space between and below videos.
                  behavior: HitTestBehavior.opaque,
                  onPointerSignal: (event) {
                    if (event is! PointerScrollEvent ||
                        !HardwareKeyboard.instance.isControlPressed) {
                      return;
                    }
                    GestureBinding.instance.pointerSignalResolver.register(
                      event,
                      (_) => preferences.stepLibraryView(
                          event.scrollDelta.dy > 0 ? 1 : -1),
                    );
                  },
                  // Fills the panel, so the empty space below the videos
                  // reacts too.
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: math.max(
                          0,
                          constraints.maxHeight -
                              theme.dButtonHeight -
                              theme.dSectionPadding * 2),
                      minWidth: double.infinity,
                    ),
                    child: grid
                        ? Wrap(
                            spacing: theme.dPanelPadding,
                            runSpacing: theme.dPanelPadding,
                            children: entries,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: entries,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          // Left of the scrollbar, so it never covers the scroll thumb.
          right: theme.dSectionPadding + theme.dScrollbarWidth,
          bottom: theme.dSectionPadding,
          child: NutriaButton.icon(
            icon: Icons.add,
            isAccented: true,
            tooltip: t.tooltipImportVideos,
            onTap: () => ref.read(graphEditorProvider).pickAndImportVideos(),
          ),
        ),
      ],
    );
  }
}

/// One video: thumbnail (unless [view] is a plain list) and file name.
/// Click previews it; dragging it onto the canvas creates a node, onto a node
/// sets that node's video.
class VideoLibraryEntry extends ConsumerStatefulWidget {
  const VideoLibraryEntry({
    super.key,
    required this.video,
    required this.view,
    required this.isPreviewed,
  });

  final VideoAsset video;
  final LibraryView view;
  final bool isPreviewed;

  @override
  ConsumerState<VideoLibraryEntry> createState() => _VideoLibraryEntryState();
}

class _VideoLibraryEntryState extends ConsumerState<VideoLibraryEntry> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final view = widget.view;
    final width = libraryThumbnailWidth(view);
    final grid = view.index <= LibraryView.smallThumbnails.index;
    final thumbnail = width == null
        ? null
        : LibraryThumbnail(path: widget.video.path, width: width);
    final name = NutriaText(
      text: widget.video.fileName,
      maxLines: grid ? 2 : 1,
      textAlign: grid ? TextAlign.center : TextAlign.start,
    );
    return Draggable<String>(
      data: widget.video.id,
      // The pointer is at the drop position; the thumbnail is centered on it.
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: LibraryThumbnail(path: widget.video.path, width: 120),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => ref
              .read(videoPreviewProvider.notifier)
              .showVideo(widget.video.id),
          child: Container(
            padding: EdgeInsets.all(
                grid ? theme.dPanelPadding : theme.dPanelPadding / 2),
            // Blends into the panel; a fill shows hover. The previewed video
            // is filled too, and raised in themes with elevation.
            decoration: BoxDecoration(
              color: widget.isPreviewed
                  ? theme.cListSelected
                  : (_hovered ? theme.cButtonHovered : null),
              borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
              boxShadow: widget.isPreviewed && theme.dElevation > 0
                  ? theme.cardShadow()
                  : null,
            ),
            child: grid
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ?thumbnail,
                      SizedBox(height: theme.dPanelPadding),
                      SizedBox(width: width, child: name),
                    ],
                  )
                : Row(
                    children: [
                      if (thumbnail != null) ...[
                        thumbnail,
                        SizedBox(width: theme.dPanelPadding),
                      ],
                      Expanded(child: name),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// A 16:9 thumbnail [width] wide, striped while it loads or if there is
/// none.
class LibraryThumbnail extends ConsumerWidget {
  const LibraryThumbnail({super.key, required this.path, required this.width});

  final String path;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final thumbnail = ref.watch(videoThumbnailProvider(path));
    return SizedBox(
      width: width,
      height: width * 9 / 16,
      child: ClipRect(
        child: switch (thumbnail) {
          AsyncData(value: final bytes?) => Image.memory(
            bytes,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
          _ => CustomPaint(
            painter: DiagonalStripesPainter(
              stripeWidth: 2.5,
              stripeSpacing: 5,
              color: theme.cOutlines,
            ),
            // The error text only where there's room for it.
            child: thumbnail is AsyncLoading || width < 100
                ? null
                : Center(
                    child: NutriaText(
                      text: AppLocalizations.of(context).nodeThumbnailError,
                    ),
                  ),
          ),
        },
      ),
    );
  }
}
