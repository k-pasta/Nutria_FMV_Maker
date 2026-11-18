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
mixin _$ProjectDocument {

 int get formatVersion; ProjectInfo get info;/// The defaults: for the first color, and every color without its own
/// entry in [colorDefaults].
 VideoSettings get settings;/// Defaults for other colors, by swatch index (1 to [kMaxColorDefaults]).
/// Missing in older files, hence empty.
 Map<int, VideoSettings> get colorDefaults;/// Nodes by id. Insertion order is kept but carries no meaning.
 Map<String, Node> get nodes; List<Edge> get edges;/// Imported files, in import order (which is also "date added").
 List<MediaAsset> get media;/// Named values for the story. Missing in older files, hence empty.
 List<Variable> get variables;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDocument&&(identical(other.formatVersion, _this.formatVersion) || other.formatVersion == _this.formatVersion)&&(identical(other.info, _this.info) || other.info == _this.info)&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&const DeepCollectionEquality().equals(other.colorDefaults, _this.colorDefaults)&&const DeepCollectionEquality().equals(other.nodes, _this.nodes)&&const DeepCollectionEquality().equals(other.edges, _this.edges)&&const DeepCollectionEquality().equals(other.media, _this.media)&&const DeepCollectionEquality().equals(other.variables, _this.variables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectDocument;
  return Object.hash(runtimeType,_this.formatVersion,_this.info,_this.settings,const DeepCollectionEquality().hash(_this.colorDefaults),const DeepCollectionEquality().hash(_this.nodes),const DeepCollectionEquality().hash(_this.edges),const DeepCollectionEquality().hash(_this.media),const DeepCollectionEquality().hash(_this.variables));
}

@override
String toString() {
  final _this = this as ProjectDocument;
  return 'ProjectDocument(formatVersion: ${_this.formatVersion}, info: ${_this.info}, settings: ${_this.settings}, colorDefaults: ${_this.colorDefaults}, nodes: ${_this.nodes}, edges: ${_this.edges}, media: ${_this.media}, variables: ${_this.variables})';
}


}

/// @nodoc
abstract mixin class $ProjectDocumentCopyWith<$Res>  {
  factory $ProjectDocumentCopyWith(ProjectDocument value, $Res Function(ProjectDocument) _then) = _$ProjectDocumentCopyWithImpl;
@useResult
$Res call({
 int formatVersion, ProjectInfo info, VideoSettings settings, Map<int, VideoSettings> colorDefaults, Map<String, Node> nodes, List<Edge> edges, List<MediaAsset> media, List<Variable> variables
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
@pragma('vm:prefer-inline') @override $Res call({Object? formatVersion = null,Object? info = null,Object? settings = null,Object? colorDefaults = null,Object? nodes = null,Object? edges = null,Object? media = null,Object? variables = null,}) {
  return _then(ProjectDocument(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as ProjectInfo,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as VideoSettings,colorDefaults: null == colorDefaults ? _self.colorDefaults : colorDefaults // ignore: cast_nullable_to_non_nullable
as Map<int, VideoSettings>,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as Map<String, Node>,edges: null == edges ? _self.edges : edges // ignore: cast_nullable_to_non_nullable
as List<Edge>,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<MediaAsset>,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as List<Variable>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int formatVersion,  ProjectInfo info,  VideoSettings settings,  Map<int, VideoSettings> colorDefaults,  Map<String, Node> nodes,  List<Edge> edges,  List<MediaAsset> media,  List<Variable> variables)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDocument() when $default != null:
return $default(_that.formatVersion,_that.info,_that.settings,_that.colorDefaults,_that.nodes,_that.edges,_that.media,_that.variables);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int formatVersion,  ProjectInfo info,  VideoSettings settings,  Map<int, VideoSettings> colorDefaults,  Map<String, Node> nodes,  List<Edge> edges,  List<MediaAsset> media,  List<Variable> variables)  $default,) {final _that = this;
switch (_that) {
case _ProjectDocument():
return $default(_that.formatVersion,_that.info,_that.settings,_that.colorDefaults,_that.nodes,_that.edges,_that.media,_that.variables);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int formatVersion,  ProjectInfo info,  VideoSettings settings,  Map<int, VideoSettings> colorDefaults,  Map<String, Node> nodes,  List<Edge> edges,  List<MediaAsset> media,  List<Variable> variables)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDocument() when $default != null:
return $default(_that.formatVersion,_that.info,_that.settings,_that.colorDefaults,_that.nodes,_that.edges,_that.media,_that.variables);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectDocument extends ProjectDocument {
  const _ProjectDocument({this.formatVersion = kNfmvFormatVersion, this.info = const ProjectInfo(), this.settings = const VideoSettings(),  Map<int, VideoSettings> colorDefaults = const <int, VideoSettings>{},  Map<String, Node> nodes = const <String, Node>{},  List<Edge> edges = const <Edge>[],  List<MediaAsset> media = const <MediaAsset>[],  List<Variable> variables = const <Variable>[]}): _colorDefaults = colorDefaults,_nodes = nodes,_edges = edges,_media = media,_variables = variables,super._();
  factory _ProjectDocument.fromJson(Map<String, dynamic> json) => _$ProjectDocumentFromJson(json);

@override@JsonKey() final  int formatVersion;
@override@JsonKey() final  ProjectInfo info;
/// The defaults: for the first color, and every color without its own
/// entry in [colorDefaults].
@override@JsonKey() final  VideoSettings settings;
/// Defaults for other colors, by swatch index (1 to [kMaxColorDefaults]).
/// Missing in older files, hence empty.
 final  Map<int, VideoSettings> _colorDefaults;
/// Defaults for other colors, by swatch index (1 to [kMaxColorDefaults]).
/// Missing in older files, hence empty.
@override@JsonKey() Map<int, VideoSettings> get colorDefaults {
  if (_colorDefaults is EqualUnmodifiableMapView) return _colorDefaults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_colorDefaults);
}

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

/// Imported files, in import order (which is also "date added").
 final  List<MediaAsset> _media;
/// Imported files, in import order (which is also "date added").
@override@JsonKey() List<MediaAsset> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

/// Named values for the story. Missing in older files, hence empty.
 final  List<Variable> _variables;
/// Named values for the story. Missing in older files, hence empty.
@override@JsonKey() List<Variable> get variables {
  if (_variables is EqualUnmodifiableListView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variables);
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDocument&&(identical(other.formatVersion, formatVersion) || other.formatVersion == formatVersion)&&(identical(other.info, info) || other.info == info)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.colorDefaults, _colorDefaults)&&const DeepCollectionEquality().equals(other.nodes, _nodes)&&const DeepCollectionEquality().equals(other.edges, _edges)&&const DeepCollectionEquality().equals(other.media, _media)&&const DeepCollectionEquality().equals(other.variables, _variables));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,formatVersion,info,settings,const DeepCollectionEquality().hash(_colorDefaults),const DeepCollectionEquality().hash(_nodes),const DeepCollectionEquality().hash(_edges),const DeepCollectionEquality().hash(_media),const DeepCollectionEquality().hash(_variables));
}

@override
String toString() {
    return 'ProjectDocument(formatVersion: $formatVersion, info: $info, settings: $settings, colorDefaults: $colorDefaults, nodes: $nodes, edges: $edges, media: $media, variables: $variables)';
}


}

/// @nodoc
abstract mixin class _$ProjectDocumentCopyWith<$Res> implements $ProjectDocumentCopyWith<$Res> {
  factory _$ProjectDocumentCopyWith(_ProjectDocument value, $Res Function(_ProjectDocument) _then) = __$ProjectDocumentCopyWithImpl;
@override @useResult
$Res call({
 int formatVersion, ProjectInfo info, VideoSettings settings, Map<int, VideoSettings> colorDefaults, Map<String, Node> nodes, List<Edge> edges, List<MediaAsset> media, List<Variable> variables
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
@override @pragma('vm:prefer-inline') $Res call({Object? formatVersion = null,Object? info = null,Object? settings = null,Object? colorDefaults = null,Object? nodes = null,Object? edges = null,Object? media = null,Object? variables = null,}) {
  return _then(_ProjectDocument(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as ProjectInfo,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as VideoSettings,colorDefaults: null == colorDefaults ? _self._colorDefaults : colorDefaults // ignore: cast_nullable_to_non_nullable
as Map<int, VideoSettings>,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as Map<String, Node>,edges: null == edges ? _self._edges : edges // ignore: cast_nullable_to_non_nullable
as List<Edge>,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<MediaAsset>,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as List<Variable>,
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
