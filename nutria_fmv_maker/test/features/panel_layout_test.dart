import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';

void main() {
  late ProviderContainer container;
  PanelLayoutNotifier panels() =>
      container.read(panelLayoutProvider.notifier);
  PanelLayout layout() => container.read(panelLayoutProvider);

  setUp(() => container = ProviderContainer.test());

  test('dragging a handle resizes within limits', () {
    panels().drag(PanelSide.left, 50, 1600);
    expect(layout().left, 350);
    panels().drag(PanelSide.left, 1000, 1600);
    expect(layout().left, 350, reason: 'past the maximum, the width holds');
  });

  test('dragging well below the minimum closes; dragging back reopens', () {
    panels().drag(PanelSide.left, -160, 1600); // intended 140 < 200 - 50
    expect(layout().leftClosed, isTrue);
    expect(layout().left, 0);
    panels().drag(PanelSide.left, 20, 1600); // intended 160 > 150
    expect(layout().leftClosed, isFalse);
    expect(layout().left, kMinLeftPanel);
  });

  test('toggle reopens at the remembered width', () {
    panels().drag(PanelSide.right, -100, 1600); // right panel grows to 400
    panels().toggle(PanelSide.right, 1600);
    expect(layout().rightClosed, isTrue);
    panels().toggle(PanelSide.right, 1600);
    expect(layout().right, 400);
  });

  test('a narrowing window shrinks both panels, then closes them', () {
    panels().windowResized(100, 500);
    expect(layout().left, 250);
    expect(layout().right, 250);
    panels().windowResized(200, 300);
    expect(layout().leftClosed && layout().rightClosed, isTrue);
  });
}
