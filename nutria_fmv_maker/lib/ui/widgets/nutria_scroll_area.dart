// A vertically scrolling panel area with an always-visible themed scrollbar.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// A vertical scroll view with an always-visible themed scrollbar.
class NutriaScrollArea extends StatefulWidget {
  const NutriaScrollArea({super.key, required this.child, this.padding});

  final Widget child;

  /// Around [child], inside the scrolling area.
  final EdgeInsets? padding;

  @override
  State<NutriaScrollArea> createState() => _NutriaScrollAreaState();
}

class _NutriaScrollAreaState extends State<NutriaScrollArea> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return RawScrollbar(
      controller: _controller,
      thumbVisibility: true,
      trackVisibility: true,
      thickness: theme.dScrollbarWidth,
      radius: Radius.circular(theme.dButtonBorderRadius),
      thumbColor: theme.cButtonPressed,
      trackColor: theme.cButton,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          controller: _controller,
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }
}
