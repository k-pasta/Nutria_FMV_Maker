import 'package:flutter/material.dart';

class AppTheme {
//background
  final Color cBackground;
  final Color cBackgroundDots;

//accent and accent buttons
  final Color cAccent;
  final Color cAccentButton;
  final Color cAccentButtonHovered;
  final Color cAccentButtonPressed;

//text
  final Color cText;
  final Color cTextActive;
  final Color cTextInactive;
  final double dTextHeight;
  final double dTextfieldPadding;

//panels
  final Color cPanel;
  final Color cPanelTransparent;
  final Color cOutlines;
  final double dPanelPadding;
  final double dPanelRowDistance;
  final double dPanelBorderRadius;
  final double dOutlinesWidth;
  final double dSwatchHeight;

//menus
  final double dSectionPadding;

//button 3 states
  final Color cButton;
  final Color cButtonHovered;
  final Color cButtonPressed;
  final double dButtonHeight;
  final double dButtonBorderRadius;

  final double dScrollbarWidth;
  final Color cButtonOutlines;
  final double dButtonOutlinesWidth;

//textfields
  final Color cTextField;
  final Color cTextFieldActive;

  //menu bar
  final Color cMenuBar;
  final Color cMenuBarText;
  final double dMenuBarHeight;

  final cSwatches = const <Color>[
    Color(0xffff4e6a),
    Color(0xffff664d),
    Color(0xffffae4d),
    Color(0xff33d56a),
    Color(0xff4da5ff),
    Color(0xff000000),
  ];

  // Constructor
  const AppTheme({
    this.cBackground = const Color(0xff121212),
    this.cBackgroundDots = const Color(0xff282828),
    this.cAccent = const Color(0xffff4e6a),
    this.cAccentButton = const Color(0xaaff4e6a),
    this.cAccentButtonHovered = const Color(0xccff4e6a),
    this.cAccentButtonPressed = const Color(0xffff4e6a),
    this.cText = const Color(0x91ffffff), //TODO make from transparent
    this.cTextActive = const Color(0xffffffff),
    this.cTextInactive = const Color.fromARGB(65, 255, 255, 255),
    this.dTextHeight = 14,
    this.dTextfieldPadding = 7,
    this.cPanel = const Color(0xff252525),
    // this.cPanelTransparent = const Color(0xff252525),
    this.cPanelTransparent = const Color(0xf1252525),
    this.cOutlines = const Color(0x45ffffff),
    this.dSectionPadding = 10,
    this.dOutlinesWidth = 1,
    this.cButtonOutlines = const Color(0xf1252525),
    this.dButtonOutlinesWidth = 1,
    this.cButton = const Color(0xff383838), //transparent
    this.cButtonHovered = const Color(0xff4a4a4a), //TODO remove
    this.cButtonPressed = const Color(0xff555555), //TODO remove
    this.cTextField = const Color(0x00000000), //transparent
    this.cTextFieldActive = const Color(0x4a000000),
    this.dPanelPadding = 7,
    this.dPanelRowDistance = 7,
    this.dPanelBorderRadius = 7,
    this.dSwatchHeight = 10,
    this.dButtonHeight = 45,
    this.dButtonBorderRadius = 5,
    this.dScrollbarWidth = 11,
    this.cMenuBar = const Color(0xff000000),
    this.cMenuBarText = const Color(0xffffffff),
    this.dMenuBarHeight = 67,
  });

  //getters
  //TODO document hardcoding
  TextStyle get swatchTextStyle => TextStyle(
        overflow: TextOverflow.ellipsis,
        color: cTextActive,
        fontVariations: const [FontVariation('wght', 500)],
        fontSize: dTextHeight,
        height: 1.0,
      );

  TextStyle get filenameTextStyle => TextStyle(
        color: cText,
        fontSize: dTextHeight,
        height: 1.0,
      );
}
