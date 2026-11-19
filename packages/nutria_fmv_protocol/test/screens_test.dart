// Designed screens: what's written, what's read back, and the parts of the
// screen full-screen answers take.
import 'dart:math' as math;

import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:test/test.dart';

void main() {
  test('styles and elements keep blur, fonts, layouts and timers', () {
    const project = FmvProject(
      choiceScreen: FmvMenuScreen(
        elements: [
          FmvScreenElement(
            kind: 'choices',
            x: 0.5,
            y: 0.7,
            width: 0.6,
            layout: FmvChoiceLayout.radial,
            style: FmvScreenStyle(blur: 0.02, fontFamily: 'ebGaramond'),
          ),
          FmvScreenElement(
            kind: 'timer',
            x: 0.5,
            y: 0.95,
            width: 0.6,
            timerMode: FmvTimerMode.fromMiddle,
            thickness: 0.01,
          ),
        ],
      ),
      settingsScreen: FmvMenuScreen(
        elements: [FmvScreenElement(kind: 'volume', x: 0.5, y: 0.5, width: 1)],
      ),
      screens: {
        'end': FmvMenuScreen(
          elements: [
            FmvScreenElement(
              kind: 'choices',
              x: 0.5,
              y: 0.5,
              width: 1,
              layout: FmvChoiceLayout.columns,
            ),
          ],
        ),
      },
      nodes: {
        '001': FmvNode(
          video: 'a.mp4',
          screen: 'end',
          choices: [FmvChoice(text: 'A'), FmvChoice(text: 'B')],
        ),
      },
    );
    final read = FmvProject.decode(project.encode());
    expect(read.encode(), project.encode());
    final choices = read.choiceScreen.elements.first;
    expect(choices.layout, FmvChoiceLayout.radial);
    expect(choices.style.blur, 0.02);
    expect(choices.style.fontFamily, 'ebGaramond');
    expect(read.choiceScreen.elements.last.timerMode, FmvTimerMode.fromMiddle);
    expect(read.settingsScreen.elements.single.kind, 'volume');
    final node = read.nodes['001']!;
    expect(node.screen, 'end');
    expect(
      read.choiceScreenOf(node).elements.single.layout,
      FmvChoiceLayout.columns,
    );
  });

  test('new keys are left out when not used; unknown values fall back', () {
    const element = FmvScreenElement(kind: 'choices', x: 0, y: 0, width: 1);
    final json = element.toJson();
    expect(json.keys, isNot(contains('layout')));
    expect(json.keys, isNot(contains('timerMode')));
    expect((json['style']! as Map).keys, isNot(contains('blur')));
    final odd = FmvScreenElement.fromJson({
      ...json,
      'layout': 'spiral',
      'style': {'fontFamily': 'Comic Sans'},
    })!;
    expect(odd.layout, FmvChoiceLayout.vertical);
    expect(odd.style.fontFamily, isNull);
  });

  group('full-screen answers', () {
    test('columns and rows split the screen evenly', () {
      final columns = fmvChoiceRegions(FmvChoiceLayout.columns, 4);
      expect([for (final r in columns) r.left], [0, 0.25, 0.5, 0.75]);
      expect(columns.every((r) => r.height == 1), isTrue);
      final rows = fmvChoiceRegions(FmvChoiceLayout.rows, 2);
      expect([for (final r in rows) r.labelY], [0.25, 0.75]);
      expect(fmvChoiceRegions(FmvChoiceLayout.vertical, 3), isEmpty);
    });

    test('a pie: two answers are left and right, three left, top, right', () {
      final two = fmvChoiceRegions(FmvChoiceLayout.radial, 2);
      expect(two.first.labelX, lessThan(0.5));
      expect(two.last.labelX, greaterThan(0.5));
      final three = fmvChoiceRegions(FmvChoiceLayout.radial, 3);
      expect(three[0].labelX, lessThan(0.5));
      expect(three[1].labelY, lessThan(0.5), reason: 'the top one');
      expect(three[1].labelX, closeTo(0.5, 1e-9));
      expect(three[2].labelX, greaterThan(0.5));
      expect(
        three.fold<double>(0, (sum, r) => sum + r.sweepAngle!),
        closeTo(2 * math.pi, 1e-9),
      );
    });

    test('a point is in the slice its label is in', () {
      for (final count in [2, 3, 5, 8]) {
        final regions = fmvChoiceRegions(FmvChoiceLayout.radial, count);
        for (final (i, r) in regions.indexed) {
          expect(
            fmvRadialIndexAt(r.labelX, r.labelY, count),
            i,
            reason: '$count answers, answer $i',
          );
        }
      }
      expect(fmvRadialIndexAt(0.1, 0.5, 2), 0, reason: 'left');
      expect(fmvRadialIndexAt(0.9, 0.5, 2), 1, reason: 'right');
    });

    test('a turned pie: slices and clicks turn with it', () {
      final turned = fmvChoiceRegions(
        FmvChoiceLayout.radial,
        2,
        rotation: 90,
      );
      expect(turned.first.labelY, lessThan(0.5), reason: 'left is now top');
      for (final count in [2, 3, 5]) {
        final regions = fmvChoiceRegions(
          FmvChoiceLayout.radial,
          count,
          rotation: 37,
        );
        for (final (i, r) in regions.indexed) {
          expect(
            fmvRadialIndexAt(r.labelX, r.labelY, count, rotation: 37),
            i,
          );
        }
      }
    });

    test('answer screens keep how they come and go', () {
      const screen = FmvMenuScreen(
        fadeInMs: 800,
        fadeOutMs: 400,
        entrance: FmvScreenEntrance.zoom,
        effect: FmvScreenEffect.vignette,
        elements: [
          FmvScreenElement(
            kind: 'choices',
            x: 0.5,
            y: 0.5,
            width: 1,
            layout: FmvChoiceLayout.radial,
            rotation: 45,
          ),
        ],
      );
      final read = FmvMenuScreen.fromJson(screen.toJson());
      expect(read.toJson(), screen.toJson());
      expect(read.effect, FmvScreenEffect.vignette);
      expect(read.elements.single.rotation, 45);
      expect(const FmvMenuScreen().toJson().keys, ['elements']);
    });
  });
}
