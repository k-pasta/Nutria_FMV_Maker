// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MusicCue _$MusicCueFromJson(Map<String, dynamic> json) => _MusicCue(
  audioId: json['audioId'] as String,
  end:
      $enumDecodeNullable(_$FmvMusicEndEnumMap, json['end']) ??
      FmvMusicEnd.videoEnds,
  loop: json['loop'] as bool? ?? false,
  fadeOutMs: (json['fadeOutMs'] as num?)?.toInt() ?? 1000,
  pauseWithVideo: json['pauseWithVideo'] as bool? ?? true,
);

Map<String, dynamic> _$MusicCueToJson(_MusicCue instance) => <String, dynamic>{
  'audioId': instance.audioId,
  'end': _$FmvMusicEndEnumMap[instance.end]!,
  'loop': instance.loop,
  'fadeOutMs': instance.fadeOutMs,
  'pauseWithVideo': instance.pauseWithVideo,
};

const _$FmvMusicEndEnumMap = {
  FmvMusicEnd.trackEnds: 'trackEnds',
  FmvMusicEnd.choicesAppear: 'choicesAppear',
  FmvMusicEnd.videoEnds: 'videoEnds',
  FmvMusicEnd.laterNodeChanges: 'laterNodeChanges',
};
