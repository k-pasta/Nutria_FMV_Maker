import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/node_video_expansion.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_text.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../models/node_data/node_data.dart';
import '../models/node_data/simple_video_node_data.dart';
import '../providers/nodes_provider.dart';
import '../providers/theme_provider.dart';
import 'node_elements/node_video_filename_text.dart';
import 'node_elements/node_video_outputs_list.dart';
import 'node_elements/node_video_thumbnail.dart';
import 'base_node.dart';

class SimpleVideoNode extends StatelessWidget {
  final String nodeId;

  const SimpleVideoNode({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Selector<NodesProvider, NodeData>(
        selector: (context, provider) =>
            provider.getNodeById(nodeId), // Only listen to this node
        builder: (context, node, child) {
          
          final SimpleVideoNodeData nodeData =
              nodesProvider.getNodeById(nodeId);

          return BaseNode(
            baseNodeData: nodeData,
            nodeId: nodeId,
            body: [
              //thumbnail
              NodeVideoThumbnail(
                videoDataId: nodeData.videoDataId,
                videoNodeData: nodeData,
              ),
              //video file name
              NodeVideoFileNameText(videoNodeData: nodeData),
              //outputs and expand button
              Padding(
                padding: EdgeInsets.all(theme.dPanelPadding),
                child: Row(
                  children: [
                    Expanded(
                        child: NutriaButton(
                      onTap: () {
                        nodesProvider.convertNode(nodeData.id);
                      },
                      child: NutriaText(text: 'Convert to branching node'),
                    )),
                    SizedBox(
                      width: theme.dPanelPadding,
                    ),
                    NutriaButton.Icon(
                      icon: nodeData.isExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      onTap: () {
                        nodesProvider.expandToggle(nodeData.id);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          nodesProvider.rebuildNode(nodeData.id);
                        });
                        // ;
                      },
                    ),
                  ],
                ),
              ),
            ],
            expansion: Placeholder(),
          );
        });
  }
}
