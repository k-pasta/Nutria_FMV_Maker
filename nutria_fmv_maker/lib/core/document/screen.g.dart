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
  builtInFont: json['builtInFont'] as String?,
  textColor: (json['textColor'] as num?)?.toInt() ?? 0xFFFFFFFF,
  backgroundColor: (json['backgroundColor'] as num?)?.toInt() ?? 0xFF000000,
  backgroundOpacity: (json['backgroundOpacity'] as num?)?.toDouble() ?? 0.0,
  radius: (json['radius'] as num?)?.toDouble() ?? 0.0,
  padding: (json['padding'] as num?)?.toDouble() ?? 0.01,
  blur: (json['blur'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$ScreenStyleToJson(_ScreenStyle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fontSize': instance.fontSize,
      'bold': instance.bold,
      'fontId': instance.fontId,
      'builtInFont': instance.builtInFont,
      'textColor': instance.textColor,
      'backgroundColor': instance.backgroundColor,
      'backgroundOpacity': instance.backgroundOpacity,
      'radius': instance.radius,
      'padding': instance.padding,
      'blur': instance.blur,
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
      layout:
          $enumDecodeNullable(_$FmvChoiceLayoutEnumMap, json['layout']) ??
          FmvChoiceLayout.vertical,
      timerMode:
          $enumDecodeNullable(_$FmvTimerModeEnumMap, json['timerMode']) ??
          FmvTimerMode.toStart,
      thickness: (json['thickness'] as num?)?.toDouble() ?? 0.012,
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
      'layout': _$FmvChoiceLayoutEnumMap[instance.layout]!,
      'timerMode': _$FmvTimerModeEnumMap[instance.timerMode]!,
      'thickness': instance.thickness,
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
  ScreenElementKind.back: 'back',
  ScreenElementKind.volume: 'volume',
  ScreenElementKind.subtitles: 'subtitles',
  ScreenElementKind.fullScreen: 'fullScreen',
  ScreenElementKind.saves: 'saves',
};

const _$FmvChoiceLayoutEnumMap = {
  FmvChoiceLayout.vertical: 'vertical',
  FmvChoiceLayout.horizontal: 'horizontal',
  FmvChoiceLayout.columns: 'columns',
  FmvChoiceLayout.rows: 'rows',
  FmvChoiceLayout.radial: 'radial',
};

const _$FmvTimerModeEnumMap = {
  FmvTimerMode.toStart: 'toStart',
  FmvTimerMode.toMiddle: 'toMiddle',
  FmvTimerMode.fromMiddle: 'fromMiddle',
};

_ScreenDesign _$ScreenDesignFromJson(Map<String, dynamic> json) =>
    _ScreenDesign(
      id: json['id'] as String,
      kind: $enumDecode(_$ScreenKindEnumMap, json['kind']),
      name: json['name'] as String?,
      backgroundId: json['backgroundId'] as String?,
      elements:
          (json['elements'] as List<dynamic>?)
              ?.map((e) => ScreenElement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ScreenElement>[],
    );

Map<String, dynamic> _$ScreenDesignToJson(_ScreenDesign instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$ScreenKindEnumMap[instance.kind]!,
      'name': instance.name,
      'backgroundId': instance.backgroundId,
      'elements': instance.elements.map((e) => e.toJson()).toList(),
    };

const _$ScreenKindEnumMap = {
  ScreenKind.menu: 'menu',
  ScreenKind.choice: 'choice',
  ScreenKind.endChoice: 'endChoice',
  ScreenKind.pause: 'pause',
  ScreenKind.settings: 'settings',
  ScreenKind.saves: 'saves',
};
