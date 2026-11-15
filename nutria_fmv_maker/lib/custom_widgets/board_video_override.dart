import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../models/enums_data.dart';
import '../providers/app_settings_provider.dart';
import '../providers/theme_provider.dart';
import 'nutria_button.dart';
import 'nutria_text.dart';

class BoardVideoSetting extends StatelessWidget {
  const BoardVideoSetting({
    super.key,
    required this.labelText,
    required this.valueText,
    required this.onTap,
    this.onTapLeft,
    this.onTapRight,
  });

  final String labelText;
  final String valueText;

  final VoidCallback onTap;
  final VoidCallback? onTapLeft;
  final VoidCallback? onTapRight;

  bool get isLeftRight => onTapLeft != null && onTapRight != null;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentAppTheme;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: theme.dButtonHeight,
            child: Row(
              children: [
                Expanded(
                  child: NutriaText(text: labelText),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: isLeftRight
              ? NutriaButton.leftRight(
                  onTapLeft: onTapLeft!,
                  onTapRight: onTapRight!,
                  child: NutriaText(text: valueText),
                )
              : NutriaButton(
                  onTap: onTap,
                  child: NutriaText(text: valueText),
                ),
        ),
      ],
    );
  }
}