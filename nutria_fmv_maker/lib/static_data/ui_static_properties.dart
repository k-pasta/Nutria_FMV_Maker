import 'dart:ui';

class UiStaticProperties {
  //GridCanvas
  static const double canvasSize = 2000000; 
  static Offset get topLeftToMiddle => const Offset(-canvasSize/2, -canvasSize/2);
  
  //Nodes
  //TODO Make precise
  static const double nodeMinSize = 200;
  static const double nodeMinWidth = 350;
  static const double nodePadding = 25;
}