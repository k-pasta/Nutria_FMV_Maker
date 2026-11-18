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
