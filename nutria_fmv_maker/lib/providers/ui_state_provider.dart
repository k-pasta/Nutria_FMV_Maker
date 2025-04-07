import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/enums_ui.dart';
import '../static_data/ui_static_properties.dart';

import 'dart:math';

class UiStateProvider extends ChangeNotifier {
  //context menu

  // bool _isOpaque = true;

  // bool get isOpaque => _isOpaque;

  // set isOpaque(bool value) {
  //   _isOpaque = value;
  //   notifyListeners();
  // }
  bool _isContextMenuOpen = false;
  bool get isContextMenuOpen => _isContextMenuOpen;

  LeftPanelSection _leftPanelSection = LeftPanelSection.videos;
  LeftPanelSection get leftPanelSection => _leftPanelSection;
  set leftPanelSection(LeftPanelSection value) {
    _leftPanelSection = value;
    notifyListeners();
  }

  void setContextMenuOpen(bool isOpen) {
    _isContextMenuOpen = isOpen;
    notifyListeners();
  }

  // bool _isModalOrMenuOpen = false;
  bool get isModalOrMenuOpen {
    return _isMenuOpen || _isModalInfoOpen;
  }

  bool _isMenuOpen = false;
  bool get isMenuOpen => _isMenuOpen;
  set isMenuOpen(bool value) {
    if (_isMenuOpen != value) {
      _isMenuOpen = value;
      notifyListeners();
    }
  }

  bool _isModalInfoOpen = false;
  bool get isModalInfoOpen => _isModalInfoOpen;
  set isModalInfoOpen(bool value) {
    if (_isModalInfoOpen != value) {
      _isModalInfoOpen = value;
      notifyListeners();
    }
  }

//menu
  final FocusNode _parentfocusNode = FocusNode();
  get parentfocusNode => _parentfocusNode;

//split view

  double leftSize = 300; // Default size
  double rightSize = 300; // Default size

  double minLeftSize = 200;
  double maxLeftSize = 700;

  double minRightSize = 200;
  double maxRightSize = double.infinity;

  double intendedLeftSize = 300;
  double intendedRightSize = 300;

  double closingThreshold = 50; //todo move to uistaticproperties

  bool isLeftClosed = false;
  bool isRightClosed = false;

  double get effectiveHandleWidth {
    return UiStaticProperties.splitViewDragWidgetSize *
        ((!isLeftClosed ? 1 : 0) + (!isRightClosed ? 1 : 0));
  }

  void updateSize(AreaSide area, double delta, double totalWidth) {
    if (area == AreaSide.left) {
      intendedLeftSize += delta;
      if (intendedLeftSize >= minLeftSize &&
          intendedLeftSize <= maxLeftSize &&
          !isLeftClosed) {
        //within bounds
        if (intendedLeftSize + effectiveHandleWidth < totalWidth) {
          //protect overflow
          leftSize = intendedLeftSize;
        }
        if (intendedLeftSize + rightSize + effectiveHandleWidth > totalWidth) {
          //////
          if (rightSize - delta >= minRightSize) {
            //push over unless exceeds min
            rightSize -= delta;
          } else {
            //toggle other if exceeds min
            closeRight();
          }
          updateIntended(AreaSide.right);
        }
      }
      if (intendedLeftSize <= minLeftSize - closingThreshold && !isLeftClosed) {
        //less than threshold, close panel
        closeLeft();
      }
      if (intendedLeftSize > minLeftSize - closingThreshold && isLeftClosed) {
        //passed threshold, open panel
        openLeft(totalWidth: totalWidth, shouldUpdateIntended: false);
      }
    } else if (area == AreaSide.right) {
      intendedRightSize -= delta;
      if (intendedRightSize >= minRightSize &&
          intendedRightSize <= maxRightSize &&
          !isRightClosed) {
        //within bounds
        if (intendedRightSize + effectiveHandleWidth < totalWidth) {
          //protect overflow
          rightSize = intendedRightSize;
        }
        if (intendedRightSize + leftSize + effectiveHandleWidth > totalWidth) {
          if (leftSize + delta >= minLeftSize) {
            leftSize += delta;
          } else {
            closeLeft();
          }
          updateIntended(AreaSide.left);
        }
      }
      if (intendedRightSize <= minRightSize - closingThreshold &&
          !isRightClosed) {
        //less than threshold, close panel
        closeRight();
      }
      if (intendedRightSize > minRightSize - closingThreshold &&
          isRightClosed) {
        //passed threshold, open panel
        openRight(totalWidth: totalWidth, shouldUpdateIntended: false);
      }
    }

    notifyListeners();
  }

  void openLeft(
      {required double totalWidth, bool shouldUpdateIntended = true}) {
    isLeftClosed =
        false; //setting this first to get correct effectiveHandleWidth Calculation
    if (max(intendedLeftSize, minLeftSize) + rightSize + effectiveHandleWidth <
        totalWidth) {
      //if fits
      leftSize = max(intendedLeftSize, minLeftSize);
    } else if (minLeftSize + minRightSize + effectiveHandleWidth < totalWidth) {
      //if mins fit
      leftSize =
          max(totalWidth - (rightSize + effectiveHandleWidth), minLeftSize);
      rightSize = totalWidth - (leftSize + effectiveHandleWidth);
      updateIntended(AreaSide.right);
    } else if (minLeftSize + effectiveHandleWidth < totalWidth) {
      //if its own min fits
      leftSize = min(max(intendedLeftSize, minLeftSize),
          totalWidth - effectiveHandleWidth);
      closeRight();
    } else {
      isLeftClosed = true;
    }
    if (shouldUpdateIntended) {
      updateIntended(AreaSide.left);
    }
    notifyListeners();
  }

  void openRight(
      {required double totalWidth, bool shouldUpdateIntended = true}) {
    isRightClosed =
        false; //setting this first to get correct effectiveHandleWidth Calculation
    if (max(intendedRightSize, minRightSize) + leftSize + effectiveHandleWidth <
        totalWidth) {
      //if fits
      rightSize = max(intendedRightSize, minRightSize);
    } else if (minRightSize + minLeftSize + effectiveHandleWidth < totalWidth) {
      //if mins fit
      rightSize =
          max(totalWidth - (leftSize + effectiveHandleWidth), minRightSize);
      leftSize = totalWidth - (rightSize + effectiveHandleWidth);
      updateIntended(AreaSide.left);
    } else if (minRightSize + effectiveHandleWidth < totalWidth) {
      //if its own min fits
      rightSize = min(max(intendedRightSize, minRightSize),
          totalWidth - effectiveHandleWidth);
      closeLeft();
    } else {
      isRightClosed = true;
    }
    if (shouldUpdateIntended) {
      updateIntended(AreaSide.right);
    }
    notifyListeners();
  }

  void closeRight() {
    isRightClosed = true;
    rightSize = 0;

    notifyListeners();
  }

  void closeLeft() {
    isLeftClosed = true;
    leftSize = 0;
    notifyListeners();
  }

  void toggleLeft(double totalWidth) {
    if (isLeftClosed) {
      openLeft(totalWidth: totalWidth);
    } else {
      closeLeft();
    }
  }

  void toggleRight(double totalWidth) {
    if (isRightClosed) {
      openRight(totalWidth: totalWidth);
    } else {
      closeRight();
    }
  }

  void onWindowChange(double dx, double fullWidth) {
    if (fullWidth - (leftSize + rightSize + effectiveHandleWidth) < 0 &&
        dx > 0) {
      if (!isLeftClosed && !isRightClosed) {
        leftSize -= dx / 2;
        rightSize -= dx / 2;
      } else if (!isLeftClosed && isRightClosed) {
        leftSize -= dx;
      } else if (isLeftClosed && !isRightClosed) {
        rightSize -= dx;
      }

      if (leftSize < minLeftSize && isLeftClosed == false) {
        isLeftClosed = true;
        leftSize = 0;
      }
      if (rightSize < minRightSize && isRightClosed == false) {
        isRightClosed = true;
        rightSize = 0;
      }
      updateIntended(AreaSide.left);
      updateIntended(AreaSide.right);
    }
  }

  void updateIntended(AreaSide area) {
    if (area == AreaSide.left) {
      intendedLeftSize = leftSize;
    } else if (area == AreaSide.right) {
      intendedRightSize = rightSize;
    }
  }
}
