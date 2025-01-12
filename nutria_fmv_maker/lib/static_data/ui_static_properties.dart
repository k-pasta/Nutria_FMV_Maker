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

  //Nodes
  //TODO Make precise
  static const double nodeMinWidth = 230;
  static const double nodeDefaultWidth = 230;
  static const double nodeMaxWidth = 500;
  static const double nodePadding = 30;
}
