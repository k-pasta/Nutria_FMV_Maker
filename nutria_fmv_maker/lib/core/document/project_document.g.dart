// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectInfo _$ProjectInfoFromJson(Map<String, dynamic> json) => _ProjectInfo(
  title: json['title'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$ProjectInfoToJson(_ProjectInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

_VideoAsset _$VideoAssetFromJson(Map<String, dynamic> json) =>
    _VideoAsset(id: json['id'] as String, path: json['path'] as String);

Map<String, dynamic> _$VideoAssetToJson(_VideoAsset instance) =>
    <String, dynamic>{'id': instance.id, 'path': instance.path};

_ProjectDocument _$ProjectDocumentFromJson(Map<String, dynamic> json) =>
    _ProjectDocument(
      formatVersion:
          (json['formatVersion'] as num?)?.toInt() ?? kNfmvFormatVersion,
      info: json['info'] == null
          ? const ProjectInfo()
          : ProjectInfo.fromJson(json['info'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? const VideoSettings()
          : VideoSettings.fromJson(json['settings'] as Map<String, dynamic>),
      nodes:
          (json['nodes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Node.fromJson(e as Map<String, dynamic>)),
          ) ??
          const <String, Node>{},
      edges:
          (json['edges'] as List<dynamic>?)
              ?.map((e) => Edge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Edge>[],
      videos:
          (json['videos'] as List<dynamic>?)
              ?.map((e) => VideoAsset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VideoAsset>[],
    );

Map<String, dynamic> _$ProjectDocumentToJson(_ProjectDocument instance) =>
    <String, dynamic>{
      'formatVersion': instance.formatVersion,
      'info': instance.info.toJson(),
      'settings': instance.settings.toJson(),
      'nodes': instance.nodes.map((k, e) => MapEntry(k, e.toJson())),
      'edges': instance.edges.map((e) => e.toJson()).toList(),
      'videos': instance.videos.map((e) => e.toJson()).toList(),
    };
