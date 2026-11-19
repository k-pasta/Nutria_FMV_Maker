// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Choice _$ChoiceFromJson(Map<String, dynamic> json) =>
    _Choice(id: json['id'] as String, text: json['text'] as String? ?? '');

Map<String, dynamic> _$ChoiceToJson(_Choice instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
};

_LogicCondition _$LogicConditionFromJson(Map<String, dynamic> json) =>
    _LogicCondition(
      id: json['id'] as String,
      variableId: json['variableId'] as String?,
      comparison:
          $enumDecodeNullable(_$FmvComparisonEnumMap, json['comparison']) ??
          FmvComparison.equal,
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$LogicConditionToJson(_LogicCondition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variableId': instance.variableId,
      'comparison': _$FmvComparisonEnumMap[instance.comparison]!,
      'value': instance.value,
    };

const _$FmvComparisonEnumMap = {
  FmvComparison.less: 'less',
  FmvComparison.lessOrEqual: 'lessOrEqual',
  FmvComparison.greater: 'greater',
  FmvComparison.greaterOrEqual: 'greaterOrEqual',
  FmvComparison.equal: 'equal',
  FmvComparison.notEqual: 'notEqual',
};

OriginNode _$OriginNodeFromJson(Map<String, dynamic> json) => OriginNode(
  id: json['id'] as String,
  position: Position.fromJson(json['position'] as Map<String, dynamic>),
  width: (json['width'] as num?)?.toDouble() ?? kDefaultNodeWidth,
  name: json['name'] as String?,
  swatch: (json['swatch'] as num?)?.toInt() ?? 1,
  isExpanded: json['isExpanded'] as bool? ?? false,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$OriginNodeToJson(OriginNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position.toJson(),
      'width': instance.width,
      'name': instance.name,
      'swatch': instance.swatch,
      'isExpanded': instance.isExpanded,
      'type': instance.$type,
    };

SimpleVideoNode _$SimpleVideoNodeFromJson(Map<String, dynamic> json) =>
    SimpleVideoNode(
      id: json['id'] as String,
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      width: (json['width'] as num?)?.toDouble() ?? kDefaultNodeWidth,
      name: json['name'] as String?,
      swatch: (json['swatch'] as num?)?.toInt() ?? 0,
      isExpanded: json['isExpanded'] as bool? ?? false,
      videoId: json['videoId'] as String?,
      overrides: json['overrides'] == null
          ? const VideoSettingsOverride()
          : VideoSettingsOverride.fromJson(
              json['overrides'] as Map<String, dynamic>,
            ),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$SimpleVideoNodeToJson(SimpleVideoNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position.toJson(),
      'width': instance.width,
      'name': instance.name,
      'swatch': instance.swatch,
      'isExpanded': instance.isExpanded,
      'videoId': instance.videoId,
      'overrides': instance.overrides.toJson(),
      'type': instance.$type,
    };

BranchedVideoNode _$BranchedVideoNodeFromJson(Map<String, dynamic> json) =>
    BranchedVideoNode(
      id: json['id'] as String,
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      width: (json['width'] as num?)?.toDouble() ?? kDefaultNodeWidth,
      name: json['name'] as String?,
      swatch: (json['swatch'] as num?)?.toInt() ?? 0,
      isExpanded: json['isExpanded'] as bool? ?? false,
      videoId: json['videoId'] as String?,
      overrides: json['overrides'] == null
          ? const VideoSettingsOverride()
          : VideoSettingsOverride.fromJson(
              json['overrides'] as Map<String, dynamic>,
            ),
      choices:
          (json['choices'] as List<dynamic>?)
              ?.map((e) => Choice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Choice>[],
      question: json['question'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$BranchedVideoNodeToJson(BranchedVideoNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position.toJson(),
      'width': instance.width,
      'name': instance.name,
      'swatch': instance.swatch,
      'isExpanded': instance.isExpanded,
      'videoId': instance.videoId,
      'overrides': instance.overrides.toJson(),
      'choices': instance.choices.map((e) => e.toJson()).toList(),
      'question': instance.question,
      'type': instance.$type,
    };

CommentNode _$CommentNodeFromJson(Map<String, dynamic> json) => CommentNode(
  id: json['id'] as String,
  position: Position.fromJson(json['position'] as Map<String, dynamic>),
  width: (json['width'] as num?)?.toDouble() ?? kDefaultNodeWidth,
  name: json['name'] as String?,
  swatch: (json['swatch'] as num?)?.toInt() ?? 0,
  isExpanded: json['isExpanded'] as bool? ?? false,
  text: json['text'] as String? ?? '',
  attachedTo: json['attachedTo'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$CommentNodeToJson(CommentNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position.toJson(),
      'width': instance.width,
      'name': instance.name,
      'swatch': instance.swatch,
      'isExpanded': instance.isExpanded,
      'text': instance.text,
      'attachedTo': instance.attachedTo,
      'type': instance.$type,
    };

ChangeVariableNode _$ChangeVariableNodeFromJson(Map<String, dynamic> json) =>
    ChangeVariableNode(
      id: json['id'] as String,
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      width: (json['width'] as num?)?.toDouble() ?? kDefaultNodeWidth,
      name: json['name'] as String?,
      swatch: (json['swatch'] as num?)?.toInt() ?? kLogicNodeSwatch,
      isExpanded: json['isExpanded'] as bool? ?? false,
      variableId: json['variableId'] as String?,
      operation:
          $enumDecodeNullable(_$FmvChangeOperationEnumMap, json['operation']) ??
          FmvChangeOperation.set,
      value: json['value'] as String? ?? '',
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ChangeVariableNodeToJson(ChangeVariableNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position.toJson(),
      'width': instance.width,
      'name': instance.name,
      'swatch': instance.swatch,
      'isExpanded': instance.isExpanded,
      'variableId': instance.variableId,
      'operation': _$FmvChangeOperationEnumMap[instance.operation]!,
      'value': instance.value,
      'type': instance.$type,
    };

const _$FmvChangeOperationEnumMap = {
  FmvChangeOperation.set: 'set',
  FmvChangeOperation.add: 'add',
  FmvChangeOperation.subtract: 'subtract',
  FmvChangeOperation.multiply: 'multiply',
  FmvChangeOperation.divide: 'divide',
  FmvChangeOperation.power: 'power',
  FmvChangeOperation.absolute: 'absolute',
  FmvChangeOperation.toggle: 'toggle',
  FmvChangeOperation.and: 'and',
  FmvChangeOperation.or: 'or',
  FmvChangeOperation.xor: 'xor',
};

CompareNode _$CompareNodeFromJson(Map<String, dynamic> json) => CompareNode(
  id: json['id'] as String,
  position: Position.fromJson(json['position'] as Map<String, dynamic>),
  width: (json['width'] as num?)?.toDouble() ?? kDefaultNodeWidth,
  name: json['name'] as String?,
  swatch: (json['swatch'] as num?)?.toInt() ?? kLogicNodeSwatch,
  isExpanded: json['isExpanded'] as bool? ?? false,
  conditions:
      (json['conditions'] as List<dynamic>?)
          ?.map((e) => LogicCondition.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LogicCondition>[],
  matchAny: json['matchAny'] as bool? ?? false,
  expression: json['expression'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$CompareNodeToJson(CompareNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position.toJson(),
      'width': instance.width,
      'name': instance.name,
      'swatch': instance.swatch,
      'isExpanded': instance.isExpanded,
      'conditions': instance.conditions.map((e) => e.toJson()).toList(),
      'matchAny': instance.matchAny,
      'expression': instance.expression,
      'type': instance.$type,
    };
