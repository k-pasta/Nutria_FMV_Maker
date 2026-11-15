// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentState {

 DocumentTimeline get timeline;/// The document as last saved or loaded; [isDirty] compares against it.
 ProjectDocument get savedDocument;/// Where the project was last saved or loaded from. `null` if never saved.
 String? get savePath;/// Increments whenever a different project is opened or created, so
/// editor state (selection, preview…) can reset itself.
 int get generation;
/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentStateCopyWith<DocumentState> get copyWith => _$DocumentStateCopyWithImpl<DocumentState>(this as DocumentState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DocumentState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentState&&(identical(other.timeline, _this.timeline) || other.timeline == _this.timeline)&&(identical(other.savedDocument, _this.savedDocument) || other.savedDocument == _this.savedDocument)&&(identical(other.savePath, _this.savePath) || other.savePath == _this.savePath)&&(identical(other.generation, _this.generation) || other.generation == _this.generation));
}


@override
int get hashCode {
  final _this = this as DocumentState;
  return Object.hash(runtimeType,_this.timeline,_this.savedDocument,_this.savePath,_this.generation);
}

@override
String toString() {
  final _this = this as DocumentState;
  return 'DocumentState(timeline: ${_this.timeline}, savedDocument: ${_this.savedDocument}, savePath: ${_this.savePath}, generation: ${_this.generation})';
}


}

/// @nodoc
abstract mixin class $DocumentStateCopyWith<$Res>  {
  factory $DocumentStateCopyWith(DocumentState value, $Res Function(DocumentState) _then) = _$DocumentStateCopyWithImpl;
@useResult
$Res call({
 DocumentTimeline timeline, ProjectDocument savedDocument, String? savePath, int generation
});


$ProjectDocumentCopyWith<$Res> get savedDocument;

}
/// @nodoc
class _$DocumentStateCopyWithImpl<$Res>
    implements $DocumentStateCopyWith<$Res> {
  _$DocumentStateCopyWithImpl(this._self, this._then);

  final DocumentState _self;
  final $Res Function(DocumentState) _then;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeline = null,Object? savedDocument = null,Object? savePath = freezed,Object? generation = null,}) {
  return _then(DocumentState(
timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as DocumentTimeline,savedDocument: null == savedDocument ? _self.savedDocument : savedDocument // ignore: cast_nullable_to_non_nullable
as ProjectDocument,savePath: freezed == savePath ? _self.savePath : savePath // ignore: cast_nullable_to_non_nullable
as String?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectDocumentCopyWith<$Res> get savedDocument {
  
  return $ProjectDocumentCopyWith<$Res>(_self.savedDocument, (value) {
    return _then(_self.copyWith(savedDocument: value));
  });
}
}


/// Adds pattern-matching-related methods to [DocumentState].
extension DocumentStatePatterns on DocumentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentState value)  $default,){
final _that = this;
switch (_that) {
case _DocumentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentState value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DocumentTimeline timeline,  ProjectDocument savedDocument,  String? savePath,  int generation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentState() when $default != null:
return $default(_that.timeline,_that.savedDocument,_that.savePath,_that.generation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DocumentTimeline timeline,  ProjectDocument savedDocument,  String? savePath,  int generation)  $default,) {final _that = this;
switch (_that) {
case _DocumentState():
return $default(_that.timeline,_that.savedDocument,_that.savePath,_that.generation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DocumentTimeline timeline,  ProjectDocument savedDocument,  String? savePath,  int generation)?  $default,) {final _that = this;
switch (_that) {
case _DocumentState() when $default != null:
return $default(_that.timeline,_that.savedDocument,_that.savePath,_that.generation);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentState extends DocumentState {
  const _DocumentState({required this.timeline, required this.savedDocument, this.savePath, this.generation = 0}): super._();
  

@override final  DocumentTimeline timeline;
/// The document as last saved or loaded; [isDirty] compares against it.
@override final  ProjectDocument savedDocument;
/// Where the project was last saved or loaded from. `null` if never saved.
@override final  String? savePath;
/// Increments whenever a different project is opened or created, so
/// editor state (selection, preview…) can reset itself.
@override@JsonKey() final  int generation;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentStateCopyWith<_DocumentState> get copyWith => __$DocumentStateCopyWithImpl<_DocumentState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentState&&(identical(other.timeline, timeline) || other.timeline == timeline)&&(identical(other.savedDocument, savedDocument) || other.savedDocument == savedDocument)&&(identical(other.savePath, savePath) || other.savePath == savePath)&&(identical(other.generation, generation) || other.generation == generation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,timeline,savedDocument,savePath,generation);
}

@override
String toString() {
    return 'DocumentState(timeline: $timeline, savedDocument: $savedDocument, savePath: $savePath, generation: $generation)';
}


}

/// @nodoc
abstract mixin class _$DocumentStateCopyWith<$Res> implements $DocumentStateCopyWith<$Res> {
  factory _$DocumentStateCopyWith(_DocumentState value, $Res Function(_DocumentState) _then) = __$DocumentStateCopyWithImpl;
@override @useResult
$Res call({
 DocumentTimeline timeline, ProjectDocument savedDocument, String? savePath, int generation
});


@override $ProjectDocumentCopyWith<$Res> get savedDocument;

}
/// @nodoc
class __$DocumentStateCopyWithImpl<$Res>
    implements _$DocumentStateCopyWith<$Res> {
  __$DocumentStateCopyWithImpl(this._self, this._then);

  final _DocumentState _self;
  final $Res Function(_DocumentState) _then;

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeline = null,Object? savedDocument = null,Object? savePath = freezed,Object? generation = null,}) {
  return _then(_DocumentState(
timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as DocumentTimeline,savedDocument: null == savedDocument ? _self.savedDocument : savedDocument // ignore: cast_nullable_to_non_nullable
as ProjectDocument,savePath: freezed == savePath ? _self.savePath : savePath // ignore: cast_nullable_to_non_nullable
as String?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DocumentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectDocumentCopyWith<$Res> get savedDocument {
  
  return $ProjectDocumentCopyWith<$Res>(_self.savedDocument, (value) {
    return _then(_self.copyWith(savedDocument: value));
  });
}
}

// dart format on
