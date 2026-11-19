// The right panel of the screen designer: which screen to design (and new
// answer screens), the styles, and ready-made layouts for the screen.
// Screens and styles are renamed here (double-click or right-click).
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screens_view.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_confirm_dialog.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

/// The name of [preset].
String screenPresetLabel(ScreenPreset preset, AppLocalizations t) =>
    switch (preset) {
      ScreenPreset.classicMenu => t.screenPresetClassicMenu,
      ScreenPreset.centeredMenu => t.screenPresetCenteredMenu,
      ScreenPreset.sideMenu => t.screenPresetSideMenu,
      ScreenPreset.bottomChoices => t.screenPresetBottomChoices,
      ScreenPreset.rowChoices => t.screenPresetRowChoices,
      ScreenPreset.sideChoices => t.screenPresetSideChoices,
      ScreenPreset.splitChoices => t.screenPresetSplitChoices,
      ScreenPreset.pieChoices => t.screenPresetPieChoices,
      ScreenPreset.stackedChoices => t.screenPresetStackedChoices,
      ScreenPreset.classicPause => t.screenPresetClassicPause,
      ScreenPreset.cornerPause => t.screenPresetCornerPause,
      ScreenPreset.classicSettings => t.screenPresetClassicSettings,
      ScreenPreset.classicSaves => t.screenPresetClassicSaves,
    };

/// The right panel while designing screens.
class ScreensSidePanel extends ConsumerStatefulWidget {
  const ScreensSidePanel({super.key});

  @override
  ConsumerState<ScreensSidePanel> createState() => _ScreensSidePanelState();
}

class _ScreensSidePanelState extends ConsumerState<ScreensSidePanel> {
  /// What is being renamed: `('screen', id)`, `('style', id)` or `null`.
  (String, String)? _renaming;
  Object _renameSession = Object();

  void _rename(String what, String id) => setState(() {
    _renaming = (what, id);
    _renameSession = Object();
  });

  void _stopRenaming() => setState(() => _renaming = null);

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final screen = ref.watch(designedScreenProvider);
    final doc = ref.watch(projectDocumentProvider);
    final selectedStyle = ref.watch(selectedScreenStyleProvider);
    final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
    final elementStyle = switch (ref.watch(selectedScreenElementProvider)) {
      final id? => switch (doc.screenElement(id)) {
        final e? => doc.styleOf(e).id,
        null => null,
      },
      null => null,
    };

    Future<void> apply(ScreenPreset preset) async {
      final ok = await showNutriaChoiceDialog<bool>(
        context,
        message: t.screenReplaceLayout(screenPresetLabel(preset, t)),
        choices: [
          (value: false, label: t.essentialsCancel, isAccented: false),
          (value: true, label: t.screenReplace, isAccented: true),
        ],
      );
      if (ok == true) editor.applyScreenPreset(preset);
    }

    Widget screenEntry(ScreenDesign s) {
      final used = switch (s.kind) {
        ScreenKind.settings => doc.hasSettingsScreen,
        ScreenKind.saves => doc.hasSavesScreen,
        _ => true,
      };
      return _ListEntry(
        label: screenLabel(s, t),
        detail: used ? '${s.elements.length}' : t.screenNotUsed,
        selected: s.id == screen.id,
        renaming: _renaming == ('screen', s.id),
        renameHint: t.screenNameHint,
        onRenamed: (name) =>
            editor.renameScreen(s.id, name, mergeKey: _renameSession),
        onRenameDone: _stopRenaming,
        onTap: () => ref.read(selectedScreenProvider.notifier).select(s.id),
        onDoubleTap: () => _rename('screen', s.id),
        menu: [
          NutriaContextMenuItem(
            icon: Icons.edit,
            label: t.screenRename,
            onSelected: () => _rename('screen', s.id),
          ),
          if (doc.canRemoveScreen(s.id))
            NutriaContextMenuItem(
              icon: Icons.delete,
              label: t.screenDeleteScreen,
              onSelected: () => editor.removeScreen(s.id),
            ),
        ],
        onMenuOpenChanged: menuOpen,
      );
    }

    Widget addButton(ScreenKind kind, String label) => NutriaButton(
      onTap: () => editor.addScreen(
        kind,
        t.screenNewScreenName(
          screenKindLabel(kind, t),
          doc.screensOf(kind).length + 1,
        ),
      ),
      child: NutriaText(text: '+ $label'),
    );

    final rows = <Widget>[
      _Header(text: t.screenScreens),
      for (final kind in ScreenKind.values) ...[
        for (final s in doc.screensOf(kind)) screenEntry(s),
        if (kind == ScreenKind.choice)
          addButton(kind, t.screenNewChoiceScreen)
        else if (kind == ScreenKind.endChoice)
          addButton(kind, t.screenNewEndChoiceScreen),
      ],
      _Header(text: t.screenStyles),
      for (final style in doc.styles)
        _ListEntry(
          label: style.name,
          detail: t.screenStyleUses(doc.usesOfStyle(style.id)),
          selected: style.id == (selectedStyle ?? elementStyle),
          renaming: _renaming == ('style', style.id),
          renameHint: t.screenRenameHint,
          onRenamed: (name) => editor.renameScreenStyle(
            style.id,
            name,
            mergeKey: _renameSession,
          ),
          onRenameDone: _stopRenaming,
          onTap: () {
            ref.read(selectedScreenElementProvider.notifier).select(null);
            ref.read(selectedScreenStyleProvider.notifier).select(style.id);
          },
          onDoubleTap: () => _rename('style', style.id),
          menu: [
            NutriaContextMenuItem(
              icon: Icons.edit,
              label: t.screenRename,
              onSelected: () => _rename('style', style.id),
            ),
            if (!ScreenOps.isBuiltInStyle(style.id))
              NutriaContextMenuItem(
                icon: Icons.delete,
                label: t.screenDeleteStyle,
                onSelected: () => editor.removeScreenStyle(style.id),
              ),
          ],
          onMenuOpenChanged: menuOpen,
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
        if (preset.kind == screen.kind)
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
/// list highlight when [selected]. While [renaming], the label is a text
/// field ([onRenamed] per keystroke; Enter or leaving it calls
/// [onRenameDone]). Right-click shows [menu].
class _ListEntry extends StatefulWidget {
  const _ListEntry({
    required this.label,
    required this.detail,
    required this.selected,
    required this.onTap,
    required this.renaming,
    required this.renameHint,
    required this.onRenamed,
    required this.onRenameDone,
    required this.onDoubleTap,
    required this.menu,
    required this.onMenuOpenChanged,
  });

  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onTap;
  final bool renaming;
  final String renameHint;
  final ValueChanged<String> onRenamed;
  final VoidCallback onRenameDone;
  final VoidCallback onDoubleTap;
  final List<NutriaContextMenuItem> menu;
  final ValueChanged<bool> onMenuOpenChanged;

  @override
  State<_ListEntry> createState() => _ListEntryState();
}

class _ListEntryState extends State<_ListEntry> {
  bool _hovered = false;

  /// When the last click was. A second one soon after is a double-click;
  /// counted here because a double-tap recognizer would hold every single
  /// click back until it knows there's no second one.
  DateTime? _lastTap;

  void _onTap() {
    final now = DateTime.now();
    final last = _lastTap;
    _lastTap = now;
    if (last != null && now.difference(last) < kDoubleTapTimeout) {
      _lastTap = null;
      widget.onDoubleTap();
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    if (widget.renaming) {
      return NutriaTextField(
        text: widget.label,
        hint: widget.renameHint,
        autofocus: true,
        onChanged: widget.onRenamed,
        onSubmitted: (_) => widget.onRenameDone(),
        onFocusChanged: (focused) {
          if (!focused) widget.onRenameDone();
        },
      );
    }
    return NutriaContextMenuArea(
      itemsAt: (_) => widget.menu,
      onOpenChanged: widget.onMenuOpenChanged,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _onTap,
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
      ),
    );
  }
}
