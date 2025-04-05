import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../models/enums_ui.dart';
import '../providers/theme_provider.dart';
import '../providers/ui_state_provider.dart';
import 'split_view_elements/open_area_button.dart';

class NutriaSplitView extends StatefulWidget {
  final Widget? leftChild;
  final Widget? rightChild;

  const NutriaSplitView({super.key, this.leftChild, this.rightChild});

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
              Offstage(
                offstage: provider.isLeftClosed,
                child: _buildResizableArea(
                    context, AreaSide.left, provider.leftSize,
                    child: widget.leftChild),
              ),
              _buildDivider(
                  context, AreaSide.left, !provider.isLeftClosed, totalWidth),
              _buildCenterArea(),
              _buildDivider(
                  context, AreaSide.right, !provider.isRightClosed, totalWidth),
              Offstage(
                offstage: provider.isRightClosed,
                child: _buildResizableArea(
                    context, AreaSide.right, provider.rightSize,
                    child: widget.rightChild),
              ),
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

Widget _buildResizableArea(BuildContext context, AreaSide area, double width,
    {Widget? child}) {
  final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
  return IntrinsicWidth(
    child: Container(
        width: width,
        height: double.infinity,
        color: theme.cPanel,
        child: child),
  );
}

Widget _buildCenterArea() {
  return Expanded(
      child: Container(
          ));
}

Widget _buildDivider(
    BuildContext context, AreaSide area, bool isOpen, double totalWidth) {
  final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
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
        width: isOpen ? UiStaticProperties.splitViewDragWidgetSize : 0,
        child: Container(
          width: UiStaticProperties.splitViewDragWidgetSize,
          decoration: BoxDecoration(
            color: theme.cPanel,
            border: Border(
              left: area == AreaSide.right
                  ? BorderSide(
                      color: theme.cOutlines,
                      width: theme.dSectionOutlineWidth,
                    )
                  : BorderSide.none,
              right: area == AreaSide.left
                  ? BorderSide(
                      color: theme.cOutlines,
                      width: theme.dSectionOutlineWidth,
                    )
                  : BorderSide.none,
            ),
          ),
        ),
      ),
    ),
  );
}
