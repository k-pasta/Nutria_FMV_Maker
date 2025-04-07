import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/providers/project_version_provider.dart';
import 'package:nutria_fmv_maker/static_data/data_static_properties.dart';
import 'package:provider/provider.dart';

import '../grid_canvas.dart';
import '../providers/notifications_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/ui_state_provider.dart';
import '../video_player_section.dart';
import 'app_info_window.dart';
import 'modal.dart';
import 'nutria_menu_bar.dart';
import 'nutria_split_view.dart';
import 'nutria_text.dart';
import 'left_section.dart';

class WindowsAppLayout extends StatelessWidget {
  const WindowsAppLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Column(
      children: [
        const NutriaMenuBar(),
        Expanded(
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: Focus(
              autofocus: true,
              onFocusChange: (gotFocus) {
                if (gotFocus) {
                  print('got focus');
                } else {
                  print('lost focus');
                }
              },
              parentNode: context.read<UiStateProvider>().parentfocusNode,
              child: Stack(
                children: [
                  const GridCanvas(),
                  NutriaSplitView(
                    rightChild: VideoPlayerSection(),
                    leftChild: LeftSection(),
                  ),
                  Positioned.fill(
                    //UI fader
                    child: Selector<UiStateProvider, bool>(
                      selector: (context, uiStateProvider) =>
                          uiStateProvider.isModalOrMenuOpen,
                      builder: (context, isModalOrMenuOpen, child) {
                        if (isModalOrMenuOpen) {
                          return GestureDetector(
                            onTap: () {
                              context.read<UiStateProvider>().isModalInfoOpen =
                                  false;
                            },
                            child: Container(
                              color: Colors.black45, //TODO de-hardcode
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  //Logo under
                  Positioned(
                    top: -theme.dMenuBarHeight + theme.dLogoPadding,
                    left: theme.dLogoPadding,
                    child: SvgPicture.asset(
                      'assets/icons/nutria_logo_top.svg',
                      width: 100,
                      height: (theme.dMenuBarHeight - theme.dLogoPadding) * 2,
                      colorFilter: ColorFilter.mode(theme.cAccentButton,
                          BlendMode.srcIn), // Optional color change
                    ),
                  ),
                  Selector<UiStateProvider, bool>(
                    selector: (context, uiStateProvider) =>
                        uiStateProvider.isModalInfoOpen,
                    builder: (context, isModalInfoOpen, child) {
                      if (isModalInfoOpen) {
                        return Modal(child: AppInfoWindow());
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // TODO enable after mvp for tooltips
        Container(
          height: 25, //TODO de-hardcode
          decoration: BoxDecoration(
              color: theme.cPanel,
              border: Border(
                top: BorderSide(
                  width: theme.dSectionOutlineWidth,
                  color: theme.cOutlines,
                ),
              )),
          child: Stack(
            children: [
              // Bottom layer: Left-aligned widget (truncates if needed)
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(child: BarFileName()),
                  ],
                ),
              ),
              // Top layer: Right-aligned widget (also truncates if needed, renders over the other)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Selector<NotificationProvider, String?>(
                        selector: (_, provider) => provider.currentNotification,
                        builder: (_, notification, __) {
                          if (notification == null)
                            return const SizedBox.shrink();
                          return BarNotification(text: notification);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BarFileName extends StatelessWidget {
  const BarFileName({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 3, horizontal: theme.dSectionPadding),
      child: Selector<ProjectVersionProvider, String>(
        selector: (_, provider) => provider.currentFileName,
        builder: (_, currentFileName, __) {
          return NutriaText(text: currentFileName);
        },
      ),
    );
  }
}

class BarNotification extends StatefulWidget {
  const BarNotification({super.key, required this.text});

  final String text;

  @override
  _BarNotificationState createState() => _BarNotificationState();
}

class _BarNotificationState extends State<BarNotification> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    // Remain fully visible for 1.8 seconds, then fade out over 200ms.
    Future.delayed(
        const Duration(
            milliseconds: DataStaticProperties.notificationTimeInMs -
                DataStaticProperties.baseAnimationTimeInMs), () {
      if (mounted) {
        setState(() {
          opacity = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return AnimatedOpacity(
      duration: const Duration(
          milliseconds: DataStaticProperties.baseAnimationTimeInMs),
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cAccentButton.withOpacity(1),
          borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 3,
            horizontal: theme.dSectionPadding,
          ),
          child: NutriaText(text: widget.text),
        ),
      ),
    );
  }
}
