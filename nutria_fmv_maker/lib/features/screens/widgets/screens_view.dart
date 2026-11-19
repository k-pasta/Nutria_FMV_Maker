// The screen designer: a 16:9 stage with the selected screen drawn as the
// Player draws it (nutria_fmv_screens), a tray of the elements it can have,
// the preview's scenario, and a full-screen preview.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/media_library/providers/media_library_providers.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_number_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_search_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:nutria_fmv_screens/nutria_fmv_screens.dart';

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
      ScreenElementKind.question => t.screenQuestion,
      ScreenElementKind.choices => t.screenChoices,
      ScreenElementKind.timer => t.screenTimer,
      ScreenElementKind.resume => t.screenResume,
      ScreenElementKind.save => t.screenSave,
      ScreenElementKind.mainMenu => t.screenMainMenu,
      ScreenElementKind.back => t.screenBack,
      ScreenElementKind.volume => t.screenVolume,
      ScreenElementKind.subtitles => t.screenSubtitles,
      ScreenElementKind.fullScreen => t.screenFullScreen,
      ScreenElementKind.saves => t.screenSaves,
      ScreenElementKind.text => t.screenText,
    };

/// The name of screen [kind].
String screenKindLabel(ScreenKind kind, AppLocalizations t) => switch (kind) {
  ScreenKind.menu => t.screenKindMenu,
  ScreenKind.choice => t.screenKindChoice,
  ScreenKind.pause => t.screenKindPause,
  ScreenKind.settings => t.screenKindSettings,
  ScreenKind.saves => t.screenKindSaves,
};

/// The name of [screen]: the author's, or its kind's.
String screenLabel(ScreenDesign screen, AppLocalizations t) =>
    screen.name ?? screenKindLabel(screen.kind, t);

/// The texts the Player shows on its own (button names, "On", …), in the
/// editor's language, for drawing screens in the designer.
Map<String, String> screenTexts(AppLocalizations t) => {
  for (final kind in ScreenElementKind.values)
    kind.name: screenElementLabel(kind, t),
  'on': t.screenOn,
  'off': t.screenOff,
  'noSaves': t.screenNoSaves,
};

/// What the designer shows on [screen]: the project's title and
/// description, and sample answers, question, saves and settings by
/// [scenario], with elements that have nothing to show still drawn.
ScreenContent designerContent(
  ProjectDocument doc,
  ScreenDesign screen,
  ChoiceScenario scenario,
  AppLocalizations t,
) {
  final answering = screen.kind == ScreenKind.choice;
  return ScreenContent(
    title: doc.info.title,
    description: doc.info.description,
    question: answering && scenario.question ? t.screenSampleQuestion : null,
    answers: [
      if (answering)
        for (var i = 1; i <= scenario.answers; i++)
          scenario.longText
              ? t.screenSampleLongAnswer(i)
              : t.screenSampleAnswer(i),
    ],
    timeLeft: 0.6,
    volume: 70,
    subtitles: switch (doc.info.languages.firstOrNull) {
      final code? => fmvLanguageLabel(code),
      null => t.screenOff,
    },
    fullScreen: true,
    saves: [t.screenSampleSave],
    texts: screenTexts(t),
    showEmpty: true,
  );
}

/// The family each imported font of [doc]'s styles is loaded under (while
/// one is still loading, it's missing and the text uses the built-in font).
Map<String, String> loadedFonts(WidgetRef ref, ProjectDocument doc) {
  final fonts = <String, String>{};
  for (final style in doc.styles) {
    final path = doc.mediaById(style.fontId)?.path;
    if (path == null) continue;
    final family = ref.watch(mediaFontFamilyProvider(path)).value;
    if (family != null) fonts[path] = family;
  }
  return fonts;
}

/// The Screens view, in the part of the window between the side panels.
class ScreensView extends ConsumerWidget {
  const ScreensView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final panels = ref.watch(panelLayoutProvider);
    final screen = ref.watch(designedScreenProvider);
    final doc = ref.watch(projectDocumentProvider);
    final editor = ref.read(graphEditorProvider);
    final required = kRequiredScreenElements[screen.kind]!;
    final answering = screen.kind == ScreenKind.choice;
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
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              // The tray (and the preview's scenario): as tall as it needs,
              // but in a small window it scrolls instead of squeezing the
              // stage.
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * 0.4,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // One button per kind of element the screen may have
                      // (the ones it must have are always there). Click to
                      // add one; drag one onto the screen to place it.
                      Wrap(
                        spacing: theme.dPanelPadding,
                        runSpacing: theme.dPanelPadding,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          for (final kind in kScreenElementKinds[screen.kind]!)
                            // One of each (but texts); the required ones
                            // are always there.
                            if (!required.contains(kind) &&
                                doc.canAddScreenElement(screen.id, kind))
                              _TrayButton(
                                label: '+ ${screenElementLabel(kind, t)}',
                                kind: kind,
                                onTap: () => editor.addScreenElement(kind),
                              ),
                          NutriaButton.icon(
                            icon: Icons.fullscreen,
                            tooltip: t.screenFullScreenPreview,
                            onTap: () => showScreenPreview(
                              context,
                              doc: doc,
                              screen: screen,
                              scenario: ref.read(choiceScenarioProvider),
                              fonts: loadedFonts(ref, doc),
                              t: t,
                            ),
                          ),
                        ],
                      ),
                      if (answering) ...[
                        SizedBox(height: theme.dPanelPadding),
                        const _ScenarioBar(),
                      ],
                    ],
                  ),
                ),
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
      ),
    );
  }
}

/// Shows [screen] filling the window, as the viewer sees it (answers light
/// up under the mouse). Escape or a click outside the answers closes it.
Future<void> showScreenPreview(
  BuildContext context, {
  required ProjectDocument doc,
  required ScreenDesign screen,
  required ChoiceScenario scenario,
  required Map<String, String> fonts,
  required AppLocalizations t,
}) => Navigator.of(context).push(
  PageRouteBuilder<void>(
    opaque: true,
    pageBuilder: (context, _, _) {
      final content = designerContent(doc, screen, scenario, t);
      void close() => Navigator.of(context).pop();
      return CallbackShortcuts(
        bindings: {const SingleActivator(LogicalKeyboardKey.escape): close},
        child: Focus(
          autofocus: true,
          child: ColoredBox(
            color: const Color(0xFF000000),
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: close,
                  child: ScreenView(
                    screen: fmvScreenOf(doc, screen),
                    background: ScreenBackground.of(doc, screen),
                    fontFamilyOf: (path) => fonts[path],
                    content: ScreenContent(
                      title: content.title,
                      description: content.description,
                      question: content.question,
                      answers: content.answers,
                      timeLeft: content.timeLeft,
                      volume: content.volume,
                      subtitles: content.subtitles,
                      fullScreen: content.fullScreen,
                      saves: content.saves,
                      texts: content.texts,
                      // Clickable, so they light up as in the Player.
                      onAnswer: (_) {},
                      onButton: (_) {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  ),
);

/// A tray button: a click adds the element, a drag places it.
class _TrayButton extends StatelessWidget {
  const _TrayButton({
    required this.label,
    required this.kind,
    required this.onTap,
  });

  final String label;
  final ScreenElementKind kind;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final button = NutriaButton(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.dTextfieldPadding),
        child: NutriaText(text: label),
      ),
    );
    return Draggable<ScreenElementKind>(
      data: kind,
      feedback: Material(
        type: MaterialType.transparency,
        child: Opacity(
          opacity: 0.8,
          child: SizedBox(height: theme.dButtonHeight, child: button),
        ),
      ),
      child: button,
    );
  }
}

/// How the answer screens are previewed: number of answers, long answers,
/// with or without a question. Only changes the preview.
class _ScenarioBar extends ConsumerWidget {
  const _ScenarioBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final scenario = ref.watch(choiceScenarioProvider);
    final notifier = ref.read(choiceScenarioProvider.notifier);
    String yesNo(bool v) => v ? t.essentialsYes : t.essentialsNo;
    Widget cell(Widget child) => SizedBox(width: 220, child: child);
    return Wrap(
      spacing: theme.dSectionPadding,
      runSpacing: theme.dPanelPadding,
      alignment: WrapAlignment.center,
      children: [
        cell(
          NutriaSettingRow(
            label: t.screenPreviewAnswers,
            value: '',
            field: NutriaNumberField(
              text: '${scenario.answers}',
              onStep: (d) => notifier.setAnswers(scenario.answers + d),
              onChanged: (text) {
                if (int.tryParse(text) case final n?) notifier.setAnswers(n);
              },
            ),
          ),
        ),
        cell(
          NutriaSettingRow(
            label: t.screenPreviewLong,
            value: yesNo(scenario.longText),
            onTap: notifier.toggleLongText,
          ),
        ),
        cell(
          NutriaSettingRow(
            label: t.screenPreviewQuestion,
            value: yesNo(scenario.question),
            onTap: notifier.toggleQuestion,
          ),
        ),
        cell(const _BackdropPicker()),
      ],
    );
  }
}

/// Picks what the designer shows behind answer screens (see
/// [DesignerBackdrop]): nothing, the video player's frame, or an imported
/// video.
class _BackdropPicker extends ConsumerWidget {
  const _BackdropPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final backdrop = ref.watch(designerBackdropProvider);
    final notifier = ref.read(designerBackdropProvider.notifier);
    final videos = [
      for (final m in ref.watch(mediaAssetsProvider))
        if (m.isVideo) m,
    ];
    final label = switch (backdrop.kind) {
      DesignerBackdrop.none => t.screenBackdropNone,
      DesignerBackdrop.frame => t.screenBackdropFrame,
      DesignerBackdrop.video =>
        videos.where((v) => v.id == backdrop.videoId).firstOrNull?.fileName ??
            t.screenBackdropNone,
    };
    return NutriaSettingRow(
      label: t.screenBackdrop,
      value: '',
      field: NutriaSearchMenu(
        label: label,
        options: [
          t.screenBackdropNone,
          if (backdrop.frame != null) t.screenBackdropFrame,
          for (final v in videos) v.fileName,
        ],
        searchHint: t.logicSearchVariables,
        onSelected: (i) {
          final frame = backdrop.frame != null ? 1 : 0;
          if (i == 0) {
            notifier.show(DesignerBackdrop.none);
          } else if (i <= frame) {
            notifier.show(DesignerBackdrop.frame);
          } else {
            notifier.showVideo(videos[i - 1 - frame].id);
          }
        },
        onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
      ),
    );
  }
}

/// The designer's backdrop behind an answer screen, filling the stage.
class _Backdrop extends ConsumerWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backdrop = ref.watch(designerBackdropProvider);
    switch (backdrop.kind) {
      case DesignerBackdrop.frame:
        final frame = backdrop.frame;
        if (frame == null) return const SizedBox.shrink();
        return Image.memory(frame, fit: BoxFit.cover, gaplessPlayback: true);
      case DesignerBackdrop.video:
        final path = ref.watch(
          mediaAssetProvider(backdrop.videoId ?? '').select((a) => a?.path),
        );
        if (path == null) return const SizedBox.shrink();
        return _LoopingVideo(key: ValueKey(path), path: path);
      case DesignerBackdrop.none:
        return const SizedBox.shrink();
    }
  }
}

/// A video playing on a loop without sound.
class _LoopingVideo extends StatefulWidget {
  const _LoopingVideo({super.key, required this.path});

  final String path;

  @override
  State<_LoopingVideo> createState() => _LoopingVideoState();
}

class _LoopingVideoState extends State<_LoopingVideo> {
  final Player _player = Player();
  late final VideoController _controller = VideoController(_player);

  @override
  void initState() {
    super.initState();
    _player
      ..setVolume(0)
      ..setPlaylistMode(PlaylistMode.single)
      ..open(Media(widget.path));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Video(
    controller: _controller,
    controls: NoVideoControls,
    fit: BoxFit.cover,
  );
}

/// The screen: the background, the elements and, while dragging, the
/// guides an element snapped to. Images and videos dropped on it become the
/// background, tray buttons dropped on it become elements there; a click
/// on empty space clears the selection.
class _Stage extends ConsumerWidget {
  const _Stage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final screen = ref.watch(designedScreenProvider);
    final doc = ref.watch(projectDocumentProvider);
    final scenario = ref.watch(choiceScenarioProvider);
    final fonts = loadedFonts(ref, doc);
    final selected = ref.watch(selectedScreenElementProvider);
    final guides = ref.watch(screenDragProvider);
    final editor = ref.read(graphEditorProvider);
    final drag = ref.read(screenDragProvider.notifier);
    final select = ref.read(selectedScreenElementProvider.notifier).select;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return DragTarget<Object>(
          onWillAcceptWithDetails: (d) => switch (d.data) {
            final MediaAsset m => m.kind == MediaKind.image || m.isVideo,
            ScreenElementKind() => true,
            _ => false,
          },
          onAcceptWithDetails: (d) {
            switch (d.data) {
              case final MediaAsset m:
                editor.setScreenBackground(m.id);
              case final ScreenElementKind element:
                final box = context.findRenderObject()! as RenderBox;
                final at = box.globalToLocal(d.offset);
                editor.addScreenElement(
                  element,
                  x: at.dx / size.width,
                  y: at.dy / size.height,
                );
            }
          },
          builder: (context, candidates, _) => GestureDetector(
            onTap: () => select(null),
            child: Container(
              decoration: BoxDecoration(
                color: theme.cScreenStage,
                border: Border.all(
                  color: candidates.isNotEmpty ? theme.cAccent : theme.cDivider,
                  width: theme.dSelectionWidth,
                ),
              ),
              child: ClipRect(
                child: Stack(
                  children: [
                    if (screen.kind == ScreenKind.choice)
                      const Positioned.fill(child: _Backdrop()),
                    if (screen.backgroundId == null)
                      // At the top, where elements rarely are.
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.all(theme.dPanelPadding),
                          child: Text(
                            screen.kind == ScreenKind.choice
                                ? t.screenVideoBehind
                                : t.screenDropBackground,
                            style: TextStyle(
                              color: theme.cScreenStageText,
                              fontSize: theme.dTextHeight,
                            ),
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: ScreenView(
                        screen: fmvScreenOf(doc, screen),
                        background: ScreenBackground.of(doc, screen),
                        content: designerContent(doc, screen, scenario, t),
                        fontFamilyOf: (path) => fonts[path],
                        // Still while designing; the preview plays it.
                        animate: false,
                        decorate: (i, element, child) {
                          final e = screen.elements[i];
                          final fills =
                              e.kind == ScreenElementKind.choices &&
                              e.layout.fillsScreen;
                          return MouseRegion(
                            cursor: fills
                                ? SystemMouseCursors.click
                                : SystemMouseCursors.move,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => select(e.id),
                              // Answers that fill the screen have no place to
                              // move to.
                              onPanStart: fills
                                  ? null
                                  : (_) => drag.begin(e.id),
                              onPanUpdate: fills
                                  ? null
                                  : (d) => drag.update(
                                      d.delta.dx / size.width,
                                      d.delta.dy / size.height,
                                    ),
                              onPanEnd: fills ? null : (_) => drag.end(),
                              onPanCancel: fills ? null : drag.end,
                              child: Container(
                                foregroundDecoration: BoxDecoration(
                                  border: selected == e.id
                                      ? Border.all(
                                          color: theme.cAccent,
                                          width: 1.5,
                                        )
                                      : null,
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                      ),
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
          ),
        );
      },
    );
  }
}

/// A screen's background: an image, or a video's thumbnail.
class ScreenBackground extends ConsumerWidget {
  const ScreenBackground({super.key, required this.asset});

  final MediaAsset asset;

  /// The background of [screen], or `null` without one.
  static Widget? of(ProjectDocument doc, ScreenDesign screen) =>
      switch (doc.mediaById(screen.backgroundId)) {
        final asset? => ScreenBackground(asset: asset),
        null => null,
      };

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
