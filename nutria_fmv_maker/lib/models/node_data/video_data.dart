import 'package:json_annotation/json_annotation.dart';
import 'package:nutria_fmv_maker/models/video_metadata.dart';

part 'video_data.g.dart';

@JsonSerializable()
class VideoData {
  final String id;
  final String videoPath;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? thumbnailPath;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<MetadataEntry>? metadata;
  String get fileName => '${Uri.file(videoPath).pathSegments.last}';

  VideoData({
    required this.videoPath,
    required this.id,
    this.thumbnailPath,
    this.metadata = const <MetadataEntry>[],
  });

  VideoData copyWith({
    String? id,
    String? videoDataPath,
    String? thumbnailPath,
    List<MetadataEntry>? metadata,
  }) {
    return VideoData(
      id: id ?? this.id,
      videoPath: videoDataPath ?? this.videoPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      metadata: metadata ?? this.metadata,
    );
  }

//JsonSerializable encode and decode methods
  factory VideoData.fromJson(Map<String, dynamic> json) =>
      _$VideoDataFromJson(json);

  Map<String, dynamic> toJson() => _$VideoDataToJson(this);
}
