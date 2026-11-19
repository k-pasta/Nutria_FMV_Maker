// The bodies of logic nodes: Change Variable and Compare.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/graph/logic_check.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/video_node_views.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_search_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// The title a logic node shows in its strip when it has no name of its
/// own, after what it does ("Increment" for adding 1, "Toggle", …).
String logicNodeTitle(Node node, AppLocalizations t) => switch (node) {
  ChangeVariableNode(:final operation, :final value) => switch (operation) {
    FmvChangeOperation.set => t.logicTitleSet,
    FmvChangeOperation.add when value.trim() == '1' => t.logicTitleIncrement,
    FmvChangeOperation.subtract when value.trim() == '1' =>
      t.logicTitleDecrement,
    FmvChangeOperation.toggle => t.logicTitleToggle,
    FmvChangeOperation.absolute => t.logicTitleAbsolute,
    _ => t.logicTitleChange,
  },
  CompareNode() => t.logicTitleCompare,
  _ => '',
};

/// The caution sign at the right of a logic node's strip, shown while the
/// node has a problem or a warning; its tooltip says what it is (like the
/// faulty field's).
class LogicIssueMark extends ConsumerWidget {
  const LogicIssueMark({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final doc = ref.watch(projectDocumentProvider);
    final simple = ref.watch(preferencesProvider.select((p) => p.simpleMath));
    final problem = logicProblem(doc, node, simple: simple);
    final message = problem != null
        ? logicProblemText(problem, t)
        : switch (logicWarning(doc, node)) {
            LogicWarning.rounded => t.logicWarningRounded,
            null => null,
          };
    if (message == null) return const SizedBox.shrink();
    return NutriaTooltip(
      message: message,
      child: Icon(
        Icons.warning_amber_rounded,
        size: theme.dTextHeight * 1.2,
        color: theme.swatchTextStyle.color,
      ),
    );
  }
}

/// What an operation is called on its stepper, with its symbol.
String operationLabel(FmvChangeOperation op, AppLocalizations t) =>
    switch (op) {
      FmvChangeOperation.set => '= ${t.logicOpSet}',
      FmvChangeOperation.add => '+ ${t.logicOpAdd}',
      FmvChangeOperation.subtract => '− ${t.logicOpSubtract}',
      FmvChangeOperation.multiply => '× ${t.logicOpMultiply}',
      FmvChangeOperation.divide => '÷ ${t.logicOpDivide}',
      FmvChangeOperation.power => '^ ${t.logicOpPower}',
      FmvChangeOperation.absolute => '|x| ${t.logicOpAbsolute}',
      FmvChangeOperation.toggle => t.logicOpToggle,
      FmvChangeOperation.and => t.logicOpAnd,
      FmvChangeOperation.or => t.logicOpOr,
      FmvChangeOperation.xor => t.logicOpXor,
    };

/// The operations offered for a variable of type [isBool]; simple math
/// leaves out power and absolute, and and/or/xor.
List<FmvChangeOperation> operationsFor({
  required bool isBool,
  required bool simple,
}) => [
  for (final op in FmvChangeOperation.values)
    if (isBool ? op.isForBooleans : op.isForNumbers)
      if (!simple ||
          !(op == FmvChangeOperation.power ||
              op == FmvChangeOperation.absolute ||
              op == FmvChangeOperation.and ||
              op == FmvChangeOperation.or ||
              op == FmvChangeOperation.xor))
        op,
];

/// The comparisons offered for a variable of type [isBool].
List<FmvComparison> comparisonsFor({required bool isBool}) => [
  for (final c in FmvComparison.values)
    if (!isBool || c.isForBooleans) c,
];

/// Explains [problem] in a sentence.
String logicProblemText(LogicProblem problem, AppLocalizations t) =>
    switch (problem.type) {
      LogicProblemType.noVariable => t.logicProblemNoVariable,
      LogicProblemType.unknownVariable => t.logicProblemUnknownVariable,
      LogicProblemType.wrongOperation => t.logicProblemWrongOperation,
      LogicProblemType.noConditions => t.logicProblemNoConditions,
      LogicProblemType.invalidExpression => switch (problem.error?.problem) {
        FmvExpressionProblem.unknownVariable => t.logicProblemUnknownName(
          problem.error?.detail ?? '',
        ),
        FmvExpressionProblem.empty => t.logicProblemEmpty,
        _ => t.logicProblemExpression,
      },
    };

/// One row of a logic node, as high as a button.
class _Row extends StatelessWidget {
  const _Row({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: context.appTheme.dButtonHeight, child: child);
}

/// The variable picker of a logic node: a button that opens a searchable
/// list of the project's variables.
class _VariablePicker extends ConsumerWidget {
  const _VariablePicker({required this.variableId, required this.onPicked});

  final String? variableId;
  final ValueChanged<String> onPicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final variables = ref.watch(variablesProvider);
    final picked = variables.where((v) => v.id == variableId).firstOrNull;
    return NutriaSearchMenu(
      label:
          picked?.name ??
          (variableId == null ? t.logicPickVariable : t.logicMissingVariable),
      isPlaceholder: variableId == null,
      isError: variableId != null && picked == null,
      options: [for (final v in variables) v.name],
      searchHint: t.logicSearchVariables,
      emptyText: t.logicNoVariables,
      onSelected: (i) => onPicked(variables[i].id),
      onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
    );
  }
}

/// A value: an expression field, or a true/false button for true/false
/// variables in simple math.
class _ValueField extends ConsumerStatefulWidget {
  const _ValueField({
    required this.text,
    required this.isBool,
    required this.isError,
    required this.hint,
    required this.onChanged,
    this.tooltip,
  });

  final String text;
  final bool isBool;
  final bool isError;
  final String hint;
  final void Function(String text, {Object? mergeKey}) onChanged;
  final String? tooltip;

  @override
  ConsumerState<_ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends ConsumerState<_ValueField> {
  Object _session = Object();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final simple = ref.watch(preferencesProvider.select((p) => p.simpleMath));
    if (widget.isBool && simple) {
      final on = widget.text.trim().toLowerCase() != 'false';
      return NutriaButton(
        onTap: () => widget.onChanged(on ? 'false' : 'true'),
        child: NutriaText(text: on ? t.variableTrue : t.variableFalse),
      );
    }
    return NutriaTooltip(
      stable: true,
      message: widget.tooltip,
      child: NutriaTextField(
        text: widget.text,
        hint: widget.hint,
        isError: widget.isError,
        expressionTypes: variableTypes(ref.watch(projectDocumentProvider)),
        onFocusChanged: (focused) {
          if (focused) _session = Object();
        },
        onChanged: (text) => widget.onChanged(text, mergeKey: _session),
      ),
    );
  }
}

/// A stepper over [values] showing [label], with all of them on
/// right-click.
Widget _stepper<T>({
  required WidgetRef ref,
  required List<T> values,
  required T current,
  required String Function(T) label,
  required ValueChanged<T> onChanged,
}) {
  T step(int direction) {
    final i = values.indexOf(current);
    final next = i == -1 ? 0 : (i + direction) % values.length;
    return values[next < 0 ? next + values.length : next];
  }

  return NutriaContextMenuArea(
    onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
    itemsAt: (_) => [
      for (final value in values)
        NutriaContextMenuItem(
          icon: value == current ? Icons.check : Icons.circle_outlined,
          label: label(value),
          onSelected: () => onChanged(value),
        ),
    ],
    child: NutriaButton.leftRight(
      onTapLeft: () => onChanged(step(-1)),
      onTapRight: () => onChanged(step(1)),
      child: NutriaText(text: label(current)),
    ),
  );
}

/// Change Variable: the variable, the operation and (if it takes one) the
/// value.
class ChangeVariableNodeBody extends ConsumerWidget {
  const ChangeVariableNodeBody({super.key, required this.node});

  final ChangeVariableNode node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final doc = ref.watch(projectDocumentProvider);
    final simple = ref.watch(preferencesProvider.select((p) => p.simpleMath));
    final variable = doc.variables
        .where((v) => v.id == node.variableId)
        .firstOrNull;
    final isBool = variable is BoolVariable;
    final problem = logicProblem(doc, node, simple: simple);
    final warning = logicWarning(doc, node);
    final ops = operationsFor(isBool: isBool, simple: simple);
    final gap = SizedBox(height: theme.dPanelPadding);
    return Padding(
      padding: EdgeInsets.all(theme.dPanelPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Row(
            child: _VariablePicker(
              variableId: node.variableId,
              onPicked: (id) => editor.setChangeVariable(node.id, id),
            ),
          ),
          gap,
          _Row(
            child: _stepper(
              ref: ref,
              values: ops.contains(node.operation)
                  ? ops
                  : [...ops, node.operation],
              current: node.operation,
              label: (op) => operationLabel(op, t),
              onChanged: (op) => editor.setChangeOperation(node.id, op),
            ),
          ),
          if (node.operation.takesValue) ...[
            gap,
            _Row(
              child: _ValueField(
                text: node.value,
                isBool: isBool,
                isError: problem?.type == LogicProblemType.invalidExpression,
                hint: node.operation == FmvChangeOperation.set
                    ? t.logicNewValueHint
                    : t.logicByValueHint,
                tooltip: problem != null
                    ? logicProblemText(problem, t)
                    : (warning == LogicWarning.rounded
                          ? t.logicWarningRounded
                          : null),
                onChanged: (text, {mergeKey}) =>
                    editor.setChangeValue(node.id, text, mergeKey: mergeKey),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compare: condition rows (or one expression), then the True and False
/// outputs.
class CompareNodeBody extends ConsumerWidget {
  const CompareNodeBody({super.key, required this.node});

  final CompareNode node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final doc = ref.watch(projectDocumentProvider);
    final simple = ref.watch(preferencesProvider.select((p) => p.simpleMath));
    final problem = logicProblem(doc, node, simple: simple);
    final gap = SizedBox(height: theme.dPanelPadding);
    final rows = <Widget>[];
    final expression = node.expression;
    if (expression != null) {
      rows.add(
        _Row(
          child: _ValueField(
            text: expression,
            isBool: false,
            isError: problem != null,
            hint: t.logicExpressionHint,
            tooltip: problem == null ? null : logicProblemText(problem, t),
            onChanged: (text, {mergeKey}) =>
                editor.setCompareExpression(node.id, text, mergeKey: mergeKey),
          ),
        ),
      );
    } else {
      for (final c in node.conditions) {
        final variable = doc.variables
            .where((v) => v.id == c.variableId)
            .firstOrNull;
        final isBool = variable is BoolVariable;
        final own = logicProblem(
          doc,
          node.copyWith(conditions: [c]),
          simple: simple,
        );
        rows.add(
          _Row(
            child: Row(
              children: [
                Expanded(
                  child: _VariablePicker(
                    variableId: c.variableId,
                    onPicked: (id) =>
                        editor.setConditionVariable(node.id, c.id, id),
                  ),
                ),
                if (node.conditions.length > 1) ...[
                  SizedBox(width: theme.dPanelPadding),
                  NutriaButton.icon(
                    icon: Icons.close,
                    tooltip: t.logicRemoveCondition,
                    onTap: () => editor.removeCondition(node.id, c.id),
                  ),
                ],
              ],
            ),
          ),
        );
        rows.add(
          _Row(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _stepper(
                    ref: ref,
                    values: comparisonsFor(isBool: isBool),
                    current: c.comparison,
                    label: (cmp) => cmp.symbol == '==' ? '=' : cmp.symbol,
                    onChanged: (cmp) =>
                        editor.setConditionComparison(node.id, c.id, cmp),
                  ),
                ),
                SizedBox(width: theme.dPanelPadding),
                Expanded(
                  flex: 3,
                  child: _ValueField(
                    text: c.value,
                    isBool: isBool,
                    isError: own?.type == LogicProblemType.invalidExpression,
                    hint: t.logicValueHint,
                    tooltip: own == null ? null : logicProblemText(own, t),
                    onChanged: (text, {mergeKey}) => editor.setConditionValue(
                      node.id,
                      c.id,
                      text,
                      mergeKey: mergeKey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      rows.add(
        _Row(
          child: Row(
            children: [
              NutriaButton.icon(
                icon: Icons.add,
                tooltip: t.logicAddCondition,
                onTap: () => editor.addCondition(node.id),
              ),
              SizedBox(width: theme.dPanelPadding),
              if (node.conditions.length > 1)
                Expanded(
                  child: NutriaButton(
                    onTap: () => editor.setMatchAny(node.id, !node.matchAny),
                    child: NutriaText(
                      text: node.matchAny ? t.logicMatchAny : t.logicMatchAll,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    for (final label in [t.logicTrue, t.logicFalse]) {
      rows.add(
        _Row(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: theme.dTextfieldPadding),
              child: NutriaText(text: label),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(theme.dPanelPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, row) in rows.indexed) ...[if (i > 0) gap, row],
        ],
      ),
    );
  }
}

/// The settings under an expanded logic node: (for Compare, outside simple
/// math) the expression switch, and the color.
class LogicNodeExpansion extends ConsumerWidget {
  const LogicNodeExpansion({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final node = this.node;
    final simple = ref.watch(preferencesProvider.select((p) => p.simpleMath));
    final children = <Widget>[
      if (node is CompareNode && (!simple || node.expression != null))
        NutriaSettingRow(
          label: t.logicUseExpression,
          value: node.expression != null ? t.essentialsYes : t.essentialsNo,
          onTap: () => editor.setCompareExpression(
            node.id,
            node.expression == null ? '' : null,
          ),
        ),
      SwatchPicker(
        selected: node.swatch,
        onSelected: (swatch) => editor.setSwatch(node.id, swatch),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, child) in children.indexed) ...[
          if (i > 0) SizedBox(height: theme.dPanelPadding),
          child,
        ],
      ],
    );
  }
}
