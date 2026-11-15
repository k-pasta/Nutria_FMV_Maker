// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoSettings _$VideoSettingsFromJson(Map<String, dynamic> json) =>
    _VideoSettings(
      selectionTimeMs: (json['selectionTimeMs'] as num?)?.toInt() ?? 6000,
      pauseOnEnd: json['pauseOnEnd'] as bool? ?? false,
      showTimer: json['showTimer'] as bool? ?? true,
      videoFit:
          $enumDecodeNullable(_$VideoFitEnumMap, json['videoFit']) ??
          VideoFit.fit,
      defaultSelection:
          $enumDecodeNullable(
            _$DefaultSelectionMethodEnumMap,
            json['defaultSelection'],
          ) ??
          DefaultSelectionMethod.first,
    );

Map<String, dynamic> _$VideoSettingsToJson(_VideoSettings instance) =>
    <String, dynamic>{
      'selectionTimeMs': instance.selectionTimeMs,
      'pauseOnEnd': instance.pauseOnEnd,
      'showTimer': instance.showTimer,
      'videoFit': _$VideoFitEnumMap[instance.videoFit]!,
      'defaultSelection':
          _$DefaultSelectionMethodEnumMap[instance.defaultSelection]!,
    };

const _$VideoFitEnumMap = {
  VideoFit.fit: 'fit',
  VideoFit.fill: 'fill',
  VideoFit.fillWidth: 'fillWidth',
  VideoFit.fillHeight: 'fillHeight',
  VideoFit.stretch: 'stretch',
};

const _$DefaultSelectionMethodEnumMap = {
  DefaultSelectionMethod.first: 'first',
  DefaultSelectionMethod.last: 'last',
  DefaultSelectionMethod.lastSelected: 'lastSelected',
  DefaultSelectionMethod.random: 'random',
  DefaultSelectionMethod.specified: 'specified',
};

_VideoSettingsOverride _$VideoSettingsOverrideFromJson(
  Map<String, dynamic> json,
) => _VideoSettingsOverride(
  selectionTimeMs: (json['selectionTimeMs'] as num?)?.toInt(),
  pauseOnEnd: json['pauseOnEnd'] as bool?,
  showTimer: json['showTimer'] as bool?,
  videoFit: $enumDecodeNullable(_$VideoFitEnumMap, json['videoFit']),
  defaultSelection: $enumDecodeNullable(
    _$DefaultSelectionMethodEnumMap,
    json['defaultSelection'],
  ),
);

Map<String, dynamic> _$VideoSettingsOverrideToJson(
  _VideoSettingsOverride instance,
) => <String, dynamic>{
  'selectionTimeMs': instance.selectionTimeMs,
  'pauseOnEnd': instance.pauseOnEnd,
  'showTimer': instance.showTimer,
  'videoFit': _$VideoFitEnumMap[instance.videoFit],
  'defaultSelection':
      _$DefaultSelectionMethodEnumMap[instance.defaultSelection],
};
