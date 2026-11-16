// The project's variables: name, type and starting value of each.
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';

/// One card per variable, and an add (+) button floating over the list.
class VariablesPanel extends ConsumerWidget {
  const VariablesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final variables = ref.watch(variablesProvider);
    return Stack(
      children: [
        Positioned.fill(
          child: NutriaScrollArea(
            padding: EdgeInsets.fromLTRB(
              theme.dSectionPadding,
              0,
              theme.dSectionPadding,
              theme.dButtonHeight + theme.dSectionPadding * 2,
            ),
            child: variables.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(theme.dPanelPadding),
                    child: NutriaText(
                      text: t.variablesEmpty,
                      state: NutriaTextState.inactive,
                      maxLines: 4,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (i, variable) in variables.indexed) ...[
                        if (i > 0) SizedBox(height: theme.dPanelPadding),
                        _VariableCard(
                            key: ValueKey(variable.id), variable: variable),
                      ],
                    ],
                  ),
          ),
        ),
        Positioned(
          right: theme.dSectionPadding + theme.dScrollbarWidth,
          bottom: theme.dSectionPadding,
          child: NutriaButton.icon(
            icon: Icons.add,
            isAccented: true,
            tooltip: t.tooltipAddVariable,
            onTap: () => ref
                .read(graphEditorProvider)
                .addVariable(t.variableDefaultName),
          ),
        ),
      ],
    );
  }
}

/// Name and delete on top, type below, then the starting value.
class _VariableCard extends ConsumerStatefulWidget {
  const _VariableCard({super.key, required this.variable});

  final Variable variable;

  @override
  ConsumerState<_VariableCard> createState() => _VariableCardState();
}

class _VariableCardState extends ConsumerState<_VariableCard> {
  // A new undo step per editing session of each field.
  Object _nameSession = Object();
  Object _valueSession = Object();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final variable = widget.variable;
    final nameError = ref.watch(conflictingVariableNamesProvider
        .select((names) => names.contains(variable.name.trim())));
    final gap = SizedBox(width: theme.dPanelPadding);

    return Container(
      padding: EdgeInsets.all(theme.dPanelPadding),
      decoration: BoxDecoration(
        color: theme.cCard,
        borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
        boxShadow: theme.dElevation > 0 ? theme.cardShadow() : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
              child: NutriaTooltip(
                message: nameError ? t.variableNameError : null,
                child: NutriaTextField(
                  text: variable.name,
                  hint: t.variableName,
                  isError: nameError,
                  onFocusChanged: (focused) {
                    if (focused) _nameSession = Object();
                  },
                  onChanged: (name) => editor.renameVariable(variable.id, name,
                      mergeKey: _nameSession),
                ),
              ),
            ),
            gap,
            NutriaButton.icon(
              icon: Icons.delete,
              tooltip: t.tooltipDeleteVariable,
              onTap: () => editor.removeVariable(variable.id),
            ),
          ]),
          SizedBox(height: theme.dPanelPadding),
          Row(children: [
            for (final (i, (type, label)) in [
              (VariableType.boolean, t.variableTypeBool),
              (VariableType.integer, t.variableTypeInt),
              (VariableType.decimal, t.variableTypeFloat),
            ].indexed) ...[
              if (i > 0) gap,
              Expanded(
                child: NutriaButton(
                  isAccented: variable.type == type,
                  onTap: () => editor.setVariableType(variable.id, type),
                  child: NutriaText(
                    text: label,
                    state: variable.type == type
                        ? NutriaTextState.onAccent
                        : NutriaTextState.normal,
                  ),
                ),
              ),
            ],
          ]),
          SizedBox(height: theme.dPanelPadding),
          switch (variable) {
            BoolVariable(:final initial) => NutriaButton(
                onTap: () => editor.toggleVariable(variable.id),
                child: NutriaText(
                    text: initial ? t.variableTrue : t.variableFalse),
              ),
            _ => NutriaTextField(
                // A new field per type, so its text and filter match it.
                key: ValueKey(variable.type),
                text: variable.initialText,
                hint: t.variableInitialValue,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    variable.type == VariableType.integer
                        ? RegExp(r'^-?\d*')
                        : RegExp(r'^-?\d*\.?\d*'),
                  ),
                ],
                onFocusChanged: (focused) {
                  if (focused) _valueSession = Object();
                },
                onChanged: (text) => editor.setVariableInitialText(
                    variable.id, text,
                    mergeKey: _valueSession),
              ),
          },
        ],
      ),
    );
  }
}
