import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Stack2 extends Stack {
  const Stack2({
    super.key,
    alignment = AlignmentDirectional.topStart,
    textDirection,
    fit = StackFit.loose,
    clipBehavior = Clip.hardEdge,
    super.children,
  }) : super(
            alignment: alignment,
            textDirection: textDirection,
            fit: fit,
            clipBehavior: clipBehavior);

  @override
  RenderStack createRenderObject(BuildContext context) {
    // assert(_debugCheckHasDirectionality(context)); does nothing if assers are disabled. had to reimplement elsewise
    return RenderStack2(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }
}

class RenderStack2 extends RenderStack {
  RenderStack2({
    super.children,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
  });
}

/*
class Stack extends MultiChildRenderObjectWidget {
  /// Creates a stack layout widget.
  ///
  /// By default, the non-positioned children of the stack are aligned by their
  /// top left corners.
  const Stack({
    super.key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    super.children,
  });

  /// How to align the non-positioned and partially-positioned children in the
  /// stack.
  ///
  /// The non-positioned children are placed relative to each other such that
  /// the points determined by [alignment] are co-located. For example, if the
  /// [alignment] is [Alignment.topLeft], then the top left corner of
  /// each non-positioned child will be located at the same global coordinate.
  ///
  /// Partially-positioned children, those that do not specify an alignment in a
  /// particular axis (e.g. that have neither `top` nor `bottom` set), use the
  /// alignment to determine how they should be positioned in that
  /// under-specified axis.
  ///
  /// Defaults to [AlignmentDirectional.topStart].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// The text direction with which to resolve [alignment].
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection? textDirection;

  /// How to size the non-positioned children in the stack.
  ///
  /// The constraints passed into the [Stack] from its parent are either
  /// loosened ([StackFit.loose]) or tightened to their biggest size
  /// ([StackFit.expand]).
  final StackFit fit;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Stacks only clip children whose _geometry_ overflows the stack. A child
  /// that paints outside its bounds (e.g. a box with a shadow) will not be
  /// clipped, regardless of the value of this property. Similarly, a child that
  /// itself has a descendant that overflows the stack will not be clipped, as
  /// only the geometry of the stack's direct children are considered.
  /// [Transform] is an example of a widget that can cause its children to paint
  /// outside its geometry.
  ///
  /// To clip children whose geometry does not overflow the stack, consider
  /// using a [ClipRect] widget.
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  bool _debugCheckHasDirectionality(BuildContext context) {
    if (alignment is AlignmentDirectional && textDirection == null) {
      assert(debugCheckHasDirectionality(
        context,
        why: "to resolve the 'alignment' argument",
        hint: alignment == AlignmentDirectional.topStart ? "The default value for 'alignment' is AlignmentDirectional.topStart, which requires a text direction." : null,
        alternative: "Instead of providing a Directionality widget, another solution would be passing a non-directional 'alignment', or an explicit 'textDirection', to the $runtimeType.",
      ));
    }
    return true;
  }

  

  @override
  void updateRenderObject(BuildContext context, RenderStack renderObject) {
    assert(_debugCheckHasDirectionality(context));
    renderObject
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.maybeOf(context)
      ..fit = fit
      ..clipBehavior = clipBehavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
    properties.add(EnumProperty<StackFit>('fit', fit));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior, defaultValue: Clip.hardEdge));
  }
}
*/