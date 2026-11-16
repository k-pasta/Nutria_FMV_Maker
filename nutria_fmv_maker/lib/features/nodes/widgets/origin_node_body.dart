// The start node: a preview of the main menu plus the project title and
// description fields.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

class OriginNodeBody extends ConsumerStatefulWidget {
  const OriginNodeBody({super.key});

  @override
  ConsumerState<OriginNodeBody> createState() => _OriginNodeBodyState();
}

class _OriginNodeBodyState extends ConsumerState<OriginNodeBody> {
  // All keystrokes while a field is focused are one undo step.
  Object _titleSession = Object();
  Object _descriptionSession = Object();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final info = ref.watch(projectInfoProvider);
    final title = info.title ?? '';
    final description = info.description ?? '';
    final editor = ref.read(graphEditorProvider);
    final isEmpty = title.isEmpty && description.isEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Rough preview of the player's main menu, inset like a screen. The
      // outer height stays the thumbnail height, which the knots rely on.
      Container(
        height: NodeMetrics.of(context).thumbnailHeight - theme.dPanelPadding,
        margin: EdgeInsets.fromLTRB(
            theme.dPanelPadding, theme.dPanelPadding, theme.dPanelPadding, 0),
        decoration: BoxDecoration(
          color: theme.cButton,
          borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
        ),
        padding: EdgeInsets.all(theme.dPanelPadding),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          NutriaText(
            text: isEmpty ? t.originTitlePlaceHolder : title,
            textAlign: TextAlign.center,
            textStyle: title.isEmpty
                ? NutriaTextStyle.italic
                : NutriaTextStyle.bold,
          ),
          SizedBox(height: theme.dPanelPadding * 3),
          NutriaText(
            text: description,
            textAlign: TextAlign.center,
            maxLines: 3,
            sizeMultiplier: .65,
          ),
        ]),
      ),
      Padding(
        padding: EdgeInsets.all(theme.dPanelPadding),
        child: NutriaTextField(
          text: title,
          hint: '${t.originProjectTitle} ...',
          onFocusChanged: (focused) {
            if (focused) _titleSession = Object();
          },
          onChanged: (value) =>
              editor.setProjectTitle(value, mergeKey: _titleSession),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(
            theme.dPanelPadding, 0, theme.dPanelPadding, theme.dPanelPadding),
        child: NutriaTextField(
          text: description,
          hint: '${t.originProjectDescription} ...',
          maxLines: 2,
          onFocusChanged: (focused) {
            if (focused) _descriptionSession = Object();
          },
          onChanged: (value) => editor.setProjectDescription(value,
              mergeKey: _descriptionSession),
        ),
      ),
    ]);
  }
}
