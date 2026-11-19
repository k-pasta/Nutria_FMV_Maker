// The Project section of the left panel: the story's title, description
// and languages, and an overview (file, size, how long it plays).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/languages.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/project_info/providers/project_overview_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_search_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

/// [bytes] in the largest unit that keeps a number above 1 ("1.4 GB").
String formatBytes(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return unit == 0
      ? '$bytes B'
      : '${value.toStringAsFixed(value < 10 ? 1 : 0)} ${units[unit]}';
}

/// [d] as h:mm:ss, or m:ss under an hour.
String formatLength(Duration d) {
  final seconds = d.inSeconds;
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = (seconds % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}

/// The Project section.
class ProjectPanel extends ConsumerStatefulWidget {
  const ProjectPanel({super.key});

  @override
  ConsumerState<ProjectPanel> createState() => _ProjectPanelState();
}

class _ProjectPanelState extends ConsumerState<ProjectPanel> {
  /// One undo step per typing session in each field.
  Object _titleSession = Object();
  Object _descriptionSession = Object();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final info = ref.watch(projectDocumentProvider.select((d) => d.info));
    final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
    final addable = [
      for (final code in kStoryLanguages.keys)
        if (!info.languages.contains(code)) code,
    ];

    final rows = <Widget>[
      _Header(text: t.projectInformation),
      NutriaTextField(
        text: info.title ?? '',
        hint: t.originProjectTitle,
        markdown: true,
        onFocusChanged: (f) {
          if (f) _titleSession = Object();
        },
        onChanged: (text) =>
            editor.setProjectTitle(text, mergeKey: _titleSession),
      ),
      NutriaTextField(
        text: info.description ?? '',
        hint: t.originProjectDescription,
        markdown: true,
        maxLines: null,
        onFocusChanged: (f) {
          if (f) _descriptionSession = Object();
        },
        onChanged: (text) =>
            editor.setProjectDescription(text, mergeKey: _descriptionSession),
      ),
      _Header(text: t.projectLanguages),
      for (final (i, code) in info.languages.indexed)
        NutriaContextMenuArea(
          onOpenChanged: menuOpen,
          itemsAt: (_) => [
            if (i > 0)
              NutriaContextMenuItem(
                icon: Icons.star,
                label: t.projectMakeMain,
                onSelected: () => editor.makeMainLanguage(code),
              ),
            NutriaContextMenuItem(
              icon: Icons.delete,
              label: t.projectRemoveLanguage,
              onSelected: () => editor.removeLanguage(code),
            ),
          ],
          child: Row(
            children: [
              Expanded(
                child: NutriaText(
                  text: languageLabel(code),
                  state: i == 0
                      ? NutriaTextState.accented
                      : NutriaTextState.normal,
                ),
              ),
              if (i == 0)
                Padding(
                  padding: EdgeInsets.only(right: theme.dPanelPadding),
                  child: NutriaText(
                    text: t.projectMainLanguage,
                    state: NutriaTextState.inactive,
                  ),
                ),
              NutriaButton.icon(
                icon: Icons.close,
                tooltip: t.projectRemoveLanguage,
                onTap: () => editor.removeLanguage(code),
              ),
            ],
          ),
        ),
      NutriaSearchMenu(
        label: t.projectAddLanguage,
        isPlaceholder: true,
        options: [for (final code in addable) languageLabel(code)],
        searchHint: t.logicSearchVariables,
        onSelected: (i) => editor.addLanguage(addable[i]),
        onOpenChanged: menuOpen,
      ),
      _Note(text: t.projectLanguagesNote),
      _Header(text: t.projectOverview),
      const _Overview(),
    ];

    return NutriaScrollArea(
      padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
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

/// The read-only facts: file, size of the files used, shortest and longest
/// ways through the story.
class _Overview extends ConsumerWidget {
  const _Overview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final file = ref.watch(projectFileNameProvider);
    final size = ref.watch(usedMediaSizeProvider);
    final length = ref.watch(storyLengthOverviewProvider);
    String way(Duration? d, {required bool longest}) => switch (length) {
      AsyncData(:final value) =>
        d != null
            ? formatLength(d)
            : (longest && value.hasLoops ? t.projectLoops : t.projectNoEnding),
      _ => t.projectReading,
    };
    final rows = <Widget>[
      _Fact(label: t.projectFile, value: file ?? t.statusUnsavedFile),
      _Fact(
        label: t.projectFilesUsed,
        value: t.projectFilesSize(size.count, formatBytes(size.bytes)),
      ),
      if (size.unreadable > 0)
        _Note(text: t.projectUnreadable(size.unreadable)),
      _Fact(
        label: t.projectShortest,
        value: way(length.value?.shortest, longest: false),
      ),
      _Fact(
        label: t.projectLongest,
        value: way(length.value?.longest, longest: true),
      ),
      if (length.value case final l? when l.unknown > 0)
        _Note(text: t.projectUnknownLengths(l.unknown)),
      _Note(text: t.projectLengthNote),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: theme.dPanelPadding),
          rows[i],
        ],
      ],
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

class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => NutriaText(
    text: text,
    state: NutriaTextState.inactive,
    maxLines: 4,
    sizeMultiplier: 0.85,
  );
}

/// A label and its value, read-only.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: NutriaText(text: label, state: NutriaTextState.inactive),
      ),
      Flexible(
        child: NutriaText(text: value, textAlign: TextAlign.end),
      ),
    ],
  );
}
