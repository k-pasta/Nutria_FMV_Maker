// Draws a designed screen: elements at fractions of the screen, sized by
// its height, in their styles. The Maker's designer and the Player both use
// it, so what the author designs is what the viewer sees.
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:nutria_fmv_screens/src/fonts.dart';

/// Texts of elements that have none of their own, and of values (in
/// English; the Maker passes its own language's).
const kScreenTexts = {
  'start': 'Start',
  'load': 'Load',
  'save': 'Save',
  'settings': 'Settings',
  'credits': 'Credits',
  'quit': 'Quit',
  'resume': 'Resume',
  'mainMenu': 'Main Menu',
  'back': 'Back',
  'volume': 'Volume',
  'subtitles': 'Subtitles',
  'fullScreen': 'Full Screen',
  'on': 'On',
  'off': 'Off',
  'noSaves': 'No saved games',
  'text': 'Text',
};

/// The element kinds that are buttons.
const kScreenButtonKinds = {
  'start',
  'load',
  'save',
  'settings',
  'credits',
  'quit',
  'resume',
  'mainMenu',
  'back',
};

/// Narrowest an answer gets in the horizontal layout before the answers
/// wrap onto another row, as a fraction of the screen width.
const kMinAnswerWidth = 0.14;

/// The most of the screen a block of answers may take; bigger blocks are
/// scaled down to fit, so any number of answers stays on the screen.
const kMaxAnswerBlock = 0.96;

/// [text] with `**bold**` and `*italic*` shown as such (the markers are
/// left out).
TextSpan markdownSpan(String text, TextStyle style) => TextSpan(
  style: style,
  children: [
    for (final run in parseInlineMarkdown(text))
      if (!run.isMarker)
        TextSpan(
          text: run.text,
          style: TextStyle(
            fontWeight: run.bold ? FontWeight.bold : null,
            fontStyle: run.italic ? FontStyle.italic : null,
          ),
        ),
  ],
);

/// What the elements of a screen show and do.
class ScreenContent {
  const ScreenContent({
    this.title,
    this.description,
    this.question,
    this.answers = const [],
    this.picked,
    this.timeLeft,
    this.onButton,
    this.onAnswer,
    this.disabled = const {},
    this.texts = kScreenTexts,
    this.volume,
    this.onVolume,
    this.subtitles,
    this.onSubtitles,
    this.fullScreen,
    this.onFullScreen,
    this.saves = const [],
    this.onSaveSlot,
    this.showEmpty = false,
  });

  final String? title;
  final String? description;
  final String? question;
  final List<String> answers;

  /// The answer picked, drawn highlighted.
  final int? picked;

  /// For the timer: how much of the choosing time is left (1 to 0), or
  /// `null` to hide it.
  final double? timeLeft;

  /// A button element ("start", "quit", …) was clicked.
  final void Function(String kind)? onButton;

  /// Answer [index] was clicked.
  final void Function(int index)? onAnswer;

  /// Button kinds shown dimmed and not clickable (e.g. "load" without a
  /// saved game).
  final Set<String> disabled;

  /// Default texts by element kind (see [kScreenTexts]).
  final Map<String, String> texts;

  /// The settings screen: volume (0 to 100) and its change.
  final double? volume;
  final ValueChanged<double>? onVolume;

  /// The settings screen: the subtitle language's name, and stepping it
  /// (-1 or 1).
  final String? subtitles;
  final ValueChanged<int>? onSubtitles;

  /// The settings screen: whether the window fills the screen.
  final bool? fullScreen;
  final VoidCallback? onFullScreen;

  /// The saves screen: one label per saved game, and picking one.
  final List<String> saves;
  final ValueChanged<int>? onSaveSlot;

  /// For the designer: elements with nothing to show (no question, no
  /// timer, …) are drawn anyway, with their name, so they can be placed.
  final bool showEmpty;

  String text(String key) => texts[key] ?? kScreenTexts[key] ?? key;
}

/// Wraps the drawing of element [index] ([element]) of a screen, e.g. to
/// select and drag it in the designer.
typedef ScreenElementDecorator =
    Widget Function(int index, FmvScreenElement element, Widget child);

/// [screen] filling the space it's given (the Player's window, or the
/// designer's stage).
class ScreenView extends StatelessWidget {
  const ScreenView({
    super.key,
    required this.screen,
    required this.content,
    this.background,
    this.fontFamilyOf,
    this.decorate,
    this.visibility = 1,
    this.animate = true,
  });

  final FmvMenuScreen screen;
  final ScreenContent content;

  /// Drawn behind everything (the screen's image or video); `null` for
  /// nothing.
  final Widget? background;

  /// The family a font file (a style's `font`) is loaded under, or `null`
  /// while it isn't (the text then uses the style's built-in font).
  final String? Function(String path)? fontFamilyOf;

  /// See [ScreenElementDecorator].
  final ScreenElementDecorator? decorate;

  /// How far the screen has come in, 0 (not at all) to 1: drives its
  /// entrance (and, backwards, its fade-out) and the strength of its effect.
  final double visibility;

  /// Whether lasting animations (the pulse effect) run; the designer's
  /// stage draws them still.
  final bool animate;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.biggest;
      final h = size.height;
      final v = visibility.clamp(0.0, 1.0);
      final layers = <Widget>[
        // The effect on what's behind (the video, under answers).
        switch (screen.effect) {
          FmvScreenEffect.darken => Positioned.fill(
            child: ColoredBox(color: Color.fromRGBO(0, 0, 0, 0.45 * v)),
          ),
          FmvScreenEffect.blur => Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 0.012 * h * v,
                sigmaY: 0.012 * h * v,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          FmvScreenEffect.vignette => Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.9,
                  colors: [
                    const Color(0x00000000),
                    Color.fromRGBO(0, 0, 0, 0.75 * v),
                  ],
                ),
              ),
            ),
          ),
          FmvScreenEffect.none ||
          FmvScreenEffect.pulse => const SizedBox.shrink(),
        },
        if (background case final background?)
          Positioned.fill(
            child: Opacity(opacity: v, child: background),
          ),
      ];
      final children = <Widget>[];
      // Answers that fill the screen go first, behind the question and the
      // rest, which stay readable (and clickable) on top of them.
      bool fills(FmvScreenElement e) =>
          e.kind == 'choices' && e.layout.fillsScreen;
      final ordered = [
        for (final (i, e) in screen.elements.indexed)
          if (fills(e)) (i, e),
        for (final (i, e) in screen.elements.indexed)
          if (!fills(e)) (i, e),
      ];
      for (final (i, element) in ordered) {
        if (!_shows(element)) continue;
        Widget decorated(Widget child) =>
            decorate == null ? child : decorate!(i, element, child);
        final view = _ElementView(
          element: element,
          screen: size,
          content: content,
          fontFamilyOf: fontFamilyOf,
        );
        if (element.kind == 'choices' && element.layout.fillsScreen) {
          children.add(Positioned.fill(child: decorated(view)));
        } else {
          children.add(
            Positioned(
              left: element.x * size.width,
              top: element.y * h,
              child: FractionalTranslation(
                translation: const Offset(-0.5, -0.5),
                child: decorated(view),
              ),
            ),
          );
        }
      }
      Widget elements = Stack(children: children);
      if (screen.effect == FmvScreenEffect.pulse && animate) {
        elements = _Pulse(child: elements);
      }
      // The entrance: fading, and rising or growing, as the screen comes in.
      elements = Opacity(
        opacity: v,
        child: switch (screen.entrance) {
          FmvScreenEntrance.fade => elements,
          FmvScreenEntrance.slideUp => Transform.translate(
            offset: Offset(0, (1 - v) * 0.04 * h),
            child: elements,
          ),
          FmvScreenEntrance.zoom => Transform.scale(
            scale: 0.94 + 0.06 * v,
            child: elements,
          ),
        },
      );
      // A plain default text style: drawn outside a Material (a preview
      // window), text would otherwise get Flutter's "no style" underline.
      return DefaultTextStyle(
        style: const TextStyle(),
        child: ClipRect(
          child: Stack(
            children: [
              ...layers,
              Positioned.fill(child: elements),
            ],
          ),
        ),
      );
    },
  );

  bool _shows(FmvScreenElement element) {
    if (content.showEmpty) return true;
    return switch (element.kind) {
      'question' => content.question?.trim().isNotEmpty ?? false,
      'choices' => content.answers.isNotEmpty,
      'timer' => content.timeLeft != null,
      'title' => content.title?.trim().isNotEmpty ?? false,
      'description' => content.description?.trim().isNotEmpty ?? false,
      'volume' => content.volume != null,
      'subtitles' => content.subtitles != null,
      'fullScreen' => content.fullScreen != null,
      'saves' => true,
      'text' => element.text?.trim().isNotEmpty ?? false,
      final kind => kScreenButtonKinds.contains(kind),
    };
  }
}

/// The text style of [style] on a screen [h] high.
TextStyle screenTextStyle(
  FmvScreenStyle style,
  double h, {
  String? Function(String path)? fontFamilyOf,
}) {
  final base = TextStyle(
    fontSize: style.fontSize * h,
    fontWeight: style.bold ? FontWeight.bold : FontWeight.normal,
    color: Color(style.textColor),
    height: 1.2,
  );
  final file = switch (style.font) {
    final path? => fontFamilyOf?.call(path),
    null => null,
  };
  if (file != null) return base.copyWith(fontFamily: file);
  if (style.fontFamily case final name?) return builtInFontStyle(name, base);
  return base;
}

/// One element in its style.
class _ElementView extends StatelessWidget {
  const _ElementView({
    required this.element,
    required this.screen,
    required this.content,
    required this.fontFamilyOf,
  });

  final FmvScreenElement element;
  final Size screen;
  final ScreenContent content;
  final String? Function(String path)? fontFamilyOf;

  @override
  Widget build(BuildContext context) {
    final style = element.style;
    final h = screen.height;
    final textStyle = screenTextStyle(style, h, fontFamilyOf: fontFamilyOf);
    final width = element.width * screen.width;

    Widget text(String value, {TextStyle? style}) => Text.rich(
      markdownSpan(value, style ?? textStyle),
      textAlign: TextAlign.center,
    );
    Widget box(Widget child, {VoidCallback? onTap, bool dimmed = false}) =>
        SizedBox(
          width: width,
          child: ScreenBox(
            style: style,
            screenHeight: h,
            dimmed: dimmed,
            onTap: onTap,
            child: child,
          ),
        );
    // An element with nothing to show, in the designer: its name, faint.
    Widget placeholder(String name) =>
        Opacity(opacity: 0.35, child: box(text(name)));

    switch (element.kind) {
      case 'choices':
        final answers = content.answers;
        if (answers.isEmpty) return placeholder(content.text('choices'));
        if (element.layout.fillsScreen) {
          return _FullScreenAnswers(
            element: element,
            content: content,
            screen: screen,
            textStyle: textStyle,
          );
        }
        return _AnswerList(
          element: element,
          content: content,
          screen: screen,
          text: text,
        );
      case 'timer':
        final left = content.timeLeft;
        if (left == null) {
          return content.showEmpty
              ? Opacity(opacity: 0.35, child: _timer(0.6))
              : const SizedBox.shrink();
        }
        return _timer(left);
      case 'text':
        final value = element.text;
        if (value == null || value.trim().isEmpty) {
          return placeholder(content.text('text'));
        }
        return box(text(value));
      case 'title' || 'description' || 'question':
        final value =
            element.text ??
            switch (element.kind) {
              'title' => content.title,
              'description' => content.description,
              _ => content.question,
            };
        if (value == null || value.trim().isEmpty) {
          return placeholder(content.text(element.kind));
        }
        return box(text(value));
      case 'volume':
        final volume = content.volume ?? 70;
        return box(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              text(element.text ?? content.text('volume')),
              SizedBox(height: style.padding * h),
              _ValueBar(
                value: volume / 100,
                color: Color(style.textColor),
                height: math.max(4, style.fontSize * h * 0.3),
                onChanged: content.onVolume == null
                    ? null
                    : (v) => content.onVolume!((v * 100).roundToDouble()),
              ),
            ],
          ),
        );
      case 'subtitles':
        final value = content.subtitles ?? content.text('off');
        final step = content.onSubtitles;
        return box(
          Row(
            children: [
              _Arrow(
                left: true,
                style: textStyle,
                onTap: step == null ? null : () => step(-1),
              ),
              Expanded(
                child: text(
                  '${element.text ?? content.text('subtitles')}: $value',
                ),
              ),
              _Arrow(
                left: false,
                style: textStyle,
                onTap: step == null ? null : () => step(1),
              ),
            ],
          ),
        );
      case 'fullScreen':
        final on = content.fullScreen ?? false;
        return box(
          text(
            '${element.text ?? content.text('fullScreen')}: '
            '${content.text(on ? 'on' : 'off')}',
          ),
          onTap: content.onFullScreen,
        );
      case 'saves':
        final saves = content.saves;
        if (saves.isEmpty) {
          return box(text(content.text('noSaves')), dimmed: true);
        }
        return SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, label) in saves.indexed) ...[
                if (i > 0) SizedBox(height: (element.gap ?? 0.015) * h),
                ScreenBox(
                  style: style,
                  screenHeight: h,
                  onTap: content.onSaveSlot == null
                      ? null
                      : () => content.onSaveSlot!(i),
                  child: text(label),
                ),
              ],
            ],
          ),
        );
      default:
        final kind = element.kind;
        final disabled = content.disabled.contains(kind);
        return box(
          text(element.text ?? content.text(kind)),
          dimmed: disabled,
          onTap: disabled || content.onButton == null
              ? null
              : () => content.onButton!(kind),
        );
    }
  }

  /// The timer: a track in the background color, the time left in the
  /// text color, running down by the element's mode.
  Widget _timer(double left) {
    final style = element.style;
    final h = screen.height;
    final thickness = (element.thickness ?? style.fontSize * 0.4) * h;
    final bar = Container(
      height: thickness,
      decoration: BoxDecoration(
        color: Color(style.textColor),
        borderRadius: BorderRadius.circular(style.radius * h),
      ),
    );
    final Widget run = switch (element.timerMode) {
      FmvTimerMode.toStart => Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(widthFactor: left, child: bar),
      ),
      FmvTimerMode.toMiddle => Center(
        child: FractionallySizedBox(widthFactor: left, child: bar),
      ),
      // Two halves, each shrinking towards its own end.
      FmvTimerMode.fromMiddle => Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(widthFactor: left, child: bar),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(widthFactor: left, child: bar),
            ),
          ),
        ],
      ),
    };
    return SizedBox(
      width: element.width * screen.width,
      child: ScreenBox(
        style: style,
        screenHeight: h,
        child: SizedBox(height: thickness, child: run),
      ),
    );
  }
}

/// The answers one under the other (more columns when they don't fit the
/// screen's height) or side by side (more rows when each would get
/// narrower than [kMinAnswerWidth]). A block bigger than the screen is
/// scaled down to fit.
class _AnswerList extends StatelessWidget {
  const _AnswerList({
    required this.element,
    required this.content,
    required this.screen,
    required this.text,
  });

  final FmvScreenElement element;
  final ScreenContent content;
  final Size screen;
  final Widget Function(String value, {TextStyle? style}) text;

  @override
  Widget build(BuildContext context) {
    final h = screen.height;
    final gap = (element.gap ?? 0.015) * h;
    final answers = content.answers;
    final vertical = element.layout == FmvChoiceLayout.vertical;
    final width = element.width * screen.width;
    final itemWidth = vertical
        ? width
        : math.max(
            kMinAnswerWidth * screen.width,
            (width - (answers.length - 1) * gap) / answers.length,
          );
    final items = [
      for (final (i, answer) in answers.indexed)
        SizedBox(
          width: math.min(itemWidth, width),
          child: ScreenBox(
            style: element.style,
            screenHeight: h,
            highlighted: content.picked == i,
            dimmed: content.picked != null && content.picked != i,
            onTap: content.onAnswer == null ? null : () => content.onAnswer!(i),
            child: text(answer),
          ),
        ),
    ];
    final Widget block = vertical
        // Wraps into another column at 90% of the screen's height.
        ? ConstrainedBox(
            constraints: BoxConstraints(maxHeight: h * 0.9),
            child: Wrap(
              direction: Axis.vertical,
              spacing: gap,
              runSpacing: gap,
              children: items,
            ),
          )
        : SizedBox(
            width: width,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: gap,
              runSpacing: gap,
              children: items,
            ),
          );
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screen.width * kMaxAnswerBlock,
        maxHeight: h * kMaxAnswerBlock,
      ),
      child: FittedBox(fit: BoxFit.scaleDown, child: block),
    );
  }
}

/// Answers that split the whole screen: columns, rows or a pie. The whole
/// part of an answer is clickable, and lights up under the mouse.
class _FullScreenAnswers extends StatefulWidget {
  const _FullScreenAnswers({
    required this.element,
    required this.content,
    required this.screen,
    required this.textStyle,
  });

  final FmvScreenElement element;
  final ScreenContent content;
  final Size screen;
  final TextStyle textStyle;

  @override
  State<_FullScreenAnswers> createState() => _FullScreenAnswersState();
}

class _FullScreenAnswersState extends State<_FullScreenAnswers> {
  int? _hovered;

  int? _indexAt(Offset local, List<FmvChoiceRegion> regions) {
    final size = widget.screen;
    final x = local.dx / size.width;
    final y = local.dy / size.height;
    if (widget.element.layout == FmvChoiceLayout.radial) {
      return fmvRadialIndexAt(
        x,
        y,
        regions.length,
        aspect: size.width / size.height,
        rotation: widget.element.rotation,
      );
    }
    for (final (i, r) in regions.indexed) {
      if (x >= r.left &&
          x <= r.left + r.width &&
          y >= r.top &&
          y <= r.top + r.height) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final element = widget.element;
    final content = widget.content;
    final size = widget.screen;
    final style = element.style;
    final h = size.height;
    final answers = content.answers;
    final regions = fmvChoiceRegions(
      element.layout,
      answers.length,
      aspect: size.width / size.height,
      rotation: element.rotation,
    );
    final lit = content.picked ?? _hovered;
    final onAnswer = content.onAnswer;
    final labelWidth = switch (element.layout) {
      FmvChoiceLayout.columns => size.width / answers.length * 0.85,
      FmvChoiceLayout.rows => size.width * element.width,
      _ => size.width * math.min(element.width, 0.3),
    };
    Widget painted = CustomPaint(
      size: size,
      painter: _RegionsPainter(
        regions: regions,
        radial: element.layout == FmvChoiceLayout.radial,
        fill: Color(style.backgroundColor),
        opacity: style.backgroundOpacity,
        lit: lit,
        line: Color(style.textColor).withValues(alpha: 0.35),
      ),
    );
    if (style.blur > 0) {
      painted = BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: style.blur * h,
          sigmaY: style.blur * h,
        ),
        child: painted,
      );
    }
    final stack = Stack(
      children: [
        Positioned.fill(child: painted),
        for (final (i, r) in regions.indexed)
          Positioned(
            left: r.labelX * size.width - labelWidth / 2,
            width: labelWidth,
            top: r.labelY * h,
            child: FractionalTranslation(
              translation: const Offset(0, -0.5),
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: content.picked != null && content.picked != i
                      ? 0.45
                      : 1,
                  child: Padding(
                    padding: EdgeInsets.all(style.padding * h),
                    child: Text.rich(
                      markdownSpan(answers[i], widget.textStyle),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    if (onAnswer == null) return stack;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (e) {
        final i = _indexAt(e.localPosition, regions);
        if (i != _hovered) setState(() => _hovered = i);
      },
      onExit: (_) => setState(() => _hovered = null),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) {
          if (_indexAt(d.localPosition, regions) case final i?) onAnswer(i);
        },
        child: stack,
      ),
    );
  }
}

class _RegionsPainter extends CustomPainter {
  const _RegionsPainter({
    required this.regions,
    required this.radial,
    required this.fill,
    required this.opacity,
    required this.lit,
    required this.line,
  });

  final List<FmvChoiceRegion> regions;
  final bool radial;
  final Color fill;
  final double opacity;
  final int? lit;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, size.height / 400);
    final center = size.center(Offset.zero);
    // Far enough to reach every corner.
    final reach = size.longestSide;
    for (final (i, r) in regions.indexed) {
      final paint = Paint()
        ..color = fill.withValues(
          alpha: (opacity + (i == lit ? 0.25 : 0)).clamp(0.0, 1.0),
        );
      if (radial) {
        final path = Path()..moveTo(center.dx, center.dy);
        if (regions.length == 1) {
          path.addRect(Offset.zero & size);
        } else {
          // Angles are clockwise from straight up; Flutter's from the right.
          path.arcTo(
            Rect.fromCircle(center: center, radius: reach),
            r.startAngle! - math.pi / 2,
            r.sweepAngle!,
            false,
          );
          path.close();
        }
        canvas.save();
        canvas.clipRect(Offset.zero & size);
        canvas.drawPath(path, paint);
        if (regions.length > 1) {
          final a = r.startAngle! - math.pi / 2;
          canvas.drawLine(
            center,
            center + Offset(math.cos(a), math.sin(a)) * reach,
            stroke,
          );
        }
        canvas.restore();
      } else {
        final rect = Rect.fromLTWH(
          r.left * size.width,
          r.top * size.height,
          r.width * size.width,
          r.height * size.height,
        );
        canvas.drawRect(rect, paint);
        if (i > 0) {
          if (r.top == 0) {
            canvas.drawLine(rect.topLeft, rect.bottomLeft, stroke);
          } else {
            canvas.drawLine(rect.topLeft, rect.topRight, stroke);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_RegionsPainter old) =>
      old.regions != regions ||
      old.lit != lit ||
      old.fill != fill ||
      old.opacity != opacity ||
      old.line != line ||
      old.radial != radial;
}

/// A box in [style]: its background (blurring what's behind, if the style
/// says so), rounded corners and padding. Clickable boxes brighten under the
/// mouse; [highlighted] ones (the picked answer) are outlined.
class ScreenBox extends StatefulWidget {
  const ScreenBox({
    super.key,
    required this.style,
    required this.screenHeight,
    required this.child,
    this.onTap,
    this.highlighted = false,
    this.dimmed = false,
  });

  final FmvScreenStyle style;
  final double screenHeight;
  final Widget child;
  final VoidCallback? onTap;
  final bool highlighted;
  final bool dimmed;

  @override
  State<ScreenBox> createState() => _ScreenBoxState();
}

class _ScreenBoxState extends State<ScreenBox> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final h = widget.screenHeight;
    final lit = widget.highlighted || (_hovered && widget.onTap != null);
    final opacity = (style.backgroundOpacity + (lit ? 0.25 : 0)).clamp(
      0.0,
      1.0,
    );
    final radius = BorderRadius.circular(style.radius * h);
    Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: EdgeInsets.all(style.padding * h),
      decoration: BoxDecoration(
        color: Color(style.backgroundColor).withValues(alpha: opacity),
        borderRadius: radius,
        border: widget.highlighted
            ? Border.all(color: Color(style.textColor), width: 2)
            : null,
      ),
      child: widget.child,
    );
    if (style.blur > 0) {
      box = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: style.blur * h,
            sigmaY: style.blur * h,
          ),
          child: box,
        ),
      );
    }
    box = AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: widget.dimmed ? 0.45 : 1,
      child: box,
    );
    if (widget.onTap == null) return box;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(onTap: widget.onTap, child: box),
    );
  }
}

/// A bar filled to [value] (0 to 1); clicking or dragging on it sets it.
class _ValueBar extends StatelessWidget {
  const _ValueBar({
    required this.value,
    required this.color,
    required this.height,
    this.onChanged,
  });

  final double value;
  final Color color;
  final double height;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      void set(Offset local) =>
          onChanged?.call((local.dx / constraints.maxWidth).clamp(0.0, 1.0));
      final radius = BorderRadius.circular(height / 2);
      final bar = Container(
        height: height,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: radius,
        ),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(color: color, borderRadius: radius),
          ),
        ),
      );
      if (onChanged == null) return bar;
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          dragStartBehavior: DragStartBehavior.down,
          onTapDown: (d) => set(d.localPosition),
          onHorizontalDragUpdate: (d) => set(d.localPosition),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height),
            child: bar,
          ),
        ),
      );
    },
  );
}

/// ◀ or ▶ beside a value that steps.
class _Arrow extends StatelessWidget {
  const _Arrow({required this.left, required this.style, this.onTap});

  final bool left;
  final TextStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final arrow = Text(left ? '◀' : '▶', style: style);
    if (onTap == null) return arrow;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onTap, child: arrow),
    );
  }
}

/// Makes [child] breathe: a slow, slight growing and shrinking.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});

  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => Transform.scale(
      scale: 1 + 0.015 * Curves.easeInOut.transform(_controller.value),
      child: child,
    ),
    child: widget.child,
  );
}
