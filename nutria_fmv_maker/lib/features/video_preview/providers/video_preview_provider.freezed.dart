// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_preview_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PreviewTarget implements DiagnosticableTreeMixin {

/// The imported file shown; the player plays it if it is a video or
/// audio.
 String get mediaId;/// The node being previewed, if the preview came from a node.
 String? get nodeId;
/// Create a copy of PreviewTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviewTargetCopyWith<PreviewTarget> get copyWith => _$PreviewTargetCopyWithImpl<PreviewTarget>(this as PreviewTarget, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as PreviewTarget;
  properties
    ..add(DiagnosticsProperty('type', 'PreviewTarget'))
    ..add(DiagnosticsProperty('mediaId', _this.mediaId))..add(DiagnosticsProperty('nodeId', _this.nodeId));
}

@override
bool operator ==(Object other) {
  final _this = this as PreviewTarget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewTarget&&(identical(other.mediaId, _this.mediaId) || other.mediaId == _this.mediaId)&&(identical(other.nodeId, _this.nodeId) || other.nodeId == _this.nodeId));
}


@override
int get hashCode {
  final _this = this as PreviewTarget;
  return Object.hash(runtimeType,_this.mediaId,_this.nodeId);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as PreviewTarget;
  return 'PreviewTarget(mediaId: ${_this.mediaId}, nodeId: ${_this.nodeId})';
}


}

/// @nodoc
abstract mixin class $PreviewTargetCopyWith<$Res>  {
  factory $PreviewTargetCopyWith(PreviewTarget value, $Res Function(PreviewTarget) _then) = _$PreviewTargetCopyWithImpl;
@useResult
$Res call({
 String mediaId, String? nodeId
});




}
/// @nodoc
class _$PreviewTargetCopyWithImpl<$Res>
    implements $PreviewTargetCopyWith<$Res> {
  _$PreviewTargetCopyWithImpl(this._self, this._then);

  final PreviewTarget _self;
  final $Res Function(PreviewTarget) _then;

/// Create a copy of PreviewTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaId = null,Object? nodeId = freezed,}) {
  return _then(PreviewTarget(
mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,nodeId: freezed == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PreviewTarget].
extension PreviewTargetPatterns on PreviewTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreviewTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreviewTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreviewTarget value)  $default,){
final _that = this;
switch (_that) {
case _PreviewTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreviewTarget value)?  $default,){
final _that = this;
switch (_that) {
case _PreviewTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mediaId,  String? nodeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreviewTarget() when $default != null:
return $default(_that.mediaId,_that.nodeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mediaId,  String? nodeId)  $default,) {final _that = this;
switch (_that) {
case _PreviewTarget():
return $default(_that.mediaId,_that.nodeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mediaId,  String? nodeId)?  $default,) {final _that = this;
switch (_that) {
case _PreviewTarget() when $default != null:
return $default(_that.mediaId,_that.nodeId);case _:
  return null;

}
}

}

/// @nodoc


class _PreviewTarget with DiagnosticableTreeMixin implements PreviewTarget {
  const _PreviewTarget({required this.mediaId, this.nodeId});
  

/// The imported file shown; the player plays it if it is a video or
/// audio.
@override final  String mediaId;
/// The node being previewed, if the preview came from a node.
@override final  String? nodeId;

/// Create a copy of PreviewTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviewTargetCopyWith<_PreviewTarget> get copyWith => __$PreviewTargetCopyWithImpl<_PreviewTarget>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'PreviewTarget'))
    ..add(DiagnosticsProperty('mediaId', mediaId))..add(DiagnosticsProperty('nodeId', nodeId));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviewTarget&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mediaId,nodeId);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'PreviewTarget(mediaId: $mediaId, nodeId: $nodeId)';
}


}

/// @nodoc
abstract mixin class _$PreviewTargetCopyWith<$Res> implements $PreviewTargetCopyWith<$Res> {
  factory _$PreviewTargetCopyWith(_PreviewTarget value, $Res Function(_PreviewTarget) _then) = __$PreviewTargetCopyWithImpl;
@override @useResult
$Res call({
 String mediaId, String? nodeId
});




}
/// @nodoc
class __$PreviewTargetCopyWithImpl<$Res>
    implements _$PreviewTargetCopyWith<$Res> {
  __$PreviewTargetCopyWithImpl(this._self, this._then);

  final _PreviewTarget _self;
  final $Res Function(_PreviewTarget) _then;

/// Create a copy of PreviewTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaId = null,Object? nodeId = freezed,}) {
  return _then(_PreviewTarget(
mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,nodeId: freezed == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
