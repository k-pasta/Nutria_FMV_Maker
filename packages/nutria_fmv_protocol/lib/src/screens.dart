// Designed screens (menus, answers, settings, saves): positions and sizes
// are fractions of the screen, so they fit any resolution.
import 'dart:math' as math;

/// The fonts both apps ship (all SIL Open Font License, with Latin, Greek
/// and Cyrillic), by the name a style gives in "fontFamily".
const kFmvBuiltInFonts = {
  'inter': 'Inter',
  'manrope': 'Manrope',
  'ebGaramond': 'EB Garamond',
  'comfortaa': 'Comfortaa',
  'jetBrainsMono': 'JetBrains Mono',
};

/// How the "choices" element lays out its answers.
enum FmvChoiceLayout {
  /// One under the other; more columns when they don't fit.
  vertical,

  /// Side by side; more rows when they don't fit.
  horizontal,

  /// The screen split into side-by-side columns, one per answer.
  columns,

  /// The screen split into rows, one per answer.
  rows,

  /// The screen split like a pie around its middle.
  radial;

  /// Whether the answers fill the whole screen (the element's place and
  /// width aren't used).
  bool get fillsScreen => this == columns || this == rows || this == radial;
}

/// How the "timer" bar runs down.
enum FmvTimerMode {
  /// From the right end to the left.
  toStart,

  /// From both ends to the middle.
  toMiddle,

  /// From the middle out to both ends.
  fromMiddle,
}

T _enumOr<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

/// One answer's part of the screen in a full-screen layout. [left], [top],
/// [width] and [height] are fractions of the screen; the label goes at
/// ([labelX], [labelY]). Radial parts are the pie slice from [startAngle]
/// sweeping [sweepAngle] (radians, clockwise from straight up); the others
/// are the rectangle.
class FmvChoiceRegion {
  const FmvChoiceRegion({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.labelX,
    required this.labelY,
    this.startAngle,
    this.sweepAngle,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final double labelX;
  final double labelY;
  final double? startAngle;
  final double? sweepAngle;
}

/// The parts of the screen [count] answers take in full-screen [layout],
/// on a screen [aspect] (width / height) wide. Empty for the other
/// layouts. Radial slices start at the bottom and go clockwise, so two
/// answers are left and right, and three are left, top and right.
List<FmvChoiceRegion> fmvChoiceRegions(
  FmvChoiceLayout layout,
  int count, {
  double aspect = 16 / 9,
}) {
  if (count <= 0) return const [];
  switch (layout) {
    case FmvChoiceLayout.columns:
      return [
        for (var i = 0; i < count; i++)
          FmvChoiceRegion(
            left: i / count,
            top: 0,
            width: 1 / count,
            height: 1,
            labelX: (i + 0.5) / count,
            labelY: 0.5,
          ),
      ];
    case FmvChoiceLayout.rows:
      return [
        for (var i = 0; i < count; i++)
          FmvChoiceRegion(
            left: 0,
            top: i / count,
            width: 1,
            height: 1 / count,
            labelX: 0.5,
            labelY: (i + 0.5) / count,
          ),
      ];
    case FmvChoiceLayout.radial:
      final sweep = 2 * math.pi / count;
      return [
        for (var i = 0; i < count; i++)
          _slice(math.pi + i * sweep, sweep, count, aspect),
      ];
    case FmvChoiceLayout.vertical || FmvChoiceLayout.horizontal:
      return const [];
  }
}

FmvChoiceRegion _slice(double start, double sweep, int count, double aspect) {
  final middle = start + sweep / 2;
  // A third of the screen height from the middle (further for one answer,
  // which is the whole screen).
  final r = count == 1 ? 0.0 : 0.3;
  return FmvChoiceRegion(
    left: 0,
    top: 0,
    width: 1,
    height: 1,
    labelX: 0.5 + math.sin(middle) * r / aspect,
    labelY: 0.5 - math.cos(middle) * r,
    startAngle: start,
    sweepAngle: sweep,
  );
}

/// Which of [count] radial answers the point ([x], [y]) (fractions of a
/// screen [aspect] wide) is in.
int fmvRadialIndexAt(double x, double y, int count, {double aspect = 16 / 9}) {
  if (count <= 1) return 0;
  // Clockwise from straight up, in screen proportions.
  var angle = math.atan2((x - 0.5) * aspect, 0.5 - y);
  final sweep = 2 * math.pi / count;
  angle = (angle - math.pi) % (2 * math.pi);
  if (angle < 0) angle += 2 * math.pi;
  return (angle ~/ sweep).clamp(0, count - 1);
}

/// How an element looks. Sizes are fractions of the screen height; colors
/// are written as "#AARRGGBB".
class FmvScreenStyle {
  const FmvScreenStyle({
    this.fontSize = 0.05,
    this.bold = false,
    this.font,
    this.textColor = 0xFFFFFFFF,
    this.backgroundColor = 0xFF000000,
    this.backgroundOpacity = 0,
    this.radius = 0,
    this.padding = 0.01,
    this.blur = 0,
    this.fontFamily,
  });

  final double fontSize;
  final bool bold;

  /// Path of a font file, or `null` for [fontFamily].
  final String? font;

  /// One of [kFmvBuiltInFonts], used when there is no [font] file; `null`
  /// for the Player's font. (Added after the first screens.)
  final String? fontFamily;

  /// How much what's behind the box is blurred, as a fraction of the
  /// screen height (0 for none). (Added after the first screens.)
  final double blur;

  /// ARGB.
  final int textColor;
  final int backgroundColor;
  final double backgroundOpacity;
  final double radius;
  final double padding;

  static String _hex(int argb) =>
      '#${argb.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  static int? _color(Object? value) {
    if (value is! String || !value.startsWith('#')) return null;
    return int.tryParse(value.substring(1), radix: 16);
  }

  Map<String, Object?> toJson() => {
        'fontSize': fontSize,
        'bold': bold,
        if (font != null) 'font': font,
        'textColor': _hex(textColor),
        'backgroundColor': _hex(backgroundColor),
        'backgroundOpacity': backgroundOpacity,
        'radius': radius,
        'padding': padding,
        if (blur > 0) 'blur': blur,
        if (fontFamily != null) 'fontFamily': fontFamily,
      };

  factory FmvScreenStyle.fromJson(Map<String, Object?> json) {
    double number(Object? v, double fallback) =>
        v is num ? v.toDouble() : fallback;
    final font = json['font'];
    final family = json['fontFamily'];
    return FmvScreenStyle(
      fontSize: number(json['fontSize'], 0.05),
      bold: json['bold'] == true,
      font: font is String ? font : null,
      textColor: _color(json['textColor']) ?? 0xFFFFFFFF,
      backgroundColor: _color(json['backgroundColor']) ?? 0xFF000000,
      backgroundOpacity: number(json['backgroundOpacity'], 0),
      radius: number(json['radius'], 0),
      padding: number(json['padding'], 0.01),
      blur: number(json['blur'], 0),
      fontFamily: family is String && kFmvBuiltInFonts.containsKey(family)
          ? family
          : null,
    );
  }
}

/// One element, centered at ([x], [y]) and [width] wide (fractions).
/// [kind] is one of:
/// - text: "title", "description", "question" (the choice's question);
/// - buttons: "start", "load", "save", "settings", "credits", "quit",
///   "resume", "mainMenu" (back to the main menu) and "back" (from the
///   settings or saves screen);
/// - "choices": the answers, laid out by [layout], [gap] apart;
/// - "timer": a bar [thickness] high that runs down by [timerMode] while
///   the viewer chooses;
/// - settings: "volume", "subtitles" (the language) and "fullScreen";
/// - "saves": the saved games, to load (or save over).
///
/// [text] replaces the default text. Readers skip kinds they don't know.
class FmvScreenElement {
  const FmvScreenElement({
    required this.kind,
    required this.x,
    required this.y,
    required this.width,
    this.text,
    this.gap,
    this.layout = FmvChoiceLayout.vertical,
    this.timerMode = FmvTimerMode.toStart,
    this.thickness,
    this.style = const FmvScreenStyle(),
  });

  final String kind;
  final double x;
  final double y;
  final double width;
  final String? text;

  /// "choices": the space between answers, as a fraction of the screen
  /// height. (Added with the choice screen.)
  final double? gap;

  /// "choices": how the answers are laid out. (Added after the first
  /// screens.)
  final FmvChoiceLayout layout;

  /// "timer": how the bar runs down, and how high it is (a fraction of the
  /// screen height; `null`: from the text size, as the first screens
  /// did). (Added after the first screens.)
  final FmvTimerMode timerMode;
  final double? thickness;
  final FmvScreenStyle style;

  Map<String, Object?> toJson() => {
        'kind': kind,
        'x': x,
        'y': y,
        'width': width,
        if (text != null) 'text': text,
        if (gap != null) 'gap': gap,
        if (layout != FmvChoiceLayout.vertical) 'layout': layout.name,
        if (timerMode != FmvTimerMode.toStart) 'timerMode': timerMode.name,
        if (thickness != null) 'thickness': thickness,
        'style': style.toJson(),
      };

  static FmvScreenElement? fromJson(Map<String, Object?> json) {
    final kind = json['kind'];
    if (kind is! String) return null;
    double number(Object? v, double fallback) =>
        v is num ? v.toDouble() : fallback;
    final text = json['text'];
    final style = json['style'];
    return FmvScreenElement(
      kind: kind,
      x: number(json['x'], 0.5),
      y: number(json['y'], 0.5),
      width: number(json['width'], 0.3),
      text: text is String ? text : null,
      gap: json['gap'] is num ? (json['gap'] as num).toDouble() : null,
      layout: _enumOr(
        FmvChoiceLayout.values,
        json['layout'],
        FmvChoiceLayout.vertical,
      ),
      timerMode: _enumOr(
        FmvTimerMode.values,
        json['timerMode'],
        FmvTimerMode.toStart,
      ),
      thickness: json['thickness'] is num
          ? (json['thickness'] as num).toDouble()
          : null,
      style: FmvScreenStyle.fromJson(
        style is Map ? Map<String, Object?>.from(style) : const {},
      ),
    );
  }
}

/// A designed screen: a background (image or video path) and elements.
/// Used for the main menu, the answers (over the video, so usually without
/// a background), the pause menu, settings and saved games.
class FmvMenuScreen {
  const FmvMenuScreen({this.background, this.elements = const []});

  final String? background;
  final List<FmvScreenElement> elements;

  bool get isEmpty => background == null && elements.isEmpty;

  Map<String, Object?> toJson() => {
        if (background != null) 'background': background,
        'elements': [for (final e in elements) e.toJson()],
      };

  factory FmvMenuScreen.fromJson(Map<String, Object?> json) {
    final background = json['background'];
    final elements = json['elements'];
    return FmvMenuScreen(
      background: background is String ? background : null,
      elements: [
        if (elements is List)
          for (final e in elements)
            if (e is Map)
              if (FmvScreenElement.fromJson(Map<String, Object?>.from(e))
                  case final element?)
                element,
      ],
    );
  }
}
