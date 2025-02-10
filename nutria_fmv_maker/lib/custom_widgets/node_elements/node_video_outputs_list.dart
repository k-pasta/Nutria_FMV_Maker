

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_theme.dart';
import '../../models/node_data.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../nutria_button.dart';
import '../nutria_textfield.dart';

class NodeVideoOutputsList extends StatelessWidget {
  const NodeVideoOutputsList({
    super.key,
    required this.videoNodeData,
  });

  final VideoNodeData videoNodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return FocusScope(
      autofocus: false,
      onFocusChange: (gotFocus) {
        if (gotFocus) {
          print('node ${videoNodeData.id} got focus');
        } else {
          print('node ${videoNodeData.id} lost focus');
        }
      },
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        //this makes it so the tab key only cycles through the current node's inputs
        child: Container(
          padding: EdgeInsets.all(theme.dPanelPadding),
          child: Column(
            children: List.generate(videoNodeData.outputs.length, (index) {
              bool isLast = index == videoNodeData.outputs.length - 1;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: NutriaTextfield(
                          onChanged: (currentText) {
                            nodesProvider.setVideoNodeOutputText(
                                text: currentText,
                                id: videoNodeData.id,
                                outputIndex: index);
                            nodesProvider.rebuildNode(videoNodeData.id);
                          },
                          index: index + 1,
                          text: (videoNodeData.outputs[index].outputData ??
                                  '') //outputData is set as object, so it needs to be casted to string
                              .toString(),
                        ),
                      ),
                      if (isLast) ...[
                        SizedBox(
                          width: theme.dPanelPadding,
                        ),
                        NutriaButton.Icon(
                          icon: videoNodeData.isExpanded
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          onTap: () {
                            nodesProvider.expandToggle(videoNodeData.id);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              nodesProvider.rebuildNode(videoNodeData.id);
                            });
                            // ;
                          },
                        ),
                      ],
                    ],
                  ),
                  if (!isLast)  //distance between outputs
                    SizedBox(
                      height: theme.dPanelPadding,
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
