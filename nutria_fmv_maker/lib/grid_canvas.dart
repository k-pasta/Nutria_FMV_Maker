import 'package:nutria_fmv_maker/custom_widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/models/node_data.dart';
import 'package:nutria_fmv_maker/painters/noodle_painter.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'custom_widgets/video_node.dart';
import './providers/grid_canvas_provider.dart';
import './providers/nodes_provider.dart';
import 'painters/grid_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    nodes = context.read<NodesProvider>().iDs.map((id) {
      return TestNode(
        nodeId: id,
        key: ValueKey(id),
      );
    }).toList();
    super.initState();
  }

  void _updateNodes(List<String> iDs) {
    if (iDs.length > nodes.length) {
      iDs.skip(nodes.length).forEach((nodeId) {
        nodes.add(TestNode(
          nodeId: nodeId,
          key: ValueKey(nodeId),
        ));
      });
    } else if (iDs.length < nodes.length) {
      nodes.removeRange(iDs.length, nodes.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final gridCanvasProvider = context.read<GridCanvasProvider>();
    final nodesProvider = context.read<NodesProvider>();

    void addNodeFromDrag(String videoId, Offset widgetLocalOffset) {
      nodesProvider.addNode(VideoNodeData(
          position: widgetLocalOffset -
              UiStaticProperties.topLeftToMiddle -
              Offset(UiStaticProperties.nodePadding,
                  UiStaticProperties.nodePadding),
          id: uuid.v1(),
          videoDataId: videoId));
    }

    return Selector<NodesProvider, List<String>>(
        selector: (_, nodesProvider) => nodesProvider.iDs,
        builder: (context, iDs, child) {
          print('full rebuild');

          _updateNodes(iDs);

          nodes.sort((a, b) {
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
                          final RenderBox box = gridCanvasKey.currentContext!
                              .findRenderObject() as RenderBox;

                          Offset localPosition = box.globalToLocal(details.offset +
                              Offset(
                                  UiStaticProperties.videoCollectionEntryWidth /
                                      2,
                                  UiStaticProperties.videoCollectionEntryWidth /
                                          2 +
                                      theme
                                          .dPanelPadding)); //TODO debug. These extra values make it work but idk why. If unset, the offset gets moved

                          addNodeFromDrag(details.data, localPosition);
                        },
                        builder: (context, candidateData, rejectedData) {
                          int hoverCounter = 0;
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
                              transformationController:
                                  gridCanvasProvider.transformationController,
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
                                transformationController:
                                    gridCanvasProvider.transformationController,
                                context: context,
                                noodles: nodesProvider.noodlesStartAndEndPoints(
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
