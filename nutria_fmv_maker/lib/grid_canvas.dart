import 'dart:ui';

import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'dart:math';

class GridCanvas extends StatefulWidget {
  GridCanvas({super.key});

  @override
  State<GridCanvas> createState() =>
      _GridCanvasState();
}

class _GridCanvasState extends State<GridCanvas> {
  late TransformationController _transformationController;

  double _top = 0;
  double _left = 0;
  double _currentScale = 1.0;
  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DeferredPointerHandler(
      child: InteractiveViewer(
        /*scale settings*/
        scaleEnabled: false,
        scaleFactor: 1000, //scale sensitivity. to expose for settings
        minScale: .01,
        maxScale: 10,

        /*move settings*/
        interactionEndFrictionCoefficient:
            double.minPositive, //near zero slide after release

        /*appearance & functionality settings*/
        transformationController:
            _transformationController, //variable that allows acces to position
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
                    transformationController: _transformationController,
                    context: context), // infinite dots grid
              ),
            ),

            Container(
              height: 500,
              child: Image.asset(
                'lib/global_assets/green.jpg',
                repeat: ImageRepeat.repeat,
              ),
            ), //need a sized container to prevent crash from infinite bounds todo debug (what is the simplest way to prevent crashing?)

            Positioned(
              top: _top,
              left: _left,
              child: DeferPointer(
                child: Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      setState(() {
                        // Calculate scale factor
                        double scaleFactor  =
                            event.scrollDelta.dy < 0 ? 1.1 : 0.9;
                        double newScale =
                            (_currentScale * scaleFactor ).clamp(0.1, 20.0);

                        // Get mouse position in local coordinates
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localFocalPoint =
                            renderBox.globalToLocal(event.position);

                        // Adjust transformation matrix to scale at the pointer position
                        Matrix4 currentMatrix = _transformationController.value;
                        Matrix4 translationToPointer = Matrix4.identity()
                          ..translate(localFocalPoint.dx, localFocalPoint.dy);
                        Matrix4 scaleMatrix = Matrix4.identity()
                          ..scale(newScale / _currentScale);
                        Matrix4 translationBack = Matrix4.identity()
                          ..translate(-localFocalPoint.dx, -localFocalPoint.dy);

                        // Combine transformations
                        _transformationController.value = translationToPointer *
                            scaleMatrix *
                            translationBack *
                            currentMatrix;

                        // Update current scale
                        _currentScale = newScale;
                      });
                    }
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (details) {
                      setState(() {
                        _top = _top + details.delta.dy;
                        _left = _left + details.delta.dx;
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green[600],
                      ),
                      child: Center(
                        child: GestureDetector(
                            // behavior: HitTestBehavior.opaque,
                            // onScaleUpdate: (details) {
                            //   print('scaled');
                            // },
                            onPanUpdate: (details) {},
                            child: IconButton(
                                onPressed: () {}, icon: Icon(Icons.abc))),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final TransformationController transformationController;
  final BuildContext context;

  GridPainter({required this.transformationController, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color.fromARGB(15, 0, 0, 0)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0 / transformationController.value.getMaxScaleOnAxis();

    // Get the current transformation matrix
    final Matrix4 matrix = transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();

    // Extract translation values from the matrix (x, y, z)
    final translation = matrix.getTranslation();
    final double translationX = translation.x;
    final double translationY = translation.y;

    // Grid spacing (smaller for higher zoom levels)

    double nearestPowerOfTwo(double num) {
      // Function to find the nearest number in the geometric sequence
      double start = 1; // Initial value of the sequence
      while (start / 4 >= num) {
        start /= 4;
      }
      return start;
    }

    double scaleModifier = nearestPowerOfTwo(scale);
    double gridSpacing = 100 / scaleModifier;

    // Calculate the offset to determine where the grid should start
    // final double startX = translationX % gridSpacing;
    // final double startY = translationY % gridSpacing;

    // List to hold all points for the grid
    List<Offset> points = [];

    // Calculate the visible grid points, including some margin beyond the visible area

    for (double x = (-translationX) / scale -
            ((-translationX) / scale) % gridSpacing -
            gridSpacing;
        x <
            (-translationX + MediaQuery.of(context).size.width) / scale +
                gridSpacing;
        x += gridSpacing) {
      for (double y =
              (-translationY) / scale - ((-translationY) / scale) % gridSpacing;
          y < (-translationY + MediaQuery.of(context).size.height) / scale;
          y += gridSpacing) {
        points.add(Offset(x, y)); // Add each point to the list
      }
    }
    print(scaleModifier);
    // Draw points on the canvas
    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; //to optimize
}

// class GridPainter extends CustomPainter {
//   final TransformationController transformationController;

//   GridPainter(this.transformationController);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0 / transformationController.value.getMaxScaleOnAxis();

//     // Get the current transformation matrix
//     final Matrix4 matrix = transformationController.value;
//     final double scale = matrix.getMaxScaleOnAxis();

//     // Grid spacing
//      double gridSpacing = 10; // Adjust spacing based on scale

//     // Draw grid lines
//     if (scale > 1) {
//       gridSpacing = 10;

//     }
//     else {
//       gridSpacing = 50;
//     }

//        List<Offset> points = [];

//     // Calculate points for the grid
//     for (double x = -size.width; x < size.width * 2; x += gridSpacing) {
//       for (double y = -size.height; y < size.height * 2; y += gridSpacing) {
//         points.add(Offset(x, y)); // Add each point to the list
//       }
//     }

//     // Draw points
//     canvas.drawPoints(PointMode.points, points, paint);
//   }

//   //   for (double x = -size.width; x < size.width * 2; x += gridSpacing) {
//   //    canvas.drawPoints(PointMode.points, [Offset(x, -size.height)], paint);
//   //     canvas.drawLine(
//   //         Offset(x, -size.height), Offset(x, size.height * 2), paint);
//   //   }
//   //   for (double y = -size.height; y < size.height * 2; y += gridSpacing) {
//   //     canvas.drawLine(Offset(-size.width, y), Offset(size.width * 2, y), paint);
//   //   }

//   // }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
