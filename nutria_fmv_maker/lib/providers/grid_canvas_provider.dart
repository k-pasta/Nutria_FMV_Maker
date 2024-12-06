import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class GridCanvasProvider extends ChangeNotifier{
double _scaleFactor = 0.1;
  double _currentScale = 1.0;
  final TransformationController _transformationController =
      TransformationController();

  double get currentScale => _currentScale;
  TransformationController get transformationController =>
      _transformationController;

  void updateScaleAndMatrix(PointerScrollEvent event, BuildContext context) {
    // Calculate scale factor
    double scaleFactor = event.scrollDelta.dy < 0 ? 1 + _scaleFactor : 1 - _scaleFactor;
    double newScale = (_currentScale * scaleFactor).clamp(0.1, 20.0);

    // Get mouse position in local coordinates
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localFocalPoint = renderBox.globalToLocal(event.position);

    // Adjust transformation matrix to scale at the pointer position
    Matrix4 currentMatrix = _transformationController.value;
    Matrix4 translationToPointer = Matrix4.identity()
      ..translate(localFocalPoint.dx, localFocalPoint.dy);
    Matrix4 scaleMatrix = Matrix4.identity()..scale(newScale / _currentScale);
    Matrix4 translationBack = Matrix4.identity()
      ..translate(-localFocalPoint.dx, -localFocalPoint.dy);

    // Combine transformations
    _transformationController.value = translationToPointer *
        scaleMatrix *
        translationBack *
        currentMatrix;

    // Update current scale
    _currentScale = newScale;

    notifyListeners();
  }
}
