// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoData _$VideoDataFromJson(Map<String, dynamic> json) => VideoData(
      videoPath: json['videoPath'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'id': instance.id,
      'videoPath': instance.videoPath,
    };
