import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_data.dart';

import 'package:provider/provider.dart';

import '../../models/node_data/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/grid_canvas_provider.dart';
import '../../providers/theme_provider.dart';

class NodeMainContainer extends StatelessWidget {
  const NodeMainContainer({
    super.key,
    required this.nodeData,
    required this.children,
  });

  final NodeData nodeData; //unnecessary?
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final GridCanvasProvider canvasProvider =
        context.read<GridCanvasProvider>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(theme.dPanelBorderRadius),
          bottomRight: Radius.circular(theme.dPanelBorderRadius),
        ),
        boxShadow: nodeData.isSelected
            ? [
                BoxShadow(
                  // color: Color.fromARGB(174, 0, 0, 0),
                  color: theme.cAccentButton,
                  blurRadius: 0 / canvasProvider.currentScale,
                  spreadRadius: 3,
                  offset: Offset(0, 0 / canvasProvider.currentScale),
                ),
              ]
            : [],
        border: Border(
          left: BorderSide(color: theme.cOutlines, width: theme.dOutlinesWidth),
          right:
              BorderSide(color: theme.cOutlines, width: theme.dOutlinesWidth),
          bottom:
              BorderSide(color: theme.cOutlines, width: theme.dOutlinesWidth),
        ),
        color: nodeData.isBeingHovered || nodeData.isSelected
            ? theme.cButton
            : theme.cPanelTransparent,
      ),
      child: Column(children: children),
    );
  }
}
