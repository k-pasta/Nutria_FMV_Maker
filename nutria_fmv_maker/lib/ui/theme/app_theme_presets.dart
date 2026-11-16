// The built-in themes.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// The default theme: near-black canvas, dark panels, lighter nodes, compact
/// controls for desktop.
const kDarkTheme = AppTheme();

/// Node colors of the light theme: deeper versions of the dark theme's, so
/// knots and lines stand out on the grey canvas, with a charcoal instead of
/// the violet.
const kLightSwatches = <Color>[
  Color(0xffc8243f),
  Color(0xffc73a1c),
  Color(0xff946200),
  Color(0xff16803e),
  Color(0xff1f6dcc),
  Color(0xff3a3a44),
];

/// Light theme: grey canvas, off-white panels, white nodes raised by soft
/// shadows.
const kLightTheme = AppTheme(
  cBackground: Color(0xffcdd1d8),
  cBackgroundDots: Color(0xff9ea4b0),
  cText: Color(0xd91b1b22),
  cTextActive: Color(0xff111116),
  cTextInactive: Color(0x991b1b22),
  cPanel: Color(0xfff5f6f8),
  cCard: Color(0xffffffff),
  cCardHovered: Color(0xfff4f5f7),
  cButton: Color(0xffd3d8e0),
  cButtonHovered: Color(0xffcad0da),
  cButtonPressed: Color(0xffbfc6d1),
  cButtonContentUnhovered: Color(0x991b1b22),
  cTextField: Color(0xffd3d8e0),
  cTextFieldActive: Color(0xffcad0da),
  cDivider: Color(0x2e000000),
  cOutlines: Color(0x33000000),
  cShadow: Color(0x24252a3a),
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
