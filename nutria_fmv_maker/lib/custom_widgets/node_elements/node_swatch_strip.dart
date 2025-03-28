import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_theme.dart';
import '../../models/node_data/node_data.dart';
import '../../providers/theme_provider.dart';

class NodeSwatchStrip extends StatelessWidget {
  const NodeSwatchStrip({
    super.key,
    required this.nodeData,
  });

  final BaseNodeData nodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: theme.dSwatchHeight / 2,
          // vertical: 0,
          horizontal: theme.dPanelPadding * 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(theme.dPanelBorderRadius),
            topRight: Radius.circular(theme.dPanelBorderRadius)),
        color: theme.cSwatches[nodeData.swatch],
      ),
      child: IgnorePointer(
        child: Container(
          alignment: Alignment.centerLeft,
          child: nodeData.nodeName != null
              ? SwatchStripText(
                  nodeData: nodeData,
                )
              : Container(),
        ),
      ),
    );
  }
}

class SwatchStripTextField extends StatelessWidget {
  const SwatchStripTextField({
    super.key,
    required this.nodeData,
  });

  final BaseNodeData nodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final TextEditingController nameTextEditingController =
        TextEditingController();
    final FocusNode focusNode = FocusNode(); //todo use for f2

    return SizedBox(
      height: theme.dTextHeight,
      child: TextField(
        focusNode: focusNode,
        controller: nameTextEditingController..text = nodeData.nodeName!,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: theme.cTextActive,
          fontVariations: const [FontVariation('wght', 500)],
          fontSize: theme.dTextHeight,
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          isDense: true,
          border: InputBorder.none,
        ),
        onSubmitted: (newValue) {
          // nodesProvider.updateNodeName(videoNodeData.id, newValue);
        },
      ),
    );
  }
}
class SwatchStripText extends StatelessWidget {
  const SwatchStripText({
    super.key,
    required this.nodeData,
  });

  final BaseNodeData nodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Text(
      textAlign: TextAlign.left,
      nodeData.nodeName!,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: theme.cTextActive,
        fontVariations: const [FontVariation('wght', 500)],
        fontSize: theme.dTextHeight,        
        height: 1.0
      ),
    );
  }
}


