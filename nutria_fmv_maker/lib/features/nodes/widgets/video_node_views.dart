// The bodies of the simple and branched video nodes, and their settings.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/video_setting_steps.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/music_rows.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/video_node_parts.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/project_settings/widgets/video_setting_row.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';

/// Thumbnail, file name, and a row with "convert" and the expand button.
/// Its output knot is level with its input, at the bottom of the thumbnail.
class SimpleVideoNodeBody extends ConsumerWidget {
  const SimpleVideoNodeBody({super.key, required this.node});

  final SimpleVideoNode node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NodeThumbnail(node: node),
        NodeFileName(node: node),
        Padding(
          padding: EdgeInsets.all(theme.dPanelPadding),
          child: NodeRow(
            children: [
              Expanded(
                child: NutriaButton(
                  onTap: () =>
                      ref.read(graphEditorProvider).convertNode(node.id),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.dTextfieldPadding,
                    ),
                    child: NutriaText(
                      text: AppLocalizations.of(context).nodeConvertToBranching,
                    ),
                  ),
                ),
              ),
              SizedBox(width: theme.dPanelPadding),
              NodeExpandButton(node: node),
            ],
          ),
        ),
      ],
    );
  }
}

/// Thumbnail, file name and one text field per choice. Each choice has an
/// output knot; the last row is empty, for typing a new choice.
class BranchedVideoNodeBody extends StatelessWidget {
  const BranchedVideoNodeBody({super.key, required this.node});

  final BranchedVideoNode node;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final rows = NodeLayout.choiceRowCount(node);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NodeThumbnail(node: node),
        NodeFileName(node: node),
        Padding(
          padding: EdgeInsets.all(theme.dPanelPadding),
          child: FocusTraversalGroup(
            child: Column(
              children: [
                // The question has no output; NodeLayout gives it the
                // first row, so the choice knots line up below it.
                if (node.question case final question?) ...[
                  NodeRow(
                    children: [
                      Expanded(
                        child: _QuestionField(
                          key: const ValueKey('question'),
                          nodeId: node.id,
                          text: question,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.dPanelPadding),
                ],
                for (var i = 0; i < rows; i++) ...[
                  if (i > 0) SizedBox(height: theme.dPanelPadding),
                  NodeRow(
                    children: [
                      Expanded(
                        child: _ChoiceField(
                          key: ValueKey(i),
                          nodeId: node.id,
                          index: i,
                          text: i < node.choices.length
                              ? node.choices[i].text
                              : '',
                        ),
                      ),
                      if (i == rows - 1) ...[
                        SizedBox(width: theme.dPanelPadding),
                        NodeExpandButton(node: node),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// One choice's text. All keystrokes while focused are one undo step.
class _ChoiceField extends ConsumerStatefulWidget {
  const _ChoiceField({
    super.key,
    required this.nodeId,
    required this.index,
    required this.text,
  });

  final String nodeId;
  final int index;
  final String text;

  @override
  ConsumerState<_ChoiceField> createState() => _ChoiceFieldState();
}

class _ChoiceFieldState extends ConsumerState<_ChoiceField> {
  Object _editSession = Object();

  @override
  Widget build(BuildContext context) => NutriaTextField(
    markdown: true,
    text: widget.text,
    hint:
        '${AppLocalizations.of(context).videoNodeChoice} '
        '${widget.index + 1}',
    onFocusChanged: (focused) {
      if (focused) _editSession = Object();
    },
    onChanged: (text) => ref
        .read(graphEditorProvider)
        .setChoiceText(
          widget.nodeId,
          widget.index,
          text,
          mergeKey: _editSession,
        ),
  );
}

/// The question above a branched node's choices. All keystrokes while
/// focused are one undo step.
class _QuestionField extends ConsumerStatefulWidget {
  const _QuestionField({super.key, required this.nodeId, required this.text});

  final String nodeId;
  final String text;

  @override
  ConsumerState<_QuestionField> createState() => _QuestionFieldState();
}

class _QuestionFieldState extends ConsumerState<_QuestionField> {
  Object _editSession = Object();

  @override
  Widget build(BuildContext context) => NutriaTextField(
    markdown: true,
    text: widget.text,
    hint: AppLocalizations.of(context).nodeQuestionHint,
    onFocusChanged: (focused) {
      if (focused) _editSession = Object();
    },
    onChanged: (text) => ref
        .read(graphEditorProvider)
        .setQuestion(widget.nodeId, text, mergeKey: _editSession),
  );
}

/// The settings under an expanded video node: per-node overrides of the
/// project settings, conversion (branched nodes) and the node color.
class VideoNodeExpansion extends ConsumerWidget {
  const VideoNodeExpansion({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = this.node;
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final settings = ref.watch(effectiveSettingsProvider(node.id));
    final overridden = node.overridesOrNull?.activeTypes ?? const [];
    final types = node is BranchedVideoNode
        ? kBranchedNodeSettings
        : kSimpleNodeSettings;
    final children = <Widget>[
      if (node is BranchedVideoNode) ...[
        NutriaButton(
          onTap: () => editor.convertNode(node.id),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.dTextfieldPadding),
            child: NutriaText(text: t.nodeConvertToSimple),
          ),
        ),
        // A text above the choices, with no output of its own.
        NutriaSettingRow(
          label: t.nodeQuestion,
          value: node.question != null ? t.essentialsYes : t.essentialsNo,
          onTap: () =>
              editor.setQuestionEnabled(node.id, node.question == null),
          options: [
            for (final enabled in [true, false])
              NutriaContextMenuItem(
                icon: enabled == (node.question != null)
                    ? Icons.check
                    : Icons.circle_outlined,
                label: enabled ? t.essentialsYes : t.essentialsNo,
                onSelected: () => editor.setQuestionEnabled(node.id, enabled),
              ),
          ],
          onOptionsOpenChanged: ref
              .read(overlayProvider.notifier)
              .setContextMenuOpen,
        ),
      ],
      for (final type in types)
        VideoSettingRow(
          onDragStart: editor.beginValueDrag,
          onDragEnd: editor.endValueDrag,
          type: type,
          settings: settings,
          isOverridden: overridden.contains(type),
          onStep: (direction) => editor.editOverrides(
            node.id,
            (o) => o.enable(type, settings.step(type, direction)),
          ),
          onChanged: (next, {mergeKey}) => editor.editOverrides(
            node.id,
            (o) => o.enable(type, next),
            mergeKey: mergeKey,
          ),
          onReset: () => editor.disableOverride(node.id, type),
          onMenuOpenChanged: ref
              .read(overlayProvider.notifier)
              .setContextMenuOpen,
        ),
      ...musicRows(context, ref, node),
      SwatchPicker(
        selected: node.swatch,
        withDefaults: ref.watch(colorDefaultsProvider).keys.toSet(),
        onSelected: (swatch) => editor.setSwatch(node.id, swatch),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: theme.dPanelPadding),
          children[i],
        ],
      ],
    );
  }
}

/// One square per theme swatch; the node's current color is outlined, and
/// colors with their own defaults show a faint "…". The first color holds
/// the project's defaults, so it's marked too as soon as any other color has
/// its own.
class SwatchPicker extends StatelessWidget {
  const SwatchPicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.withDefaults = const {},
  });

  final int selected;
  final ValueChanged<int> onSelected;

  /// The colors that have their own defaults.
  final Set<int> withDefaults;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final swatches = theme.cSwatches;
    final marked = withDefaults.isEmpty ? const <int>{} : {0, ...withDefaults};
    return SizedBox(
      height: theme.dButtonHeight * 2 / 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < swatches.length; i++) ...[
            if (i > 0) SizedBox(width: theme.dPanelPadding),
            Expanded(
              child: NutriaTooltip(
                message: AppLocalizations.of(context).tooltipNodeColor(i + 1),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onSelected(i),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: swatches[i],
                        borderRadius: BorderRadius.circular(
                          theme.dButtonBorderRadius,
                        ),
                        border: i == selected
                            ? Border.all(
                                color: theme.cTextActive,
                                width: theme.dOutlinesWidth * 2,
                              )
                            : null,
                      ),
                      child: marked.contains(i)
                          ? Icon(
                              Icons.more_horiz,
                              color: theme.cSwatchMark,
                              size: theme.dButtonHeight * 0.5,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
