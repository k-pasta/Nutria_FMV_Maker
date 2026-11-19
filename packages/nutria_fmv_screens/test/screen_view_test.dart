import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:nutria_fmv_screens/nutria_fmv_screens.dart';

const _screen = Size(1600, 900);

Future<void> _pump(
  WidgetTester tester,
  FmvMenuScreen screen,
  ScreenContent content,
) async {
  tester.view.physicalSize = _screen;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: ScreenView(screen: screen, content: content),
    ),
  );
}

FmvMenuScreen _answers(FmvChoiceLayout layout, {double y = 0.7}) =>
    FmvMenuScreen(
      elements: [
        FmvScreenElement(
          kind: 'choices',
          x: 0.5,
          y: y,
          width: 0.5,
          layout: layout,
          style: const FmvScreenStyle(fontSize: 0.05, padding: 0.015),
        ),
      ],
    );

List<String> _many(int n) => [for (var i = 1; i <= n; i++) 'Answer $i'];

void main() {
  for (final layout in [FmvChoiceLayout.vertical, FmvChoiceLayout.horizontal]) {
    testWidgets('$layout: ten answers stay on the screen', (tester) async {
      await _pump(
        tester,
        _answers(layout, y: 0.5),
        ScreenContent(answers: _many(10)),
      );
      for (var i = 1; i <= 10; i++) {
        final rect = tester.getRect(find.text('Answer $i'));
        expect(rect.top, greaterThanOrEqualTo(0), reason: 'answer $i');
        expect(rect.bottom, lessThanOrEqualTo(_screen.height));
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(_screen.width));
      }
    });
  }

  testWidgets('vertical answers wrap into a second column', (tester) async {
    await _pump(
      tester,
      _answers(FmvChoiceLayout.vertical, y: 0.5),
      ScreenContent(answers: _many(10)),
    );
    final first = tester.getCenter(find.text('Answer 1'));
    final last = tester.getCenter(find.text('Answer 10'));
    expect(last.dx, greaterThan(first.dx), reason: 'another column');
  });

  testWidgets('a pie: clicking anywhere in a slice picks its answer', (
    tester,
  ) async {
    final picked = <int>[];
    await _pump(
      tester,
      _answers(FmvChoiceLayout.radial),
      ScreenContent(answers: _many(3), onAnswer: picked.add),
    );
    await tester.tapAt(const Offset(100, 800)); // bottom left
    await tester.tapAt(const Offset(800, 40)); // top
    await tester.tapAt(const Offset(1500, 800)); // bottom right
    expect(picked, [0, 1, 2]);
  });

  testWidgets('columns: each answer has its part of the screen', (
    tester,
  ) async {
    final picked = <int>[];
    await _pump(
      tester,
      _answers(FmvChoiceLayout.columns),
      ScreenContent(answers: _many(2), onAnswer: picked.add),
    );
    await tester.tapAt(const Offset(10, 10));
    await tester.tapAt(const Offset(1590, 890));
    expect(picked, [0, 1]);
  });

  testWidgets('the timer runs down from the middle out', (tester) async {
    await _pump(
      tester,
      const FmvMenuScreen(
        elements: [
          FmvScreenElement(
            kind: 'timer',
            x: 0.5,
            y: 0.5,
            width: 0.5,
            timerMode: FmvTimerMode.fromMiddle,
            thickness: 0.02,
            style: FmvScreenStyle(padding: 0),
          ),
        ],
      ),
      const ScreenContent(timeLeft: 0.5),
    );
    final bars = find.byWidgetPredicate(
      (w) => w is Container && w.decoration is BoxDecoration && w.constraints?.maxHeight == 18,
    );
    expect(bars, findsNWidgets(2), reason: 'two halves');
    final left = tester.getRect(bars.first);
    final right = tester.getRect(bars.last);
    expect(left.left, closeTo(400, 1), reason: 'at the left end');
    expect(left.width, closeTo(200, 1), reason: 'half of its half');
    expect(right.right, closeTo(1200, 1), reason: 'at the right end');
  });

  testWidgets('elements without content are hidden, except in the designer', (
    tester,
  ) async {
    const screen = FmvMenuScreen(
      elements: [
        FmvScreenElement(kind: 'question', x: 0.5, y: 0.2, width: 0.5),
      ],
    );
    await _pump(tester, screen, const ScreenContent());
    expect(find.text('question'), findsNothing);
    await _pump(
      tester,
      screen,
      const ScreenContent(showEmpty: true, texts: {'question': 'Question'}),
    );
    expect(find.text('Question'), findsOneWidget);
  });

  test('built-in fonts come from this package', () {
    final style = builtInFontStyle(
      'ebGaramond',
      const TextStyle(fontWeight: FontWeight.bold),
    );
    expect(style.fontFamily, 'packages/nutria_fmv_screens/EB Garamond');
    expect(style.fontVariations, [const FontVariation('wght', 700)]);
    expect(builtInFontStyle('nope', const TextStyle()).fontFamily, isNull);
  });
}
