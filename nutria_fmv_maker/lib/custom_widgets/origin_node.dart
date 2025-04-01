import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/node_video_expansion.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_textfield.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/providers/theme_provider.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import '../models/node_data/node_data.dart';
import '../models/node_data/origin_node_data.dart';
import '../providers/nodes_provider.dart';
import 'node_elements/node_video_filename_text.dart';
import 'node_elements/node_video_outputs_list.dart';
import 'node_elements/node_video_thumbnail.dart';
import 'base_node.dart';

class OriginNode extends StatelessWidget {
  final String nodeId;

  const OriginNode({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Selector<NodesProvider, NodeData>(
        selector: (context, provider) =>
            provider.getNodeById(nodeId), // Only listen to this node
        builder: (context, node, child) {
          final OriginNodeData nodeData = nodesProvider.getNodeById(nodeId);

          return BaseNode(
            baseNodeData: nodeData,
            nodeId: nodeId,
            body: [
              SizedBox(
                width: double.infinity,
                height: UiStaticProperties.nodeDefaultWidth * 9 / 16,
                child: Container(
                  color: Colors.black, //TODO de-hardcode
                  child: Center(
                    child: NutriaText(text: 'Main Menu Placeholder'),
                  ), //TODO create render
                ),
              ),
              Padding(
                padding: EdgeInsets.all(theme.dPanelPadding),
                child: NutriaTextfield(
                  placeholderText: 'Project Title ...',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: theme.dPanelPadding,
                  right: theme.dPanelPadding,
                  bottom: theme.dPanelPadding,
                ),
                child: NutriaTextfield(
                  placeholderText: 'Project Description ...',
                  maxlines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
            expansion: Placeholder(),
          );
        });
  }
}
