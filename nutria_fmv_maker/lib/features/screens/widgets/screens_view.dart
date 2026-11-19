// The screen designer: a 16:9 stage with the selected screen's background
// and elements, and a tray of the elements it can have.
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
import 'package:nutria_fmv_maker/ui/widgets/nutria_number_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
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
      ScreenElementKind.question => t.screenQuestion,
      ScreenElementKind.choices => t.screenChoices,
      ScreenElementKind.timer => t.screenTimer,
      ScreenElementKind.resume => t.screenResume,
      ScreenElementKind.save => t.screenSave,
      ScreenElementKind.mainMenu => t.screenMainMenu,
    };

/// The name of screen [kind].
String screenKindLabel(ScreenKind kind, AppLocalizations t) => switch (kind) {
  ScreenKind.menu => t.screenKindMenu,
  ScreenKind.choice => t.screenKindChoice,
  ScreenKind.pause => t.screenKindPause,
};

/// The Screens view, in the part of the window between the side panels.
class ScreensView extends ConsumerWidget {
  const ScreensView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final panels = ref.watch(panelLayoutProvider);
    final screen = ref.watch(selectedScreenProvider);
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
                      // The tray: one button per kind of element. Click to add one;
                      // drag one onto the screen to place it.
                      Wrap(
                        spacing: theme.dPanelPadding,
                        runSpacing: theme.dPanelPadding,
                        alignment: WrapAlignment.center,
                        children: [
                          for (final kind in kScreenElementKinds[screen]!)
                            _TrayButton(
                              label: '+ ${screenElementLabel(kind, t)}',
                              kind: kind,
                              onTap: () => editor.addScreenElement(kind),
                            ),
                        ],
                      ),
                      if (screen == ScreenKind.choice) ...[
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

/// How the choice screen is previewed: number of answers, long answers,
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
      ],
    );
  }
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
    final kind = ref.watch(selectedScreenProvider);
    final screen = ref.watch(
      projectDocumentProvider.select((d) => d.screenOf(kind)),
    );
    final background = ref.watch(videoAssetProvider(screen.backgroundId ?? ''));
    final guides = ref.watch(screenDragProvider);
    final editor = ref.read(graphEditorProvider);
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
            onTap: () =>
                ref.read(selectedScreenElementProvider.notifier).select(null),
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
                    Positioned.fill(
                      child: background != null
                          ? _Background(asset: background)
                          : Center(
                              child: Text(
                                kind == ScreenKind.choice
                                    ? t.screenVideoBehind
                                    : t.screenDropBackground,
                                style: TextStyle(
                                  color: theme.cScreenStageText,
                                  fontSize: theme.dTextHeight,
                                ),
                              ),
                            ),
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
          ),
        );
      },
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
    final scenario = ref.watch(choiceScenarioProvider);
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
    final textStyle = TextStyle(
      fontSize: style.fontSize * h,
      fontWeight: style.bold ? FontWeight.bold : FontWeight.normal,
      fontFamily: family,
      color: Color(style.textColor),
      height: 1.2,
    );
    final radius = BorderRadius.circular(style.radius * h);

    /// One box in the element's style (an answer, a button, the text).
    Widget box(Widget child, {double? height}) => Container(
      width: element.width * stage.width,
      height: height,
      padding: EdgeInsets.all(style.padding * h),
      decoration: BoxDecoration(
        color: Color(
          style.backgroundColor,
        ).withValues(alpha: style.backgroundOpacity),
        borderRadius: radius,
      ),
      child: child,
    );
    Widget text(String value) =>
        Text.rich(markdownSpan(value, textStyle), textAlign: TextAlign.center);

    final Widget content = switch (element.kind) {
      ScreenElementKind.choices => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= scenario.answers; i++) ...[
            if (i > 1) SizedBox(height: element.gap * h),
            box(
              text(
                scenario.longText
                    ? t.screenSampleLongAnswer(i)
                    : t.screenSampleAnswer(i),
              ),
            ),
          ],
        ],
      ),
      // A bar, partly run down, in the text color over the background.
      ScreenElementKind.timer => box(
        Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.6,
            child: Container(
              height: style.fontSize * h * 0.4,
              decoration: BoxDecoration(
                color: Color(style.textColor),
                borderRadius: radius,
              ),
            ),
          ),
        ),
      ),
      ScreenElementKind.question => Opacity(
        // Hidden in the preview when the scenario has no question, but
        // still there to select and move.
        opacity: scenario.question ? 1 : 0.25,
        child: box(text(element.text ?? t.screenSampleQuestion)),
      ),
      _ => box(
        text(
          element.text ??
              switch (element.kind) {
                ScreenElementKind.title => doc.info.title,
                ScreenElementKind.description => doc.info.description,
                _ => null,
              } ??
              screenElementLabel(element.kind, t),
        ),
      ),
    };

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
              foregroundDecoration: BoxDecoration(
                border: selected
                    ? Border.all(color: theme.cAccent, width: 1.5)
                    : null,
                borderRadius: radius,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
