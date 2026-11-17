// A question dialog with a row of answer buttons, in the app's style.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_modal.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// One answer button of [showNutriaChoiceDialog].
typedef NutriaChoice<T> = ({T value, String label, bool isAccented});

/// Asks [message] with one button per choice, left to right. Resolves to
/// the chosen value, or `null` if the dialog was closed (x, Escape or a click
/// outside).
Future<T?> showNutriaChoiceDialog<T>(
  BuildContext context, {
  required String message,
  required List<NutriaChoice<T>> choices,
}) => showDialog<T>(
  context: context,
  barrierColor: context.appTheme.cDimmer,
  builder: (context) {
    final theme = context.appTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: NutriaModal(
        onClose: () => Navigator.of(context).pop(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NutriaText(
              text: message,
              maxLines: 5,
              state: NutriaTextState.accented,
            ),
            SizedBox(height: theme.dSectionPadding * 2),
            Row(
              children: [
                for (final (i, choice) in choices.indexed) ...[
                  if (i > 0) SizedBox(width: theme.dSectionPadding),
                  Expanded(
                    child: NutriaButton(
                      isAccented: choice.isAccented,
                      onTap: () => Navigator.of(context).pop(choice.value),
                      child: NutriaText(
                        text: choice.label,
                        state: choice.isAccented
                            ? NutriaTextState.onAccent
                            : NutriaTextState.normal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  },
);
