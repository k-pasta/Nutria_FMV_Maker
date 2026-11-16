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
  }) = IntVariable;

  @FreezedUnionValue('decimal')
  const factory Variable.decimal({
    required String id,
    required String name,
    @Default(0.0) double initial,
  }) = DecimalVariable;

  factory Variable.fromJson(Map<String, dynamic> json) =>
      _$VariableFromJson(json);

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
  /// become true unless 0, true becomes 1, decimals round to integers.
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

  /// The starting value as typed in a field.
  String get initialText => switch (this) {
    BoolVariable(:final initial) => '$initial',
    IntVariable(:final initial) => '$initial',
    DecimalVariable(:final initial) => _formatDecimal(initial),
  };

  /// This variable with the starting value read from [text], or `null` if
  /// [text] isn't a value of its type.
  Variable? withInitialText(String text) {
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
