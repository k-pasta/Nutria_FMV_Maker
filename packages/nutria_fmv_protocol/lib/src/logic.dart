// Variables and the logic nodes that change and compare them, and how
// playback applies them.
import 'dart:math' as math;

import 'package:nutria_fmv_protocol/src/enums.dart';
import 'package:nutria_fmv_protocol/src/expression.dart';

/// The kind of a story variable.
enum FmvVariableType {
  boolean,
  integer,
  decimal;

  static FmvVariableType? parse(Object? value) =>
      value is String ? fmvParseEnum(values, value) : null;

  FmvValueType get valueType =>
      this == boolean ? FmvValueType.boolean : FmvValueType.number;
}

/// A named value of the story, with its value at the start and, for
/// numbers, optional limits.
class FmvVariable {
  const FmvVariable({
    required this.type,
    required this.initial,
    this.min,
    this.max,
  });

  final FmvVariableType type;

  /// A bool, int or double, by [type].
  final Object initial;
  final num? min;
  final num? max;

  /// [value] as this variable stores it: rounded (half away from zero) for
  /// whole numbers, and kept between [min] and [max].
  Object store(Object value) {
    if (type == FmvVariableType.boolean) return value as bool;
    var number = value as num;
    if (type == FmvVariableType.integer) number = fmvRound(number);
    if (min != null && number < min!) number = min!;
    if (max != null && number > max!) number = max!;
    return type == FmvVariableType.integer ? number.toInt() : number.toDouble();
  }

  Map<String, Object?> toJson() => {
        'type': type.name,
        'initial': initial,
        if (min != null) 'min': min,
        if (max != null) 'max': max,
      };

  /// Reads a variable; `null` if its type is unknown.
  static FmvVariable? fromJson(Map<String, Object?> json) {
    final type = FmvVariableType.parse(json['type']);
    if (type == null) return null;
    final initial = json['initial'];
    num? number(Object? v) => v is num ? v : null;
    return FmvVariable(
      type: type,
      initial: switch (type) {
        FmvVariableType.boolean => initial is bool ? initial : false,
        FmvVariableType.integer => initial is num ? fmvRound(initial) : 0,
        FmvVariableType.decimal => initial is num ? initial.toDouble() : 0.0,
      },
      min: number(json['min']),
      max: number(json['max']),
    );
  }
}

/// What a change node does to its variable.
enum FmvChangeOperation {
  /// Variable = value (numbers and true/false).
  set,
  add,
  subtract,
  multiply,
  divide,
  power,

  /// Variable = |variable| (no value).
  absolute,

  /// Variable = not variable (no value).
  toggle,
  and,
  or,
  xor;

  static FmvChangeOperation? parse(Object? value) =>
      value is String ? fmvParseEnum(values, value) : null;

  /// Whether it needs a value (all but [absolute] and [toggle]).
  bool get takesValue => this != absolute && this != toggle;

  /// Whether it works on true/false variables (otherwise on numbers).
  bool get isForBooleans =>
      this == set || this == toggle || this == and || this == or || this == xor;

  /// Whether it works on number variables.
  bool get isForNumbers =>
      this != toggle && this != and && this != or && this != xor;
}

/// How a condition compares its variable with its value.
enum FmvComparison {
  less('<'),
  lessOrEqual('<='),
  greater('>'),
  greaterOrEqual('>='),
  equal('=='),
  notEqual('!=');

  const FmvComparison(this.symbol);

  /// How it's written in an expression.
  final String symbol;

  static FmvComparison? parse(Object? value) =>
      value is String ? fmvParseEnum(values, value) : null;

  /// Whether it can compare true/false values (only equal and not equal).
  bool get isForBooleans => this == equal || this == notEqual;
}

/// One condition of a compare node: [variable] [comparison] [value].
class FmvCondition {
  const FmvCondition({
    required this.variable,
    required this.comparison,
    required this.value,
  });

  final String variable;
  final FmvComparison comparison;

  /// An expression.
  final String value;

  /// The condition as one expression.
  String get asExpression => '($variable) ${comparison.symbol} ($value)';

  Map<String, Object?> toJson() => {
        'variable': variable,
        'comparison': comparison.name,
        'value': value,
      };

  static FmvCondition? fromJson(Map<String, Object?> json) {
    final variable = json['variable'];
    final comparison = FmvComparison.parse(json['comparison']);
    if (variable is! String || comparison == null) return null;
    final value = json['value'];
    return FmvCondition(
      variable: variable,
      comparison: comparison,
      value: value is String ? value : '$value',
    );
  }
}

/// The values of the story's variables during playback, and what logic
/// nodes do to them.
class FmvVariableState {
  /// Starts every variable of [definitions] at its initial value.
  FmvVariableState(this.definitions)
      : values = {
          for (final MapEntry(:key, :value) in definitions.entries)
            key: value.initial,
        };

  final Map<String, FmvVariable> definitions;

  /// Current values by name.
  final Map<String, Object> values;

  /// A separate state with the same values (to try what logic nodes would
  /// do without changing this one).
  FmvVariableState copy() =>
      FmvVariableState(definitions)..values.addAll(values);

  /// Sets the values saved earlier ([values] of another state), keeping
  /// only variables that still exist with a value of the right type.
  void restore(Map<String, Object?> saved) {
    for (final MapEntry(:key, :value) in saved.entries) {
      final definition = definitions[key];
      if (definition == null || value == null) continue;
      final fits = definition.type == FmvVariableType.boolean
          ? value is bool
          : value is num;
      if (fits) values[key] = definition.store(value);
    }
  }

  Map<String, FmvValueType> get _types => {
        for (final MapEntry(:key, :value) in definitions.entries)
          key: value.type.valueType,
      };

  Object _evaluate(String source) {
    final expression = FmvExpression.parse(source, _types);
    final error = expression.error;
    if (error != null) {
      throw FmvEvaluationError('Invalid expression "$source": $error');
    }
    return expression.evaluate(values);
  }

  /// Applies [operation] with [value] (an expression) to [variable].
  ///
  /// A division by zero, an invalid expression or an unknown variable leave
  /// the variable unchanged; the error is returned (`null` if it worked).
  FmvEvaluationError? change(
    String variable,
    FmvChangeOperation operation,
    String? value,
  ) {
    final definition = definitions[variable];
    if (definition == null) {
      return FmvEvaluationError('Unknown variable $variable');
    }
    try {
      final current = values[variable]!;
      final operand = operation.takesValue ? _evaluate(value ?? '') : current;
      Object next;
      if (definition.type == FmvVariableType.boolean) {
        final a = current as bool;
        final b = operand as bool;
        next = switch (operation) {
          FmvChangeOperation.toggle => !a,
          FmvChangeOperation.and => a && b,
          FmvChangeOperation.or => a || b,
          FmvChangeOperation.xor => a != b,
          _ => b,
        };
      } else {
        final a = current as num;
        final b = operand as num;
        next = switch (operation) {
          FmvChangeOperation.add => a + b,
          FmvChangeOperation.subtract => a - b,
          FmvChangeOperation.multiply => a * b,
          FmvChangeOperation.divide =>
            b == 0 ? throw const FmvEvaluationError('Division by zero') : a / b,
          FmvChangeOperation.power => a == 0 && b < 0
              ? throw const FmvEvaluationError('Division by zero')
              : math.pow(a, b),
          FmvChangeOperation.absolute => a.abs(),
          _ => b,
        };
      }
      values[variable] = definition.store(next);
      return null;
    } on FmvEvaluationError catch (e) {
      return e;
    } on TypeError {
      return FmvEvaluationError('Wrong type for $variable');
    }
  }

  /// Whether [conditions] hold (all of them, or any with [matchAny]); an
  /// [expression], if given, is used instead. Anything that can't be
  /// evaluated counts as false.
  bool test({
    List<FmvCondition> conditions = const [],
    bool matchAny = false,
    String? expression,
  }) {
    bool holds(String source) {
      try {
        return _evaluate(source) == true;
      } on FmvEvaluationError {
        return false;
      }
    }

    if (expression != null && expression.trim().isNotEmpty) {
      return holds(expression);
    }
    if (conditions.isEmpty) return false;
    return matchAny
        ? conditions.any((c) => holds(c.asExpression))
        : conditions.every((c) => holds(c.asExpression));
  }
}
