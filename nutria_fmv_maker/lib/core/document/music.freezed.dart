// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'music.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MusicCue {

 String get audioId; FmvMusicEnd get end; bool get loop; int get fadeOutMs;/// Pauses while the video is paused at its end ("pause on end").
 bool get pauseWithVideo;
/// Create a copy of MusicCue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MusicCueCopyWith<MusicCue> get copyWith => _$MusicCueCopyWithImpl<MusicCue>(this as MusicCue, _$identity);

  /// Serializes this MusicCue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MusicCue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MusicCue&&(identical(other.audioId, _this.audioId) || other.audioId == _this.audioId)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.loop, _this.loop) || other.loop == _this.loop)&&(identical(other.fadeOutMs, _this.fadeOutMs) || other.fadeOutMs == _this.fadeOutMs)&&(identical(other.pauseWithVideo, _this.pauseWithVideo) || other.pauseWithVideo == _this.pauseWithVideo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MusicCue;
  return Object.hash(runtimeType,_this.audioId,_this.end,_this.loop,_this.fadeOutMs,_this.pauseWithVideo);
}

@override
String toString() {
  final _this = this as MusicCue;
  return 'MusicCue(audioId: ${_this.audioId}, end: ${_this.end}, loop: ${_this.loop}, fadeOutMs: ${_this.fadeOutMs}, pauseWithVideo: ${_this.pauseWithVideo})';
}


}

/// @nodoc
abstract mixin class $MusicCueCopyWith<$Res>  {
  factory $MusicCueCopyWith(MusicCue value, $Res Function(MusicCue) _then) = _$MusicCueCopyWithImpl;
@useResult
$Res call({
 String audioId, FmvMusicEnd end, bool loop, int fadeOutMs, bool pauseWithVideo
});




}
/// @nodoc
class _$MusicCueCopyWithImpl<$Res>
    implements $MusicCueCopyWith<$Res> {
  _$MusicCueCopyWithImpl(this._self, this._then);

  final MusicCue _self;
  final $Res Function(MusicCue) _then;

/// Create a copy of MusicCue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? audioId = null,Object? end = null,Object? loop = null,Object? fadeOutMs = null,Object? pauseWithVideo = null,}) {
  return _then(MusicCue(
audioId: null == audioId ? _self.audioId : audioId // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as FmvMusicEnd,loop: null == loop ? _self.loop : loop // ignore: cast_nullable_to_non_nullable
as bool,fadeOutMs: null == fadeOutMs ? _self.fadeOutMs : fadeOutMs // ignore: cast_nullable_to_non_nullable
as int,pauseWithVideo: null == pauseWithVideo ? _self.pauseWithVideo : pauseWithVideo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MusicCue].
extension MusicCuePatterns on MusicCue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MusicCue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MusicCue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MusicCue value)  $default,){
final _that = this;
switch (_that) {
case _MusicCue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MusicCue value)?  $default,){
final _that = this;
switch (_that) {
case _MusicCue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String audioId,  FmvMusicEnd end,  bool loop,  int fadeOutMs,  bool pauseWithVideo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MusicCue() when $default != null:
return $default(_that.audioId,_that.end,_that.loop,_that.fadeOutMs,_that.pauseWithVideo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String audioId,  FmvMusicEnd end,  bool loop,  int fadeOutMs,  bool pauseWithVideo)  $default,) {final _that = this;
switch (_that) {
case _MusicCue():
return $default(_that.audioId,_that.end,_that.loop,_that.fadeOutMs,_that.pauseWithVideo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String audioId,  FmvMusicEnd end,  bool loop,  int fadeOutMs,  bool pauseWithVideo)?  $default,) {final _that = this;
switch (_that) {
case _MusicCue() when $default != null:
return $default(_that.audioId,_that.end,_that.loop,_that.fadeOutMs,_that.pauseWithVideo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MusicCue implements MusicCue {
  const _MusicCue({required this.audioId, this.end = FmvMusicEnd.videoEnds, this.loop = false, this.fadeOutMs = 1000, this.pauseWithVideo = true});
  factory _MusicCue.fromJson(Map<String, dynamic> json) => _$MusicCueFromJson(json);

@override final  String audioId;
@override@JsonKey() final  FmvMusicEnd end;
@override@JsonKey() final  bool loop;
@override@JsonKey() final  int fadeOutMs;
/// Pauses while the video is paused at its end ("pause on end").
@override@JsonKey() final  bool pauseWithVideo;

/// Create a copy of MusicCue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MusicCueCopyWith<_MusicCue> get copyWith => __$MusicCueCopyWithImpl<_MusicCue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MusicCueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MusicCue&&(identical(other.audioId, audioId) || other.audioId == audioId)&&(identical(other.end, end) || other.end == end)&&(identical(other.loop, loop) || other.loop == loop)&&(identical(other.fadeOutMs, fadeOutMs) || other.fadeOutMs == fadeOutMs)&&(identical(other.pauseWithVideo, pauseWithVideo) || other.pauseWithVideo == pauseWithVideo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,audioId,end,loop,fadeOutMs,pauseWithVideo);
}

@override
String toString() {
    return 'MusicCue(audioId: $audioId, end: $end, loop: $loop, fadeOutMs: $fadeOutMs, pauseWithVideo: $pauseWithVideo)';
}


}

/// @nodoc
abstract mixin class _$MusicCueCopyWith<$Res> implements $MusicCueCopyWith<$Res> {
  factory _$MusicCueCopyWith(_MusicCue value, $Res Function(_MusicCue) _then) = __$MusicCueCopyWithImpl;
@override @useResult
$Res call({
 String audioId, FmvMusicEnd end, bool loop, int fadeOutMs, bool pauseWithVideo
});




}
/// @nodoc
class __$MusicCueCopyWithImpl<$Res>
    implements _$MusicCueCopyWith<$Res> {
  __$MusicCueCopyWithImpl(this._self, this._then);

  final _MusicCue _self;
  final $Res Function(_MusicCue) _then;

/// Create a copy of MusicCue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? audioId = null,Object? end = null,Object? loop = null,Object? fadeOutMs = null,Object? pauseWithVideo = null,}) {
  return _then(_MusicCue(
audioId: null == audioId ? _self.audioId : audioId // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as FmvMusicEnd,loop: null == loop ? _self.loop : loop // ignore: cast_nullable_to_non_nullable
as bool,fadeOutMs: null == fadeOutMs ? _self.fadeOutMs : fadeOutMs // ignore: cast_nullable_to_non_nullable
as int,pauseWithVideo: null == pauseWithVideo ? _self.pauseWithVideo : pauseWithVideo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
