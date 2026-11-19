// The Design section of the left panel (screen designer only): the screen's
// background, and the selected element with its style, or a style picked
// from the list.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
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
import 'package:nutria_fmv_maker/ui/widgets/nutria_color_picker.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_number_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_search_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// Colors offered for text and backgrounds (ARGB).
const kScreenPalette = [
  0xFFFFFFFF,
  0xFFBDBDBD,
  0xFF616161,
  0xFF000000,
  0xFFFF4E6A,
  0xFFFFAE4D,
  0xFF33D56A,
  0xFF4DA5FF,
  0xFFA47BFF,
];

/// The hues of the colour wheel on the "any colour" square. Fixed colours,
/// not theme colours: they show what the button does.
const _wheel = [
  Color(0xFFFF0000),
  Color(0xFFFFFF00),
  Color(0xFF00FF00),
  Color(0xFF00FFFF),
  Color(0xFF0000FF),
  Color(0xFFFF00FF),
  Color(0xFFFF0000),
];

/// [v] (a fraction) as a percentage number, with one decimal when it has
/// one ("4.5").
String _percent(double v) {
  final tenths = (v * 1000).round();
  return tenths % 10 == 0 ? '${tenths ~/ 10}' : '${tenths / 10}';
}

/// The name of answer layout [layout], and its icon.
String choiceLayoutLabel(FmvChoiceLayout layout, AppLocalizations t) =>
    switch (layout) {
      FmvChoiceLayout.vertical => t.screenLayoutVertical,
      FmvChoiceLayout.horizontal => t.screenLayoutHorizontal,
      FmvChoiceLayout.columns => t.screenLayoutColumns,
      FmvChoiceLayout.rows => t.screenLayoutRows,
      FmvChoiceLayout.radial => t.screenLayoutRadial,
    };

IconData _layoutIcon(FmvChoiceLayout layout) => switch (layout) {
  FmvChoiceLayout.vertical => Icons.view_agenda,
  FmvChoiceLayout.horizontal => Icons.view_week,
  FmvChoiceLayout.columns => Icons.vertical_split,
  FmvChoiceLayout.rows => Icons.horizontal_split,
  FmvChoiceLayout.radial => Icons.pie_chart,
};

String _timerModeLabel(FmvTimerMode mode, AppLocalizations t) => switch (mode) {
  FmvTimerMode.toStart => t.screenTimerToStart,
  FmvTimerMode.toMiddle => t.screenTimerToMiddle,
  FmvTimerMode.fromMiddle => t.screenTimerFromMiddle,
};

/// The Screen section.
class ScreenPanel extends ConsumerStatefulWidget {
  const ScreenPanel({super.key});

  @override
  ConsumerState<ScreenPanel> createState() => _ScreenPanelState();
}

class _ScreenPanelState extends ConsumerState<ScreenPanel> {
  Object _textSession = Object();

  /// Which color has its full picker open: `'text'`, `'back'` or `null`.
  String? _openPicker;

  /// A number setting shown as a percentage ([value] is a fraction of the
  /// screen's height or width, or an opacity): typed, stepped by [step]
  /// with the arrows, or dragged (one undo step per drag), kept within [min]
  /// and [max].
  Widget _fraction(
    String label,
    double value, {
    required double step,
    required double min,
    required double max,
    required void Function(double v, {Object? mergeKey}) onChanged,
  }) {
    final editor = ref.read(graphEditorProvider);
    double clamp(double v) => v.clamp(min, max).toDouble();
    return NutriaSettingRow(
      label: label,
      value: '',
      field: NutriaNumberField(
        text: _percent(value),
        decimals: true,
        onStep: (d) => onChanged(clamp(value + d * step)),
        onDragStart: editor.beginValueDrag,
        onDragEnd: editor.endValueDrag,
        onFocusChanged: (f) {
          if (f) _textSession = Object();
        },
        onChanged: (text) {
          final typed = NutriaNumberField.parse(text);
          if (typed != null) {
            onChanged(clamp(typed / 100), mergeKey: _textSession);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final doc = ref.watch(projectDocumentProvider);
    final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
    final screen = ref.watch(designedScreenProvider);
    final selectedId = ref.watch(selectedScreenElementProvider);
    final element = selectedId == null ? null : doc.screenElement(selectedId);
    final pickedStyle = switch (ref.watch(selectedScreenStyleProvider)) {
      final id? => doc.styles.where((s) => s.id == id).firstOrNull,
      null => null,
    };
    final backgrounds = [
      for (final m in doc.media)
        if (m.isVideo || m.kind == MediaKind.image) m,
    ];
    final fonts = [
      for (final m in doc.media)
        if (m.kind == MediaKind.font) m,
    ];
    final gap = SizedBox(height: theme.dPanelPadding);
    final rows = <Widget>[
      NutriaText(text: screenLabel(screen, t), textStyle: NutriaTextStyle.bold),
      NutriaText(text: t.screenBackground, state: NutriaTextState.inactive),
      Row(
        children: [
          Expanded(
            child: NutriaSearchMenu(
              label:
                  doc.mediaById(screen.backgroundId)?.fileName ??
                  t.screenNoBackground,
              isPlaceholder: screen.backgroundId == null,
              options: [for (final m in backgrounds) m.fileName],
              searchHint: t.logicSearchVariables,
              onSelected: (i) => editor.setScreenBackground(backgrounds[i].id),
              onOpenChanged: menuOpen,
            ),
          ),
          if (screen.backgroundId != null) ...[
            SizedBox(width: theme.dPanelPadding),
            NutriaButton.icon(
              icon: Icons.close,
              tooltip: t.screenRemoveBackground,
              onTap: () => editor.setScreenBackground(null),
            ),
          ],
        ],
      ),
    ];

    /// The rows that change [style] (every element in it changes). For a
    /// timer ([forTimer]), text settings are left out and the colours are
    /// the bar's.
    List<Widget> styleRows(ScreenStyle style, {bool forTimer = false}) {
      void editStyle(ScreenStyle Function(ScreenStyle s) edit) =>
          editor.editScreenStyle(style.id, edit);
      void editMerged(
        ScreenStyle Function(ScreenStyle s) edit, {
        Object? mergeKey,
      }) => editor.editScreenStyle(style.id, edit, mergeKey: mergeKey);
      List<Widget> swatches(int current, ValueChanged<int> onPicked) => [
        for (final color in kScreenPalette)
          GestureDetector(
            onTap: () => onPicked(color),
            child: Container(
              width: theme.dButtonHeight * 0.7,
              height: theme.dButtonHeight * 0.7,
              decoration: BoxDecoration(
                color: Color(color),
                borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
                border: Border.all(
                  color: color == current ? theme.cAccent : theme.cDivider,
                  width: color == current ? 2 : 1,
                ),
              ),
            ),
          ),
      ];

      // The palette, then a square that opens the full picker below it.
      Widget palette(String which, int current, ValueChanged<int> onPicked) {
        final open = _openPicker == which;
        final square = theme.dButtonHeight * 0.7;
        final own = !kScreenPalette.contains(current);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: theme.dPanelPadding / 2,
              runSpacing: theme.dPanelPadding / 2,
              children: [
                ...swatches(current, onPicked),
                NutriaTooltip(
                  message: t.screenPickColor,
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _openPicker = open ? null : which),
                    // A colour wheel ("any colour"), or the own colour
                    // once one is picked.
                    child: Container(
                      width: square,
                      height: square,
                      decoration: BoxDecoration(
                        color: own ? Color(current) : null,
                        gradient: own
                            ? null
                            : const SweepGradient(colors: _wheel),
                        borderRadius: BorderRadius.circular(
                          theme.dButtonBorderRadius,
                        ),
                        border: Border.all(
                          color: own || open ? theme.cAccent : theme.cDivider,
                          width: own || open ? 2 : 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (open) ...[
              SizedBox(height: theme.dPanelPadding),
              NutriaColorPicker(
                color: current,
                onChanged: onPicked,
                onChangeStart: editor.beginValueDrag,
                onChangeEnd: editor.endValueDrag,
              ),
            ],
          ],
        );
      }

      // The fonts: the Player's, those both apps ship, then imported ones.
      final builtIn = kFmvBuiltInFonts.keys.toList();
      final fontLabel =
          doc.mediaById(style.fontId)?.fileName ??
          kFmvBuiltInFonts[style.builtInFont] ??
          t.screenDefaultFont;

      return [
        NutriaText(
          text: '${t.screenStyleNote(style.name)} ${t.screenPercentNote}',
          state: NutriaTextState.inactive,
          maxLines: 4,
          sizeMultiplier: 0.85,
        ),
        if (!forTimer) ...[
          _fraction(
            t.screenTextSize,
            style.fontSize,
            step: 0.005,
            min: 0.01,
            max: 0.3,
            onChanged: (v, {mergeKey}) =>
                editMerged((s) => s.copyWith(fontSize: v), mergeKey: mergeKey),
          ),
          NutriaSettingRow(
            label: t.screenBold,
            value: style.bold ? t.essentialsYes : t.essentialsNo,
            onTap: () => editStyle((s) => s.copyWith(bold: !s.bold)),
          ),
          NutriaSettingRow(
            label: t.screenFont,
            value: '',
            field: NutriaSearchMenu(
              label: fontLabel,
              isPlaceholder: style.fontId == null && style.builtInFont == null,
              options: [
                t.screenDefaultFont,
                for (final name in builtIn) kFmvBuiltInFonts[name]!,
                for (final f in fonts) f.fileName,
              ],
              searchHint: t.logicSearchVariables,
              onSelected: (i) => editStyle(
                (s) => switch (i) {
                  0 => s.copyWith(fontId: null, builtInFont: null),
                  _ when i <= builtIn.length => s.copyWith(
                    fontId: null,
                    builtInFont: builtIn[i - 1],
                  ),
                  _ => s.copyWith(fontId: fonts[i - 1 - builtIn.length].id),
                },
              ),
              onOpenChanged: menuOpen,
            ),
          ),
        ],
        NutriaText(
          text: forTimer ? t.screenBarColor : t.screenTextColor,
          state: NutriaTextState.inactive,
        ),
        palette(
          'text',
          style.textColor,
          (c) => editStyle((s) => s.copyWith(textColor: c)),
        ),
        NutriaText(
          text: forTimer ? t.screenTrackColor : t.screenBackColor,
          state: NutriaTextState.inactive,
        ),
        palette(
          'back',
          style.backgroundColor,
          (c) => editStyle(
            (s) => s.copyWith(
              backgroundColor: c,
              backgroundOpacity: s.backgroundOpacity == 0
                  ? 0.6
                  : s.backgroundOpacity,
            ),
          ),
        ),
        _fraction(
          t.screenBackOpacity,
          style.backgroundOpacity,
          step: 0.05,
          min: 0,
          max: 1,
          onChanged: (v, {mergeKey}) => editMerged(
            (s) => s.copyWith(backgroundOpacity: v),
            mergeKey: mergeKey,
          ),
        ),
        _fraction(
          t.screenRoundness,
          style.radius,
          step: 0.005,
          min: 0,
          max: 0.2,
          onChanged: (v, {mergeKey}) =>
              editMerged((s) => s.copyWith(radius: v), mergeKey: mergeKey),
        ),
        _fraction(
          t.screenPadding,
          style.padding,
          step: 0.005,
          min: 0,
          max: 0.1,
          onChanged: (v, {mergeKey}) =>
              editMerged((s) => s.copyWith(padding: v), mergeKey: mergeKey),
        ),
        _fraction(
          t.screenBlur,
          style.blur,
          step: 0.002,
          min: 0,
          max: 0.05,
          onChanged: (v, {mergeKey}) =>
              editMerged((s) => s.copyWith(blur: v), mergeKey: mergeKey),
        ),
      ];
    }

    if (element != null) {
      final style = doc.styleOf(element);
      final styleIds = [for (final s in doc.styles) s.id];
      String styleName(String id) =>
          doc.styles.where((s) => s.id == id).firstOrNull?.name ?? id;
      final removable = doc.canRemoveScreenElement(element.id);
      final isChoices = element.kind == ScreenElementKind.choices;
      final isTimer = element.kind == ScreenElementKind.timer;
      rows.addAll([
        SizedBox(height: theme.dSectionPadding),
        Row(
          children: [
            Expanded(
              child: NutriaText(
                text: screenElementLabel(element.kind, t),
                textStyle: NutriaTextStyle.bold,
              ),
            ),
            NutriaTooltip(
              message: removable ? null : t.screenRequiredElement,
              child: NutriaButton.icon(
                icon: Icons.delete,
                isActive: removable,
                tooltip: t.screenRemoveElement,
                onTap: () => editor.removeScreenElement(element.id),
              ),
            ),
          ],
        ),
        if (!isChoices && !isTimer && element.kind != ScreenElementKind.saves)
          NutriaTextField(
            key: ValueKey('text-${element.id}'),
            text: element.text ?? '',
            markdown: true,
            hint: t.screenTextHint,
            onFocusChanged: (f) {
              if (f) _textSession = Object();
            },
            onChanged: (text) => editor.setScreenElementText(
              element.id,
              text,
              mergeKey: _textSession,
            ),
          ),
        if (isChoices) ...[
          NutriaText(text: t.screenLayout, state: NutriaTextState.inactive),
          // The layouts as a row of icons: quicker to compare than a list.
          Row(
            children: [
              for (final (i, layout) in FmvChoiceLayout.values.indexed) ...[
                if (i > 0) SizedBox(width: theme.dPanelPadding / 2),
                Expanded(
                  child: NutriaButton.icon(
                    icon: _layoutIcon(layout),
                    tooltip: choiceLayoutLabel(layout, t),
                    isAccented: element.layout == layout,
                    onTap: () =>
                        editor.setScreenElementLayout(element.id, layout),
                  ),
                ),
              ],
            ],
          ),
          NutriaText(
            text: choiceLayoutLabel(element.layout, t),
            state: NutriaTextState.inactive,
            sizeMultiplier: 0.85,
          ),
        ],
        if (!(isChoices && element.layout == FmvChoiceLayout.columns))
          _fraction(
            t.screenWidth,
            element.width,
            step: 0.05,
            min: 0.05,
            max: 1,
            onChanged: (v, {mergeKey}) =>
                editor.setScreenElementWidth(element.id, v, mergeKey: mergeKey),
          ),
        if ((isChoices && !element.layout.fillsScreen) ||
            element.kind == ScreenElementKind.saves)
          _fraction(
            t.screenGap,
            element.gap,
            step: 0.005,
            min: 0,
            max: 0.2,
            onChanged: (v, {mergeKey}) =>
                editor.setScreenElementGap(element.id, v, mergeKey: mergeKey),
          ),
        if (isTimer) ...[
          NutriaSettingRow(
            label: t.screenTimerMode,
            value: _timerModeLabel(element.timerMode, t),
            onPrevious: () => editor.setScreenElementTimerMode(
              element.id,
              FmvTimerMode.values[(element.timerMode.index - 1) %
                  FmvTimerMode.values.length],
            ),
            onNext: () => editor.setScreenElementTimerMode(
              element.id,
              FmvTimerMode.values[(element.timerMode.index + 1) %
                  FmvTimerMode.values.length],
            ),
            options: [
              for (final mode in FmvTimerMode.values)
                NutriaContextMenuItem(
                  icon: mode == element.timerMode
                      ? Icons.check
                      : Icons.circle_outlined,
                  label: _timerModeLabel(mode, t),
                  onSelected: () =>
                      editor.setScreenElementTimerMode(element.id, mode),
                ),
            ],
            onOptionsOpenChanged: menuOpen,
          ),
          _fraction(
            t.screenThickness,
            element.thickness,
            step: 0.002,
            min: 0.002,
            max: 0.1,
            onChanged: (v, {mergeKey}) => editor.setScreenElementThickness(
              element.id,
              v,
              mergeKey: mergeKey,
            ),
          ),
        ],
        NutriaSettingRow(
          label: t.screenStyle,
          value: style.name,
          onPrevious: () => editor.setScreenElementStyle(
            element.id,
            styleIds[(styleIds.indexOf(style.id) - 1) % styleIds.length],
          ),
          onNext: () => editor.setScreenElementStyle(
            element.id,
            styleIds[(styleIds.indexOf(style.id) + 1) % styleIds.length],
          ),
          options: [
            for (final id in styleIds)
              NutriaContextMenuItem(
                icon: id == style.id ? Icons.check : Icons.circle_outlined,
                label: styleName(id),
                onSelected: () => editor.setScreenElementStyle(element.id, id),
              ),
          ],
          onOptionsOpenChanged: menuOpen,
        ),
        ...styleRows(style, forTimer: isTimer),
      ]);
    } else if (pickedStyle != null) {
      final builtIn = ScreenOps.isBuiltInStyle(pickedStyle.id);
      rows.addAll([
        SizedBox(height: theme.dSectionPadding),
        Row(
          children: [
            Expanded(
              child: NutriaTextField(
                key: ValueKey('style-name-${pickedStyle.id}'),
                text: pickedStyle.name,
                hint: t.screenRenameHint,
                onFocusChanged: (f) {
                  if (f) _textSession = Object();
                },
                onChanged: (name) => editor.renameScreenStyle(
                  pickedStyle.id,
                  name,
                  mergeKey: _textSession,
                ),
              ),
            ),
            if (!builtIn) ...[
              SizedBox(width: theme.dPanelPadding),
              NutriaButton.icon(
                icon: Icons.delete,
                tooltip: t.screenDeleteStyle,
                onTap: () => editor.removeScreenStyle(pickedStyle.id),
              ),
            ],
          ],
        ),
        NutriaText(
          text: t.screenStyleUses(doc.usesOfStyle(pickedStyle.id)),
          state: NutriaTextState.inactive,
          sizeMultiplier: 0.85,
        ),
        ...styleRows(pickedStyle),
      ]);
    } else {
      rows.add(
        NutriaText(
          text: '${t.screenSelectHint}\n\n${t.screenStyleHint}',
          state: NutriaTextState.inactive,
          maxLines: 4,
        ),
      );
    }
    return NutriaScrollArea(
      padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, row) in rows.indexed) ...[if (i > 0) gap, row],
        ],
      ),
    );
  }
}
