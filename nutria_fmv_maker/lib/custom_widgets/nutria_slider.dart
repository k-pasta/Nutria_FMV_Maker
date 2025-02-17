import 'package:flutter/material.dart';

class NutriaSlider extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  const NutriaSlider({
    Key? key,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  _NutriaSliderState createState() => _NutriaSliderState();
}

class _NutriaSliderState extends State<NutriaSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  void _updateValue(Offset localPosition, double width) {
    double newValue =
        (localPosition.dx / width) * (widget.max - widget.min) + widget.min;
    newValue = newValue.clamp(widget.min, widget.max);
    setState(() {
      _currentValue = newValue;
    });
    widget.onChanged(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // // Ensure that constraints are valid (non-zero width).
        // if (constraints.maxWidth <= 0) {
        //   return SizedBox.shrink(); // Prevent errors if width is invalid.
        // }

        double sliderWidth = constraints.maxWidth;
        double fillPercentage =
            (_currentValue - widget.min) / (widget.max - widget.min);

        return GestureDetector(
          onPanUpdate: (details) {
            widget.onChanged(_currentValue);
            _updateValue(details.localPosition, sliderWidth);
          },
          onPanEnd: (_) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(_currentValue);
            }
          },
          onTapDown: (details) {
            // Update the slider value when the user taps on the track
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(_currentValue);
            }
            _updateValue(details.localPosition, sliderWidth);
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: sliderWidth * fillPercentage,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
