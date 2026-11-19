// The node types of the story graph (saved data only, no editor state).
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

part 'node.freezed.dart';
part 'node.g.dart';

/// Default width of a node on the canvas.
const double kDefaultNodeWidth = 230;

/// Narrowest a node can be resized to.
const double kMinNodeWidth = 160;

/// Widest a node can be resized to.
const double kMaxNodeWidth = 400;

/// Most choices a branched video node can have (a Player limit).
const int kMaxChoices = 10;

/// Fewest choice slots a branched video node keeps, even when empty.
const int kMinChoices = 2;

/// One answer the viewer can pick on a [BranchedVideoNode].
///
/// [id] is stable for the choice's lifetime and doubles as the key of its
/// output port, so edges survive reordering and text edits.
@freezed
abstract class Choice with _$Choice {
  const factory Choice({required String id, @Default('') String text}) =
      _Choice;

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
}

/// The swatch new logic nodes get: the last color.
const int kLogicNodeSwatch = 5;

/// One test of a [CompareNode]: variable [variableId] [comparison] [value]
/// (an expression).
@freezed
abstract class LogicCondition with _$LogicCondition {
  const factory LogicCondition({
    required String id,
    String? variableId,
    @Default(FmvComparison.equal) FmvComparison comparison,
    @Default('') String value,
  }) = _LogicCondition;

  factory LogicCondition.fromJson(Map<String, dynamic> json) =>
      _$LogicConditionFromJson(json);
}

/// A node in the story graph.
///
/// Only data that belongs in the saved project lives here. Selection, hover,
/// drag state and layout geometry belong to the editor (`features/`).
///
/// Fields shared by every variant (id, position, width, name, swatch,
/// isExpanded) can be read and `copyWith`-ed on [Node] directly.
@Freezed(unionKey: 'type')
sealed class Node with _$Node {
  const Node._();

  /// The fixed start of the story. Exactly one exists and it can't be deleted.
  @FreezedUnionValue('origin')
  const factory Node.origin({
    required String id,
    required Position position,
    @Default(kDefaultNodeWidth) double width,
    String? name,
    @Default(1) int swatch,
    @Default(false) bool isExpanded,
  }) = OriginNode;

  /// Plays a video, then continues to a single next node.
  @FreezedUnionValue('simpleVideo')
  const factory Node.simpleVideo({
    required String id,
    required Position position,
    @Default(kDefaultNodeWidth) double width,
    String? name,
    @Default(0) int swatch,
    @Default(false) bool isExpanded,
    String? videoId,
    @Default(VideoSettingsOverride()) VideoSettingsOverride overrides,
  }) = SimpleVideoNode;

  /// Plays a video, then lets the viewer pick one of [choices].
  @FreezedUnionValue('branchedVideo')
  const factory Node.branchedVideo({
    required String id,
    required Position position,
    @Default(kDefaultNodeWidth) double width,
    String? name,
    @Default(0) int swatch,
    @Default(false) bool isExpanded,
    String? videoId,
    @Default(VideoSettingsOverride()) VideoSettingsOverride overrides,
    @Default(<Choice>[]) List<Choice> choices,

    /// A question shown above the choices, with no output of its own;
    /// `null` when the node has none (the "Question" setting is off).
    String? question,
  }) = BranchedVideoNode;

  /// A note for the author: text only, never exported. It stands on the
  /// canvas or, with [attachedTo], sits on top of that node, follows it and
  /// takes its width (then its own position and width are not used).
  @FreezedUnionValue('comment')
  const factory Node.comment({
    required String id,
    required Position position,
    @Default(kDefaultNodeWidth) double width,
    String? name,
    @Default(0) int swatch,
    @Default(false) bool isExpanded,

    /// The text, with `**bold**` and `*italic*`.
    @Default('') String text,

    /// The node it is attached to, if any. A node has at most one.
    String? attachedTo,
  }) = CommentNode;

  /// Changes a variable ([operation] with [value], an expression), then
  /// continues to a single next node.
  @FreezedUnionValue('changeVariable')
  const factory Node.changeVariable({
    required String id,
    required Position position,
    @Default(kDefaultNodeWidth) double width,
    String? name,
    @Default(kLogicNodeSwatch) int swatch,
    @Default(false) bool isExpanded,
    String? variableId,
    @Default(FmvChangeOperation.set) FmvChangeOperation operation,
    @Default('') String value,
  }) = ChangeVariableNode;

  /// Tests [conditions] (all, or any with [matchAny]) or, when not `null`,
  /// [expression], and continues to its "true" or "false" output.
  @FreezedUnionValue('compare')
  const factory Node.compare({
    required String id,
    required Position position,
    @Default(kDefaultNodeWidth) double width,
    String? name,
    @Default(kLogicNodeSwatch) int swatch,
    @Default(false) bool isExpanded,
    @Default(<LogicCondition>[]) List<LogicCondition> conditions,
    @Default(false) bool matchAny,
    String? expression,
  }) = CompareNode;

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);

  /// The video this node plays, or `null` for non-video nodes / no video yet.
  String? get videoIdOrNull => switch (this) {
    SimpleVideoNode(:final videoId) => videoId,
    BranchedVideoNode(:final videoId) => videoId,
    _ => null,
  };

  /// This node's setting overrides, or `null` for non-video nodes.
  VideoSettingsOverride? get overridesOrNull => switch (this) {
    SimpleVideoNode(:final overrides) => overrides,
    BranchedVideoNode(:final overrides) => overrides,
    _ => null,
  };

  /// Whether this node changes or tests variables.
  bool get isLogicNode => this is ChangeVariableNode || this is CompareNode;

  /// Whether this node plays a video (and so has video settings).
  bool get isVideoNode => this is SimpleVideoNode || this is BranchedVideoNode;
}
