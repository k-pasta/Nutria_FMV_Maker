// The right panel of the screen designer: which screen to design, the
// styles, and ready-made layouts for the screen.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screens_view.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_confirm_dialog.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// The name of [preset].
String screenPresetLabel(ScreenPreset preset, AppLocalizations t) =>
    switch (preset) {
      ScreenPreset.classicMenu => t.screenPresetClassicMenu,
      ScreenPreset.centeredMenu => t.screenPresetCenteredMenu,
      ScreenPreset.sideMenu => t.screenPresetSideMenu,
      ScreenPreset.bottomChoices => t.screenPresetBottomChoices,
      ScreenPreset.sideChoices => t.screenPresetSideChoices,
      ScreenPreset.classicPause => t.screenPresetClassicPause,
      ScreenPreset.cornerPause => t.screenPresetCornerPause,
    };

/// The right panel while designing screens.
class ScreensSidePanel extends ConsumerWidget {
  const ScreensSidePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final screen = ref.watch(selectedScreenProvider);
    final doc = ref.watch(projectDocumentProvider);
    final selectedStyle = ref.watch(selectedScreenStyleProvider);
    final elementStyle = switch (ref.watch(selectedScreenElementProvider)) {
      final id? => switch (doc.screenElement(id)) {
        final e? => doc.styleOf(e).id,
        null => null,
      },
      null => null,
    };

    Future<void> apply(ScreenPreset preset) async {
      if (doc.screenOf(preset.screen).elements.isNotEmpty) {
        final ok = await showNutriaChoiceDialog<bool>(
          context,
          message: t.screenReplaceLayout(screenPresetLabel(preset, t)),
          choices: [
            (value: false, label: t.essentialsCancel, isAccented: false),
            (value: true, label: t.screenReplace, isAccented: true),
          ],
        );
        if (ok != true) return;
      }
      editor.applyScreenPreset(preset);
    }

    final rows = <Widget>[
      _Header(text: t.screenScreens),
      for (final kind in ScreenKind.values)
        _ListEntry(
          label: screenKindLabel(kind, t),
          detail: '${doc.screenOf(kind).elements.length}',
          selected: kind == screen,
          onTap: () => ref.read(selectedScreenProvider.notifier).select(kind),
        ),
      _Header(text: t.screenStyles),
      for (final style in doc.styles)
        _ListEntry(
          label: style.name,
          detail: t.screenStyleUses(doc.usesOfStyle(style.id)),
          selected: style.id == (selectedStyle ?? elementStyle),
          onTap: () {
            ref.read(selectedScreenElementProvider.notifier).select(null);
            ref.read(selectedScreenStyleProvider.notifier).select(style.id);
          },
        ),
      NutriaButton(
        onTap: () => editor.addScreenStyle(
          t.screenNewStyleName(doc.styles.length + 1),
          fromId: elementStyle ?? selectedStyle ?? 'button',
        ),
        child: NutriaText(text: '+ ${t.screenNewStyle}'),
      ),
      _Header(text: t.screenPresets),
      for (final preset in ScreenPreset.values)
        if (preset.screen == screen)
          NutriaButton(
            onTap: () => apply(preset),
            child: NutriaText(text: screenPresetLabel(preset, t)),
          ),
    ];
    return NutriaScrollArea(
      padding: EdgeInsets.all(theme.dSectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              SizedBox(
                height: rows[i] is _Header
                    ? theme.dSectionPadding * 2
                    : theme.dPanelPadding,
              ),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) =>
      NutriaText(text: text, textStyle: NutriaTextStyle.bold);
}

/// A row to pick from a list: [label], a faint [detail] at the end, and the
/// list highlight when [selected].
class _ListEntry extends StatefulWidget {
  const _ListEntry({
    required this.label,
    required this.detail,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_ListEntry> createState() => _ListEntryState();
}

class _ListEntryState extends State<_ListEntry> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: theme.dButtonHeight,
          padding: EdgeInsets.symmetric(horizontal: theme.dTextfieldPadding),
          decoration: BoxDecoration(
            color: widget.selected
                ? theme.cListSelected
                : (_hovered ? theme.cButtonHovered : Colors.transparent),
            borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
            boxShadow: widget.selected && theme.dElevation > 0
                ? theme.cardShadow()
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: NutriaText(
                  text: widget.label,
                  state: widget.selected
                      ? NutriaTextState.accented
                      : NutriaTextState.normal,
                ),
              ),
              NutriaText(
                text: widget.detail,
                state: NutriaTextState.inactive,
                sizeMultiplier: 0.85,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
