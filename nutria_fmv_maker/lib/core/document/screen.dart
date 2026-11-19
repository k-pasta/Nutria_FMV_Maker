// Designed screens (for now the main menu): elements placed on a background
// in fractions of the screen, so they fit any resolution, and the styles
// they share.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen.freezed.dart';
part 'screen.g.dart';

/// What a menu element is. The Player shows the title and description of
/// the project, and makes the others buttons.
enum ScreenElementKind {
  title,
  description,
  start,
  load,
  settings,
  credits,
  quit,
}

/// How elements look. Sizes are fractions of the screen height, so a style
/// looks the same at every resolution.
@freezed
abstract class ScreenStyle with _$ScreenStyle {
  const factory ScreenStyle({
    required String id,
    required String name,

    /// Text height, as a fraction of the screen height.
    @Default(0.05) double fontSize,
    @Default(false) bool bold,

    /// An imported font file, or `null` for the Player's own font.
    String? fontId,

    /// ARGB.
    @Default(0xFFFFFFFF) int textColor,
    @Default(0xFF000000) int backgroundColor,

    /// 0 (no background) to 1.
    @Default(0.0) double backgroundOpacity,

    /// Corner radius, as a fraction of the screen height.
    @Default(0.0) double radius,

    /// Space around the text, as a fraction of the screen height.
    @Default(0.01) double padding,
  }) = _ScreenStyle;

  factory ScreenStyle.fromJson(Map<String, dynamic> json) =>
      _$ScreenStyleFromJson(json);
}

/// The styles every project starts with.
const kDefaultScreenStyles = [
  ScreenStyle(id: 'heading', name: 'Heading', fontSize: 0.09, bold: true),
  ScreenStyle(id: 'text', name: 'Text', fontSize: 0.035),
  ScreenStyle(
    id: 'button',
    name: 'Button',
    fontSize: 0.045,
    backgroundOpacity: 0.55,
    radius: 0.015,
    padding: 0.015,
  ),
];

/// The style an element of [kind] uses unless it has its own.
String defaultStyleIdFor(ScreenElementKind kind) => switch (kind) {
  ScreenElementKind.title => 'heading',
  ScreenElementKind.description => 'text',
  _ => 'button',
};

/// One element on a screen, centered at ([x], [y]) and [width] wide, all as
/// fractions of the screen (0 to 1).
@freezed
abstract class ScreenElement with _$ScreenElement {
  const factory ScreenElement({
    required String id,
    required ScreenElementKind kind,
    @Default(0.5) double x,
    @Default(0.5) double y,
    @Default(0.3) double width,

    /// The style, or `null` for the default of its kind.
    String? styleId,

    /// Text instead of the default (the project title, "Start", …).
    String? text,
  }) = _ScreenElement;

  factory ScreenElement.fromJson(Map<String, dynamic> json) =>
      _$ScreenElementFromJson(json);
}

/// The main menu: a background (an imported image or video) and elements.
@freezed
abstract class MenuScreen with _$MenuScreen {
  const factory MenuScreen({
    String? backgroundId,
    @Default(<ScreenElement>[]) List<ScreenElement> elements,
  }) = _MenuScreen;

  factory MenuScreen.fromJson(Map<String, dynamic> json) =>
      _$MenuScreenFromJson(json);
}

/// Where a moved point snaps: to the middle, and to the centers of other
/// elements, when within [threshold]. Returns the point and the guides it
/// snapped to (x and y lines, or `null`).
({double x, double y, double? guideX, double? guideY}) snapScreenPoint(
  double x,
  double y, {
  required Iterable<ScreenElement> others,
  double threshold = 0.012,
}) {
  double? snap(double value, Iterable<double> targets) {
    double? best;
    for (final target in targets) {
      if ((target - value).abs() <= threshold &&
          (best == null || (target - value).abs() < (best - value).abs())) {
        best = target;
      }
    }
    return best;
  }

  final gx = snap(x, [0.5, for (final o in others) o.x]);
  final gy = snap(y, [0.5, for (final o in others) o.y]);
  return (x: gx ?? x, y: gy ?? y, guideX: gx, guideY: gy);
}
