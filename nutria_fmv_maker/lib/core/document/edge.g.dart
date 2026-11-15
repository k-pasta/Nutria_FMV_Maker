// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortRef _$PortRefFromJson(Map<String, dynamic> json) =>
    _PortRef(nodeId: json['nodeId'] as String, port: json['port'] as String);

Map<String, dynamic> _$PortRefToJson(_PortRef instance) => <String, dynamic>{
  'nodeId': instance.nodeId,
  'port': instance.port,
};

_Edge _$EdgeFromJson(Map<String, dynamic> json) => _Edge(
  from: PortRef.fromJson(json['from'] as Map<String, dynamic>),
  to: PortRef.fromJson(json['to'] as Map<String, dynamic>),
  kind: $enumDecodeNullable(_$EdgeKindEnumMap, json['kind']) ?? EdgeKind.flow,
);

Map<String, dynamic> _$EdgeToJson(_Edge instance) => <String, dynamic>{
  'from': instance.from.toJson(),
  'to': instance.to.toJson(),
  'kind': _$EdgeKindEnumMap[instance.kind]!,
};

const _$EdgeKindEnumMap = {EdgeKind.flow: 'flow', EdgeKind.value: 'value'};
