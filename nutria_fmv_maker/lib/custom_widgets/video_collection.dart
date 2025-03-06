import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/providers/theme_provider.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import '../models/node_data.dart';
import '../providers/nodes_provider.dart';

class VideoCollection extends StatelessWidget {
  VideoCollection({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.dPanelPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: theme.dPanelPadding,
                right: theme.dPanelPadding -
                            UiStaticProperties.splitViewDragWidgetSize >=
                        0
                    ? theme.dPanelPadding -
                        UiStaticProperties.splitViewDragWidgetSize
                    : 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDropdown(
                  options: [
                    DropdownOption(
                        icon: Icons.camera_roll, text: 'Imported Videos'),
                    DropdownOption(icon: Icons.list_alt, text: 'Variables'),
                    DropdownOption(icon: Icons.tune, text: 'Project Settings'),
                    DropdownOption(icon: Icons.settings, text: 'Preferences'),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: theme.dPanelPadding,
          ),
          Expanded(
            child: RawScrollbar(
              controller: scrollController,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.right,
              radius: Radius.circular(theme.dButtonBorderRadius),
              thumbColor: theme.cButtonPressed,
              trackColor: theme.cButton,
              trackVisibility: true,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: theme.dPanelPadding),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.hardEdge,
                    controller: scrollController,
                    child: Wrap(
                        children: nodesProvider.videos
                            .map((video) =>
                                VideoCollectionEntry(videoDataId: video.id))
                            .toList()

                        // children: List.generate(
                        //   25,
                        //   (index) => const VideoCollectionEntry(),
                        // ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownOption {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  DropdownOption({
    required this.icon,
    required this.text,
    this.onTap,
  });
}

class CustomDropdown extends StatefulWidget {
  final List<DropdownOption> options;
  final int initialIndex;
  const CustomDropdown({
    Key? key,
    required this.options,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  late int selectedIndex;
  bool isExpanded = false;
  bool isBeingHovered = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The top (active) button.
    final activeOption = widget.options[selectedIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isBeingHovered = true),
          onExit: (_) => setState(() => isBeingHovered = false),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
                if (isExpanded) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              });
            },
            child: _DropdownItem(
              option: activeOption,
              isHovered: isBeingHovered || isExpanded,
              showArrow: true,
              isExpanded: isExpanded,
            ),
          ),
        ),
        // The expanded list slides down/up.
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.options
                .asMap()
                .entries
                .where((entry) => entry.key != selectedIndex)
                .map((entry) {
              int index = entry.key;
              DropdownOption option = entry.value;
              return _HoverableDropdownItem(
                option: option,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    isExpanded = false;
                    _controller.reverse();
                  });
                  // Trigger the option's callback if available.
                  option.onTap?.call();
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final DropdownOption option;
  final bool isHovered;
  final bool showArrow;
  final bool isExpanded;

  const _DropdownItem({
    Key? key,
    required this.option,
    required this.isHovered,
    this.showArrow = false,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isHovered ? Colors.grey[700] : Colors.grey[800];
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(option.icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              option.text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          if (showArrow)
            Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}

class _HoverableDropdownItem extends StatefulWidget {
  final DropdownOption option;
  final VoidCallback onTap;
  const _HoverableDropdownItem({
    Key? key,
    required this.option,
    required this.onTap,
  }) : super(key: key);

  @override
  _HoverableDropdownItemState createState() => _HoverableDropdownItemState();
}

class _HoverableDropdownItemState extends State<_HoverableDropdownItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: _DropdownItem(
          option: widget.option,
          isHovered: isHovered,
          showArrow: false,
        ),
      ),
    );
  }
}

// class MenuTab extends StatefulWidget {
//   final IconData? iconData;
//   final String tabName;
//   final bool isActive;
//   const MenuTab(
//       {super.key, required this.tabName, this.isActive = false, this.iconData});

//   @override
//   _MenuTabState createState() => _MenuTabState();
// }

// class _MenuTabState extends State<MenuTab> {
//   bool isBeingHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
//     return Expanded(
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         onEnter: (_) {
//           setState(() {
//             isBeingHovered = true;
//           });
//         },
//         onExit: (_) {
//           setState(() {
//             isBeingHovered = false;
//           });
//         },
//         child: Tooltip(
//           message: widget.tabName,
//           preferBelow: false,
//           child: Container(
//             decoration: BoxDecoration(
//               color: isBeingHovered ? theme.cButtonHovered : theme.cButton,
//               // borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
//               // border: Border.all(
//               // color: widget.isActive ? theme.cOutlines : Colors.transparent,
//               // width: 1,
//               // ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(theme.dPanelPadding),
//                   child: Icon(
//                     widget.iconData,
//                     color: widget.isActive ? theme.cText : theme.cTextInactive,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     widget.tabName,
//                     style: TextStyle(color: theme.cText),
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_drop_down,
//                   size: 30,
//                   color: isBeingHovered ? theme.cText : Colors.transparent,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

enum VideoFileState { none, hovered, selected, active }

class VideoCollectionEntry extends StatefulWidget {
  final String videoDataId;
  const VideoCollectionEntry({
    required this.videoDataId,
    super.key,
  });

  @override
  State<VideoCollectionEntry> createState() => _VideoCollectionEntryState();
}

class _VideoCollectionEntryState extends State<VideoCollectionEntry> {
  VideoFileState _videoFileState = VideoFileState.none;
  // Offset _dragPosition = Offset.zero;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    VideoData videoData = nodesProvider.getVideoDataById(widget.videoDataId);

    return Draggable<String>(
      data: widget.videoDataId,

      dragAnchorStrategy: (draggable, context, position) {
        return Offset(100 / 2, 100 * 9 / 16); //TODO move to uiStaticProperties
      },
      // feedbackOffset: _dragPosition,
// feedbackOffset: ,
      feedback: const IgnorePointer(
        child: SizedBox(
          height: 100 * 9 / 16, //TODO move to uiStaticProperties
          width: 100,
          child: Placeholder(),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _videoFileState = VideoFileState.hovered;
          });
        },
        onExit: (_) {
          setState(() {
            _videoFileState = VideoFileState.none;
          });
        },
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              _videoFileState = VideoFileState.active;
            });
          },
          onTapUp: (_) {
            setState(() {
              _videoFileState = VideoFileState.hovered;
            });
          },

          // onPanStart: (details) => (_dragPosition = details.localPosition),
          child: Container(
            decoration: BoxDecoration(
                color: _videoFileState == VideoFileState.hovered
                    ? theme.cButtonHovered
                    : _videoFileState == VideoFileState.selected
                        ? theme.cButton
                        : _videoFileState == VideoFileState.active
                            ? theme.cButtonPressed
                            : Colors.transparent,
                borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
                border: Border.all(
                  color: _videoFileState == VideoFileState.none
                      ? Colors.transparent
                      : theme.cOutlines,
                  width: 1,
                )),
            padding: EdgeInsets.all(theme.dPanelPadding),
            child: Column(
              children: [
                SizedBox(
                  height: 100 * 9 / 16, //TODO move to ui
                  width: 100,
                  child: ClipRect(
                    child: FittedBox(
                      // color: Colors.black,
                    
                      fit: BoxFit.cover,
                      child: videoData.thumbnailPath == null
                          ? Placeholder() //todo implement missing
                          : videoData.thumbnailPath!.startsWith('http')
                              ? Image.network(videoData.thumbnailPath!)
                              : Image.file(File(videoData.thumbnailPath!)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'filename a very long filename',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.cText),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
