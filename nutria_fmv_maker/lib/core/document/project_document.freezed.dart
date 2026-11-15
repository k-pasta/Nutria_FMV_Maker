// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectInfo {

 String? get title; String? get description;
/// Create a copy of ProjectInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectInfoCopyWith<ProjectInfo> get copyWith => _$ProjectInfoCopyWithImpl<ProjectInfo>(this as ProjectInfo, _$identity);

  /// Serializes this ProjectInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectInfo&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectInfo;
  return Object.hash(runtimeType,_this.title,_this.description);
}

@override
String toString() {
  final _this = this as ProjectInfo;
  return 'ProjectInfo(title: ${_this.title}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $ProjectInfoCopyWith<$Res>  {
  factory $ProjectInfoCopyWith(ProjectInfo value, $Res Function(ProjectInfo) _then) = _$ProjectInfoCopyWithImpl;
@useResult
$Res call({
 String? title, String? description
});




}
/// @nodoc
class _$ProjectInfoCopyWithImpl<$Res>
    implements $ProjectInfoCopyWith<$Res> {
  _$ProjectInfoCopyWithImpl(this._self, this._then);

  final ProjectInfo _self;
  final $Res Function(ProjectInfo) _then;

/// Create a copy of ProjectInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,}) {
  return _then(ProjectInfo(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectInfo].
extension ProjectInfoPatterns on ProjectInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectInfo value)  $default,){
final _that = this;
switch (_that) {
case _ProjectInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectInfo() when $default != null:
return $default(_that.title,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ProjectInfo():
return $default(_that.title,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ProjectInfo() when $default != null:
return $default(_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectInfo implements ProjectInfo {
  const _ProjectInfo({this.title, this.description});
  factory _ProjectInfo.fromJson(Map<String, dynamic> json) => _$ProjectInfoFromJson(json);

@override final  String? title;
@override final  String? description;

/// Create a copy of ProjectInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectInfoCopyWith<_ProjectInfo> get copyWith => __$ProjectInfoCopyWithImpl<_ProjectInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectInfo&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,description);
}

@override
String toString() {
    return 'ProjectInfo(title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ProjectInfoCopyWith<$Res> implements $ProjectInfoCopyWith<$Res> {
  factory _$ProjectInfoCopyWith(_ProjectInfo value, $Res Function(_ProjectInfo) _then) = __$ProjectInfoCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description
});




}
/// @nodoc
class __$ProjectInfoCopyWithImpl<$Res>
    implements _$ProjectInfoCopyWith<$Res> {
  __$ProjectInfoCopyWithImpl(this._self, this._then);

  final _ProjectInfo _self;
  final $Res Function(_ProjectInfo) _then;

/// Create a copy of ProjectInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,}) {
  return _then(_ProjectInfo(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$VideoAsset {

 String get id;/// Absolute path on the machine that last saved the project.
 String get path;
/// Create a copy of VideoAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoAssetCopyWith<VideoAsset> get copyWith => _$VideoAssetCopyWithImpl<VideoAsset>(this as VideoAsset, _$identity);

  /// Serializes this VideoAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VideoAsset;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoAsset&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.path, _this.path) || other.path == _this.path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VideoAsset;
  return Object.hash(runtimeType,_this.id,_this.path);
}

@override
String toString() {
  final _this = this as VideoAsset;
  return 'VideoAsset(id: ${_this.id}, path: ${_this.path})';
}


}

/// @nodoc
abstract mixin class $VideoAssetCopyWith<$Res>  {
  factory $VideoAssetCopyWith(VideoAsset value, $Res Function(VideoAsset) _then) = _$VideoAssetCopyWithImpl;
@useResult
$Res call({
 String id, String path
});




}
/// @nodoc
class _$VideoAssetCopyWithImpl<$Res>
    implements $VideoAssetCopyWith<$Res> {
  _$VideoAssetCopyWithImpl(this._self, this._then);

  final VideoAsset _self;
  final $Res Function(VideoAsset) _then;

/// Create a copy of VideoAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,}) {
  return _then(VideoAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoAsset].
extension VideoAssetPatterns on VideoAsset {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoAsset() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoAsset value)  $default,){
final _that = this;
switch (_that) {
case _VideoAsset():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoAsset value)?  $default,){
final _that = this;
switch (_that) {
case _VideoAsset() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoAsset() when $default != null:
return $default(_that.id,_that.path);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String path)  $default,) {final _that = this;
switch (_that) {
case _VideoAsset():
return $default(_that.id,_that.path);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String path)?  $default,) {final _that = this;
switch (_that) {
case _VideoAsset() when $default != null:
return $default(_that.id,_that.path);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoAsset extends VideoAsset {
  const _VideoAsset({required this.id, required this.path}): super._();
  factory _VideoAsset.fromJson(Map<String, dynamic> json) => _$VideoAssetFromJson(json);

@override final  String id;
/// Absolute path on the machine that last saved the project.
@override final  String path;

/// Create a copy of VideoAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoAssetCopyWith<_VideoAsset> get copyWith => __$VideoAssetCopyWithImpl<_VideoAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoAssetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,path);
}

@override
String toString() {
    return 'VideoAsset(id: $id, path: $path)';
}


}

/// @nodoc
abstract mixin class _$VideoAssetCopyWith<$Res> implements $VideoAssetCopyWith<$Res> {
  factory _$VideoAssetCopyWith(_VideoAsset value, $Res Function(_VideoAsset) _then) = __$VideoAssetCopyWithImpl;
@override @useResult
$Res call({
 String id, String path
});




}
/// @nodoc
class __$VideoAssetCopyWithImpl<$Res>
    implements _$VideoAssetCopyWith<$Res> {
  __$VideoAssetCopyWithImpl(this._self, this._then);

  final _VideoAsset _self;
  final $Res Function(_VideoAsset) _then;

/// Create a copy of VideoAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,}) {
  return _then(_VideoAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProjectDocument {

 int get formatVersion; ProjectInfo get info; VideoSettings get settings;/// Nodes by id. Insertion order is kept but carries no meaning.
 Map<String, Node> get nodes; List<Edge> get edges; List<VideoAsset> get videos;
/// Create a copy of ProjectDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDocumentCopyWith<ProjectDocument> get copyWith => _$ProjectDocumentCopyWithImpl<ProjectDocument>(this as ProjectDocument, _$identity);

  /// Serializes this ProjectDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDocument&&(identical(other.formatVersion, _this.formatVersion) || other.formatVersion == _this.formatVersion)&&(identical(other.info, _this.info) || other.info == _this.info)&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&const DeepCollectionEquality().equals(other.nodes, _this.nodes)&&const DeepCollectionEquality().equals(other.edges, _this.edges)&&const DeepCollectionEquality().equals(other.videos, _this.videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectDocument;
  return Object.hash(runtimeType,_this.formatVersion,_this.info,_this.settings,const DeepCollectionEquality().hash(_this.nodes),const DeepCollectionEquality().hash(_this.edges),const DeepCollectionEquality().hash(_this.videos));
}

@override
String toString() {
  final _this = this as ProjectDocument;
  return 'ProjectDocument(formatVersion: ${_this.formatVersion}, info: ${_this.info}, settings: ${_this.settings}, nodes: ${_this.nodes}, edges: ${_this.edges}, videos: ${_this.videos})';
}


}

/// @nodoc
abstract mixin class $ProjectDocumentCopyWith<$Res>  {
  factory $ProjectDocumentCopyWith(ProjectDocument value, $Res Function(ProjectDocument) _then) = _$ProjectDocumentCopyWithImpl;
@useResult
$Res call({
 int formatVersion, ProjectInfo info, VideoSettings settings, Map<String, Node> nodes, List<Edge> edges, List<VideoAsset> videos
});


$ProjectInfoCopyWith<$Res> get info;$VideoSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$ProjectDocumentCopyWithImpl<$Res>
    implements $ProjectDocumentCopyWith<$Res> {
  _$ProjectDocumentCopyWithImpl(this._self, this._then);

  final ProjectDocument _self;
  final $Res Function(ProjectDocument) _then;

/// Create a copy of ProjectDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formatVersion = null,Object? info = null,Object? settings = null,Object? nodes = null,Object? edges = null,Object? videos = null,}) {
  return _then(ProjectDocument(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as ProjectInfo,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as VideoSettings,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as Map<String, Node>,edges: null == edges ? _self.edges : edges // ignore: cast_nullable_to_non_nullable
as List<Edge>,videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoAsset>,
  ));
}
/// Create a copy of ProjectDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectInfoCopyWith<$Res> get info {
  
  return $ProjectInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of ProjectDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoSettingsCopyWith<$Res> get settings {
  
  return $VideoSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectDocument].
extension ProjectDocumentPatterns on ProjectDocument {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDocument() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDocument value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDocument():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDocument value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDocument() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int formatVersion,  ProjectInfo info,  VideoSettings settings,  Map<String, Node> nodes,  List<Edge> edges,  List<VideoAsset> videos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDocument() when $default != null:
return $default(_that.formatVersion,_that.info,_that.settings,_that.nodes,_that.edges,_that.videos);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int formatVersion,  ProjectInfo info,  VideoSettings settings,  Map<String, Node> nodes,  List<Edge> edges,  List<VideoAsset> videos)  $default,) {final _that = this;
switch (_that) {
case _ProjectDocument():
return $default(_that.formatVersion,_that.info,_that.settings,_that.nodes,_that.edges,_that.videos);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int formatVersion,  ProjectInfo info,  VideoSettings settings,  Map<String, Node> nodes,  List<Edge> edges,  List<VideoAsset> videos)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDocument() when $default != null:
return $default(_that.formatVersion,_that.info,_that.settings,_that.nodes,_that.edges,_that.videos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectDocument extends ProjectDocument {
  const _ProjectDocument({this.formatVersion = kNfmvFormatVersion, this.info = const ProjectInfo(), this.settings = const VideoSettings(),  Map<String, Node> nodes = const <String, Node>{},  List<Edge> edges = const <Edge>[],  List<VideoAsset> videos = const <VideoAsset>[]}): _nodes = nodes,_edges = edges,_videos = videos,super._();
  factory _ProjectDocument.fromJson(Map<String, dynamic> json) => _$ProjectDocumentFromJson(json);

@override@JsonKey() final  int formatVersion;
@override@JsonKey() final  ProjectInfo info;
@override@JsonKey() final  VideoSettings settings;
/// Nodes by id. Insertion order is kept but carries no meaning.
 final  Map<String, Node> _nodes;
/// Nodes by id. Insertion order is kept but carries no meaning.
@override@JsonKey() Map<String, Node> get nodes {
  if (_nodes is EqualUnmodifiableMapView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_nodes);
}

 final  List<Edge> _edges;
@override@JsonKey() List<Edge> get edges {
  if (_edges is EqualUnmodifiableListView) return _edges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_edges);
}

 final  List<VideoAsset> _videos;
@override@JsonKey() List<VideoAsset> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}


/// Create a copy of ProjectDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDocumentCopyWith<_ProjectDocument> get copyWith => __$ProjectDocumentCopyWithImpl<_ProjectDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDocument&&(identical(other.formatVersion, formatVersion) || other.formatVersion == formatVersion)&&(identical(other.info, info) || other.info == info)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.nodes, _nodes)&&const DeepCollectionEquality().equals(other.edges, _edges)&&const DeepCollectionEquality().equals(other.videos, _videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,formatVersion,info,settings,const DeepCollectionEquality().hash(_nodes),const DeepCollectionEquality().hash(_edges),const DeepCollectionEquality().hash(_videos));
}

@override
String toString() {
    return 'ProjectDocument(formatVersion: $formatVersion, info: $info, settings: $settings, nodes: $nodes, edges: $edges, videos: $videos)';
}


}

/// @nodoc
abstract mixin class _$ProjectDocumentCopyWith<$Res> implements $ProjectDocumentCopyWith<$Res> {
  factory _$ProjectDocumentCopyWith(_ProjectDocument value, $Res Function(_ProjectDocument) _then) = __$ProjectDocumentCopyWithImpl;
@override @useResult
$Res call({
 int formatVersion, ProjectInfo info, VideoSettings settings, Map<String, Node> nodes, List<Edge> edges, List<VideoAsset> videos
});


@override $ProjectInfoCopyWith<$Res> get info;@override $VideoSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$ProjectDocumentCopyWithImpl<$Res>
    implements _$ProjectDocumentCopyWith<$Res> {
  __$ProjectDocumentCopyWithImpl(this._self, this._then);

  final _ProjectDocument _self;
  final $Res Function(_ProjectDocument) _then;

/// Create a copy of ProjectDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formatVersion = null,Object? info = null,Object? settings = null,Object? nodes = null,Object? edges = null,Object? videos = null,}) {
  return _then(_ProjectDocument(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as ProjectInfo,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as VideoSettings,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as Map<String, Node>,edges: null == edges ? _self._edges : edges // ignore: cast_nullable_to_non_nullable
as List<Edge>,videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoAsset>,
  ));
}

/// Create a copy of ProjectDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectInfoCopyWith<$Res> get info {
  
  return $ProjectInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of ProjectDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoSettingsCopyWith<$Res> get settings {
  
  return $VideoSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
