// Yes/No question dialog in the app's style.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_modal.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// Asks [message]; resolves to `true` only if the user confirms.
Future<bool> showNutriaConfirmDialog(
  BuildContext context, {
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: context.appTheme.cDimmer,
    builder: (context) {
      final theme = context.appTheme;
      void close(bool value) => Navigator.of(context).pop(value);
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: NutriaModal(
          onClose: () => close(false),
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
                  Expanded(
                    child: NutriaButton(
                      onTap: () => close(false),
                      child: NutriaText(text: cancelLabel),
                    ),
                  ),
                  SizedBox(width: theme.dSectionPadding),
                  Expanded(
                    child: NutriaButton(
                      isAccented: true,
                      onTap: () => close(true),
                      child: NutriaText(
                        text: confirmLabel,
                        state: NutriaTextState.accented,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return result ?? false;
}
