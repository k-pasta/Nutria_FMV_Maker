// The project's variables: name, type and starting value of each.
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/notifications_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_number_field.dart';
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
                          key: ValueKey(variable.id),
                          variable: variable,
                        ),
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
  Object _limitSession = Object();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final variable = widget.variable;
    final nameError = ref.watch(
      invalidVariableNamesProvider.select(
        (names) => names.contains(variable.name),
      ),
    );
    final gap = SizedBox(width: theme.dPanelPadding);
    final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
    String typeName(VariableType type) => switch (type) {
      VariableType.boolean => t.variableTypeBool,
      VariableType.integer => t.variableTypeInt,
      VariableType.decimal => t.variableTypeFloat,
    };

    final typeStepper = NutriaContextMenuArea(
      onOpenChanged: menuOpen,
      itemsAt: (_) => [
        for (final type in VariableType.values)
          NutriaContextMenuItem(
            icon: type == variable.type ? Icons.check : Icons.circle_outlined,
            label: typeName(type),
            onSelected: () => editor.setVariableType(variable.id, type),
          ),
      ],
      child: NutriaTooltip(
        message: t.variableType,
        child: NutriaButton.leftRight(
          onTapLeft: () =>
              editor.setVariableType(variable.id, _stepType(variable.type, -1)),
          onTapRight: () =>
              editor.setVariableType(variable.id, _stepType(variable.type, 1)),
          child: NutriaText(text: typeName(variable.type)),
        ),
      ),
    );

    final value = switch (variable) {
      BoolVariable(:final initial) => NutriaContextMenuArea(
        onOpenChanged: menuOpen,
        itemsAt: (_) => [
          for (final value in [true, false])
            NutriaContextMenuItem(
              icon: value == initial ? Icons.check : Icons.circle_outlined,
              label: value ? t.variableTrue : t.variableFalse,
              onSelected: () => editor.setVariableBool(variable.id, value),
            ),
        ],
        child: NutriaButton(
          onTap: () => editor.toggleVariable(variable.id),
          child: NutriaText(text: initial ? t.variableTrue : t.variableFalse),
        ),
      ),
      _ => Row(
        children: [
          _limitField(variable, isMin: true),
          gap,
          Expanded(
            child: NutriaNumberField(
              // A new field per type, so its text and filter match it.
              key: ValueKey(variable.type),
              text: variable.initialText,
              hint: t.variableInitialValue,
              decimals: variable.type == VariableType.decimal,
              onStep: (direction) =>
                  editor.stepVariable(variable.id, direction),
              onFocusChanged: (focused) {
                if (focused) _valueSession = Object();
              },
              onChanged: (text) => editor.setVariableInitialText(
                variable.id,
                text,
                mergeKey: _valueSession,
              ),
            ),
          ),
          gap,
          _limitField(variable, isMin: false),
        ],
      ),
    };

    return Container(
      padding: EdgeInsets.all(theme.dPanelPadding),
      decoration: BoxDecoration(
        color: theme.cCard,
        borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
        boxShadow: theme.dElevation > 0 ? theme.cardShadow() : null,
      ),
      // Two lines: name, type and delete; then the value (with its limits).
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: NutriaTooltip(
                  message: nameError ? t.variableNameError : null,
                  // The error comes and goes while typing; keep the field.
                  stable: true,
                  child: NutriaTextField(
                    text: variable.name,
                    hint: t.variableName,
                    isError: nameError,
                    inputFormatters: [_nameFilter],
                    onFocusChanged: (focused) {
                      if (focused) _nameSession = Object();
                    },
                    onChanged: (name) => editor.renameVariable(
                      variable.id,
                      name,
                      mergeKey: _nameSession,
                    ),
                  ),
                ),
              ),
              gap,
              Expanded(flex: 2, child: typeStepper),
              gap,
              NutriaButton.icon(
                icon: Icons.delete,
                tooltip: t.tooltipDeleteVariable,
                onTap: () => editor.removeVariable(variable.id),
              ),
            ],
          ),
          SizedBox(height: theme.dPanelPadding),
          value,
        ],
      ),
    );
  }

  /// Rejects characters a name can't have, and says why in the status bar.
  late final TextInputFormatter _nameFilter = TextInputFormatter.withFunction((
    old,
    next,
  ) {
    if (Variable.typingPattern.hasMatch(next.text)) return next;
    ref
        .read(notificationsProvider.notifier)
        .post(AppLocalizations.of(context).variableNameRejected);
    return old;
  });

  /// A small square field for the minimum ([isMin]) or maximum; empty (shown
  /// as −∞ / +∞) means no limit.
  Widget _limitField(Variable variable, {required bool isMin}) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    return SizedBox(
      width: theme.dButtonHeight * 1.6,
      child: NutriaTooltip(
        message: isMin ? t.variableMin : t.variableMax,
        child: NutriaTextField(
          key: ValueKey((variable.type, isMin)),
          text: variable.limitText(isMin: isMin),
          hint: isMin ? '−∞' : '+∞',
          textAlign: TextAlign.center,
          horizontalPadding: 2,
          isError: !variable.hasValidRange,
          inputFormatters: [
            NutriaNumberField.filter(
              decimals: variable.type == VariableType.decimal,
            ),
          ],
          onFocusChanged: (focused) {
            if (focused) _limitSession = Object();
          },
          onChanged: (text) => ref
              .read(graphEditorProvider)
              .setVariableLimit(
                variable.id,
                isMin: isMin,
                text: text,
                mergeKey: _limitSession,
              ),
        ),
      ),
    );
  }
}

/// The type before ([direction] -1) or after (1) [type], wrapping around.
VariableType _stepType(VariableType type, int direction) =>
    VariableType.values[(type.index + direction) % VariableType.values.length];
