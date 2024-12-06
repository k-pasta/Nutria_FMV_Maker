import 'package:defer_pointer/defer_pointer.dart';
import 'package:nutria_fmv_maker/node.dart';
import './providers/grid_canvas_provider.dart';
import './providers/nodes_provider.dart';
import './grid_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridCanvas extends StatelessWidget {
  GridCanvas({super.key});

  late TransformationController _transformationController =
      TransformationController();

  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    final gridCanvasProvider = context.watch<GridCanvasProvider>();
    final nodesProvider = context.watch<NodesProvider>();

    double _top = MediaQuery.of(context).size.height / 2 - 100;
    double _left = MediaQuery.of(context).size.width / 2 - 100;
    return Listener(
      onPointerSignal: (event) {
        // print('interacted');
        if (event is PointerScrollEvent) {
          gridCanvasProvider.updateScaleAndMatrix(event, context);
        }
      },
      child: DeferredPointerHandler(
        child: InteractiveViewer(
          /*scale settings*/
          scaleEnabled: false, // handled separately

          /*move settings*/
          interactionEndFrictionCoefficient:
              double.minPositive, //near zero slide after release

          /*appearance & functionality settings*/
          transformationController: gridCanvasProvider
              .transformationController, //variable that allows acces to position
          boundaryMargin: const EdgeInsets.all(
              double.infinity), //creates infinite canvas by extending outwards.
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

              ...nodesProvider.nodes.map((node) {
                // print('remapping');
                return Node(
                  nodeData: node,
                  key: ValueKey(node.id),
                );
              }),

              SizedBox(
                height: 100,
                width: 100,
              ), //need a sized container to prevent crash from infinite bounds todo debug (what is the simplest way to prevent crashing?)
            ],
          ),
        ),
      ),
    );
  }
}
