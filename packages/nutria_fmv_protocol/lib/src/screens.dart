// Designed screens (for now the main menu): positions and sizes are
// fractions of the screen, so they fit any resolution.

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
  });

  final double fontSize;
  final bool bold;

  /// Path of a font file, or `null` for the Player's font.
  final String? font;

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
      };

  factory FmvScreenStyle.fromJson(Map<String, Object?> json) {
    double number(Object? v, double fallback) =>
        v is num ? v.toDouble() : fallback;
    final font = json['font'];
    return FmvScreenStyle(
      fontSize: number(json['fontSize'], 0.05),
      bold: json['bold'] == true,
      font: font is String ? font : null,
      textColor: _color(json['textColor']) ?? 0xFFFFFFFF,
      backgroundColor: _color(json['backgroundColor']) ?? 0xFF000000,
      backgroundOpacity: number(json['backgroundOpacity'], 0),
      radius: number(json['radius'], 0),
      padding: number(json['padding'], 0.01),
    );
  }
}

/// One element, centered at ([x], [y]) and [width] wide (fractions).
/// [kind] is one of:
/// - text: "title", "description", "question" (the choice's question);
/// - buttons: "start", "load", "save", "settings", "credits", "quit",
///   "resume" and "mainMenu" (back to the main menu);
/// - "choices": the answers, one under the other, [gap] apart;
/// - "timer": a bar that empties while the viewer chooses.
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
  final FmvScreenStyle style;

  Map<String, Object?> toJson() => {
        'kind': kind,
        'x': x,
        'y': y,
        'width': width,
        if (text != null) 'text': text,
        if (gap != null) 'gap': gap,
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
      style: FmvScreenStyle.fromJson(
        style is Map ? Map<String, Object?>.from(style) : const {},
      ),
    );
  }
}

/// A designed screen: a background (image or video path) and elements.
/// Used for the main menu, the choice screen (over the paused video, so
/// usually without a background) and the pause screen.
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
