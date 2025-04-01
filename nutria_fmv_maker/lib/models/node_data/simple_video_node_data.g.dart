// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_video_node_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleVideoNodeData _$SimpleVideoNodeDataFromJson(Map<String, dynamic> json) =>
    SimpleVideoNodeData(
      position: const OffsetConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      intendedPosition: _$JsonConverterFromJson<Map<String, dynamic>, Offset>(
          json['intendedPosition'], const OffsetConverter().fromJson),
      id: json['id'] as String,
      videoDataId: json['videoDataId'] as String?,
      overrides: json['overrides'] == null
          ? const <String, dynamic>{}
          : const OverridesConverter()
              .fromJson(json['overrides'] as Map<String, dynamic>),
      outputs: (json['outputs'] as List<dynamic>?)
              ?.map((e) => Output.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [Output()],
      input: json['input'] == null
          ? const Input()
          : Input.fromJson(json['input'] as Map<String, dynamic>),
      nodeName: json['nodeName'] as String?,
      isExpanded: json['isExpanded'] as bool? ?? false,
      nodeWidth: (json['nodeWidth'] as num?)?.toDouble() ??
          UiStaticProperties.nodeDefaultWidth,
      intendedNodeWidth: (json['intendedNodeWidth'] as num?)?.toDouble(),
      swatch: (json['swatch'] as num?)?.toInt() ?? 0,
      isSelected: json['isSelected'] as bool? ?? false,
      isBeingHovered: json['isBeingHovered'] as bool? ?? false,
    );

Map<String, dynamic> _$SimpleVideoNodeDataToJson(
        SimpleVideoNodeData instance) =>
    <String, dynamic>{
      'position': const OffsetConverter().toJson(instance.position),
      'id': instance.id,
      'intendedPosition':
          const OffsetConverter().toJson(instance.intendedPosition),
      'isSelected': instance.isSelected,
      'isBeingHovered': instance.isBeingHovered,
      'nodeName': instance.nodeName,
      'nodeWidth': instance.nodeWidth,
      'intendedNodeWidth': instance.intendedNodeWidth,
      'isExpanded': instance.isExpanded,
      'input': instance.input,
      'swatch': instance.swatch,
      'videoDataId': instance.videoDataId,
      'overrides': const OverridesConverter().toJson(instance.overrides),
      'outputs': instance.outputs,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
