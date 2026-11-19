import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:test/test.dart';

const _types = {
  'coins': FmvValueType.number,
  'lives-left': FmvValueType.number,
  'has_key': FmvValueType.boolean,
};

Object eval(String source, [Map<String, Object> values = const {}]) {
  final expression = FmvExpression.parse(source, _types);
  expect(expression.error, isNull, reason: source);
  return expression.evaluate({
    'coins': 10,
    'lives-left': 3,
    'has_key': true,
    ...values,
  });
}

FmvExpressionProblem? problem(String source) =>
    FmvExpression.parse(source, _types).error?.problem;

void main() {
  test('arithmetic follows the usual precedence', () {
    expect(eval('1 + 2 * 3'), 7);
    expect(eval('(1 + 2) * 3'), 9);
    expect(eval('2 ^ 3 ^ 2'), 512, reason: 'power is right-associative');
    expect(eval('-2 ^ 2'), -4);
    expect(eval('7 / 2'), 3.5);
    expect(eval('coins * 2 - lives-left'), 17);
    expect(eval('3 × 4 ÷ 2 − 1'), 5, reason: 'the display symbols work too');
  });

  test('names with a dash are read as names only when they exist', () {
    expect(eval('lives-left'), 3);
    expect(eval('coins-1'), 9, reason: 'no variable is called coins-1');
  });

  test('comparisons and boolean logic', () {
    expect(eval('coins > 5 and has_key'), true);
    expect(eval('coins >= 11 || !has_key'), false);
    expect(eval('coins = 10'), true, reason: '= compares');
    expect(eval('not (coins != 10) && true'), true);
    expect(eval('has_key == false'), false);
  });

  test('mistakes are found, with where they are', () {
    expect(problem(''), FmvExpressionProblem.empty);
    expect(problem('coins +'), FmvExpressionProblem.missingValue);
    expect(problem('(coins + 1'), FmvExpressionProblem.unclosedParen);
    expect(problem('gold + 1'), FmvExpressionProblem.unknownVariable);
    expect(problem('coins + has_key'), FmvExpressionProblem.wrongType);
    expect(problem('has_key and 3'), FmvExpressionProblem.wrongType);
    expect(problem('1 2'), FmvExpressionProblem.unexpected);
    final error = FmvExpression.parse('coins + gold', _types).error!;
    expect((error.start, error.end, error.detail), (8, 12, 'gold'));
  });

  test('types, used variables and possible fractions', () {
    final e = FmvExpression.parse('coins / 2 + lives-left', _types);
    expect(e.type, FmvValueType.number);
    expect(e.variables, ['coins', 'lives-left']);
    expect(e.mayBeFractional, isTrue);
    expect(FmvExpression.parse('coins + 1', _types).mayBeFractional, isFalse);
    expect(FmvExpression.parse('coins > 1', _types).type, FmvValueType.boolean);
  });

  test('division by zero is an evaluation error', () {
    final e = FmvExpression.parse('coins / (lives-left - 3)', _types);
    expect(
      () => e.evaluate({'coins': 1, 'lives-left': 3}),
      throwsA(isA<FmvEvaluationError>()),
    );
  });

  test('whole numbers round half away from zero', () {
    expect(fmvRound(2.5), 3);
    expect(fmvRound(-2.5), -3);
    expect(fmvRound(2.4), 2);
    expect(fmvRound(-0.4), 0);
  });
}
