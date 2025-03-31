import 'package:flutter/material.dart';
import '../../models/app_theme.dart';

class MenuStyles {
  final AppTheme theme;

  late final MenuStyle menuStyle;
  late final MenuStyle submenuStyle;
  late final ButtonStyle buttonStyleBar;
  late final ButtonStyle buttonStyleMenu;

  MenuStyles({required this.theme}) {
    menuStyle = MenuStyle(
      backgroundColor: WidgetStatePropertyAll(theme.cMenuBar),
      shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(side: BorderSide.none)),
    );
    submenuStyle = MenuStyle(
      backgroundColor: WidgetStatePropertyAll(theme.cPanel),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      ),
    );

    buttonStyleBar = ButtonStyle(
      overlayColor: WidgetStatePropertyAll(theme.cPanel),
      foregroundColor: WidgetStatePropertyAll(theme.cMenuBarText),
      fixedSize: WidgetStatePropertyAll<Size>(
        Size.fromHeight(theme.dMenuBarHeight),
      ),
    );

    buttonStyleMenu = ButtonStyle(
      iconColor: WidgetStatePropertyAll(theme.cAccent),
      overlayColor: WidgetStatePropertyAll(theme.cAccentButtonHovered),
      foregroundColor: WidgetStatePropertyAll(theme.cMenuBarText),
      shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(side: BorderSide.none)),
    );
  }
}
