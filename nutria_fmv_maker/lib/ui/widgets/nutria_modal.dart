// Centered dialog panel with a close button.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';

/// A centered, scrollable panel. The caller shows/hides it and dims what's
/// behind it.
class NutriaModal extends StatelessWidget {
  const NutriaModal({super.key, required this.onClose, required this.child});

  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kModalMaxWidth),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.cPanel,
                  borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                  boxShadow: theme.cardShadow(lifted: true),
                ),
                padding: EdgeInsets.all(theme.dSectionPadding * 3),
                child: child,
              ),
              Positioned(
                right: theme.dSectionPadding * 2,
                top: theme.dSectionPadding * 2,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Icon(
                      Icons.close,
                      color: theme.cTextInactive,
                      size: theme.dButtonHeight / 1.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
