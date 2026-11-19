// The small expression language of logic nodes: numbers, true/false,
// variable names, arithmetic, comparisons and and/or/not. Both apps parse and
// evaluate it with this code, so the Maker's checks match what plays.
import 'dart:math' as math;

/// What kind of token a stretch of expression text is, for colouring.
enum FmvTokenKind { number, boolean, variable, operator, paren, unknown }

/// A token of an expression, from [start] to [end] in its text.
class FmvToken {
  const FmvToken(this.kind, this.start, this.end, this.text);

  final FmvTokenKind kind;
  final int start;
  final int end;
  final String text;

  @override
  String toString() => 'FmvToken($kind "$text")';
}

/// The type of a value: a number or true/false.
enum FmvValueType { number, boolean }

/// Why an expression can't be used, and where ([start] to [end]).
enum FmvExpressionProblem {
  empty,
  unknownVariable,
  unexpected,
  missingValue,
  unclosedParen,
  wrongType,
}

class FmvExpressionError {
  const FmvExpressionError(this.problem, this.start, this.end, [this.detail]);

  final FmvExpressionProblem problem;
  final int start;
  final int end;

  /// The variable name, for [FmvExpressionProblem.unknownVariable].
  final String? detail;

  @override
  String toString() => 'FmvExpressionError($problem $start-$end $detail)';
}

/// A parsed expression. [error] is set when it can't be evaluated; [tokens]
/// are always there, for colouring.
class FmvExpression {
  FmvExpression._(this.source, this.tokens, this._root, this.error);

  final String source;
  final List<FmvToken> tokens;
  final _Node? _root;
  final FmvExpressionError? error;

  bool get isValid => error == null;

  /// The type of the result, or `null` if invalid.
  FmvValueType? get type => _root?.type;

  /// The variable names used, in order of first use.
  List<String> get variables => [
        for (final t in tokens)
          if (t.kind == FmvTokenKind.variable) t.text,
      ].toSet().toList();

  /// Whether the result can have a fractional part even when every
  /// variable is a whole number (there is a division, a power or a decimal
  /// number): stored in a whole-number variable, it is rounded.
  bool get mayBeFractional => tokens.any((t) =>
      (t.kind == FmvTokenKind.operator && (t.text == '/' || t.text == '^')) ||
      (t.kind == FmvTokenKind.number && t.text.contains('.')));

  /// Reads [source]. [types] gives the type of every variable that exists,
  /// by name.
  static FmvExpression parse(String source, Map<String, FmvValueType> types) {
    final tokens = _tokenize(source, types.keys.toSet());
    final parser = _Parser(source, tokens, types);
    final root = parser.parse();
    return FmvExpression._(
        source, tokens, parser.error == null ? root : null, parser.error);
  }

  /// The value with [values] for the variables (num or bool, by name).
  /// Throws [FmvEvaluationError] on division by zero or a missing value.
  Object evaluate(Map<String, Object> values) {
    final root = _root;
    if (root == null) throw StateError('Invalid expression: $error');
    return root.evaluate(values);
  }
}

/// Evaluation failed: a division by zero, or a variable without a value.
class FmvEvaluationError implements Exception {
  const FmvEvaluationError(this.message);
  final String message;

  @override
  String toString() => 'FmvEvaluationError($message)';
}

/// Rounds [value] half away from zero, the rule for storing a result in a
/// whole-number variable.
int fmvRound(num value) =>
    value.isNegative ? -((-value) + 0.5).floor() : (value + 0.5).floor();

// ------------------------------------------------------------------ tokens

bool _isLetter(String c) => RegExp(r'\p{L}', unicode: true).hasMatch(c);
bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
bool _isNameChar(String c) => _isLetter(c) || _isDigit(c) || c == '_';

/// Two-character operators, then one-character ones. `×`, `÷` and `−` are
/// read as `*`, `/` and `-`; `=` as `==`.
const _operators2 = ['&&', '||', '<=', '>=', '==', '!='];
const _operators1 = [
  '+',
  '-',
  '*',
  '/',
  '^',
  '<',
  '>',
  '!',
  '=',
  '×',
  '÷',
  '−'
];
const _words = {'and': '&&', 'or': '||', 'not': '!'};

List<FmvToken> _tokenize(String s, Set<String> names) {
  final tokens = <FmvToken>[];
  var i = 0;
  while (i < s.length) {
    final c = s[i];
    if (c.trim().isEmpty) {
      i++;
      continue;
    }
    if (_isDigit(c) || (c == '.' && i + 1 < s.length && _isDigit(s[i + 1]))) {
      var end = i;
      var dot = false;
      while (end < s.length && (_isDigit(s[end]) || (s[end] == '.' && !dot))) {
        if (s[end] == '.') dot = true;
        end++;
      }
      tokens.add(FmvToken(FmvTokenKind.number, i, end, s.substring(i, end)));
      i = end;
      continue;
    }
    if (_isLetter(c)) {
      var end = i;
      while (end < s.length && _isNameChar(s[end])) {
        end++;
      }
      // Names may contain `-`: take it as part of the name only when that
      // makes (the start of) a known name, so `a-b` is a minus otherwise.
      while (end < s.length - 1 && s[end] == '-' && _isNameChar(s[end + 1])) {
        var next = end + 1;
        while (next < s.length && _isNameChar(s[next])) {
          next++;
        }
        final candidate = s.substring(i, next);
        if (!names.any((n) => n == candidate || n.startsWith('$candidate-'))) {
          break;
        }
        end = next;
      }
      final word = s.substring(i, end);
      final lower = word.toLowerCase();
      if (lower == 'true' || lower == 'false') {
        tokens.add(FmvToken(FmvTokenKind.boolean, i, end, lower));
      } else if (_words.containsKey(lower)) {
        tokens.add(FmvToken(FmvTokenKind.operator, i, end, _words[lower]!));
      } else {
        tokens.add(FmvToken(FmvTokenKind.variable, i, end, word));
      }
      i = end;
      continue;
    }
    if (c == '(' || c == ')') {
      tokens.add(FmvToken(FmvTokenKind.paren, i, i + 1, c));
      i++;
      continue;
    }
    final two = i + 1 < s.length ? s.substring(i, i + 2) : '';
    if (_operators2.contains(two)) {
      tokens.add(FmvToken(FmvTokenKind.operator, i, i + 2, two));
      i += 2;
      continue;
    }
    if (_operators1.contains(c)) {
      final normal = switch (c) {
        '×' => '*',
        '÷' => '/',
        '−' => '-',
        '=' => '==',
        _ => c,
      };
      tokens.add(FmvToken(FmvTokenKind.operator, i, i + 1, normal));
      i++;
      continue;
    }
    tokens.add(FmvToken(FmvTokenKind.unknown, i, i + 1, c));
    i++;
  }
  return tokens;
}

// ------------------------------------------------------------------ syntax

abstract class _Node {
  FmvValueType get type;
  Object evaluate(Map<String, Object> values);
}

class _Literal extends _Node {
  _Literal(this.value);
  final Object value;
  @override
  FmvValueType get type =>
      value is bool ? FmvValueType.boolean : FmvValueType.number;
  @override
  Object evaluate(Map<String, Object> values) => value;
}

class _Variable extends _Node {
  _Variable(this.name, this.type);
  final String name;
  @override
  final FmvValueType type;
  @override
  Object evaluate(Map<String, Object> values) =>
      values[name] ?? (throw FmvEvaluationError('No value for $name'));
}

class _Unary extends _Node {
  _Unary(this.op, this.operand);
  final String op;
  final _Node operand;
  @override
  FmvValueType get type =>
      op == '!' ? FmvValueType.boolean : FmvValueType.number;
  @override
  Object evaluate(Map<String, Object> values) {
    final v = operand.evaluate(values);
    return op == '!' ? !(v as bool) : -(v as num);
  }
}

class _Binary extends _Node {
  _Binary(this.op, this.left, this.right);
  final String op;
  final _Node left;
  final _Node right;

  @override
  FmvValueType get type => switch (op) {
        '+' || '-' || '*' || '/' || '^' => FmvValueType.number,
        _ => FmvValueType.boolean,
      };

  @override
  Object evaluate(Map<String, Object> values) {
    // and/or skip the right side when the left decides.
    if (op == '&&') {
      return (left.evaluate(values) as bool) &&
          (right.evaluate(values) as bool);
    }
    if (op == '||') {
      return (left.evaluate(values) as bool) ||
          (right.evaluate(values) as bool);
    }
    final a = left.evaluate(values);
    final b = right.evaluate(values);
    if (op == '==') return a == b || (a is num && b is num && a == b);
    if (op == '!=') return !(a == b || (a is num && b is num && a == b));
    final x = a as num;
    final y = b as num;
    switch (op) {
      case '+':
        return x + y;
      case '-':
        return x - y;
      case '*':
        return x * y;
      case '/':
        if (y == 0) throw const FmvEvaluationError('Division by zero');
        return x / y;
      case '^':
        return _power(x, y);
      case '<':
        return x < y;
      case '<=':
        return x <= y;
      case '>':
        return x > y;
      case '>=':
        return x >= y;
    }
    throw StateError('Unknown operator $op');
  }
}

num _power(num x, num y) {
  if (x == 0 && y < 0) throw const FmvEvaluationError('Division by zero');
  return math.pow(x, y);
}

/// Precedence climbing over the tokens.
class _Parser {
  _Parser(this.source, this.tokens, this.types);

  final String source;
  final List<FmvToken> tokens;
  final Map<String, FmvValueType> types;
  var _i = 0;
  FmvExpressionError? error;

  FmvToken? get _peek => _i < tokens.length ? tokens[_i] : null;

  void _fail(FmvExpressionProblem problem, int start, int end,
      [String? detail]) {
    error ??= FmvExpressionError(problem, start, end, detail);
  }

  _Node? parse() {
    if (tokens.isEmpty) {
      _fail(FmvExpressionProblem.empty, 0, source.length);
      return null;
    }
    final node = _or();
    final extra = _peek;
    if (extra != null)
      _fail(FmvExpressionProblem.unexpected, extra.start, extra.end);
    return node;
  }

  bool _isOp(String op) {
    final t = _peek;
    return t != null && t.kind == FmvTokenKind.operator && t.text == op;
  }

  _Node? _binary(_Node? Function() next, List<String> ops) {
    var left = next();
    while (left != null && ops.any(_isOp)) {
      final opToken = tokens[_i++];
      final right = next();
      if (right == null) return null;
      left = _check(_Binary(opToken.text, left, right), opToken);
    }
    return left;
  }

  _Node? _or() => _binary(_and, ['||']);
  _Node? _and() => _binary(_not, ['&&']);

  _Node? _not() {
    if (_isOp('!')) {
      final op = tokens[_i++];
      final operand = _not();
      if (operand == null) return null;
      return _check(_Unary('!', operand), op);
    }
    return _comparison();
  }

  _Node? _comparison() =>
      _binary(_additive, ['<', '<=', '>', '>=', '==', '!=']);
  _Node? _additive() => _binary(_multiplicative, ['+', '-']);
  _Node? _multiplicative() => _binary(_unary, ['*', '/']);

  _Node? _unary() {
    if (_isOp('-')) {
      final op = tokens[_i++];
      final operand = _unary();
      if (operand == null) return null;
      return _check(_Unary('-', operand), op);
    }
    return _power();
  }

  _Node? _power() {
    final base = _atom();
    if (base == null || !_isOp('^')) return base;
    final op = tokens[_i++];
    // Right-associative: 2^3^2 is 2^(3^2).
    final exponent = _unary();
    if (exponent == null) return null;
    return _check(_Binary('^', base, exponent), op);
  }

  _Node? _atom() {
    final t = _peek;
    if (t == null) {
      _fail(FmvExpressionProblem.missingValue, source.length, source.length);
      return null;
    }
    _i++;
    switch (t.kind) {
      case FmvTokenKind.number:
        final value =
            t.text.contains('.') ? double.parse(t.text) : int.parse(t.text);
        return _Literal(value);
      case FmvTokenKind.boolean:
        return _Literal(t.text == 'true');
      case FmvTokenKind.variable:
        final type = types[t.text];
        if (type == null) {
          _fail(FmvExpressionProblem.unknownVariable, t.start, t.end, t.text);
          return null;
        }
        return _Variable(t.text, type);
      case FmvTokenKind.paren when t.text == '(':
        final inner = _or();
        if (inner == null) return null;
        final close = _peek;
        if (close == null || close.text != ')') {
          _fail(FmvExpressionProblem.unclosedParen, t.start, t.end);
          return null;
        }
        _i++;
        return inner;
      case FmvTokenKind.operator || FmvTokenKind.paren || FmvTokenKind.unknown:
        _fail(FmvExpressionProblem.missingValue, t.start, t.end);
        return null;
    }
  }

  /// Fails with [FmvExpressionProblem.wrongType] at [op] if the operands
  /// don't fit the operator.
  _Node? _check(_Node node, FmvToken op) {
    bool ok;
    if (node is _Unary) {
      ok = node.op == '!'
          ? node.operand.type == FmvValueType.boolean
          : node.operand.type == FmvValueType.number;
    } else {
      final b = node as _Binary;
      ok = switch (b.op) {
        '&&' || '||' => b.left.type == FmvValueType.boolean &&
            b.right.type == FmvValueType.boolean,
        '==' || '!=' => b.left.type == b.right.type,
        _ => b.left.type == FmvValueType.number &&
            b.right.type == FmvValueType.number,
      };
    }
    if (!ok) {
      _fail(FmvExpressionProblem.wrongType, op.start, op.end);
      return null;
    }
    return node;
  }
}
