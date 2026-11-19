// The app's design tokens (colors and sizes), as a Material ThemeExtension.
import 'package:material_ui/material_ui.dart';

/// Node colors of the dark theme. Each theme has its own set; nodes store
/// an index into it, see [AppTheme.swatch].
const kDefaultSwatches = <Color>[
  Color(0xffff4e6a),
  Color(0xffff664d),
  Color(0xffffae4d),
  Color(0xff33d56a),
  Color(0xff4da5ff),
  Color(0xffa47bff),
];

/// Every color (`c…`) and dimension (`d…`) the UI uses. Widgets read it with
/// `context.appTheme`; never hard-code colors or sizes in widgets.
///
/// The look is flat: filled buttons and fields without outlines, and raised
/// surfaces ([cCard]) separated by soft shadows ([cShadow]) rather than lines.
///
/// Registered on the app's [ThemeData] (see `app/app.dart`); presets are in
/// `app_theme_presets.dart`. The defaults are the dark theme.
@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  const AppTheme({
    this.cBackground = const Color(0xff0b0b0e),
    this.cBackgroundDots = const Color(0xff3c3c46),
    this.cAccent = const Color(0xffff4e6a),
    this.cAccentButton = const Color(0xffe8455f),
    this.cAccentButtonHovered = const Color(0xffff4e6a),
    this.cAccentButtonPressed = const Color(0xffff6b82),
    this.cOnAccent = const Color(0xffffffff),
    this.cText = const Color(0xbfffffff),
    this.cTextActive = const Color(0xffffffff),
    this.cTextInactive = const Color(0x80ffffff),
    this.cPanel = const Color(0xff212128),
    this.cCard = const Color(0xff32323c),
    this.cCardHovered = const Color(0xff3a3a45),
    this.cButton = const Color(0xff50505a),
    this.cButtonHovered = const Color(0xff5a5a64),
    this.cButtonPressed = const Color(0xff656570),
    this.cButtonContentUnhovered = const Color(0x99ffffff),
    this.cListSelected = const Color(0xff656570),
    this.cTextField = const Color(0xff50505a),
    this.cTextFieldActive = const Color(0xff5a5a64),
    this.cDivider = const Color(0x26ffffff),
    this.cSwatchMark = const Color(0x59000000),
    this.cOutlines = const Color(0x29ffffff),
    this.cShadow = const Color(0x99000000),
    this.cMenuBar = const Color(0xff212128),
    this.cMenuBarText = const Color(0xffffffff),
    this.cLogoBadge = const Color(0x00000000),
    this.logoAsset = 'assets/icons/nutria_logo_top.svg',
    this.cDimmer = const Color(0x73000000),
    this.cWindowClose = const Color(0xffc42b1c),
    this.cOnWindowClose = const Color(0xffffffff),
    this.cSwatches = kDefaultSwatches,
    this.dTextHeight = 14,
    this.dTextfieldPadding = 8,
    this.dPanelPadding = 7,
    this.dPanelRowDistance = 7,
    this.dPanelBorderRadius = 5,
    this.dNodeBorderRadius = 10,
    this.dElevation = 0,
    this.dOutlinesWidth = 1,
    this.dSwatchHeight = 6,
    this.dSelectionWidth = 2,
    this.dSectionPadding = 10,
    this.dDividerWidth = 1,
    this.dShadowBlur = 14,
    this.dButtonHeight = 32,
    this.dButtonBorderRadius = 4,
    this.dScrollbarWidth = 11,
    this.dMenuBarHeight = 45,
    this.dLogoPadding = 10,
    this.dStatusBarHeight = 25,
  });

  /// Canvas background.
  final Color cBackground;

  /// Canvas grid dots.
  final Color cBackgroundDots;

  /// Brand accent: knots, noodles, highlights.
  final Color cAccent;

  /// Filled accent buttons (import, remove).
  final Color cAccentButton;
  final Color cAccentButtonHovered;
  final Color cAccentButtonPressed;

  /// Icons and text on accent-filled buttons.
  final Color cOnAccent;

  /// Default text.
  final Color cText;

  /// Emphasized or focused text.
  final Color cTextActive;

  /// Disabled text and placeholders.
  final Color cTextInactive;

  /// Side panels, status bar, menus and dialogs.
  final Color cPanel;

  /// Raised surfaces: nodes, the section dropdown, library entries.
  final Color cCard;
  final Color cCardHovered;

  /// Filled buttons (no outline).
  final Color cButton;
  final Color cButtonHovered;
  final Color cButtonPressed;

  /// Icons on buttons that are not hovered.
  final Color cButtonContentUnhovered;

  /// The selected entry of a list, such as the previewed video.
  final Color cListSelected;

  /// Filled text fields (no outline).
  final Color cTextField;
  final Color cTextFieldActive;

  /// Hairlines between panels and the canvas.
  final Color cDivider;

  /// The "…" on a color square whose color has its own defaults.
  final Color cSwatchMark;

  /// The few remaining lines: stripes, swatch borders.
  final Color cOutlines;

  /// Shadows under cards, menus and dialogs.
  final Color cShadow;
  final Color cMenuBar;
  final Color cMenuBarText;

  /// Backing behind the logo; transparent when the logo art suits the menu bar.
  final Color cLogoBadge;

  /// The mascot in the menu bar. Themes can ship their own artwork.
  final String logoAsset;

  /// Darkens the editor behind open menus and dialogs.
  final Color cDimmer;

  /// Behind the window's close button while it's hovered (Windows red).
  final Color cWindowClose;
  final Color cOnWindowClose;

  /// Node color swatches, indexed by `Node.swatch`.
  final List<Color> cSwatches;

  /// Base font size.
  final double dTextHeight;
  final double dTextfieldPadding;
  final double dPanelPadding;
  final double dPanelRowDistance;

  /// Corners of panels, menus, dialogs, list entries.
  final double dPanelBorderRadius;

  /// Corners of nodes; rounder than the rest of the UI.
  final double dNodeBorderRadius;

  /// Above 0, nodes and selected list entries cast a soft shadow.
  final double dElevation;
  final double dOutlinesWidth;

  /// Height of the colored strip on top of nodes.
  final double dSwatchHeight;

  /// Outline of selected nodes, drawn inside them in their color.
  final double dSelectionWidth;
  final double dSectionPadding;
  final double dDividerWidth;

  /// Blur of card shadows; selected nodes use more.
  final double dShadowBlur;

  /// Height of buttons, text fields and node rows.
  final double dButtonHeight;
  final double dButtonBorderRadius;
  final double dScrollbarWidth;
  final double dMenuBarHeight;
  final double dLogoPadding;
  final double dStatusBarHeight;

  /// Node titles.
  TextStyle get swatchTextStyle => TextStyle(
    overflow: TextOverflow.ellipsis,
    color: cTextActive,
    fontVariations: const [FontVariation('wght', 500)],
    fontSize: dTextHeight,
    height: 1.0,
  );

  /// Video file names on nodes.
  TextStyle get filenameTextStyle =>
      TextStyle(color: cText, fontSize: dTextHeight, height: 1.0);

  /// Node color [index] (`Node.swatch`). Themes may have different numbers
  /// of colors, so the index wraps around.
  Color swatch(int index) => cSwatches[index % cSwatches.length];

  /// The soft shadow under a raised surface; [lifted] for selected nodes.
  List<BoxShadow> cardShadow({bool lifted = false}) => [
    BoxShadow(
      color: cShadow,
      blurRadius: lifted ? dShadowBlur * 2 : dShadowBlur,
      offset: Offset(0, lifted ? 6 : 2),
    ),
  ];

  @override
  AppTheme copyWith({
    Color? cBackground,
    Color? cBackgroundDots,
    Color? cAccent,
    Color? cAccentButton,
    Color? cAccentButtonHovered,
    Color? cAccentButtonPressed,
    Color? cOnAccent,
    Color? cText,
    Color? cTextActive,
    Color? cTextInactive,
    Color? cPanel,
    Color? cCard,
    Color? cCardHovered,
    Color? cButton,
    Color? cButtonHovered,
    Color? cButtonPressed,
    Color? cButtonContentUnhovered,
    Color? cListSelected,
    Color? cTextField,
    Color? cTextFieldActive,
    Color? cDivider,
    Color? cSwatchMark,
    Color? cOutlines,
    Color? cShadow,
    Color? cMenuBar,
    Color? cMenuBarText,
    Color? cLogoBadge,
    String? logoAsset,
    Color? cDimmer,
    Color? cWindowClose,
    Color? cOnWindowClose,
    List<Color>? cSwatches,
    double? dTextHeight,
    double? dTextfieldPadding,
    double? dPanelPadding,
    double? dPanelRowDistance,
    double? dPanelBorderRadius,
    double? dNodeBorderRadius,
    double? dElevation,
    double? dOutlinesWidth,
    double? dSwatchHeight,
    double? dSelectionWidth,
    double? dSectionPadding,
    double? dDividerWidth,
    double? dShadowBlur,
    double? dButtonHeight,
    double? dButtonBorderRadius,
    double? dScrollbarWidth,
    double? dMenuBarHeight,
    double? dLogoPadding,
    double? dStatusBarHeight,
  }) => AppTheme(
    cBackground: cBackground ?? this.cBackground,
    cBackgroundDots: cBackgroundDots ?? this.cBackgroundDots,
    cAccent: cAccent ?? this.cAccent,
    cAccentButton: cAccentButton ?? this.cAccentButton,
    cAccentButtonHovered: cAccentButtonHovered ?? this.cAccentButtonHovered,
    cAccentButtonPressed: cAccentButtonPressed ?? this.cAccentButtonPressed,
    cOnAccent: cOnAccent ?? this.cOnAccent,
    cText: cText ?? this.cText,
    cTextActive: cTextActive ?? this.cTextActive,
    cTextInactive: cTextInactive ?? this.cTextInactive,
    cPanel: cPanel ?? this.cPanel,
    cCard: cCard ?? this.cCard,
    cCardHovered: cCardHovered ?? this.cCardHovered,
    cButton: cButton ?? this.cButton,
    cButtonHovered: cButtonHovered ?? this.cButtonHovered,
    cButtonPressed: cButtonPressed ?? this.cButtonPressed,
    cButtonContentUnhovered:
        cButtonContentUnhovered ?? this.cButtonContentUnhovered,
    cListSelected: cListSelected ?? this.cListSelected,
    cTextField: cTextField ?? this.cTextField,
    cTextFieldActive: cTextFieldActive ?? this.cTextFieldActive,
    cDivider: cDivider ?? this.cDivider,
    cSwatchMark: cSwatchMark ?? this.cSwatchMark,
    cOutlines: cOutlines ?? this.cOutlines,
    cShadow: cShadow ?? this.cShadow,
    cMenuBar: cMenuBar ?? this.cMenuBar,
    cMenuBarText: cMenuBarText ?? this.cMenuBarText,
    cLogoBadge: cLogoBadge ?? this.cLogoBadge,
    logoAsset: logoAsset ?? this.logoAsset,
    cDimmer: cDimmer ?? this.cDimmer,
    cWindowClose: cWindowClose ?? this.cWindowClose,
    cOnWindowClose: cOnWindowClose ?? this.cOnWindowClose,
    cSwatches: cSwatches ?? this.cSwatches,
    dTextHeight: dTextHeight ?? this.dTextHeight,
    dTextfieldPadding: dTextfieldPadding ?? this.dTextfieldPadding,
    dPanelPadding: dPanelPadding ?? this.dPanelPadding,
    dPanelRowDistance: dPanelRowDistance ?? this.dPanelRowDistance,
    dPanelBorderRadius: dPanelBorderRadius ?? this.dPanelBorderRadius,
    dNodeBorderRadius: dNodeBorderRadius ?? this.dNodeBorderRadius,
    dElevation: dElevation ?? this.dElevation,
    dOutlinesWidth: dOutlinesWidth ?? this.dOutlinesWidth,
    dSwatchHeight: dSwatchHeight ?? this.dSwatchHeight,
    dSelectionWidth: dSelectionWidth ?? this.dSelectionWidth,
    dSectionPadding: dSectionPadding ?? this.dSectionPadding,
    dDividerWidth: dDividerWidth ?? this.dDividerWidth,
    dShadowBlur: dShadowBlur ?? this.dShadowBlur,
    dButtonHeight: dButtonHeight ?? this.dButtonHeight,
    dButtonBorderRadius: dButtonBorderRadius ?? this.dButtonBorderRadius,
    dScrollbarWidth: dScrollbarWidth ?? this.dScrollbarWidth,
    dMenuBarHeight: dMenuBarHeight ?? this.dMenuBarHeight,
    dLogoPadding: dLogoPadding ?? this.dLogoPadding,
    dStatusBarHeight: dStatusBarHeight ?? this.dStatusBarHeight,
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
