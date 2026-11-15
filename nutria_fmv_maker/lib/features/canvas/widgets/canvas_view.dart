// The node canvas.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// Placeholder until the canvas is ported: just the background.
// TODO(#refactor-step-6): grid, pan/zoom, nodes, noodles, drop targets.
class CanvasView extends StatelessWidget {
  const CanvasView({super.key});

  @override
  Widget build(BuildContext context) =>
      SizedBox.expand(child: ColoredBox(color: context.appTheme.cBackground));
}
