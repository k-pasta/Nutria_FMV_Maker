// Project variables: named values the story will read and change.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'variable.freezed.dart';
part 'variable.g.dart';

/// The kinds of value a variable holds.
enum VariableType { boolean, integer, decimal }

/// A named value with its starting value. Saved in the project; not yet
/// exported to the Player.
@Freezed(unionKey: 'type')
sealed class Variable with _$Variable {
  const Variable._();

  @FreezedUnionValue('boolean')
  const factory Variable.boolean({
    required String id,
    required String name,
    @Default(false) bool initial,
  }) = BoolVariable;

  @FreezedUnionValue('integer')
  const factory Variable.integer({
    required String id,
    required String name,
    @Default(0) int initial,

    /// Lowest and highest allowed value; `null` means no limit.
    int? min,
    int? max,
  }) = IntVariable;

  @FreezedUnionValue('decimal')
  const factory Variable.decimal({
    required String id,
    required String name,
    @Default(0.0) double initial,

    /// Lowest and highest allowed value; `null` means no limit.
    double? min,
    double? max,
  }) = DecimalVariable;

  factory Variable.fromJson(Map<String, dynamic> json) =>
      _$VariableFromJson(json);

  /// A complete name: a letter first, then letters, digits, `-` or `_`.
  /// Letters of any script count, so names can be in the author's language.
  static final namePattern = RegExp(r'^\p{L}[\p{L}\p{N}_-]*$', unicode: true);

  /// What a name may look like while it's being typed (it may be empty).
  static final typingPattern = RegExp(
    r'^(\p{L}[\p{L}\p{N}_-]*)?$',
    unicode: true,
  );

  static bool isValidName(String name) => namePattern.hasMatch(name);

  /// The limits of a number variable, `(null, null)` for true/false ones.
  (num?, num?) get limits => switch (this) {
    BoolVariable() => (null, null),
    IntVariable(:final min, :final max) => (min, max),
    DecimalVariable(:final min, :final max) => (min, max),
  };

  /// Whether the limits are usable: not a minimum above the maximum.
  bool get hasValidRange {
    final (min, max) = limits;
    return min == null || max == null || min <= max;
  }

  /// This variable with its starting value moved inside its limits (unless
  /// they are contradictory, which the editor shows as an error instead).
  Variable clamped() {
    if (!hasValidRange) return this;
    return switch (this) {
      final BoolVariable v => v,
      final IntVariable v => v.copyWith(
        initial: _clamp(v.initial, v.min, v.max),
      ),
      final DecimalVariable v => v.copyWith(
        initial: _clamp(v.initial, v.min, v.max),
      ),
    };
  }

  static T _clamp<T extends num>(T value, T? min, T? max) {
    if (min != null && value < min) return min;
    if (max != null && value > max) return max;
    return value;
  }

  /// The minimum ([isMin]) or maximum as typed in its field; empty if none.
  String limitText({required bool isMin}) {
    final (min, max) = limits;
    final limit = isMin ? min : max;
    return switch (limit) {
      null => '',
      final double d => _formatDecimal(d),
      final value => '$value',
    };
  }

  /// This variable with the minimum ([isMin]) or maximum read from [text]
  /// (empty removes it), and its starting value clamped; `null` if [text]
  /// isn't a number of its type.
  Variable? withLimitText({required bool isMin, required String text}) {
    final trimmed = text.trim();
    switch (this) {
      case BoolVariable():
        return null;
      case final IntVariable v:
        final value = trimmed.isEmpty ? null : int.tryParse(trimmed);
        if (trimmed.isNotEmpty && value == null) return null;
        return (isMin ? v.copyWith(min: value) : v.copyWith(max: value))
            .clamped();
      case final DecimalVariable v:
        final value = trimmed.isEmpty
            ? null
            : double.tryParse(trimmed.replaceAll(',', '.'));
        if (trimmed.isNotEmpty && (value == null || !value.isFinite)) {
          return null;
        }
        return (isMin ? v.copyWith(min: value) : v.copyWith(max: value))
            .clamped();
    }
  }

  VariableType get type => switch (this) {
    BoolVariable() => VariableType.boolean,
    IntVariable() => VariableType.integer,
    DecimalVariable() => VariableType.decimal,
  };

  /// The starting value as a number (true is 1).
  double get _number => switch (this) {
    BoolVariable(:final initial) => initial ? 1 : 0,
    IntVariable(:final initial) => initial.toDouble(),
    DecimalVariable(:final initial) => initial,
  };

  /// This variable as [type], keeping the value as well as it can: numbers
  /// become true unless 0, true becomes 1, decimals round to integers. The
  /// limits are dropped.
  Variable withType(VariableType type) {
    if (type == this.type) return this;
    return switch (type) {
      VariableType.boolean => Variable.boolean(
        id: id,
        name: name,
        initial: _number != 0,
      ),
      VariableType.integer => Variable.integer(
        id: id,
        name: name,
        initial: _number.round(),
      ),
      VariableType.decimal => Variable.decimal(
        id: id,
        name: name,
        initial: _number,
      ),
    };
  }

  /// This variable with the starting value one step up ([direction] 1) or
  /// down (-1), within its limits: whole numbers by 1, decimals by 0.1,
  /// true/false flips.
  Variable stepped(int direction) => _stepped(direction).clamped();

  Variable _stepped(int direction) => switch (this) {
    final BoolVariable v => v.copyWith(initial: !v.initial),
    final IntVariable v => v.copyWith(initial: v.initial + direction),
    // Rounded, so repeated steps don't drift (0.30000000000000004).
    final DecimalVariable v => v.copyWith(
      initial: ((v.initial + direction / 10) * 1e6).roundToDouble() / 1e6,
    ),
  };

  /// The starting value as typed in a field.
  String get initialText => switch (this) {
    BoolVariable(:final initial) => '$initial',
    IntVariable(:final initial) => '$initial',
    DecimalVariable(:final initial) => _formatDecimal(initial),
  };

  /// This variable with the starting value read from [text] (and kept
  /// within its limits), or `null` if [text] isn't a value of its type.
  Variable? withInitialText(String text) => _withInitialText(text)?.clamped();

  Variable? _withInitialText(String text) {
    final trimmed = text.trim();
    return switch (this) {
      final BoolVariable v => switch (trimmed.toLowerCase()) {
        'true' => v.copyWith(initial: true),
        'false' => v.copyWith(initial: false),
        _ => null,
      },
      final IntVariable v => switch (int.tryParse(trimmed)) {
        final value? => v.copyWith(initial: value),
        null => null,
      },
      // A comma works as the decimal point too ("2,5").
      final DecimalVariable v => switch (double.tryParse(
        trimmed.replaceAll(',', '.'),
      )) {
        final value? when value.isFinite => v.copyWith(initial: value),
        _ => null,
      },
    };
  }

  static String _formatDecimal(double value) =>
      value == value.roundToDouble() ? value.toStringAsFixed(1) : '$value';
}
