// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoolVariable _$BoolVariableFromJson(Map<String, dynamic> json) => BoolVariable(
  id: json['id'] as String,
  name: json['name'] as String,
  initial: json['initial'] as bool? ?? false,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$BoolVariableToJson(BoolVariable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'initial': instance.initial,
      'type': instance.$type,
    };

IntVariable _$IntVariableFromJson(Map<String, dynamic> json) => IntVariable(
  id: json['id'] as String,
  name: json['name'] as String,
  initial: (json['initial'] as num?)?.toInt() ?? 0,
  min: (json['min'] as num?)?.toInt(),
  max: (json['max'] as num?)?.toInt(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$IntVariableToJson(IntVariable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'initial': instance.initial,
      'min': instance.min,
      'max': instance.max,
      'type': instance.$type,
    };

DecimalVariable _$DecimalVariableFromJson(Map<String, dynamic> json) =>
    DecimalVariable(
      id: json['id'] as String,
      name: json['name'] as String,
      initial: (json['initial'] as num?)?.toDouble() ?? 0.0,
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$DecimalVariableToJson(DecimalVariable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'initial': instance.initial,
      'min': instance.min,
      'max': instance.max,
      'type': instance.$type,
    };
