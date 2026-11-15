// A 2D point in canvas space. Pure Dart so `core/` doesn't depend on dart:ui.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

/// A point on the infinite canvas, in logical canvas units.
///
/// Mirrors the parts of `Offset` that the document needs, so the document
/// model stays independent of Flutter.
@freezed
abstract class Position with _$Position {
  const Position._();

  const factory Position(double x, double y) = _Position;

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  /// The canvas origin.
  static const Position zero = Position(0, 0);

  Position operator +(Position other) => Position(x + other.x, y + other.y);

  Position operator -(Position other) => Position(x - other.x, y - other.y);
}
