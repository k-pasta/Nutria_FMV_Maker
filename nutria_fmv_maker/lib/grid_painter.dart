import 'package:flutter/material.dart';
import 'models/app_theme.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class GridPainter extends CustomPainter {
  final TransformationController transformationController;
  final BuildContext context;

  const GridPainter(
      {required this.transformationController, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final AppTheme theme =
        Provider.of<ThemeProvider>(context, listen: false).currentAppTheme;

    final Paint paint = Paint()
      ..color = theme.cBackgroundDots
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
            (-translationX + 5000 /* MediaQuery.of(context).size.width */) /
                    scale +
                gridSpacing;
        x += gridSpacing) {
      for (double y =
              (-translationY) / scale - ((-translationY) / scale) % gridSpacing;
          y <
              (-translationY + 5000 /* MediaQuery.of(context).size.height */) /
                  scale;
          y += gridSpacing) {
        points.add(Offset(x, y)); // Add each point to the list
      } //TODO de-hardcode. Changed from mediaquery to a number because mediaquery would cause the whole widget tree to rebuild
    }
    // Draw points on the canvas
    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; //to optimize
}
