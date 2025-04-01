// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Output _$OutputFromJson(Map<String, dynamic> json) => Output(
      targetNodeId: json['targetNodeId'] as String?,
      outputData: const OutputDataConverter().fromJson(json['outputData']),
      isBeingTargeted: json['isBeingTargeted'] as bool? ?? false,
      isBeingDragged: json['isBeingDragged'] as bool? ?? false,
    );

Map<String, dynamic> _$OutputToJson(Output instance) => <String, dynamic>{
      'targetNodeId': instance.targetNodeId,
      'outputData': const OutputDataConverter().toJson(instance.outputData),
      'isBeingTargeted': instance.isBeingTargeted,
      'isBeingDragged': instance.isBeingDragged,
    };
