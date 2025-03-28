import 'package:nutria_fmv_maker/custom_widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/custom_widgets/origin_node.dart';
import 'package:nutria_fmv_maker/custom_widgets/simple_video_node.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/models/node_data/branched_video_node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/origin_node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/simple_video_node_data.dart';
import 'package:nutria_fmv_maker/painters/noodle_painter.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'custom_widgets/branched_video_node.dart';
import './providers/grid_canvas_provider.dart';
import './providers/nodes_provider.dart';
import 'painters/grid_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_settings_provider.dart';
import 'providers/theme_provider.dart';
import 'static_data/ui_static_properties.dart';

class GridCanvas extends StatefulWidget {
  const GridCanvas({super.key});

  @override
  State<GridCanvas> createState() => _GridCanvasState();
}

class _GridCanvasState extends State<GridCanvas> {
  Uuid uuid = Uuid();
  final double keyboardMoveSensitivity =
      UiStaticProperties.gridCanvasArrowMoveSensitivity;
  GlobalKey gridCanvasKey = GlobalKey();

  late List<Widget> nodes;

  // @override
  // void initState() {
  //   nodes = context.read<NodesProvider>().iDs.map((id) {
  //     return BranchedVideoNode(
  //       nodeId: id,
  //       key: ValueKey(id),
  //     );
  //   }).toList();
  //   super.initState();
  // }
  @override
  void initState() {
    var iDs = context.read<NodesProvider>().iDs;
    var types = context.read<NodesProvider>().types;

// void initState() {
    nodes = List.generate(iDs.length, (index) {
      return _addNodeById(iDs[index], types[index]);
    });

    super.initState();
// }

    // nodes = context.read<NodesProvider>().iDsandTypes.entries.map((entry) {
    //   return _addNodeById(entry.key, entry.value);
    // }).toList();
    // super.initState();
  }

  Widget _addNodeById(String id, Type type) {
    if (type == SimpleVideoNodeData) {
      return SimpleVideoNode(
        nodeId: id,
        key: ValueKey(id),
      );
    } else if (type == BranchedVideoNodeData) {
      return BranchedVideoNode(
        nodeId: id,
        key: ValueKey(id),
      );
    } else if (type == OriginNodeData) {
      return OriginNode(
        nodeId: id,
        key: ValueKey(id),
      );
    } else {
      throw Exception('Unsupported node type: $type');
    }
  }

  void _updateNodes(List<String> iDs, List<Type> types) {
    // Extract the list of IDs from the map

    // If there are more IDs in the list than nodes in the list, add the missing nodes
    if (iDs.length > nodes.length) {
      iDs.skip(nodes.length).forEach((nodeId) {
        // Find the corresponding type for this ID
        int index = iDs.indexOf(nodeId);
        Type nodeType = types[index];

        // Add a new node for each missing ID
        nodes.add(_addNodeById(nodeId, nodeType));
      });
    }
    // If there are fewer IDs in the map than nodes in the list, remove the extra nodes
    else if (iDs.length < nodes.length) {
      // Remove nodes that are no longer in the map
      nodes.removeRange(iDs.length, nodes.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final GridCanvasProvider gridCanvasProvider =
        context.read<GridCanvasProvider>();
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final AppSettingsProvider appSettingsProvider =
        context.read<AppSettingsProvider>();

    void addNodeFromDrag(String videoId, Offset widgetLocalOffset) {
      switch (appSettingsProvider.defaultNodeType) {
        case NodeDataType.simpleVideo:
          nodesProvider.addNode(SimpleVideoNodeData(
              position: widgetLocalOffset -
                  UiStaticProperties.topLeftToMiddle -
                  Offset(UiStaticProperties.nodePadding,
                      UiStaticProperties.nodePadding),
              id: uuid.v1(),
              videoDataId: videoId));
          break;
        case NodeDataType.branchedVideo:
          nodesProvider.addNode(BranchedVideoNodeData(
              position: widgetLocalOffset -
                  UiStaticProperties.topLeftToMiddle -
                  Offset(UiStaticProperties.nodePadding,
                      UiStaticProperties.nodePadding),
              id: uuid.v1(),
              videoDataId: videoId));
          break;
        default:
          throw Exception(
              'Invalid default node type: ${appSettingsProvider.defaultNodeType}');
      }
    }

    return

        // Selector<NodesProvider, Map<String, Type>>(
        //     selector: (_, nodesProvider) => nodesProvider.iDsandTypes,
        //     builder: (context, iDsandTypes, child) {
        Selector(
            selector: (_, NodesProvider provider) => provider.iDsandTypes,
            builder: (context, iDsandTypes, child) {
              print('full rebuild');
              final List<String> iDs = iDsandTypes.item1;
              final List<Type> types = iDsandTypes.item2;

              _updateNodes(iDs, types);

              nodes.sort((a, b) {
                print(iDs.last);
                print((nodes.first.key as ValueKey).value);

                final aId = (a.key as ValueKey).value as String;
                final bId = (b.key as ValueKey).value as String;
                return iDs.indexOf(aId).compareTo(iDs.indexOf(bId));
              });

              return Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    gridCanvasProvider.updateScaleAndMatrix(event, context);
                  }
                },
                child: Center(
                  child: InteractiveViewer(
                    onInteractionUpdate: (_) {},
                    /*scale settings*/
                    scaleEnabled: false, // handled separately

                    /*move settings*/
                    interactionEndFrictionCoefficient:
                        double.minPositive, //near zero slide after release

                    /*appearance & functionality settings*/
                    transformationController: gridCanvasProvider
                        .transformationController, //variable that allows acces to position
                    boundaryMargin: const EdgeInsets.all(double
                        .infinity), //creates infinite canvas by extending outwards.
                    clipBehavior: Clip.none, // allows no clipping
                    constrained: false, //panning glitches if not set to false

                    child: Stack(
                      clipBehavior: Clip.none, //allows no clipping

                      children: [
                        DragTarget<String>(
                            key: gridCanvasKey,
                            onAcceptWithDetails: (details) {
                              final RenderBox box = gridCanvasKey
                                  .currentContext!
                                  .findRenderObject() as RenderBox;

                              Offset localPosition = box.globalToLocal(details
                                      .offset +
                                  Offset(
                                      UiStaticProperties
                                              .videoCollectionEntryWidth /
                                          2,
                                      UiStaticProperties
                                                  .videoCollectionEntryWidth /
                                              2 +
                                          theme
                                              .dPanelPadding)); //TODO debug. These extra values make it work but idk why. If unset, the offset gets moved

                              addNodeFromDrag(details.data, localPosition);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return MouseRegion(
                                child: NutriaContextMenu(
                                  child: SizedBox(
                                    height: UiStaticProperties.canvasSize,
                                    width: UiStaticProperties.canvasSize,
                                    child: Container(
                                      color: theme.cBackground,
                                      // child: const Placeholder(),
                                    ),
                                  ),
                                ),
                              ) //need a sized container to prevent crash from infinite bounds todo debug (what is the simplest way to prevent crashing?)

                                  ;
                            }),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: GridPainter(
                                  transformationController: gridCanvasProvider
                                      .transformationController,
                                  context: context), // infinite dots grid
                            ),
                          ),
                        ),
                        Selector(
                            selector: (_, NodesProvider provider) =>
                                provider.currentNoodle,
                            builder: (context, currentNoodle, child) {
                              if (currentNoodle != null) {
                                return Positioned.fill(
                                  child: IgnorePointer(
                                    child: CustomPaint(
                                      painter: NoodlePainter(
                                          transformationController:
                                              gridCanvasProvider
                                                  .transformationController,
                                          context: context,
                                          noodles: [currentNoodle]), // noodles
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                        Selector(
                          selector: (_, NodesProvider provider) =>
                              provider.positionsAndOutputs,
                          builder: (context, positionsAndOutputs, child) =>
                              Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: NoodlePainter(
                                    transformationController: gridCanvasProvider
                                        .transformationController,
                                    context: context,
                                    noodles:
                                        nodesProvider.noodlesStartAndEndPoints(
                                            theme)), // noodles
                              ),
                            ),
                          ),
                        ),
                        ...nodes
                      ],
                    ),
                  ),
                ),
              );
            });
  }
}
