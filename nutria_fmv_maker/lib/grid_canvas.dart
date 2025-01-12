import 'package:defer_pointer/defer_pointer.dart';
import 'custom_widgets/video_node.dart';
import './providers/grid_canvas_provider.dart';
import './providers/nodes_provider.dart';
import './grid_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'static_data/ui_static_properties.dart';

class GridCanvas extends StatelessWidget {
  GridCanvas({super.key});
  double keyboardMoveSensitivity = 100;

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
          // child: DeferredPointerHandler(
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

                  SizedBox(
                    height: UiStaticProperties.canvasSize,
                    width: UiStaticProperties.canvasSize,
                    child: Container(
                      // color: Colors.black12,
                      // color: Colors.amber,
                      child: Placeholder(),
                    ),
                  ), //need a sized container to prevent crash from infinite bounds todo debug (what is the simplest way to prevent crashing?)
                  // Positioned(
                  //   top: -(UiStaticProperties.canvasSize / 2),
                  //   left: -(UiStaticProperties.canvasSize / 2),
                  //   child: Container(
                  //     width: 100,
                  //     height: 100,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  ...nodesProvider.nodes.map((node) {
                    return VideoNode(
                      nodeData: node,
                      key: ValueKey(node.id),
                    );
                  }),
                ],
              ),
            ),
          ),
          // ),
        ),
      ),
    );
  }
}
