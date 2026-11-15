// The left (library/settings) and right (video preview) panels around the canvas.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/left_panel.dart';
import 'package:nutria_fmv_maker/features/video_preview/widgets/video_preview_panel.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_split_view.dart';

PanelSide _side(SplitSide side) =>
    side == SplitSide.left ? PanelSide.left : PanelSide.right;

class SidePanels extends ConsumerWidget {
  const SidePanels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(panelLayoutProvider);
    final panels = ref.read(panelLayoutProvider.notifier);
    return NutriaSplitView(
      leftWidth: layout.left,
      rightWidth: layout.right,
      leftOpen: !layout.leftClosed,
      rightOpen: !layout.rightClosed,
      handleWidth: kPanelHandleWidth,
      onDividerDrag: (side, dx, total) => panels.drag(_side(side), dx, total),
      onDividerDragEnd: (side) => panels.dragEnd(_side(side)),
      onOpenRequested: (side, total) => panels.toggle(_side(side), total),
      onWindowResized: panels.windowResized,
      left: const LeftPanel(),
      right: const VideoPreviewPanel(),
    );
  }
}
