import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../static_data/ui_static_properties.dart';

class GridCanvasProvider extends ChangeNotifier {
TransformationController _transformationController = TransformationController();

GridCanvasProvider(){
 _transformationController = TransformationController();
  offsetPosition(-UiStaticProperties.topLeftToMiddle); //move view to the middle
}

  final double _scaleFactor = UiStaticProperties.gridCanvasScaleFactor; 
  final double _minScale = UiStaticProperties.gridCanvasMinScale;
  final double _maxScale = UiStaticProperties.gridCanvasMaxScale;

  final ShortcutActivator _moveUp = LogicalKeySet(LogicalKeyboardKey.arrowUp);
  final ShortcutActivator _moveLeft = LogicalKeySet(LogicalKeyboardKey.arrowLeft);
  final ShortcutActivator _moveRight = LogicalKeySet(LogicalKeyboardKey.arrowRight);
  final ShortcutActivator _moveDown = LogicalKeySet(LogicalKeyboardKey.arrowDown);

  ShortcutActivator get moveUp => _moveUp;
  ShortcutActivator get moveLeft => _moveLeft;
  ShortcutActivator get moveRight => _moveRight;
  ShortcutActivator get moveDown => _moveDown;

// Offset _positionOffset = Offset.zero;
  Offset get positionOffset => Offset(
        _transformationController.value.getTranslation().x,
        _transformationController.value.getTranslation().y,
      );

  double _currentScale = 1.0;


  double get currentScale => _currentScale;
  TransformationController get transformationController =>
      _transformationController;

  void offsetPosition(offset, {bool isScreenSpaceTransformation = false}) {
   
    if (!isScreenSpaceTransformation) {
      offset = Offset(
        offset.dx * _currentScale,
        offset.dy * _currentScale,
      );
    }

    // Retrieve the current transformation matrix
    Matrix4 currentMatrix = _transformationController.value;

    // Create a translation matrix for the offset
    Matrix4 translationMatrix = Matrix4.identity()
      ..translate(offset.dx, offset.dy);

    // Combine the translation with the current transformation matrix
    _transformationController.value = translationMatrix * currentMatrix;

    // Notify listeners about the change
    notifyListeners();
  }

  void updateScaleAndMatrix(PointerScrollEvent event, BuildContext context) {
    // Calculate scale factor
    double scaleFactor =
        event.scrollDelta.dy < 0 ? 1 + _scaleFactor : 1 - _scaleFactor;
    double newScale = (_currentScale * scaleFactor).clamp(_minScale, _maxScale);

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
    _transformationController.value =
        translationToPointer * scaleMatrix * translationBack * currentMatrix;

    // Update current scale
    _currentScale = newScale;
//  print (newScale);
    // print('${positionOffset.dx} - dx, ${positionOffset.dy} - dy');
    notifyListeners();
  }
}
