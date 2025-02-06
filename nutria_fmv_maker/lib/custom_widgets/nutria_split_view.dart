import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/ui_state_provider.dart';
import 'split_view_elements/test.dart';




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
    // print(_lastSize- View.of(context).physicalSize);
    // // [View.of] exposes the view from `WidgetsBinding.instance.platformDispatcher.views`
    // // into which this widget is drawn.
    _lastSize = View.of(context).physicalSize;
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
    UiStateProvider splitViewProvider =
        Provider.of<UiStateProvider>(context, listen: false);
    splitViewProvider.onWindowChange(
        _lastSize.width - _currentSize.width, _currentSize.width);

    _lastSize = _currentSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final provider = Provider.of<UiStateProvider>(context);

        // Notify provider of total available width
        double totalWidth = constraints.maxWidth;

        return Stack(children: [
          Row(
            children: [
              if (!provider.isLeftClosed)
                _buildResizableArea(context, AreaSide.left, provider.leftSize),
              // _buildOpen("left"),
              _buildDivider(
                  context,  AreaSide.left, !provider.isLeftClosed, totalWidth),
              _buildCenterArea(),
              // _buildOpen("right"),
              _buildDivider(
                  context,  AreaSide.right, !provider.isRightClosed, totalWidth),
              if (!provider.isRightClosed)
                _buildResizableArea(context, AreaSide.right, provider.rightSize),
            ],
          ),
          OpenAreaButton(
            area: AreaSide.left,
            totalWidth: totalWidth,
          ),
          OpenAreaButton(
            area: AreaSide.right,
            totalWidth: totalWidth,
          ),
        ]);
      },
    );
  }
}

Widget _buildResizableArea(BuildContext context, AreaSide area, double width) {
  return IntrinsicWidth(
    child: Container(
      width: width,
      color: Colors.blue[100],
      child: Center(child: Text(area.toString().toUpperCase())),
    ),
  );
}

Widget _buildCenterArea() {
  return Expanded(
      child: Container(
    // color: Colors.grey[300],
    // child: Center(child: Text("CENTER")),
  ));
}

Widget _buildDivider(
    BuildContext context, AreaSide area, bool isOpen, double totalWidth) {
  UiStateProvider uiProvider =
      Provider.of<UiStateProvider>(context, listen: false);
  return GestureDetector(
    onHorizontalDragUpdate: (details) {
      uiProvider.updateSize(area, details.delta.dx, totalWidth);
    },
    onHorizontalDragEnd: (_) {
      uiProvider.updateIntended(area);
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

