// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoSettings _$VideoSettingsFromJson(
  Map<String, dynamic> json,
) => _VideoSettings(
  selectionTimeMs: (json['selectionTimeMs'] as num?)?.toInt() ?? 6000,
  pauseOnEnd: json['pauseOnEnd'] as bool? ?? false,
  showTimer: json['showTimer'] as bool? ?? true,
  showQuestion: json['showQuestion'] as bool? ?? false,
  videoFit:
      $enumDecodeNullable(_$VideoFitEnumMap, json['videoFit']) ?? VideoFit.fit,
  defaultSelection:
      $enumDecodeNullable(
        _$DefaultSelectionMethodEnumMap,
        json['defaultSelection'],
      ) ??
      DefaultSelectionMethod.first,
  music: json['music'] == null
      ? kNoMusic
      : MusicCue.fromJson(json['music'] as Map<String, dynamic>),
  pauseMusicId: json['pauseMusicId'] as String? ?? '',
  pauseMusicFadeOutMs: (json['pauseMusicFadeOutMs'] as num?)?.toInt() ?? 1000,
  choiceScreenId: json['choiceScreenId'] as String? ?? 'choice',
);

Map<String, dynamic> _$VideoSettingsToJson(_VideoSettings instance) =>
    <String, dynamic>{
      'selectionTimeMs': instance.selectionTimeMs,
      'pauseOnEnd': instance.pauseOnEnd,
      'showTimer': instance.showTimer,
      'showQuestion': instance.showQuestion,
      'videoFit': _$VideoFitEnumMap[instance.videoFit]!,
      'defaultSelection':
          _$DefaultSelectionMethodEnumMap[instance.defaultSelection]!,
      'music': instance.music.toJson(),
      'pauseMusicId': instance.pauseMusicId,
      'pauseMusicFadeOutMs': instance.pauseMusicFadeOutMs,
      'choiceScreenId': instance.choiceScreenId,
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
  showQuestion: json['showQuestion'] as bool?,
  videoFit: $enumDecodeNullable(_$VideoFitEnumMap, json['videoFit']),
  defaultSelection: $enumDecodeNullable(
    _$DefaultSelectionMethodEnumMap,
    json['defaultSelection'],
  ),
  music: json['music'] == null
      ? null
      : MusicCue.fromJson(json['music'] as Map<String, dynamic>),
  pauseMusicId: json['pauseMusicId'] as String?,
  pauseMusicFadeOutMs: (json['pauseMusicFadeOutMs'] as num?)?.toInt(),
  choiceScreenId: json['choiceScreenId'] as String?,
);

Map<String, dynamic> _$VideoSettingsOverrideToJson(
  _VideoSettingsOverride instance,
) => <String, dynamic>{
  'selectionTimeMs': instance.selectionTimeMs,
  'pauseOnEnd': instance.pauseOnEnd,
  'showTimer': instance.showTimer,
  'showQuestion': instance.showQuestion,
  'videoFit': _$VideoFitEnumMap[instance.videoFit],
  'defaultSelection':
      _$DefaultSelectionMethodEnumMap[instance.defaultSelection],
  'music': instance.music?.toJson(),
  'pauseMusicId': instance.pauseMusicId,
  'pauseMusicFadeOutMs': instance.pauseMusicFadeOutMs,
  'choiceScreenId': instance.choiceScreenId,
};
