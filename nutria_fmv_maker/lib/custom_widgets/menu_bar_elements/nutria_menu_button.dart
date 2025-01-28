import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class NutriaMenuButton {
  final String title;
  final List<NutriaSubmenuButton> submenuButtons;

  NutriaMenuButton({
    required this.title,
    required this.submenuButtons,
  });
}

class NutriaSubmenuButton {
  final String text;
  final VoidCallback function;
  final MenuSerializableShortcut? shortcut;
  final IconData? icon;

  NutriaSubmenuButton({
    required this.text,
    required this.function,
    this.shortcut,
    this.icon,
  });
}