import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

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

class NutriaMenuDropdown extends StatefulWidget {
  final List<DropdownOption> options;
  final int initialIndex;
  const NutriaMenuDropdown({
    Key? key,
    required this.options,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _NutriaMenuDropdownState createState() => _NutriaMenuDropdownState();
}

class _NutriaMenuDropdownState extends State<NutriaMenuDropdown>
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
      duration: const Duration(milliseconds: UiStaticProperties.animationDurationsInMs), //TODO UIStaticPorperties
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
    //TODO theme

    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    final backgroundColor = isHovered ? theme.cButtonHovered : theme.cButton;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(option.icon, color: theme.cTextActive),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              option.text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.cTextActive),
            ),
          ),
          if (showArrow)
            Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: theme.cTextActive,
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
