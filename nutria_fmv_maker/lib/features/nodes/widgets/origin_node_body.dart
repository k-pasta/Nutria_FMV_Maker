// The start node: a preview of the main menu plus the project title and
// description fields.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/music_rows.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screens_view.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';
import 'package:nutria_fmv_screens/nutria_fmv_screens.dart';

/// The start node: a preview of the main menu, then the project title and
/// description fields.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The main menu as designed, drawn small. The outer height stays the
        // thumbnail height, which the knots rely on.
        Container(
          height: NodeMetrics.of(context).thumbnailHeight - theme.dPanelPadding,
          margin: EdgeInsets.fromLTRB(
            theme.dPanelPadding,
            theme.dPanelPadding,
            theme.dPanelPadding,
            0,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.cScreenStage,
            borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
          ),
          child: const IgnorePointer(
            child: Center(
              child: AspectRatio(aspectRatio: 16 / 9, child: _MenuPreview()),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(theme.dPanelPadding),
          child: NutriaTextField(
            markdown: true,
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
            theme.dPanelPadding,
            0,
            theme.dPanelPadding,
            theme.dPanelPadding,
          ),
          child: NutriaTextField(
            markdown: true,
            text: description,
            hint: '${t.originProjectDescription} ...',
            maxLines: 2,
            onFocusChanged: (focused) {
              if (focused) _descriptionSession = Object();
            },
            onChanged: (value) => editor.setProjectDescription(
              value,
              mergeKey: _descriptionSession,
            ),
          ),
        ),
        const MenuMusicRow(),
      ],
    );
  }
}

/// The main menu, drawn as the Player draws it. It watches only what the
/// menu shows (not the whole document), so moving nodes doesn't redraw it.
/// Imported fonts aren't loaded here: the preview is approximate.
class _MenuPreview extends ConsumerWidget {
  const _MenuPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final menu = ref.watch(
      projectDocumentProvider.select((d) => d.screenOf(ScreenKind.menu)),
    );
    final styles = ref.watch(projectDocumentProvider.select((d) => d.styles));
    final info = ref.watch(projectInfoProvider);
    final background = ref.watch(mediaAssetProvider(menu.backgroundId ?? ''));
    final doc = ProjectDocument(
      info: info,
      styles: styles,
      screens: [menu],
      media: [?background],
    );
    return ScreenView(
      screen: fmvScreenOf(doc, menu),
      background: ScreenBackground.of(doc, menu),
      content: designerContent(doc, menu, (
        answers: 0,
        longText: false,
        question: false,
      ), t),
    );
  }
}
