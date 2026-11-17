// Project-wide playback settings. Saved in the project; nodes can override
// them.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/video_setting_steps.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/project_settings/widgets/video_setting_row.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';

/// The Project Settings section: playback defaults for every video node.
class ProjectSettingsPanel extends ConsumerWidget {
  const ProjectSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final settings = ref.watch(projectSettingsProvider);
    final editor = ref.read(graphEditorProvider);
    return NutriaScrollArea(
      padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
      child: Column(children: [
        for (final type in VideoSettingType.values) ...[
          if (type.index > 0) SizedBox(height: theme.dPanelPadding),
          VideoSettingRow(
            type: type,
            settings: settings,
            onStep: (direction) =>
                editor.editProjectSettings((s) => s.step(type, direction)),
            onChanged: (next, {mergeKey}) =>
                editor.editProjectSettings((_) => next, mergeKey: mergeKey),
            onMenuOpenChanged:
                ref.read(overlayProvider.notifier).setContextMenuOpen,
          ),
        ],
      ]),
    );
  }
}
