// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataEntry<T> _$MetadataEntryFromJson<T>(Map<String, dynamic> json) =>
    MetadataEntry<T>(
      key: $enumDecode(_$VideoMetadataTypeEnumMap, json['key']),
      value: MetadataEntryConverter<T>().fromJson(json['value']),
    );

Map<String, dynamic> _$MetadataEntryToJson<T>(MetadataEntry<T> instance) =>
    <String, dynamic>{
      'key': _$VideoMetadataTypeEnumMap[instance.key]!,
      'value': MetadataEntryConverter<T>().toJson(instance.value),
    };

const _$VideoMetadataTypeEnumMap = {
  VideoMetadataType.filename: 'filename',
  VideoMetadataType.filePath: 'filePath',
  VideoMetadataType.fileSize: 'fileSize',
  VideoMetadataType.dateCreated: 'dateCreated',
  VideoMetadataType.resolution: 'resolution',
  VideoMetadataType.frameRate: 'frameRate',
  VideoMetadataType.codecFormat: 'codecFormat',
  VideoMetadataType.bitrate: 'bitrate',
  VideoMetadataType.aspectRatio: 'aspectRatio',
  VideoMetadataType.colorProfile: 'colorProfile',
  VideoMetadataType.duration: 'duration',
  VideoMetadataType.timecode: 'timecode',
  VideoMetadataType.audioSampleRate: 'audioSampleRate',
  VideoMetadataType.audioBitDepth: 'audioBitDepth',
  VideoMetadataType.audioChannels: 'audioChannels',
  VideoMetadataType.audioCodecFormat: 'audioCodecFormat',
};
