import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import 'models/app_theme.dart';
import 'providers/theme_provider.dart';

class SplitViewProvider extends ChangeNotifier {
  double leftSize = 300; // Default size
  double rightSize = 300; // Default size

  double minLeftSize = 200;
  double maxLeftSize = 700;

  double minRightSize = 200;
  double maxRightSize = double.infinity;

  double intendedLeftSize = 300;
  double intendedRightSize = 300;

  double closingThreshold = 50;

  bool isLeftClosed = false;
  bool isRightClosed = false;

  double get effectiveHandleWidth {
    return UiStaticProperties.splitViewDragWidgetSize *
        ((!isLeftClosed ? 1 : 0) + (!isRightClosed ? 1 : 0));
  }

// }

  void updateSize(String area, double delta, double totalWidth) {
    if (area == "left") {
      intendedLeftSize += delta;

      if (intendedLeftSize >= minLeftSize &&
          intendedLeftSize <= maxLeftSize &&
          !isLeftClosed) {
        //within bounds
        if (intendedLeftSize + effectiveHandleWidth < totalWidth) {
          //protect overflow
          leftSize = intendedLeftSize;
        }
        if (intendedLeftSize + rightSize + effectiveHandleWidth >= totalWidth) {
          if (rightSize - delta >= minRightSize) {
            //push over unless exceeds min
            rightSize -= delta;
          } else {
            //toggle other if exceeds min
            closeRight();
          }
        }
      }
      if (intendedLeftSize <= minLeftSize - closingThreshold && !isLeftClosed) {
        //less than threshold, close panel
        closeLeft();
      }
      if (intendedLeftSize > minLeftSize - closingThreshold && isLeftClosed) {
        //passed threshold, open panel
        openLeft(totalWidth);
      }
    } else if (area == "right") {
      intendedRightSize -= delta;
      if (intendedRightSize >= minRightSize &&
          intendedRightSize <= maxRightSize &&
          !isRightClosed) {
        //within bounds
        if (intendedRightSize + effectiveHandleWidth < totalWidth) {
          //protect overflow
          rightSize = intendedRightSize;
        }
        if (intendedRightSize + leftSize + effectiveHandleWidth >= totalWidth) {
          if (leftSize + delta >= minLeftSize) {
            leftSize += delta;
          } else {
            closeLeft();
          }
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
        openRight(totalWidth);
      }
    }

    notifyListeners();
  }

  void openLeft(double totalWidth) {
    isLeftClosed = false; //setting this first to get correct effectiveHandleWidth Calculation
    if (minLeftSize + rightSize + effectiveHandleWidth < totalWidth) {
      leftSize = minLeftSize;
    } else if (minLeftSize + minRightSize + effectiveHandleWidth < totalWidth) {
      leftSize = minLeftSize;
      rightSize = totalWidth - (leftSize + effectiveHandleWidth);
    } else if (minLeftSize + effectiveHandleWidth < totalWidth) {
      leftSize = minLeftSize;
      closeRight();
    } else {
      isLeftClosed = true;
    }
    notifyListeners();
  }

  void closeLeft() {
    isLeftClosed = true;
    leftSize = 0;
    notifyListeners();
  }

  void openRight(double totalWidth) {
    isRightClosed = false; //setting this first to get correct effectiveHandleWidth Calculation
    if (minRightSize + leftSize + effectiveHandleWidth < totalWidth) {
      rightSize = minRightSize;
    } else if (minLeftSize + minRightSize + effectiveHandleWidth < totalWidth) {
      rightSize = minRightSize;
      leftSize = totalWidth - (rightSize + effectiveHandleWidth);
    } else if (minRightSize + effectiveHandleWidth < totalWidth) {
      rightSize = minRightSize;
      closeLeft();
    } else {
      isRightClosed = true;
    }
    notifyListeners();
  }

  void closeRight() {
    isRightClosed = true;
    rightSize = 0;

    notifyListeners();
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
      updateIntended();
    }
  }

  void updateIntended() {
    if (leftSize <= minLeftSize) {
      intendedLeftSize = minLeftSize;
    } else {
      intendedLeftSize = leftSize;
    }

    if (rightSize <= minRightSize) {
      intendedRightSize = minRightSize;
    } else {
      intendedRightSize = rightSize;
    }
  }
}

class NutriaSplitView extends StatefulWidget {
  @override
  State<NutriaSplitView> createState() => _NutriaSplitViewState();
}

class _NutriaSplitViewState extends State<NutriaSplitView>
    with WidgetsBindingObserver {
  late Size _lastSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('ch d');
    // print(_lastSize- View.of(context).physicalSize);
    // // [View.of] exposes the view from `WidgetsBinding.instance.platformDispatcher.views`
    // // into which this widget is drawn.
    _lastSize = View.of(context).physicalSize;
    print(_lastSize);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    print('ch m');
    print(View.of(context).physicalSize);
    Size _currentSize = View.of(context).physicalSize;
    SplitViewProvider splitViewProvider =
        Provider.of<SplitViewProvider>(context, listen: false);
    splitViewProvider.onWindowChange(
        _lastSize.width - _currentSize.width, _currentSize.width);

    _lastSize = _currentSize;
    // setState(() { _lastSize = View.of(context).physicalSize; });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final provider = Provider.of<SplitViewProvider>(context);

        // Notify provider of total available width
        double totalWidth = constraints.maxWidth;

        return Stack(children: [
          Row(
            children: [
              if (!provider.isLeftClosed)
                _buildResizableArea(context, "left", provider.leftSize),
              // _buildOpen("left"),
              _buildDivider(
                  context, "left", !provider.isLeftClosed, totalWidth),
              _buildCenterArea(),
              // _buildOpen("right"),
              _buildDivider(
                  context, "right", !provider.isRightClosed, totalWidth),
              if (!provider.isRightClosed)
                _buildResizableArea(context, "right", provider.rightSize),
            ],
          ),
          OpenAreaButton(
            area: 'left',
            totalWidth: totalWidth,
          ),
          OpenAreaButton(
            area: 'right',
            totalWidth: totalWidth,
          ),
        ]);
      },
    );
  }
}

Widget _buildResizableArea(BuildContext context, String area, double width) {
  return IntrinsicWidth(
    child: Container(
      width: width,
      color: Colors.blue[100],
      child: Center(child: Text(area.toUpperCase())),
    ),
  );
}

Widget _buildCenterArea() {
  return Expanded(
      child: Container(
    color: Colors.grey[300],
    child: Center(child: Text("CENTER")),
  ));
}

// Widget _buildDivider(BuildContext context, String area, bool isOpen) {
//   SplitViewProvider uiProvider =
//       Provider.of<SplitViewProvider>(context, listen: false);
//   return GestureDetector(
//     behavior: HitTestBehavior.translucent,
//     onHorizontalDragUpdate: (details) {
//       uiProvider.updateSize(area, details.delta.dx);
//     },
//     onHorizontalDragEnd: (_) {
//       print('hey');
//       uiProvider.updateIntended();
//     },
//     child: MouseRegion(
//       cursor: SystemMouseCursors.resizeLeftRight,
//       child: Container(
//         width: isOpen ? 10 : 0,
//         color: Colors.green,
//       ),
//     ),
//   );
// }

Widget _buildDivider(
    BuildContext context, String area, bool isOpen, double totalWidth) {
  SplitViewProvider uiProvider =
      Provider.of<SplitViewProvider>(context, listen: false);
  return GestureDetector(
    onHorizontalDragUpdate: (details) {
      uiProvider.updateSize(area, details.delta.dx, totalWidth);
    },
    onHorizontalDragEnd: (_) {
      uiProvider.updateIntended();
    },
    child: MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: Container(
        width: isOpen ? 10 : 0,
        // width: 10,
        color: Colors.green,
      ),
    ),
  );
}

class OpenAreaButton extends StatefulWidget {
  final String area;
  final double totalWidth;
  const OpenAreaButton(
      {super.key, required this.area, required this.totalWidth});

  @override
  State<OpenAreaButton> createState() => _OpenAreaButtonState();
}

class _OpenAreaButtonState extends State<OpenAreaButton> {
  bool _isHovered = false;
  bool _isClicked = false;
  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
    final SplitViewProvider uiProvider =
        Provider.of<SplitViewProvider>(context, listen: false);
    final bool _isleftSide = widget.area == 'left';
    _isActive =
        _isleftSide ? uiProvider.isLeftClosed : uiProvider.isRightClosed;
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Positioned(
      left: _isleftSide ? 0 : null,
      right: !_isleftSide ? 0 : null,
      top: 0,
      bottom: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: (_isHovered) ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: !_isActive,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                _isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHovered = false;
              });
            },
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _isClicked = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  _isClicked = false;
                });
              },
              onTap: () {
                _isleftSide
                    ? uiProvider.openLeft(widget.totalWidth)
                    : uiProvider.openRight(widget.totalWidth);
                uiProvider.updateIntended();
              },
              child: Container(
                height: theme.dButtonHeight,
                width: theme.dButtonHeight / 2,
                decoration: BoxDecoration(
                    color: _isClicked
                        ? theme.cButtonPressed
                        : (_isHovered ? theme.cButtonHovered : theme.cButton),
                    borderRadius: BorderRadius.only(
                      topRight: _isleftSide
                          ? Radius.circular(theme.dButtonBorderRadius)
                          : Radius.zero,
                      bottomRight: _isleftSide
                          ? Radius.circular(theme.dButtonBorderRadius)
                          : Radius.zero,
                      topLeft: !_isleftSide
                          ? Radius.circular(theme.dButtonBorderRadius)
                          : Radius.zero,
                      bottomLeft: !_isleftSide
                          ? Radius.circular(theme.dButtonBorderRadius)
                          : Radius.zero,
                    ),
                    border: Border(
                      top: BorderSide(
                          color: theme.cOutlines, width: theme.dOutlinesWidth),
                      bottom: BorderSide(
                          color: theme.cOutlines, width: theme.dOutlinesWidth),
                      right: _isleftSide
                          ? BorderSide(
                              color: theme.cOutlines,
                              width: theme.dOutlinesWidth)
                          : BorderSide.none,
                      left: !_isleftSide
                          ? BorderSide(
                              color: theme.cOutlines,
                              width: theme.dOutlinesWidth)
                          : BorderSide.none,
                    )),
                child: Icon(
                  _isleftSide ? Icons.arrow_right : Icons.arrow_left,
                  color: theme.cText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
