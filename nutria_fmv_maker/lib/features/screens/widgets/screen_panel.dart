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
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_search_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';

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

/// [v] as a percentage, with one decimal when it has one (4.5%).
String _percent(double v) {
  final tenths = (v * 1000).round();
  return tenths % 10 == 0 ? '${tenths ~/ 10}%' : '${tenths / 10}%';
}

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

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final doc = ref.watch(projectDocumentProvider);
    final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
    final screenKind = ref.watch(selectedScreenProvider);
    final screen = doc.screenOf(screenKind);
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
      NutriaText(
        text: screenKindLabel(screenKind, t),
        textStyle: NutriaTextStyle.bold,
      ),
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

    /// The rows that change [style] (every element in it changes).
    List<Widget> styleRows(ScreenStyle style) {
      void editStyle(ScreenStyle Function(ScreenStyle s) edit) =>
          editor.editScreenStyle(style.id, edit);
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
                            : const SweepGradient(
                                colors: [
                                  Color(0xFFFF0000),
                                  Color(0xFFFFFF00),
                                  Color(0xFF00FF00),
                                  Color(0xFF00FFFF),
                                  Color(0xFF0000FF),
                                  Color(0xFFFF00FF),
                                  Color(0xFFFF0000),
                                ],
                              ),
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

      return [
        NutriaText(
          text: t.screenStyleNote(style.name),
          state: NutriaTextState.inactive,
          maxLines: 3,
          sizeMultiplier: 0.85,
        ),
        NutriaSettingRow(
          label: t.screenTextSize,
          value: _percent(style.fontSize),
          onPrevious: () => editStyle(
            (s) => s.copyWith(fontSize: (s.fontSize - 0.005).clamp(0.01, 0.3)),
          ),
          onNext: () => editStyle(
            (s) => s.copyWith(fontSize: (s.fontSize + 0.005).clamp(0.01, 0.3)),
          ),
        ),
        NutriaSettingRow(
          label: t.screenBold,
          value: style.bold ? t.essentialsYes : t.essentialsNo,
          onTap: () => editStyle((s) => s.copyWith(bold: !s.bold)),
        ),
        NutriaSearchMenu(
          label: doc.mediaById(style.fontId)?.fileName ?? t.screenDefaultFont,
          isPlaceholder: style.fontId == null,
          options: [t.screenDefaultFont, for (final f in fonts) f.fileName],
          searchHint: t.logicSearchVariables,
          onSelected: (i) => editStyle(
            (s) => s.copyWith(fontId: i == 0 ? null : fonts[i - 1].id),
          ),
          onOpenChanged: menuOpen,
        ),
        NutriaText(text: t.screenTextColor, state: NutriaTextState.inactive),
        palette(
          'text',
          style.textColor,
          (c) => editStyle((s) => s.copyWith(textColor: c)),
        ),
        NutriaText(text: t.screenBackColor, state: NutriaTextState.inactive),
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
        NutriaSettingRow(
          label: t.screenBackOpacity,
          value: _percent(style.backgroundOpacity),
          onPrevious: () => editStyle(
            (s) => s.copyWith(
              backgroundOpacity: (s.backgroundOpacity - 0.1).clamp(0, 1),
            ),
          ),
          onNext: () => editStyle(
            (s) => s.copyWith(
              backgroundOpacity: (s.backgroundOpacity + 0.1).clamp(0, 1),
            ),
          ),
        ),
        NutriaSettingRow(
          label: t.screenRoundness,
          value: _percent(style.radius),
          onPrevious: () => editStyle(
            (s) => s.copyWith(radius: (s.radius - 0.005).clamp(0, 0.2)),
          ),
          onNext: () => editStyle(
            (s) => s.copyWith(radius: (s.radius + 0.005).clamp(0, 0.2)),
          ),
        ),
        NutriaSettingRow(
          label: t.screenPadding,
          value: _percent(style.padding),
          onPrevious: () => editStyle(
            (s) => s.copyWith(padding: (s.padding - 0.005).clamp(0, 0.1)),
          ),
          onNext: () => editStyle(
            (s) => s.copyWith(padding: (s.padding + 0.005).clamp(0, 0.1)),
          ),
        ),
      ];
    }

    if (element != null) {
      final style = doc.styleOf(element);
      final styleIds = [for (final s in doc.styles) s.id];
      String styleName(String id) =>
          doc.styles.where((s) => s.id == id).firstOrNull?.name ?? id;
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
            NutriaButton.icon(
              icon: Icons.delete,
              tooltip: t.screenRemoveElement,
              onTap: () => editor.removeScreenElement(element.id),
            ),
          ],
        ),
        if (element.kind != ScreenElementKind.choices &&
            element.kind != ScreenElementKind.timer)
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
        NutriaSettingRow(
          label: t.screenWidth,
          value: _percent(element.width),
          onPrevious: () =>
              editor.setScreenElementWidth(element.id, element.width - 0.05),
          onNext: () =>
              editor.setScreenElementWidth(element.id, element.width + 0.05),
        ),
        if (element.kind == ScreenElementKind.choices)
          NutriaSettingRow(
            label: t.screenGap,
            value: _percent(element.gap),
            onPrevious: () =>
                editor.setScreenElementGap(element.id, element.gap - 0.005),
            onNext: () =>
                editor.setScreenElementGap(element.id, element.gap + 0.005),
          ),
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
        ...styleRows(style),
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
