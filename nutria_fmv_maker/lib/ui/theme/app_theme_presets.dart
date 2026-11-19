// The built-in themes.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// The default theme: near-black canvas, dark panels, lighter nodes, compact
/// controls for desktop.
const kDarkTheme = AppTheme();

/// Node colors of the light theme: the dark theme's hues, saturated but deep
/// enough that knots and lines stand out on the light canvas.
const kLightSwatches = <Color>[
  Color(0xffe0284a),
  Color(0xffd44a16),
  Color(0xffa36a00),
  Color(0xff108a40),
  Color(0xff2670e0),
  Color(0xff7a4fe0),
];

/// Light theme: a light cool-grey canvas with faint dots, off-white panels,
/// white nodes raised by soft shadows, and outlined controls.
const kLightTheme = AppTheme(
  cBackground: Color(0xffd3d8e0),
  cBackgroundDots: Color(0xffbcc1ca),
  cText: Color(0xd91b1b22),
  cTextActive: Color(0xff111116),
  cTextInactive: Color(0x991b1b22),
  cPanel: Color(0xfff5f6f8),
  // Nodes rest on a soft grey and turn white (the lightest) when hovered or
  // selected.
  cCard: Color(0xfff1f3f6),
  cCardHovered: Color(0xffffffff),
  // Light fills; a thin outline (elevation) sets them apart.
  cButton: Color(0xffe8ebf0),
  cButtonHovered: Color(0xffdfe3e9),
  cButtonPressed: Color(0xffd3d8e0),
  cButtonContentUnhovered: Color(0x991b1b22),
  cTextField: Color(0xffe8ebf0),
  cTextFieldActive: Color(0xffffffff),
  cDivider: Color(0x2e000000),
  cOutlines: Color(0x33000000),
  cShadow: Color(0x33252a3a),
  cControlOutline: Color(0x26252a3a),
  cMenuBar: Color(0xfff5f6f8),
  cMenuBarText: Color(0xff1b1b22),
  cDimmer: Color(0x40000000),
  cSwatches: kLightSwatches,
  cListSelected: Color(0xffffffff),
  // Light surfaces are told apart by soft shadows more than by fill.
  dElevation: 1,
);

/// The roomier sizes the app started with: the seed of a future, more
/// accessible theme (larger targets, stronger contrast).
const kCustomTheme = AppTheme(
  dButtonHeight: 45,
  dPanelBorderRadius: 6,
  dButtonBorderRadius: 5,
);

/// Builds the Material [ThemeData] that carries [appTheme], so Material
/// widgets (menus, scrollbars, text selection) match it too.
ThemeData buildThemeData(AppTheme appTheme, {required bool dark}) => ThemeData(
  brightness: dark ? Brightness.dark : Brightness.light,
  fontFamily: 'SourceSans',
  scaffoldBackgroundColor: appTheme.cBackground,
  splashFactory: NoSplash.splashFactory,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontWeight: FontWeight.w600),
    bodySmall: TextStyle(fontWeight: FontWeight.w600),
    headlineLarge: TextStyle(fontWeight: FontWeight.w800),
  ),
  extensions: [appTheme],
);
