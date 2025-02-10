import 'package:nutria_fmv_maker/custom_widgets/video_node_tests.dart';
import 'package:nutria_fmv_maker/models/node_data.dart';

import 'custom_widgets/video_node.dart';
import './providers/grid_canvas_provider.dart';
import './providers/nodes_provider.dart';
import './grid_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'static_data/ui_static_properties.dart';

class GridCanvas extends StatefulWidget {
  const GridCanvas({super.key});

  @override
  State<GridCanvas> createState() => _GridCanvasState();
}

class _GridCanvasState extends State<GridCanvas> {
  final double keyboardMoveSensitivity =
      UiStaticProperties.gridCanvasArrowMoveSensitivity;

  late List<Widget> nodes;
  @override
  void initState() {
    nodes = context.read<NodesProvider>().nodes.map((node) {
      return TestNode(
        nodeData: node as VideoNodeData,
        key: ValueKey(node.id),
      );
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gridCanvasProvider = context.read<GridCanvasProvider>();
    final nodesProvider = context.read<NodesProvider>();

    return Selector<NodesProvider, List<String>>(
        selector: (_, nodesProvider) => nodesProvider.iDs,
        builder: (context, iDs, child) {
          print('full rebuilt');
            nodes.sort((a, b) {
            final aId = (a.key as ValueKey).value as String;
            final bId = (b.key as ValueKey).value as String;
            return iDs.indexOf(aId).compareTo(iDs.indexOf(bId));
            });
          // final List<Widget> nodes = nodesProvider.nodes.map((node) {
          //   return TestNode(
          //     nodeData: node as VideoNodeData,
          //     key: ValueKey(node.id),
          //   );
          // }).toList();

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
                    Positioned.fill(
                      child: CustomPaint(
                        painter: GridPainter(
                            transformationController:
                                gridCanvasProvider.transformationController,
                            context: context), // infinite dots grid
                      ),
                    ),
                    const SizedBox(
                      height: UiStaticProperties.canvasSize,
                      width: UiStaticProperties.canvasSize,
                      child: Placeholder(),
                    ), //need a sized container to prevent crash from infinite bounds todo debug (what is the simplest way to prevent crashing?)
                    ...nodes
                  ],
                ),
              ),
            ),
          );
        });
  }
}
