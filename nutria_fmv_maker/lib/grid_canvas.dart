import 'package:defer_pointer/defer_pointer.dart';
import 'node.dart';
import './providers/grid_canvas_provider.dart';
import './providers/nodes_provider.dart';
import './grid_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './static_data/grid_canvas_properties.dart';

class GridCanvas extends StatelessWidget {
  GridCanvas({super.key});
  double keyboardMoveSensitivity = 100;

  late final TransformationController _transformationController =
      TransformationController();
      
  @override
  Widget build(BuildContext context) {
    final gridCanvasProvider = context.watch<GridCanvasProvider>();
    final nodesProvider = context.watch<NodesProvider>();

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        gridCanvasProvider.moveUp: () {
          gridCanvasProvider.offsetPosition(
            Offset(0, keyboardMoveSensitivity),
            isScreenSpaceTransformation: true,
          );
        },
        gridCanvasProvider.moveDown: () {
          gridCanvasProvider.offsetPosition(Offset(0, -keyboardMoveSensitivity),
              isScreenSpaceTransformation: true);
        },
        gridCanvasProvider.moveLeft: () {
          gridCanvasProvider.offsetPosition(Offset(keyboardMoveSensitivity, 0),
              isScreenSpaceTransformation: true);
        },
        gridCanvasProvider.moveRight: () {
          gridCanvasProvider.offsetPosition(Offset(-keyboardMoveSensitivity, 0),
              isScreenSpaceTransformation: true);
        },
      },
      child: Focus(
        onFocusChange: (gotFocus) {
          if (gotFocus) {
            print('got focus');
          } else {
            print('lost focus');
          }
        },
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              gridCanvasProvider.updateScaleAndMatrix(event, context);
            }
          },
          child: DeferredPointerHandler(
            child: Center(
              child: InteractiveViewer(
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
              
                    SizedBox(
                      height: GridCanvasProperties.canvasSize,
                      width: GridCanvasProperties.canvasSize,
                      child: Container(
                        color: Colors.black12,
                      ),
                    ), //need a sized container to prevent crash from infinite bounds todo debug (what is the simplest way to prevent crashing?)
              
                    ...nodesProvider.nodes.map((node) {
                      // print('remapping');
                      return Node(
                        nodeData: node,
                        key: ValueKey(node.id),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
