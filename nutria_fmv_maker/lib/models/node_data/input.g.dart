// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Input _$InputFromJson(Map<String, dynamic> json) => Input(
      isBeingTargeted: json['isBeingTargeted'] as bool? ?? false,
      isBeingDragged: json['isBeingDragged'] as bool? ?? false,
    );

Map<String, dynamic> _$InputToJson(Input instance) => <String, dynamic>{
      'isBeingTargeted': instance.isBeingTargeted,
      'isBeingDragged': instance.isBeingDragged,
    };
