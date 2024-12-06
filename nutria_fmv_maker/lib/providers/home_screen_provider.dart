import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier{
double zoomlevel = 1;
Offset signalingMousePosition = Offset(0, 0);

void setZoomLevel(double x){
  this.zoomlevel = x;
  notifyListeners();
}
void doZoomIn(double x){
  this.zoomlevel += x/1000;
  notifyListeners();
}
void doZoomOut(double x){
  this.zoomlevel -= x/1000;
  notifyListeners();
}
void setMousePosition(Offset offset){
 this.signalingMousePosition = offset;
 print(offset.dx);
  notifyListeners();
}

}