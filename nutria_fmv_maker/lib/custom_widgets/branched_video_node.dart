import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/node_video_expansion.dart';
import 'package:provider/provider.dart';

import '../models/node_data/branched_video_node_data.dart';
import '../models/node_data/node_data.dart';
import '../providers/nodes_provider.dart';
import 'node_elements/node_video_filename_text.dart';
import 'node_elements/node_video_outputs_list.dart';
import 'node_elements/node_video_thumbnail.dart';
import 'base_node.dart';

class BranchedVideoNode extends StatelessWidget {
  final String nodeId;

  const BranchedVideoNode({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return Selector<NodesProvider, NodeData>(
        selector: (context, provider) =>
            provider.getNodeById(nodeId), // Only listen to this node
        builder: (context, node, child) {
          nodesProvider.initializeOutputs(nodeId);
          
          final BranchedVideoNodeData nodeData = nodesProvider.getNodeById(nodeId);

          return BaseNode(
            baseNodeData: nodeData,
            nodeId: nodeId,
            body: [
              //thumbnail
              NodeVideoThumbnail(
                videoNodeData: nodeData,
              ),
              //video file name
              NodeVideoFileNameText(videoNodeData: nodeData),
              //outputs and expand button
              NodeVideoOutputsList(
                videoNodeData: nodeData,
              ),
            ],
            expansion: NodeVideoExpansion(videoNodeData: nodeData),
          );
        });
  }
}
