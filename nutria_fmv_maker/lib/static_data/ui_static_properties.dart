import 'dart:ui';

class UiStaticProperties {
//overall
  static const bool isDebug = true;

  //GridCanvas
  static const double canvasSize = 2010;
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
  static const double nodePlayIndicatorPadding = 10;
  static const double nodePlayIndicatorSize = 36;
  static const int thumbnailSize = 500;

  //Knots
  static const double knotSizeLarge = 25;
  static const double knotSizeSmall = 17;

  //Noodles
  static const double noodleWidth = 5;
  static const double noodleConnectedSpacing = 25;

  //Split View
  static const double splitViewDragWidgetSize = 10;

  //Context menu
  static const double contextMenuWidth = 150;
  
}
