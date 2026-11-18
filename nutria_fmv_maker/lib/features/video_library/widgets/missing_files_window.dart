// The list of imported files that can't be found, shown after opening a
// project that has some.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_commands.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/video_library/providers/video_library_providers.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// The contents of the missing files window (inside a `NutriaModal`). The
/// list updates as files are found.
class MissingFilesWindow extends ConsumerWidget {
  const MissingFilesWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final missing = ref.watch(missingMediaProvider);
    final media = [
      for (final asset in ref.watch(mediaAssetsProvider))
        if (missing.contains(asset.id)) asset,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        NutriaText(
          text: t.missingFilesTitle,
          state: NutriaTextState.accented,
          textStyle: NutriaTextStyle.bold,
        ),
        SizedBox(height: theme.dSectionPadding),
        NutriaText(
          text: media.isEmpty ? t.missingFilesNone : t.missingFilesMessage,
          maxLines: 3,
        ),
        for (final asset in media) ...[
          SizedBox(height: theme.dSectionPadding),
          NutriaText(text: asset.fileName, maxLines: 2),
          NutriaText(
            text: asset.path,
            state: NutriaTextState.inactive,
            sizeMultiplier: 0.85,
            maxLines: 3,
          ),
        ],
        if (media.isNotEmpty) ...[
          SizedBox(height: theme.dSectionPadding * 2),
          Align(
            alignment: Alignment.centerRight,
            child: NutriaButton(
              isAccented: true,
              onTap: AppCommands(context, ref).locateMissingFiles,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.dTextfieldPadding,
                ),
                child: NutriaText(
                  text: t.missingFilesLocate,
                  state: NutriaTextState.onAccent,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
