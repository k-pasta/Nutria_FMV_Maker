import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../models/enums_ui.dart';
import '../providers/theme_provider.dart';
import 'nutria_text.dart';

class ProjectSettingsBoard extends StatelessWidget {
  const ProjectSettingsBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Container(
      color: theme.cBackground,
      child: Center(
        child: NutriaText(
          text: 'Project Settings',
          state: NutriaTextState.accented,
          textStyle: NutriaTextStyle.bold,
        ),
      ),
    );
  }
}