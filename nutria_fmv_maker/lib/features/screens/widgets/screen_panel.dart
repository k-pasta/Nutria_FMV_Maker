// The Screen section of the left panel: the menu's background and layout,
// and the selected element with its style.
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
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_search_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

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

String _percent(double v) => '${(v * 100).round()}%';

/// The Screen section.
class ScreenPanel extends ConsumerStatefulWidget {
  const ScreenPanel({super.key});

  @override
  ConsumerState<ScreenPanel> createState() => _ScreenPanelState();
}

class _ScreenPanelState extends ConsumerState<ScreenPanel> {
  Object _textSession = Object();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final doc = ref.watch(projectDocumentProvider);
    final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
    final selectedId = ref.watch(selectedScreenElementProvider);
    final element = doc.menuScreen.elements
        .where((e) => e.id == selectedId)
        .firstOrNull;
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
      if (ref.watch(editorViewProvider) != EditorView.screens)
        NutriaButton(
          isAccented: true,
          onTap: () =>
              ref.read(editorViewProvider.notifier).show(EditorView.screens),
          child: NutriaText(
            text: t.screenOpenDesigner,
            state: NutriaTextState.onAccent,
          ),
        ),
      NutriaText(text: t.screenBackground, state: NutriaTextState.inactive),
      Row(
        children: [
          Expanded(
            child: NutriaSearchMenu(
              label:
                  doc.mediaById(doc.menuScreen.backgroundId)?.fileName ??
                  t.screenNoBackground,
              isPlaceholder: doc.menuScreen.backgroundId == null,
              options: [for (final m in backgrounds) m.fileName],
              searchHint: t.logicSearchVariables,
              onSelected: (i) => editor.setMenuBackground(backgrounds[i].id),
              onOpenChanged: menuOpen,
            ),
          ),
          if (doc.menuScreen.backgroundId != null) ...[
            SizedBox(width: theme.dPanelPadding),
            NutriaButton.icon(
              icon: Icons.close,
              tooltip: t.screenRemoveBackground,
              onTap: () => editor.setMenuBackground(null),
            ),
          ],
        ],
      ),
      NutriaButton(
        onTap: editor.applyClassicMenu,
        child: NutriaText(text: t.screenClassicLayout),
      ),
    ];

    if (element != null) {
      final style = doc.styleOf(element);
      void editStyle(ScreenStyle Function(ScreenStyle s) edit) =>
          editor.editScreenStyle(style.id, edit);
      Widget palette(int current, ValueChanged<int> onPicked) => Wrap(
        spacing: theme.dPanelPadding / 2,
        runSpacing: theme.dPanelPadding / 2,
        children: [
          for (final color in kScreenPalette)
            GestureDetector(
              onTap: () => onPicked(color),
              child: Container(
                width: theme.dButtonHeight * 0.7,
                height: theme.dButtonHeight * 0.7,
                decoration: BoxDecoration(
                  color: Color(color),
                  borderRadius: BorderRadius.circular(
                    theme.dButtonBorderRadius,
                  ),
                  border: Border.all(
                    color: color == current ? theme.cAccent : theme.cDivider,
                    width: color == current ? 2 : 1,
                  ),
                ),
              ),
            ),
        ],
      );
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
          style.textColor,
          (c) => editStyle((s) => s.copyWith(textColor: c)),
        ),
        NutriaText(text: t.screenBackColor, state: NutriaTextState.inactive),
        palette(
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
      ]);
    } else {
      rows.add(
        NutriaText(
          text: t.screenSelectHint,
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
