// The app's design tokens (colors and sizes), as a Material ThemeExtension.
import 'package:material_ui/material_ui.dart';

/// Default node color swatches.
const kDefaultSwatches = <Color>[
  Color(0xffff4e6a),
  Color(0xffff664d),
  Color(0xffffae4d),
  Color(0xff33d56a),
  Color(0xff4da5ff),
  Color(0xff000000),
];

/// Every color (`c…`) and dimension (`d…`) the UI uses. Widgets read it with
/// `context.appTheme`; never hard-code colors or sizes in widgets.
///
/// Registered on the app's [ThemeData] (see `app/app.dart`); presets are in
/// `app_theme_presets.dart`. The defaults are the dark theme.
@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  const AppTheme({
    this.cBackground = const Color(0xff121212),
    this.cBackgroundDots = const Color(0xff282828),
    this.cAccent = const Color(0xffff4e6a),
    this.cAccentButton = const Color(0xaaff4e6a),
    this.cAccentButtonHovered = const Color(0xccff4e6a),
    this.cAccentButtonPressed = const Color(0xffff4e6a),
    this.cText = const Color(0x91ffffff),
    this.cTextActive = const Color(0xffffffff),
    this.cTextInactive = const Color.fromARGB(65, 255, 255, 255),
    this.cPanel = const Color(0xff252525),
    this.cPanelTransparent = const Color(0xf1252525),
    this.cOutlines = const Color(0x45ffffff),
    this.cButton = const Color(0xff383838),
    this.cButtonHovered = const Color(0xff4a4a4a),
    this.cButtonPressed = const Color(0xff555555),
    this.cButtonContentUnhovered = const Color(0xff252525),
    this.cButtonOutlines = const Color(0xf1252525),
    this.cTextField = const Color(0x00000000),
    this.cTextFieldActive = const Color(0x4a000000),
    this.cMenuBar = const Color(0xff000000),
    this.cMenuBarText = const Color(0xffffffff),
    this.cSwatches = kDefaultSwatches,
    this.dTextHeight = 14,
    this.dTextfieldPadding = 7,
    this.dPanelPadding = 7,
    this.dPanelRowDistance = 7,
    this.dPanelBorderRadius = 7,
    this.dOutlinesWidth = 1,
    this.dSwatchHeight = 10,
    this.dSectionPadding = 10,
    this.dSectionOutlineWidth = 2,
    this.dButtonHeight = 45,
    this.dButtonBorderRadius = 5,
    this.dButtonOutlinesWidth = 1,
    this.dScrollbarWidth = 11,
    this.dMenuBarHeight = 45,
    this.dLogoPadding = 10,
  });

  /// Canvas background.
  final Color cBackground;
  /// Canvas grid dots.
  final Color cBackgroundDots;
  /// Brand accent: knots, noodles, highlights.
  final Color cAccent;
  final Color cAccentButton;
  final Color cAccentButtonHovered;
  final Color cAccentButtonPressed;
  /// Default text.
  final Color cText;
  /// Emphasized or focused text.
  final Color cTextActive;
  /// Disabled text and placeholders.
  final Color cTextInactive;
  /// Side panels, nodes, menus.
  final Color cPanel;
  final Color cPanelTransparent;
  final Color cOutlines;
  final Color cButton;
  final Color cButtonHovered;
  final Color cButtonPressed;
  /// Icons on buttons that are not hovered.
  final Color cButtonContentUnhovered;
  final Color cButtonOutlines;
  final Color cTextField;
  final Color cTextFieldActive;
  final Color cMenuBar;
  final Color cMenuBarText;
  /// Node color swatches, indexed by `Node.swatch`.
  final List<Color> cSwatches;
  /// Base font size.
  final double dTextHeight;
  final double dTextfieldPadding;
  final double dPanelPadding;
  final double dPanelRowDistance;
  final double dPanelBorderRadius;
  final double dOutlinesWidth;
  /// Height of the colored strip on top of nodes.
  final double dSwatchHeight;
  final double dSectionPadding;
  final double dSectionOutlineWidth;
  /// Height of buttons, text fields and node rows.
  final double dButtonHeight;
  final double dButtonBorderRadius;
  final double dButtonOutlinesWidth;
  final double dScrollbarWidth;
  final double dMenuBarHeight;
  final double dLogoPadding;

  /// Node titles.
  TextStyle get swatchTextStyle => TextStyle(
        overflow: TextOverflow.ellipsis,
        color: cTextActive,
        fontVariations: const [FontVariation('wght', 500)],
        fontSize: dTextHeight,
        height: 1.0,
      );

  /// Video file names on nodes.
  TextStyle get filenameTextStyle => TextStyle(
        color: cText,
        fontSize: dTextHeight,
        height: 1.0,
      );

  @override
  AppTheme copyWith({
    Color? cBackground,
    Color? cBackgroundDots,
    Color? cAccent,
    Color? cAccentButton,
    Color? cAccentButtonHovered,
    Color? cAccentButtonPressed,
    Color? cText,
    Color? cTextActive,
    Color? cTextInactive,
    Color? cPanel,
    Color? cPanelTransparent,
    Color? cOutlines,
    Color? cButton,
    Color? cButtonHovered,
    Color? cButtonPressed,
    Color? cButtonContentUnhovered,
    Color? cButtonOutlines,
    Color? cTextField,
    Color? cTextFieldActive,
    Color? cMenuBar,
    Color? cMenuBarText,
    List<Color>? cSwatches,
    double? dTextHeight,
    double? dTextfieldPadding,
    double? dPanelPadding,
    double? dPanelRowDistance,
    double? dPanelBorderRadius,
    double? dOutlinesWidth,
    double? dSwatchHeight,
    double? dSectionPadding,
    double? dSectionOutlineWidth,
    double? dButtonHeight,
    double? dButtonBorderRadius,
    double? dButtonOutlinesWidth,
    double? dScrollbarWidth,
    double? dMenuBarHeight,
    double? dLogoPadding,
  }) =>
      AppTheme(
        cBackground: cBackground ?? this.cBackground,
        cBackgroundDots: cBackgroundDots ?? this.cBackgroundDots,
        cAccent: cAccent ?? this.cAccent,
        cAccentButton: cAccentButton ?? this.cAccentButton,
        cAccentButtonHovered: cAccentButtonHovered ?? this.cAccentButtonHovered,
        cAccentButtonPressed: cAccentButtonPressed ?? this.cAccentButtonPressed,
        cText: cText ?? this.cText,
        cTextActive: cTextActive ?? this.cTextActive,
        cTextInactive: cTextInactive ?? this.cTextInactive,
        cPanel: cPanel ?? this.cPanel,
        cPanelTransparent: cPanelTransparent ?? this.cPanelTransparent,
        cOutlines: cOutlines ?? this.cOutlines,
        cButton: cButton ?? this.cButton,
        cButtonHovered: cButtonHovered ?? this.cButtonHovered,
        cButtonPressed: cButtonPressed ?? this.cButtonPressed,
        cButtonContentUnhovered: cButtonContentUnhovered ?? this.cButtonContentUnhovered,
        cButtonOutlines: cButtonOutlines ?? this.cButtonOutlines,
        cTextField: cTextField ?? this.cTextField,
        cTextFieldActive: cTextFieldActive ?? this.cTextFieldActive,
        cMenuBar: cMenuBar ?? this.cMenuBar,
        cMenuBarText: cMenuBarText ?? this.cMenuBarText,
        cSwatches: cSwatches ?? this.cSwatches,
        dTextHeight: dTextHeight ?? this.dTextHeight,
        dTextfieldPadding: dTextfieldPadding ?? this.dTextfieldPadding,
        dPanelPadding: dPanelPadding ?? this.dPanelPadding,
        dPanelRowDistance: dPanelRowDistance ?? this.dPanelRowDistance,
        dPanelBorderRadius: dPanelBorderRadius ?? this.dPanelBorderRadius,
        dOutlinesWidth: dOutlinesWidth ?? this.dOutlinesWidth,
        dSwatchHeight: dSwatchHeight ?? this.dSwatchHeight,
        dSectionPadding: dSectionPadding ?? this.dSectionPadding,
        dSectionOutlineWidth: dSectionOutlineWidth ?? this.dSectionOutlineWidth,
        dButtonHeight: dButtonHeight ?? this.dButtonHeight,
        dButtonBorderRadius: dButtonBorderRadius ?? this.dButtonBorderRadius,
        dButtonOutlinesWidth: dButtonOutlinesWidth ?? this.dButtonOutlinesWidth,
        dScrollbarWidth: dScrollbarWidth ?? this.dScrollbarWidth,
        dMenuBarHeight: dMenuBarHeight ?? this.dMenuBarHeight,
        dLogoPadding: dLogoPadding ?? this.dLogoPadding,
      );

  /// Themes switch instantly: there is no meaningful halfway point between
  /// two token sets, so this snaps at the middle of the animation.
  @override
  AppTheme lerp(covariant AppTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

/// `context.appTheme` shortcut.
extension AppThemeContext on BuildContext {
  /// The [AppTheme] of the nearest [Theme]. Falls back to the dark defaults,
  /// so widgets also work in tests without a configured theme.
  AppTheme get appTheme =>
      Theme.of(this).extension<AppTheme>() ?? const AppTheme();
}
