// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScreenStyle _$ScreenStyleFromJson(Map<String, dynamic> json) => _ScreenStyle(
  id: json['id'] as String,
  name: json['name'] as String,
  fontSize: (json['fontSize'] as num?)?.toDouble() ?? 0.05,
  bold: json['bold'] as bool? ?? false,
  fontId: json['fontId'] as String?,
  textColor: (json['textColor'] as num?)?.toInt() ?? 0xFFFFFFFF,
  backgroundColor: (json['backgroundColor'] as num?)?.toInt() ?? 0xFF000000,
  backgroundOpacity: (json['backgroundOpacity'] as num?)?.toDouble() ?? 0.0,
  radius: (json['radius'] as num?)?.toDouble() ?? 0.0,
  padding: (json['padding'] as num?)?.toDouble() ?? 0.01,
);

Map<String, dynamic> _$ScreenStyleToJson(_ScreenStyle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fontSize': instance.fontSize,
      'bold': instance.bold,
      'fontId': instance.fontId,
      'textColor': instance.textColor,
      'backgroundColor': instance.backgroundColor,
      'backgroundOpacity': instance.backgroundOpacity,
      'radius': instance.radius,
      'padding': instance.padding,
    };

_ScreenElement _$ScreenElementFromJson(Map<String, dynamic> json) =>
    _ScreenElement(
      id: json['id'] as String,
      kind: $enumDecode(_$ScreenElementKindEnumMap, json['kind']),
      x: (json['x'] as num?)?.toDouble() ?? 0.5,
      y: (json['y'] as num?)?.toDouble() ?? 0.5,
      width: (json['width'] as num?)?.toDouble() ?? 0.3,
      styleId: json['styleId'] as String?,
      text: json['text'] as String?,
      gap: (json['gap'] as num?)?.toDouble() ?? 0.015,
    );

Map<String, dynamic> _$ScreenElementToJson(_ScreenElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$ScreenElementKindEnumMap[instance.kind]!,
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'styleId': instance.styleId,
      'text': instance.text,
      'gap': instance.gap,
    };

const _$ScreenElementKindEnumMap = {
  ScreenElementKind.title: 'title',
  ScreenElementKind.description: 'description',
  ScreenElementKind.start: 'start',
  ScreenElementKind.load: 'load',
  ScreenElementKind.settings: 'settings',
  ScreenElementKind.credits: 'credits',
  ScreenElementKind.quit: 'quit',
  ScreenElementKind.question: 'question',
  ScreenElementKind.choices: 'choices',
  ScreenElementKind.timer: 'timer',
  ScreenElementKind.resume: 'resume',
  ScreenElementKind.save: 'save',
  ScreenElementKind.mainMenu: 'mainMenu',
};

_ScreenDesign _$ScreenDesignFromJson(Map<String, dynamic> json) =>
    _ScreenDesign(
      backgroundId: json['backgroundId'] as String?,
      elements:
          (json['elements'] as List<dynamic>?)
              ?.map((e) => ScreenElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ScreenElement>[],
    );

Map<String, dynamic> _$ScreenDesignToJson(_ScreenDesign instance) =>
    <String, dynamic>{
      'backgroundId': instance.backgroundId,
      'elements': instance.elements.map((e) => e.toJson()).toList(),
    };
