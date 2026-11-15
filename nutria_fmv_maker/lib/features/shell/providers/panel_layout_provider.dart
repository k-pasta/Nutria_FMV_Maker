// Widths of the left and right side panels around the canvas, and their
// open/closed state.
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'panel_layout_provider.freezed.dart';
part 'panel_layout_provider.g.dart';

enum PanelSide { left, right }

/// Tabs of the left panel.
enum LeftPanelSection { videos, projectSettings, preferences }

/// Width of one split-view drag handle.
const kPanelHandleWidth = 10.0;
const kMinLeftPanel = 200.0;
const kMaxLeftPanel = 700.0;
const kMinRightPanel = 200.0;
const kMaxRightPanel = double.infinity;

/// Dragging a panel this far below its minimum width closes it.
const kPanelCloseThreshold = 50.0;

@freezed
abstract class PanelLayout with _$PanelLayout {
  const PanelLayout._();

  const factory PanelLayout({
    @Default(300) double left,
    @Default(300) double right,

    /// Widths the user is dragging towards, before limits are applied.
    /// Remembered so a panel reopens at the size it had.
    @Default(300) double intendedLeft,
    @Default(300) double intendedRight,
    @Default(false) bool leftClosed,
    @Default(false) bool rightClosed,
    @Default(LeftPanelSection.videos) LeftPanelSection section,
  }) = _PanelLayout;

  /// Total width taken by the visible drag handles.
  double get handlesWidth =>
      kPanelHandleWidth * ((leftClosed ? 0 : 1) + (rightClosed ? 0 : 1));
}

/// Resizing rules: panels respect their min/max widths, push each other when
/// the window is too narrow, close when dragged well below their minimum, and
/// reopen when dragged back out.
@Riverpod(keepAlive: true)
class PanelLayoutNotifier extends _$PanelLayoutNotifier {
  @override
  PanelLayout build() => const PanelLayout();

  void showSection(LeftPanelSection section) =>
      state = state.copyWith(section: section);

  /// The handle next to [side] was dragged by [delta] pixels (positive to the
  /// right) in a window [totalWidth] wide.
  void drag(PanelSide side, double delta, double totalWidth) {
    var s = state;
    if (side == PanelSide.left) {
      s = s.copyWith(intendedLeft: s.intendedLeft + delta);
      final intended = s.intendedLeft;
      if (intended >= kMinLeftPanel && intended <= kMaxLeftPanel && !s.leftClosed) {
        if (intended + s.handlesWidth < totalWidth) s = s.copyWith(left: intended);
        if (intended + s.right + s.handlesWidth > totalWidth) {
          s = s.right - delta >= kMinRightPanel
              ? s.copyWith(right: s.right - delta)
              : _close(s, PanelSide.right);
          s = s.copyWith(intendedRight: s.right);
        }
      }
      if (intended <= kMinLeftPanel - kPanelCloseThreshold && !s.leftClosed) {
        s = _close(s, PanelSide.left);
      }
      if (intended > kMinLeftPanel - kPanelCloseThreshold && s.leftClosed) {
        s = _open(s, PanelSide.left, totalWidth, rememberSize: false);
      }
    } else {
      s = s.copyWith(intendedRight: s.intendedRight - delta);
      final intended = s.intendedRight;
      if (intended >= kMinRightPanel && intended <= kMaxRightPanel && !s.rightClosed) {
        if (intended + s.handlesWidth < totalWidth) s = s.copyWith(right: intended);
        if (intended + s.left + s.handlesWidth > totalWidth) {
          s = s.left + delta >= kMinLeftPanel
              ? s.copyWith(left: s.left + delta)
              : _close(s, PanelSide.left);
          s = s.copyWith(intendedLeft: s.left);
        }
      }
      if (intended <= kMinRightPanel - kPanelCloseThreshold && !s.rightClosed) {
        s = _close(s, PanelSide.right);
      }
      if (intended > kMinRightPanel - kPanelCloseThreshold && s.rightClosed) {
        s = _open(s, PanelSide.right, totalWidth, rememberSize: false);
      }
    }
    state = s;
  }

  /// Opens or closes the panel on [side].
  void toggle(PanelSide side, double totalWidth) {
    final closed = side == PanelSide.left ? state.leftClosed : state.rightClosed;
    state = closed ? _open(state, side, totalWidth) : _close(state, side);
  }

  /// The window got [dx] pixels narrower (negative: wider) and is now
  /// [totalWidth] wide. Shrinks the panels if they no longer fit.
  void windowResized(double dx, double totalWidth) {
    var s = state;
    if (totalWidth - (s.left + s.right + s.handlesWidth) >= 0 || dx <= 0) return;
    if (!s.leftClosed && !s.rightClosed) {
      s = s.copyWith(left: s.left - dx / 2, right: s.right - dx / 2);
    } else if (!s.leftClosed) {
      s = s.copyWith(left: s.left - dx);
    } else if (!s.rightClosed) {
      s = s.copyWith(right: s.right - dx);
    }
    if (s.left < kMinLeftPanel && !s.leftClosed) s = _close(s, PanelSide.left);
    if (s.right < kMinRightPanel && !s.rightClosed) s = _close(s, PanelSide.right);
    state = s.copyWith(intendedLeft: s.left, intendedRight: s.right);
  }

  PanelLayout _close(PanelLayout s, PanelSide side) => side == PanelSide.left
      ? s.copyWith(leftClosed: true, left: 0)
      : s.copyWith(rightClosed: true, right: 0);

  /// Opens [side] at its remembered size if it fits, otherwise squeezes the
  /// other panel, otherwise closes the other panel, otherwise stays closed.
  PanelLayout _open(PanelLayout s, PanelSide side, double totalWidth,
      {bool rememberSize = true}) {
    final isLeft = side == PanelSide.left;
    // Mark open first so handlesWidth counts this panel's handle.
    s = isLeft ? s.copyWith(leftClosed: false) : s.copyWith(rightClosed: false);
    final minThis = isLeft ? kMinLeftPanel : kMinRightPanel;
    final minOther = isLeft ? kMinRightPanel : kMinLeftPanel;
    final wanted = max(isLeft ? s.intendedLeft : s.intendedRight, minThis);
    final other = isLeft ? s.right : s.left;
    final handles = s.handlesWidth;

    PanelLayout withSizes(double mine, double theirs) => isLeft
        ? s.copyWith(left: mine, right: theirs)
        : s.copyWith(right: mine, left: theirs);

    if (wanted + other + handles < totalWidth) {
      s = withSizes(wanted, other);
    } else if (minThis + minOther + handles < totalWidth) {
      final mine = max(totalWidth - (other + handles), minThis);
      s = withSizes(mine, totalWidth - (mine + handles));
      s = isLeft
          ? s.copyWith(intendedRight: s.right)
          : s.copyWith(intendedLeft: s.left);
    } else if (minThis + handles < totalWidth) {
      final mine = min(wanted, totalWidth - handles);
      s = _close(withSizes(mine, other), isLeft ? PanelSide.right : PanelSide.left);
    } else {
      return isLeft ? s.copyWith(leftClosed: true) : s.copyWith(rightClosed: true);
    }
    if (!rememberSize) return s;
    return isLeft ? s.copyWith(intendedLeft: s.left) : s.copyWith(intendedRight: s.right);
  }
}
