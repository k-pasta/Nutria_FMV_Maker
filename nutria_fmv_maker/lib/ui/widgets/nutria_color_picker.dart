// A full color picker: saturation/brightness square, hue strip and a hex
// field, for any color the palette doesn't have.
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

/// [argb] as six hex digits (no alpha), e.g. "FF4E6A".
String colorHex(int argb) =>
    (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

/// Six hex digits (an optional leading # allowed) as an opaque ARGB color,
/// or `null`.
int? parseColorHex(String text) {
  final digits = text.trim().replaceFirst('#', '');
  if (digits.length != 6) return null;
  final value = int.tryParse(digits, radix: 16);
  return value == null ? null : 0xFF000000 | value;
}

/// Picks an opaque color. Dragging calls [onChangeStart], [onChanged] for
/// every move, then [onChangeEnd], so a drag can be one undo step; typing
/// a hex code calls [onChanged] once it's complete.
class NutriaColorPicker extends StatefulWidget {
  const NutriaColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  /// ARGB.
  final int color;
  final ValueChanged<int> onChanged;
  final VoidCallback? onChangeStart;
  final VoidCallback? onChangeEnd;

  @override
  State<NutriaColorPicker> createState() => _NutriaColorPickerState();
}

class _NutriaColorPickerState extends State<NutriaColorPicker> {
  /// Kept while dragging, so a gray (no hue) doesn't lose the hue.
  late HSVColor _hsv = HSVColor.fromColor(Color(widget.color));

  @override
  void didUpdateWidget(NutriaColorPicker old) {
    super.didUpdateWidget(old);
    if (widget.color != _hsv.toColor().toARGB32()) {
      final next = HSVColor.fromColor(Color(widget.color));
      // Grays and black have no hue of their own: keep the one shown.
      _hsv = next.saturation == 0 || next.value == 0
          ? next.withHue(_hsv.hue)
          : next;
    }
  }

  void _set(HSVColor hsv) {
    setState(() => _hsv = hsv);
    widget.onChanged(hsv.toColor().toARGB32());
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final radius = BorderRadius.circular(theme.dButtonBorderRadius);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: theme.dButtonHeight * 3.5,
          child: _DragArea(
            onStart: widget.onChangeStart,
            onEnd: widget.onChangeEnd,
            onAt: (dx, dy) => _set(_hsv.withSaturation(dx).withValue(1 - dy)),
            child: ClipRRect(
              borderRadius: radius,
              child: CustomPaint(
                painter: _SaturationValuePainter(_hsv, theme.cOutlines),
              ),
            ),
          ),
        ),
        SizedBox(height: theme.dPanelPadding),
        SizedBox(
          height: theme.dButtonHeight * 0.5,
          child: _DragArea(
            onStart: widget.onChangeStart,
            onEnd: widget.onChangeEnd,
            onAt: (dx, _) => _set(_hsv.withHue(dx * 360)),
            child: ClipRRect(
              borderRadius: radius,
              child: CustomPaint(painter: _HuePainter(_hsv.hue)),
            ),
          ),
        ),
        SizedBox(height: theme.dPanelPadding),
        NutriaTextField(
          key: ValueKey(widget.color),
          text: '#${colorHex(widget.color)}',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[#0-9a-fA-F]')),
            LengthLimitingTextInputFormatter(7),
          ],
          onChanged: (text) {
            final color = parseColorHex(text);
            if (color != null) widget.onChanged(color);
          },
        ),
      ],
    );
  }
}

/// Reports where it is pressed and dragged, as fractions (0 to 1) of its
/// size.
class _DragArea extends StatelessWidget {
  const _DragArea({
    required this.onAt,
    required this.child,
    this.onStart,
    this.onEnd,
  });

  final void Function(double dx, double dy) onAt;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      void at(Offset local) => onAt(
        (local.dx / constraints.maxWidth).clamp(0, 1),
        (local.dy / constraints.maxHeight).clamp(0, 1),
      );
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (d) {
          onStart?.call();
          at(d.localPosition);
        },
        onPanUpdate: (d) => at(d.localPosition),
        onPanEnd: (_) => onEnd?.call(),
        onPanCancel: onEnd,
        onTapUp: (d) {
          onStart?.call();
          at(d.localPosition);
          onEnd?.call();
        },
        child: SizedBox.expand(child: child),
      );
    },
  );
}

/// Saturation left to right, brightness top to bottom, for one hue, with a
/// ring at the current color.
class _SaturationValuePainter extends CustomPainter {
  _SaturationValuePainter(this.hsv, this.ring);

  final HSVColor hsv;
  final Color ring;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final pure = HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor();
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFFFFFFFF), pure],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00000000), Color(0xFF000000)],
        ).createShader(rect),
    );
    final at = Offset(
      hsv.saturation * size.width,
      (1 - hsv.value) * size.height,
    );
    canvas.drawCircle(
      at,
      6,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = hsv.value > 0.5 ? const Color(0xFF000000) : ring,
    );
    canvas.drawCircle(
      at,
      7.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFFFFFFFF),
    );
  }

  @override
  bool shouldRepaint(_SaturationValuePainter old) => old.hsv != hsv;
}

/// Every hue, left to right, with a mark at the current one.
class _HuePainter extends CustomPainter {
  _HuePainter(this.hue);

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            for (var h = 0; h <= 360; h += 60)
              HSVColor.fromAHSV(1, h.toDouble(), 1, 1).toColor(),
          ],
        ).createShader(rect),
    );
    final x = hue / 360 * size.width;
    canvas.drawRect(
      Rect.fromLTWH(x - 2, 0, 4, size.height),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFFFFFFFF),
    );
  }

  @override
  bool shouldRepaint(_HuePainter old) => old.hue != hue;
}
