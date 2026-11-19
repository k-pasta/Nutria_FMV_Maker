// Designed screens (the main menu, answer screens, the pause menu, settings,
// saved games): elements placed on a background in fractions of the
// screen, so they fit any resolution, and the styles they share.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

part 'screen.freezed.dart';
part 'screen.g.dart';

/// The kinds of screen an author can design.
enum ScreenKind {
  /// Before the story: title, Start, Load, …
  menu,

  /// Over the video while the viewer picks an answer. A project can have
  /// several; each node uses one (a setting).
  choice,

  /// Over the last frame of a video that waits for an answer ("pause on
  /// end"). Several, like [choice].
  endChoice,

  /// When the viewer pauses: Resume, Save, …
  pause,

  /// Volume, subtitles and full screen. There when a menu has a Settings
  /// button.
  settings,

  /// The saved games, to load or save over. There when a menu has a Load or
  /// Save button.
  saves;

  /// Whether a project can have more than one screen of this kind.
  bool get isMultiple => this == choice || this == endChoice;

  /// The id of the screen of this kind every project has (or gets when its
  /// buttons appear).
  String get defaultId => name;
}

/// What a screen element is. The Player shows the title and description of
/// the project and the question as text, [choices] as the answers, [timer]
/// as a bar that runs down, [volume], [subtitles] and [fullScreen] as
/// settings, [saves] as the saved games; the others are buttons.
enum ScreenElementKind {
  title,
  description,
  start,
  load,
  settings,
  credits,
  quit,
  question,
  choices,
  timer,
  resume,
  save,
  mainMenu,
  back,
  volume,
  subtitles,
  fullScreen,
  saves,
}

/// The elements each kind of screen can have, in the order of its tray.
const kScreenElementKinds = {
  ScreenKind.menu: [
    ScreenElementKind.title,
    ScreenElementKind.description,
    ScreenElementKind.start,
    ScreenElementKind.load,
    ScreenElementKind.settings,
    ScreenElementKind.credits,
    ScreenElementKind.quit,
  ],
  ScreenKind.choice: [
    ScreenElementKind.question,
    ScreenElementKind.choices,
    ScreenElementKind.timer,
  ],
  ScreenKind.endChoice: [ScreenElementKind.question, ScreenElementKind.choices],
  ScreenKind.pause: [
    ScreenElementKind.title,
    ScreenElementKind.resume,
    ScreenElementKind.save,
    ScreenElementKind.load,
    ScreenElementKind.settings,
    ScreenElementKind.mainMenu,
    ScreenElementKind.quit,
  ],
  ScreenKind.settings: [
    ScreenElementKind.title,
    ScreenElementKind.volume,
    ScreenElementKind.subtitles,
    ScreenElementKind.fullScreen,
    ScreenElementKind.back,
  ],
  ScreenKind.saves: [
    ScreenElementKind.title,
    ScreenElementKind.saves,
    ScreenElementKind.back,
  ],
};

/// The elements a screen can't do without (a menu needs Start, an answer
/// screen its answers, …). Every screen has one of each; they can't be
/// removed, so the tray doesn't offer them.
const kRequiredScreenElements = {
  ScreenKind.menu: {ScreenElementKind.start},
  ScreenKind.choice: {
    ScreenElementKind.question,
    ScreenElementKind.choices,
    ScreenElementKind.timer,
  },
  ScreenKind.endChoice: {ScreenElementKind.question, ScreenElementKind.choices},
  ScreenKind.pause: {ScreenElementKind.resume},
  ScreenKind.settings: {
    ScreenElementKind.volume,
    ScreenElementKind.subtitles,
    ScreenElementKind.fullScreen,
    ScreenElementKind.back,
  },
  ScreenKind.saves: {ScreenElementKind.saves, ScreenElementKind.back},
};

/// Whether an element of [kind] is drawn with text (so its style's text
/// size, weight and font apply).
bool screenElementHasText(ScreenElementKind kind) =>
    kind != ScreenElementKind.timer;

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

    /// An imported font file; else [builtInFont].
    String? fontId,

    /// One of the fonts both apps ship (a key of `kFmvBuiltInFonts`), or
    /// `null` for the Player's own.
    String? builtInFont,

    /// ARGB.
    @Default(0xFFFFFFFF) int textColor,
    @Default(0xFF000000) int backgroundColor,

    /// 0 (no background) to 1.
    @Default(0.0) double backgroundOpacity,

    /// Corner radius, as a fraction of the screen height.
    @Default(0.0) double radius,

    /// Space around the text, as a fraction of the screen height.
    @Default(0.01) double padding,

    /// Blur of what's behind the background, as a fraction of the screen
    /// height (0 for none).
    @Default(0.0) double blur,
  }) = _ScreenStyle;

  factory ScreenStyle.fromJson(Map<String, dynamic> json) =>
      _$ScreenStyleFromJson(json);
}

/// The styles every project starts with.
const kDefaultScreenStyles = [
  ScreenStyle(
    id: 'heading',
    name: 'Heading',
    fontSize: 0.09,
    bold: true,
    builtInFont: 'manrope',
  ),
  ScreenStyle(id: 'text', name: 'Text', fontSize: 0.035, builtInFont: 'inter'),
  ScreenStyle(
    id: 'button',
    name: 'Button',
    fontSize: 0.045,
    builtInFont: 'inter',
    backgroundOpacity: 0.55,
    radius: 0.015,
    padding: 0.015,
  ),
];

/// The style an element of [kind] uses unless it has its own.
String defaultStyleIdFor(ScreenElementKind kind) => switch (kind) {
  ScreenElementKind.title => 'heading',
  ScreenElementKind.description || ScreenElementKind.question => 'text',
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

    /// [ScreenElementKind.choices] and [ScreenElementKind.saves]: the space
    /// between entries, as a fraction of the screen height.
    @Default(0.015) double gap,

    /// [ScreenElementKind.choices]: how the answers are laid out.
    @Default(FmvChoiceLayout.vertical) FmvChoiceLayout layout,

    /// [ScreenElementKind.timer]: how the bar runs down, and how thick it
    /// is (a fraction of the screen height).
    @Default(FmvTimerMode.toStart) FmvTimerMode timerMode,
    @Default(0.012) double thickness,
  }) = _ScreenElement;

  factory ScreenElement.fromJson(Map<String, dynamic> json) =>
      _$ScreenElementFromJson(json);
}

/// A designed screen of [kind]: a background (an imported image or video)
/// and elements. Answer screens go over the video, so their background is
/// usually left empty. [id] is the kind's name for the screens every
/// project has (see [ScreenKind.defaultId]).
@freezed
abstract class ScreenDesign with _$ScreenDesign {
  const factory ScreenDesign({
    required String id,
    required ScreenKind kind,

    /// The author's name for it; `null` shows the kind's name.
    String? name,
    String? backgroundId,
    @Default(<ScreenElement>[]) List<ScreenElement> elements,
  }) = _ScreenDesign;

  factory ScreenDesign.fromJson(Map<String, dynamic> json) =>
      _$ScreenDesignFromJson(json);
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
