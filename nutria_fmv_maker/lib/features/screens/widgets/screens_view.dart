// The screen designer: a 16:9 stage with the menu's background and
// elements, and a tray to add elements.
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/video_library/providers/video_library_providers.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/text/markdown_text.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// What element [kind] says unless it has its own text.
String screenElementLabel(ScreenElementKind kind, AppLocalizations t) =>
    switch (kind) {
      ScreenElementKind.title => t.screenTitle,
      ScreenElementKind.description => t.screenDescription,
      ScreenElementKind.start => t.screenStart,
      ScreenElementKind.load => t.screenLoad,
      ScreenElementKind.settings => t.screenSettings,
      ScreenElementKind.credits => t.screenCredits,
      ScreenElementKind.quit => t.screenQuit,
    };

/// The Screens view, in the part of the window between the side panels.
class ScreensView extends ConsumerWidget {
  const ScreensView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final panels = ref.watch(panelLayoutProvider);
    final editor = ref.read(graphEditorProvider);
    return ColoredBox(
      color: theme.cBackground,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          (panels.leftClosed ? 0 : panels.left + kPanelHandleWidth) +
              theme.dSectionPadding * 2,
          theme.dSectionPadding * 2,
          (panels.rightClosed ? 0 : panels.right + kPanelHandleWidth) +
              theme.dSectionPadding * 2,
          theme.dSectionPadding * 2,
        ),
        child: Column(
          children: [
            // The tray: one button per kind of element.
            Wrap(
              spacing: theme.dPanelPadding,
              runSpacing: theme.dPanelPadding,
              alignment: WrapAlignment.center,
              children: [
                for (final kind in ScreenElementKind.values)
                  NutriaButton(
                    onTap: () => editor.addScreenElement(kind),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.dTextfieldPadding,
                      ),
                      child: NutriaText(
                        text: '+ ${screenElementLabel(kind, t)}',
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: theme.dSectionPadding * 2),
            const Expanded(
              child: Center(
                child: AspectRatio(aspectRatio: 16 / 9, child: _Stage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The screen: the background, the elements and, while dragging, the
/// guides an element snapped to. Images and videos dropped on it become the
/// background; a click on empty space clears the selection.
class _Stage extends ConsumerWidget {
  const _Stage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final screen = ref.watch(
      projectDocumentProvider.select((d) => d.menuScreen),
    );
    final background = ref.watch(videoAssetProvider(screen.backgroundId ?? ''));
    final guides = ref.watch(screenDragProvider);
    final editor = ref.read(graphEditorProvider);
    return DragTarget<MediaAsset>(
      onWillAcceptWithDetails: (d) =>
          d.data.kind == MediaKind.image || d.data.isVideo,
      onAcceptWithDetails: (d) => editor.setMenuBackground(d.data.id),
      builder: (context, candidates, _) => LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          return GestureDetector(
            onTap: () =>
                ref.read(selectedScreenElementProvider.notifier).select(null),
            child: Container(
              decoration: BoxDecoration(
                color: theme.cPanel,
                border: Border.all(
                  color: candidates.isNotEmpty ? theme.cAccent : theme.cDivider,
                  width: theme.dSelectionWidth,
                ),
              ),
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: background == null
                          ? Center(
                              child: NutriaText(
                                text: t.screenDropBackground,
                                state: NutriaTextState.inactive,
                              ),
                            )
                          : _Background(asset: background),
                    ),
                    for (final element in screen.elements)
                      _ElementView(
                        key: ValueKey(element.id),
                        element: element,
                        stage: size,
                      ),
                    if (guides?.x case final x?)
                      Positioned(
                        left: x * size.width,
                        top: 0,
                        bottom: 0,
                        child: Container(width: 1, color: theme.cAccent),
                      ),
                    if (guides?.y case final y?)
                      Positioned(
                        top: y * size.height,
                        left: 0,
                        right: 0,
                        child: Container(height: 1, color: theme.cAccent),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Background extends ConsumerWidget {
  const _Background({required this.asset});

  final MediaAsset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (asset.kind == MediaKind.image) {
      return Image.file(
        File(asset.path),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      );
    }
    final bytes = ref.watch(videoThumbnailProvider(asset.path)).value;
    return bytes == null
        ? const SizedBox.shrink()
        : Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
  }
}

/// One element, drawn in its style at the size it has on a [stage]-sized
/// screen. Dragging moves it; clicking selects it.
class _ElementView extends ConsumerWidget {
  const _ElementView({super.key, required this.element, required this.stage});

  final ScreenElement element;
  final Size stage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final doc = ref.watch(projectDocumentProvider);
    final style = doc.styleOf(element);
    final selected = ref.watch(
      selectedScreenElementProvider.select((id) => id == element.id),
    );
    final font = style.fontId == null
        ? null
        : doc.mediaById(style.fontId)?.path;
    final family = font == null
        ? null
        : ref.watch(mediaFontFamilyProvider(font)).value;
    final h = stage.height;
    final text =
        element.text ??
        switch (element.kind) {
          ScreenElementKind.title => doc.info.title,
          ScreenElementKind.description => doc.info.description,
          _ => null,
        } ??
        screenElementLabel(element.kind, t);
    final textStyle = TextStyle(
      fontSize: style.fontSize * h,
      fontWeight: style.bold ? FontWeight.bold : FontWeight.normal,
      fontFamily: family,
      color: Color(style.textColor),
      height: 1.2,
    );
    final drag = ref.read(screenDragProvider.notifier);
    return Positioned(
      left: element.x * stage.width,
      top: element.y * h,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: MouseRegion(
          cursor: SystemMouseCursors.move,
          child: GestureDetector(
            onTap: () => ref
                .read(selectedScreenElementProvider.notifier)
                .select(element.id),
            onPanStart: (_) => drag.begin(element.id),
            onPanUpdate: (d) =>
                drag.update(d.delta.dx / stage.width, d.delta.dy / h),
            onPanEnd: (_) => drag.end(),
            onPanCancel: drag.end,
            child: Container(
              width: element.width * stage.width,
              padding: EdgeInsets.all(style.padding * h),
              decoration: BoxDecoration(
                color: Color(
                  style.backgroundColor,
                ).withValues(alpha: style.backgroundOpacity),
                borderRadius: BorderRadius.circular(style.radius * h),
              ),
              foregroundDecoration: BoxDecoration(
                border: selected
                    ? Border.all(color: theme.cAccent, width: 1.5)
                    : null,
                borderRadius: BorderRadius.circular(style.radius * h),
              ),
              child: Text.rich(
                markdownSpan(text, textStyle),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
