import 'dart:ui';

class UiStaticProperties {
//overall
  static const bool isDebug = true;

  //GridCanvas
  static const double canvasSize = 2000;
  static Offset get topLeftToMiddle =>
      const Offset(canvasSize / 2, canvasSize / 2);
  static const double gridCanvasScaleFactor = 0.1; 
  static const double gridCanvasMinScale = 0.01;
  static const double gridCanvasMaxScale = 300;
  static const double gridCanvasArrowMoveSensitivity = 100;


  //Nodes
  //TODO Make precise
  static const double nodeMinWidth = 160;
  static const double nodeDefaultWidth = 230;
  static const double nodeMaxWidth = 400;
  static const double nodePadding = 30;

  //Knots
  static const double knotSizeLarge = 25;
  static const double knotSizeSmall = 17;
}
