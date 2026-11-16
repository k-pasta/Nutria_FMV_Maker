// Keeps the themes readable: surfaces that sit on each other must be told
// apart, and text must be legible on all of them (WCAG contrast ratios).
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme_presets.dart';

/// WCAG contrast ratio of [a] and [b] (1 to 21). Translucent colors are
/// first composited onto [over].
double contrast(Color a, Color b, {Color? over}) {
  Color flat(Color c) =>
      over == null || c.a == 1 ? c : Color.alphaBlend(c, over);
  final la = flat(a).computeLuminance();
  final lb = flat(b).computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  const themes = {'dark': kDarkTheme, 'light': kLightTheme};

  for (final MapEntry(key: name, value: t) in themes.entries) {
    group('$name theme', () {
      // (what, foreground, background, minimum)
      final pairs = <(String, Color, Color, double)>[
        ('nodes on the canvas', t.cCard, t.cBackground, 1.5),
        ('panels next to the canvas', t.cPanel, t.cBackground, 1.2),
        ('buttons on nodes', t.cButton, t.cCard, 1.3),
        ('buttons on panels', t.cButton, t.cPanel, 1.3),
        ('text fields on nodes', t.cTextField, t.cCard, 1.3),
        ('grid dots', t.cBackgroundDots, t.cBackground, 1.6),
        for (final (surface, color) in [
          ('canvas', t.cBackground),
          ('panel', t.cPanel),
          ('node', t.cCard),
          ('button', t.cButton),
          ('text field', t.cTextField),
        ]) ...[
          ('text on $surface', t.cText, color, 4.5),
          ('emphasized text on $surface', t.cTextActive, color, 4.5),
          ('placeholder text on $surface', t.cTextInactive, color, 3.0),
        ],
        for (final (i, swatch) in t.cSwatches.indexed)
          ('node color $i on the canvas (knots, lines)', swatch,
              t.cBackground, 3.0),
      ];
      for (final (what, fg, bg, minimum) in pairs) {
        test('$what: at least $minimum:1', () {
          expect(contrast(fg, bg, over: bg),
              greaterThanOrEqualTo(minimum));
        });
      }
    });
  }

  test('the dark theme has no black node color', () {
    for (final swatch in kDarkTheme.cSwatches) {
      expect(swatch.computeLuminance(), greaterThan(0.05));
    }
  });

  test('a node color index wraps around the theme\'s colors', () {
    const theme = AppTheme(cSwatches: [Color(0xff000001), Color(0xff000002)]);
    expect(theme.swatch(3), const Color(0xff000002));
  });
}
