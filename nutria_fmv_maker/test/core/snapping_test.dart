import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/snapping.dart';

void main() {
  test('snapToGrid rounds to the nearest grid point, honoring the offset', () {
    expect(snapToGrid(const Position(74, 26)), const Position(50, 50));
    expect(
      snapToGrid(const Position(74, 26), gridOffset: -30),
      const Position(70, 20),
    );
  });

  test('snapNodeWidth clamps and pulls to the default width', () {
    expect(snapNodeWidth(10), kMinNodeWidth);
    expect(snapNodeWidth(5000), kMaxNodeWidth);
    expect(snapNodeWidth(kDefaultNodeWidth + 15), kDefaultNodeWidth);
    expect(snapNodeWidth(300), 300);
  });
}
