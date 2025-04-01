// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'origin_node_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OriginNodeData _$OriginNodeDataFromJson(Map<String, dynamic> json) =>
    OriginNodeData(
      position: const OffsetConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      intendedPosition: _$JsonConverterFromJson<Map<String, dynamic>, Offset>(
          json['intendedPosition'], const OffsetConverter().fromJson),
      id: json['id'] as String,
      outputs: (json['outputs'] as List<dynamic>?)
              ?.map((e) => Output.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [Output()],
      nodeName: json['nodeName'] as String?,
      isExpanded: json['isExpanded'] as bool? ?? false,
      nodeWidth: (json['nodeWidth'] as num?)?.toDouble() ??
          UiStaticProperties.nodeDefaultWidth,
      intendedNodeWidth: (json['intendedNodeWidth'] as num?)?.toDouble(),
      swatch: (json['swatch'] as num?)?.toInt() ?? 0,
      isSelected: json['isSelected'] as bool? ?? false,
      isBeingHovered: json['isBeingHovered'] as bool? ?? false,
    );

Map<String, dynamic> _$OriginNodeDataToJson(OriginNodeData instance) =>
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
      'outputs': instance.outputs,
      'swatch': instance.swatch,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
