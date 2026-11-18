// The imported media: click a video to preview it, drag one onto the canvas
// or a node. Sorted and grouped as the user chooses.
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_commands.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/video_library/library_order.dart';
import 'package:nutria_fmv_maker/features/video_library/providers/video_library_providers.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/painters/diagonal_stripes_painter.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';

/// Thumbnail width of each library view; `null` for views without one.
double? libraryThumbnailWidth(LibraryView view) => switch (view) {
  LibraryView.largeThumbnails => 180,
  LibraryView.thumbnails => 120,
  LibraryView.smallThumbnails => 80,
  LibraryView.listWithThumbnails => 48,
  LibraryView.list => null,
};

/// The icon standing for media of [kind] where there's no thumbnail.
IconData mediaKindIcon(MediaKind kind) => switch (kind) {
  MediaKind.video => Icons.movie,
  MediaKind.audio => Icons.music_note,
  MediaKind.image => Icons.image,
  MediaKind.subtitle => Icons.subtitles,
  MediaKind.font => Icons.font_download,
};

/// The title of a library group (see [LibraryGroup.key]).
String libraryGroupTitle(AppLocalizations t, Object? key) => switch (key) {
  MediaKind.video => t.mediaKindVideo,
  MediaKind.audio => t.mediaKindAudio,
  MediaKind.image => t.mediaKindImage,
  MediaKind.subtitle => t.mediaKindSubtitle,
  MediaKind.font => t.mediaKindFont,
  final String extension when extension.isNotEmpty => extension.toUpperCase(),
  _ => '?',
};

/// The imported media as a grid or a list, optionally in collapsible groups,
/// with an import (+) button that floats over them. Ctrl+wheel, or the
/// right-click menu, changes the size; the menu also sorts and groups.
class VideoLibraryPanel extends ConsumerWidget {
  const VideoLibraryPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final media = ref.watch(mediaAssetsProvider);
    final previewed = ref.watch(videoPreviewProvider.select((p) => p?.mediaId));
    // Linked subtitles are shown with their video only.
    final linked = ref.watch(linkedSubtitleIdsProvider);
    final listed = linked.isEmpty
        ? media
        : [
            for (final asset in media)
              if (!linked.contains(asset.id)) asset,
          ];
    final (view, sort, grouping) = ref.watch(
      preferencesProvider.select(
        (p) => (p.libraryView, p.librarySort, p.libraryGrouping),
      ),
    );
    final collapsed = ref.watch(collapsedLibraryGroupsProvider);
    final preferences = ref.read(preferencesProvider.notifier);
    final grid = view.index <= LibraryView.smallThumbnails.index;
    final groups = libraryGroups(listed, sort, grouping);

    Widget entriesOf(List<MediaAsset> list) {
      final entries = [
        for (final asset in list)
          VideoLibraryEntry(
            key: ValueKey(asset.id),
            video: asset,
            view: view,
            isPreviewed: asset.id == previewed,
          ),
      ];
      return grid
          ? Wrap(
              spacing: theme.dPanelPadding,
              runSpacing: theme.dPanelPadding,
              children: entries,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: entries,
            );
    }

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
                onOpenChanged: ref
                    .read(overlayProvider.notifier)
                    .setContextMenuOpen,
                behavior: HitTestBehavior.opaque,
                itemsAt: (_) => [
                  for (final (option, label, icon) in [
                    (
                      LibraryView.largeThumbnails,
                      t.libraryLargeThumbnails,
                      Icons.photo_size_select_large,
                    ),
                    (
                      LibraryView.thumbnails,
                      t.libraryThumbnails,
                      Icons.grid_view,
                    ),
                    (
                      LibraryView.smallThumbnails,
                      t.librarySmallThumbnails,
                      Icons.apps,
                    ),
                    (
                      LibraryView.listWithThumbnails,
                      t.libraryListWithThumbnails,
                      Icons.view_list,
                    ),
                    (LibraryView.list, t.libraryList, Icons.list),
                  ])
                    NutriaContextMenuItem(
                      icon: option == view ? Icons.check : icon,
                      label: label,
                      onSelected: () => preferences.setLibraryView(option),
                    ),
                  const NutriaContextMenuItem.divider(),
                  for (final (option, label, icon) in [
                    (
                      LibrarySort.dateAdded,
                      t.librarySortDateAdded,
                      Icons.schedule,
                    ),
                    (LibrarySort.name, t.librarySortName, Icons.sort_by_alpha),
                    (LibrarySort.type, t.librarySortType, Icons.category),
                  ])
                    NutriaContextMenuItem(
                      icon: option == sort ? Icons.check : icon,
                      label: label,
                      onSelected: () => preferences.setLibrarySort(option),
                    ),
                  const NutriaContextMenuItem.divider(),
                  for (final (option, label, icon) in [
                    (
                      LibraryGrouping.none,
                      t.libraryGroupNone,
                      Icons.view_agenda,
                    ),
                    (
                      LibraryGrouping.kind,
                      t.libraryGroupKind,
                      Icons.folder_copy,
                    ),
                    (
                      LibraryGrouping.fileType,
                      t.libraryGroupFileType,
                      Icons.description,
                    ),
                  ])
                    NutriaContextMenuItem(
                      icon: option == grouping ? Icons.check : icon,
                      label: label,
                      onSelected: () => preferences.setLibraryGrouping(option),
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
                        event.scrollDelta.dy > 0 ? 1 : -1,
                      ),
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
                            theme.dSectionPadding * 2,
                      ),
                      minWidth: double.infinity,
                    ),
                    child: grouping == LibraryGrouping.none
                        ? entriesOf(groups.single.media)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final group in groups) ...[
                                LibraryGroupHeader(
                                  title: libraryGroupTitle(t, group.key),
                                  count: group.media.length,
                                  isCollapsed: collapsed.contains(group.key),
                                  onTap: () => ref
                                      .read(
                                        collapsedLibraryGroupsProvider.notifier,
                                      )
                                      .toggle(group.key!),
                                ),
                                if (!collapsed.contains(group.key)) ...[
                                  entriesOf(group.media),
                                  SizedBox(height: theme.dPanelPadding),
                                ],
                              ],
                            ],
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
            onTap: () => ref.read(graphEditorProvider).pickAndImportMedia(),
          ),
        ),
      ],
    );
  }
}

/// A group's title row: an arrow, the title and how many files it holds.
/// Clicking it collapses or expands the group.
class LibraryGroupHeader extends StatelessWidget {
  const LibraryGroupHeader({
    super.key,
    required this.title,
    required this.count,
    required this.isCollapsed,
    required this.onTap,
  });

  final String title;
  final int count;
  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: theme.dButtonHeight,
          child: Row(
            children: [
              Icon(
                isCollapsed ? Icons.chevron_right : Icons.expand_more,
                size: theme.dTextHeight * 1.4,
                color: theme.cTextInactive,
              ),
              SizedBox(width: theme.dPanelPadding),
              Flexible(child: NutriaText(text: title)),
              SizedBox(width: theme.dPanelPadding),
              NutriaText(text: '$count', state: NutriaTextState.inactive),
            ],
          ),
        ),
      ),
    );
  }
}

/// One imported file: thumbnail (unless [view] is a plain list) and file
/// name. Clicking a video previews it; dragging one onto the canvas creates a
/// node, onto a node sets that node's video.
class VideoLibraryEntry extends ConsumerStatefulWidget {
  const VideoLibraryEntry({
    super.key,
    required this.video,
    required this.view,
    required this.isPreviewed,
  });

  final MediaAsset video;
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
    final t = AppLocalizations.of(context);
    final view = widget.view;
    final width = libraryThumbnailWidth(view);
    final grid = view.index <= LibraryView.smallThumbnails.index;
    final asset = widget.video;
    final missing = ref.watch(
      missingMediaProvider.select((ids) => ids.contains(asset.id)),
    );
    final subtitles = asset.subtitleId == null
        ? null
        : ref.watch(videoAssetProvider(asset.subtitleId!));
    final commands = AppCommands(context, ref);
    final name = NutriaText(
      text: asset.fileName,
      maxLines: grid ? 2 : 1,
      textAlign: grid ? TextAlign.center : TextAlign.start,
      // Missing files stand out, in the accent color.
      state: missing ? NutriaTextState.accented : NutriaTextState.normal,
    );
    final subtitlesMark = Icon(
      Icons.closed_caption,
      size: theme.dTextHeight * 1.2,
      color: theme.cTextActive,
    );

    Widget? picture = width == null
        ? null
        : MediaThumbnail(asset: asset, width: width);
    if (picture != null && missing) picture = _MissingMark(child: picture);
    if (picture != null && grid && subtitles != null) {
      picture = Stack(
        children: [
          picture,
          Positioned(
            right: theme.dPanelPadding / 2,
            bottom: theme.dPanelPadding / 2,
            child: subtitlesMark,
          ),
        ],
      );
    }

    // Blends into the panel; a fill shows hover (or a subtitle file about to
    // be dropped). The previewed file is filled too, and raised in themes
    // with elevation.
    Widget card(bool highlighted) => Container(
      padding: EdgeInsets.all(
        grid ? theme.dPanelPadding : theme.dPanelPadding / 2,
      ),
      decoration: BoxDecoration(
        color: widget.isPreviewed
            ? theme.cListSelected
            : (highlighted ? theme.cButtonHovered : null),
        borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
        boxShadow: widget.isPreviewed && theme.dElevation > 0
            ? theme.cardShadow()
            : null,
      ),
      child: grid
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ?picture,
                SizedBox(height: theme.dPanelPadding),
                SizedBox(width: width, child: name),
              ],
            )
          : Row(
              children: [
                picture ??
                    // The plain list shows what kind each file is.
                    Icon(
                      missing ? Icons.link_off : mediaKindIcon(asset.kind),
                      size: theme.dTextHeight * 1.2,
                      color: missing ? theme.cAccent : theme.cTextInactive,
                    ),
                SizedBox(width: theme.dPanelPadding),
                Expanded(child: name),
                if (subtitles != null) subtitlesMark,
              ],
            ),
    );

    return Draggable<MediaAsset>(
      data: asset,
      // The pointer is at the drop position; the thumbnail is centered on it.
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: MediaThumbnail(asset: asset, width: 120),
      ),
      child: NutriaContextMenuArea(
        onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
        itemsAt: (_) => [
          if (missing)
            NutriaContextMenuItem(
              icon: Icons.search,
              label: t.mediaFindMissing,
              onSelected: () => commands.findMissingFile(asset.id),
            ),
          if (subtitles != null)
            NutriaContextMenuItem(
              icon: Icons.subtitles_off,
              label: t.mediaUnlinkSubtitles,
              onSelected: () =>
                  ref.read(graphEditorProvider).unlinkSubtitle(asset.id),
            ),
          NutriaContextMenuItem(
            icon: Icons.swap_horiz,
            label: t.mediaReplace,
            onSelected: () => commands.replaceMedia(asset.id),
          ),
        ],
        child: NutriaTooltip(
          message: missing
              ? t.tooltipMissingFile(asset.path)
              : (subtitles == null
                    ? null
                    : t.tooltipHasSubtitles(subtitles.fileName)),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTap: () =>
                  ref.read(videoPreviewProvider.notifier).showMedia(asset.id),
              // A subtitle file dropped on a video is linked to it.
              child: DragTarget<MediaAsset>(
                onWillAcceptWithDetails: (details) =>
                    asset.isVideo && details.data.kind == MediaKind.subtitle,
                onAcceptWithDetails: (details) =>
                    commands.linkSubtitle(asset.id, details.data.id),
                builder: (context, candidates, _) =>
                    card(_hovered || candidates.isNotEmpty),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// [child] dimmed, with a broken-link icon over it: the file is missing.
class _MissingMark extends StatelessWidget {
  const _MissingMark({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0.35, child: child),
        Icon(Icons.link_off, color: theme.cAccent, size: theme.dButtonHeight),
      ],
    );
  }
}

/// A 16:9 picture of [asset], [width] wide: a video's thumbnail, an image
/// itself, or the icon of its kind.
class MediaThumbnail extends StatelessWidget {
  const MediaThumbnail({super.key, required this.asset, required this.width});

  final MediaAsset asset;
  final double width;

  @override
  Widget build(BuildContext context) => switch (asset.kind) {
    MediaKind.video => LibraryThumbnail(path: asset.path, width: width),
    MediaKind.image => SizedBox(
      width: width,
      height: width * 9 / 16,
      child: Image.file(
        File(asset.path),
        fit: BoxFit.cover,
        cacheWidth: (width * MediaQuery.devicePixelRatioOf(context)).round(),
        gaplessPlayback: true,
        errorBuilder: (_, _, _) =>
            MediaKindTile(kind: asset.kind, width: width),
      ),
    ),
    _ => MediaKindTile(kind: asset.kind, width: width),
  };
}

/// A 16:9 tile [width] wide with the icon of [kind].
class MediaKindTile extends StatelessWidget {
  const MediaKindTile({super.key, required this.kind, required this.width});

  final MediaKind kind;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      width: width,
      height: width * 9 / 16,
      color: theme.cTextField,
      child: Icon(
        mediaKindIcon(kind),
        size: width * 0.22,
        color: theme.cTextInactive,
      ),
    );
  }
}

/// A 16:9 video thumbnail [width] wide, striped while it loads or if there
/// is none.
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
