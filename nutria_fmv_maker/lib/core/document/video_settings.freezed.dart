// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoSettings {

/// Time, in milliseconds before the end of the video, when choices appear.
 int get selectionTimeMs;/// Whether playback pauses when the choices appear instead of auto-selecting.
 bool get pauseOnEnd;/// Whether the Player shows the remaining-time bar.
 bool get showTimer;/// Whether branched nodes show their question above the answers.
 bool get showQuestion; VideoFit get videoFit; DefaultSelectionMethod get defaultSelection;/// The music with the video; [kNoMusic] (an empty track) for none, so a
/// node can override its defaults' music with silence.
 MusicCue get music;/// Imported audio that loops while the viewer chooses; `''` for none
/// (so a node can override it to "no music").
 String get pauseMusicId; int get pauseMusicFadeOutMs;/// The id of the answer screen. A screen that's gone falls back to the
/// first one.
 String get choiceScreenId;
/// Create a copy of VideoSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoSettingsCopyWith<VideoSettings> get copyWith => _$VideoSettingsCopyWithImpl<VideoSettings>(this as VideoSettings, _$identity);

  /// Serializes this VideoSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VideoSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoSettings&&(identical(other.selectionTimeMs, _this.selectionTimeMs) || other.selectionTimeMs == _this.selectionTimeMs)&&(identical(other.pauseOnEnd, _this.pauseOnEnd) || other.pauseOnEnd == _this.pauseOnEnd)&&(identical(other.showTimer, _this.showTimer) || other.showTimer == _this.showTimer)&&(identical(other.showQuestion, _this.showQuestion) || other.showQuestion == _this.showQuestion)&&(identical(other.videoFit, _this.videoFit) || other.videoFit == _this.videoFit)&&(identical(other.defaultSelection, _this.defaultSelection) || other.defaultSelection == _this.defaultSelection)&&(identical(other.music, _this.music) || other.music == _this.music)&&(identical(other.pauseMusicId, _this.pauseMusicId) || other.pauseMusicId == _this.pauseMusicId)&&(identical(other.pauseMusicFadeOutMs, _this.pauseMusicFadeOutMs) || other.pauseMusicFadeOutMs == _this.pauseMusicFadeOutMs)&&(identical(other.choiceScreenId, _this.choiceScreenId) || other.choiceScreenId == _this.choiceScreenId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VideoSettings;
  return Object.hash(runtimeType,_this.selectionTimeMs,_this.pauseOnEnd,_this.showTimer,_this.showQuestion,_this.videoFit,_this.defaultSelection,_this.music,_this.pauseMusicId,_this.pauseMusicFadeOutMs,_this.choiceScreenId);
}

@override
String toString() {
  final _this = this as VideoSettings;
  return 'VideoSettings(selectionTimeMs: ${_this.selectionTimeMs}, pauseOnEnd: ${_this.pauseOnEnd}, showTimer: ${_this.showTimer}, showQuestion: ${_this.showQuestion}, videoFit: ${_this.videoFit}, defaultSelection: ${_this.defaultSelection}, music: ${_this.music}, pauseMusicId: ${_this.pauseMusicId}, pauseMusicFadeOutMs: ${_this.pauseMusicFadeOutMs}, choiceScreenId: ${_this.choiceScreenId})';
}


}

/// @nodoc
abstract mixin class $VideoSettingsCopyWith<$Res>  {
  factory $VideoSettingsCopyWith(VideoSettings value, $Res Function(VideoSettings) _then) = _$VideoSettingsCopyWithImpl;
@useResult
$Res call({
 int selectionTimeMs, bool pauseOnEnd, bool showTimer, bool showQuestion, VideoFit videoFit, DefaultSelectionMethod defaultSelection, MusicCue music, String pauseMusicId, int pauseMusicFadeOutMs, String choiceScreenId
});


$MusicCueCopyWith<$Res> get music;

}
/// @nodoc
class _$VideoSettingsCopyWithImpl<$Res>
    implements $VideoSettingsCopyWith<$Res> {
  _$VideoSettingsCopyWithImpl(this._self, this._then);

  final VideoSettings _self;
  final $Res Function(VideoSettings) _then;

/// Create a copy of VideoSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectionTimeMs = null,Object? pauseOnEnd = null,Object? showTimer = null,Object? showQuestion = null,Object? videoFit = null,Object? defaultSelection = null,Object? music = null,Object? pauseMusicId = null,Object? pauseMusicFadeOutMs = null,Object? choiceScreenId = null,}) {
  return _then(VideoSettings(
selectionTimeMs: null == selectionTimeMs ? _self.selectionTimeMs : selectionTimeMs // ignore: cast_nullable_to_non_nullable
as int,pauseOnEnd: null == pauseOnEnd ? _self.pauseOnEnd : pauseOnEnd // ignore: cast_nullable_to_non_nullable
as bool,showTimer: null == showTimer ? _self.showTimer : showTimer // ignore: cast_nullable_to_non_nullable
as bool,showQuestion: null == showQuestion ? _self.showQuestion : showQuestion // ignore: cast_nullable_to_non_nullable
as bool,videoFit: null == videoFit ? _self.videoFit : videoFit // ignore: cast_nullable_to_non_nullable
as VideoFit,defaultSelection: null == defaultSelection ? _self.defaultSelection : defaultSelection // ignore: cast_nullable_to_non_nullable
as DefaultSelectionMethod,music: null == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as MusicCue,pauseMusicId: null == pauseMusicId ? _self.pauseMusicId : pauseMusicId // ignore: cast_nullable_to_non_nullable
as String,pauseMusicFadeOutMs: null == pauseMusicFadeOutMs ? _self.pauseMusicFadeOutMs : pauseMusicFadeOutMs // ignore: cast_nullable_to_non_nullable
as int,choiceScreenId: null == choiceScreenId ? _self.choiceScreenId : choiceScreenId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of VideoSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MusicCueCopyWith<$Res> get music {
  
  return $MusicCueCopyWith<$Res>(_self.music, (value) {
    return _then(_self.copyWith(music: value));
  });
}
}


/// Adds pattern-matching-related methods to [VideoSettings].
extension VideoSettingsPatterns on VideoSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoSettings value)  $default,){
final _that = this;
switch (_that) {
case _VideoSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoSettings value)?  $default,){
final _that = this;
switch (_that) {
case _VideoSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int selectionTimeMs,  bool pauseOnEnd,  bool showTimer,  bool showQuestion,  VideoFit videoFit,  DefaultSelectionMethod defaultSelection,  MusicCue music,  String pauseMusicId,  int pauseMusicFadeOutMs,  String choiceScreenId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoSettings() when $default != null:
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.showQuestion,_that.videoFit,_that.defaultSelection,_that.music,_that.pauseMusicId,_that.pauseMusicFadeOutMs,_that.choiceScreenId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int selectionTimeMs,  bool pauseOnEnd,  bool showTimer,  bool showQuestion,  VideoFit videoFit,  DefaultSelectionMethod defaultSelection,  MusicCue music,  String pauseMusicId,  int pauseMusicFadeOutMs,  String choiceScreenId)  $default,) {final _that = this;
switch (_that) {
case _VideoSettings():
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.showQuestion,_that.videoFit,_that.defaultSelection,_that.music,_that.pauseMusicId,_that.pauseMusicFadeOutMs,_that.choiceScreenId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int selectionTimeMs,  bool pauseOnEnd,  bool showTimer,  bool showQuestion,  VideoFit videoFit,  DefaultSelectionMethod defaultSelection,  MusicCue music,  String pauseMusicId,  int pauseMusicFadeOutMs,  String choiceScreenId)?  $default,) {final _that = this;
switch (_that) {
case _VideoSettings() when $default != null:
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.showQuestion,_that.videoFit,_that.defaultSelection,_that.music,_that.pauseMusicId,_that.pauseMusicFadeOutMs,_that.choiceScreenId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoSettings extends VideoSettings {
  const _VideoSettings({this.selectionTimeMs = 6000, this.pauseOnEnd = false, this.showTimer = true, this.showQuestion = false, this.videoFit = VideoFit.fit, this.defaultSelection = DefaultSelectionMethod.first, this.music = kNoMusic, this.pauseMusicId = '', this.pauseMusicFadeOutMs = 1000, this.choiceScreenId = 'choice'}): super._();
  factory _VideoSettings.fromJson(Map<String, dynamic> json) => _$VideoSettingsFromJson(json);

/// Time, in milliseconds before the end of the video, when choices appear.
@override@JsonKey() final  int selectionTimeMs;
/// Whether playback pauses when the choices appear instead of auto-selecting.
@override@JsonKey() final  bool pauseOnEnd;
/// Whether the Player shows the remaining-time bar.
@override@JsonKey() final  bool showTimer;
/// Whether branched nodes show their question above the answers.
@override@JsonKey() final  bool showQuestion;
@override@JsonKey() final  VideoFit videoFit;
@override@JsonKey() final  DefaultSelectionMethod defaultSelection;
/// The music with the video; [kNoMusic] (an empty track) for none, so a
/// node can override its defaults' music with silence.
@override@JsonKey() final  MusicCue music;
/// Imported audio that loops while the viewer chooses; `''` for none
/// (so a node can override it to "no music").
@override@JsonKey() final  String pauseMusicId;
@override@JsonKey() final  int pauseMusicFadeOutMs;
/// The id of the answer screen. A screen that's gone falls back to the
/// first one.
@override@JsonKey() final  String choiceScreenId;

/// Create a copy of VideoSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoSettingsCopyWith<_VideoSettings> get copyWith => __$VideoSettingsCopyWithImpl<_VideoSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoSettings&&(identical(other.selectionTimeMs, selectionTimeMs) || other.selectionTimeMs == selectionTimeMs)&&(identical(other.pauseOnEnd, pauseOnEnd) || other.pauseOnEnd == pauseOnEnd)&&(identical(other.showTimer, showTimer) || other.showTimer == showTimer)&&(identical(other.showQuestion, showQuestion) || other.showQuestion == showQuestion)&&(identical(other.videoFit, videoFit) || other.videoFit == videoFit)&&(identical(other.defaultSelection, defaultSelection) || other.defaultSelection == defaultSelection)&&(identical(other.music, music) || other.music == music)&&(identical(other.pauseMusicId, pauseMusicId) || other.pauseMusicId == pauseMusicId)&&(identical(other.pauseMusicFadeOutMs, pauseMusicFadeOutMs) || other.pauseMusicFadeOutMs == pauseMusicFadeOutMs)&&(identical(other.choiceScreenId, choiceScreenId) || other.choiceScreenId == choiceScreenId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,selectionTimeMs,pauseOnEnd,showTimer,showQuestion,videoFit,defaultSelection,music,pauseMusicId,pauseMusicFadeOutMs,choiceScreenId);
}

@override
String toString() {
    return 'VideoSettings(selectionTimeMs: $selectionTimeMs, pauseOnEnd: $pauseOnEnd, showTimer: $showTimer, showQuestion: $showQuestion, videoFit: $videoFit, defaultSelection: $defaultSelection, music: $music, pauseMusicId: $pauseMusicId, pauseMusicFadeOutMs: $pauseMusicFadeOutMs, choiceScreenId: $choiceScreenId)';
}


}

/// @nodoc
abstract mixin class _$VideoSettingsCopyWith<$Res> implements $VideoSettingsCopyWith<$Res> {
  factory _$VideoSettingsCopyWith(_VideoSettings value, $Res Function(_VideoSettings) _then) = __$VideoSettingsCopyWithImpl;
@override @useResult
$Res call({
 int selectionTimeMs, bool pauseOnEnd, bool showTimer, bool showQuestion, VideoFit videoFit, DefaultSelectionMethod defaultSelection, MusicCue music, String pauseMusicId, int pauseMusicFadeOutMs, String choiceScreenId
});


@override $MusicCueCopyWith<$Res> get music;

}
/// @nodoc
class __$VideoSettingsCopyWithImpl<$Res>
    implements _$VideoSettingsCopyWith<$Res> {
  __$VideoSettingsCopyWithImpl(this._self, this._then);

  final _VideoSettings _self;
  final $Res Function(_VideoSettings) _then;

/// Create a copy of VideoSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectionTimeMs = null,Object? pauseOnEnd = null,Object? showTimer = null,Object? showQuestion = null,Object? videoFit = null,Object? defaultSelection = null,Object? music = null,Object? pauseMusicId = null,Object? pauseMusicFadeOutMs = null,Object? choiceScreenId = null,}) {
  return _then(_VideoSettings(
selectionTimeMs: null == selectionTimeMs ? _self.selectionTimeMs : selectionTimeMs // ignore: cast_nullable_to_non_nullable
as int,pauseOnEnd: null == pauseOnEnd ? _self.pauseOnEnd : pauseOnEnd // ignore: cast_nullable_to_non_nullable
as bool,showTimer: null == showTimer ? _self.showTimer : showTimer // ignore: cast_nullable_to_non_nullable
as bool,showQuestion: null == showQuestion ? _self.showQuestion : showQuestion // ignore: cast_nullable_to_non_nullable
as bool,videoFit: null == videoFit ? _self.videoFit : videoFit // ignore: cast_nullable_to_non_nullable
as VideoFit,defaultSelection: null == defaultSelection ? _self.defaultSelection : defaultSelection // ignore: cast_nullable_to_non_nullable
as DefaultSelectionMethod,music: null == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as MusicCue,pauseMusicId: null == pauseMusicId ? _self.pauseMusicId : pauseMusicId // ignore: cast_nullable_to_non_nullable
as String,pauseMusicFadeOutMs: null == pauseMusicFadeOutMs ? _self.pauseMusicFadeOutMs : pauseMusicFadeOutMs // ignore: cast_nullable_to_non_nullable
as int,choiceScreenId: null == choiceScreenId ? _self.choiceScreenId : choiceScreenId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of VideoSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MusicCueCopyWith<$Res> get music {
  
  return $MusicCueCopyWith<$Res>(_self.music, (value) {
    return _then(_self.copyWith(music: value));
  });
}
}


/// @nodoc
mixin _$VideoSettingsOverride {

 int? get selectionTimeMs; bool? get pauseOnEnd; bool? get showTimer; bool? get showQuestion; VideoFit? get videoFit; DefaultSelectionMethod? get defaultSelection; MusicCue? get music; String? get pauseMusicId; int? get pauseMusicFadeOutMs; String? get choiceScreenId;
/// Create a copy of VideoSettingsOverride
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoSettingsOverrideCopyWith<VideoSettingsOverride> get copyWith => _$VideoSettingsOverrideCopyWithImpl<VideoSettingsOverride>(this as VideoSettingsOverride, _$identity);

  /// Serializes this VideoSettingsOverride to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VideoSettingsOverride;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoSettingsOverride&&(identical(other.selectionTimeMs, _this.selectionTimeMs) || other.selectionTimeMs == _this.selectionTimeMs)&&(identical(other.pauseOnEnd, _this.pauseOnEnd) || other.pauseOnEnd == _this.pauseOnEnd)&&(identical(other.showTimer, _this.showTimer) || other.showTimer == _this.showTimer)&&(identical(other.showQuestion, _this.showQuestion) || other.showQuestion == _this.showQuestion)&&(identical(other.videoFit, _this.videoFit) || other.videoFit == _this.videoFit)&&(identical(other.defaultSelection, _this.defaultSelection) || other.defaultSelection == _this.defaultSelection)&&(identical(other.music, _this.music) || other.music == _this.music)&&(identical(other.pauseMusicId, _this.pauseMusicId) || other.pauseMusicId == _this.pauseMusicId)&&(identical(other.pauseMusicFadeOutMs, _this.pauseMusicFadeOutMs) || other.pauseMusicFadeOutMs == _this.pauseMusicFadeOutMs)&&(identical(other.choiceScreenId, _this.choiceScreenId) || other.choiceScreenId == _this.choiceScreenId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VideoSettingsOverride;
  return Object.hash(runtimeType,_this.selectionTimeMs,_this.pauseOnEnd,_this.showTimer,_this.showQuestion,_this.videoFit,_this.defaultSelection,_this.music,_this.pauseMusicId,_this.pauseMusicFadeOutMs,_this.choiceScreenId);
}

@override
String toString() {
  final _this = this as VideoSettingsOverride;
  return 'VideoSettingsOverride(selectionTimeMs: ${_this.selectionTimeMs}, pauseOnEnd: ${_this.pauseOnEnd}, showTimer: ${_this.showTimer}, showQuestion: ${_this.showQuestion}, videoFit: ${_this.videoFit}, defaultSelection: ${_this.defaultSelection}, music: ${_this.music}, pauseMusicId: ${_this.pauseMusicId}, pauseMusicFadeOutMs: ${_this.pauseMusicFadeOutMs}, choiceScreenId: ${_this.choiceScreenId})';
}


}

/// @nodoc
abstract mixin class $VideoSettingsOverrideCopyWith<$Res>  {
  factory $VideoSettingsOverrideCopyWith(VideoSettingsOverride value, $Res Function(VideoSettingsOverride) _then) = _$VideoSettingsOverrideCopyWithImpl;
@useResult
$Res call({
 int? selectionTimeMs, bool? pauseOnEnd, bool? showTimer, bool? showQuestion, VideoFit? videoFit, DefaultSelectionMethod? defaultSelection, MusicCue? music, String? pauseMusicId, int? pauseMusicFadeOutMs, String? choiceScreenId
});


$MusicCueCopyWith<$Res>? get music;

}
/// @nodoc
class _$VideoSettingsOverrideCopyWithImpl<$Res>
    implements $VideoSettingsOverrideCopyWith<$Res> {
  _$VideoSettingsOverrideCopyWithImpl(this._self, this._then);

  final VideoSettingsOverride _self;
  final $Res Function(VideoSettingsOverride) _then;

/// Create a copy of VideoSettingsOverride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectionTimeMs = freezed,Object? pauseOnEnd = freezed,Object? showTimer = freezed,Object? showQuestion = freezed,Object? videoFit = freezed,Object? defaultSelection = freezed,Object? music = freezed,Object? pauseMusicId = freezed,Object? pauseMusicFadeOutMs = freezed,Object? choiceScreenId = freezed,}) {
  return _then(VideoSettingsOverride(
selectionTimeMs: freezed == selectionTimeMs ? _self.selectionTimeMs : selectionTimeMs // ignore: cast_nullable_to_non_nullable
as int?,pauseOnEnd: freezed == pauseOnEnd ? _self.pauseOnEnd : pauseOnEnd // ignore: cast_nullable_to_non_nullable
as bool?,showTimer: freezed == showTimer ? _self.showTimer : showTimer // ignore: cast_nullable_to_non_nullable
as bool?,showQuestion: freezed == showQuestion ? _self.showQuestion : showQuestion // ignore: cast_nullable_to_non_nullable
as bool?,videoFit: freezed == videoFit ? _self.videoFit : videoFit // ignore: cast_nullable_to_non_nullable
as VideoFit?,defaultSelection: freezed == defaultSelection ? _self.defaultSelection : defaultSelection // ignore: cast_nullable_to_non_nullable
as DefaultSelectionMethod?,music: freezed == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as MusicCue?,pauseMusicId: freezed == pauseMusicId ? _self.pauseMusicId : pauseMusicId // ignore: cast_nullable_to_non_nullable
as String?,pauseMusicFadeOutMs: freezed == pauseMusicFadeOutMs ? _self.pauseMusicFadeOutMs : pauseMusicFadeOutMs // ignore: cast_nullable_to_non_nullable
as int?,choiceScreenId: freezed == choiceScreenId ? _self.choiceScreenId : choiceScreenId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of VideoSettingsOverride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MusicCueCopyWith<$Res>? get music {
    if (_self.music == null) {
    return null;
  }

  return $MusicCueCopyWith<$Res>(_self.music!, (value) {
    return _then(_self.copyWith(music: value));
  });
}
}


/// Adds pattern-matching-related methods to [VideoSettingsOverride].
extension VideoSettingsOverridePatterns on VideoSettingsOverride {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoSettingsOverride value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoSettingsOverride() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoSettingsOverride value)  $default,){
final _that = this;
switch (_that) {
case _VideoSettingsOverride():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoSettingsOverride value)?  $default,){
final _that = this;
switch (_that) {
case _VideoSettingsOverride() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? selectionTimeMs,  bool? pauseOnEnd,  bool? showTimer,  bool? showQuestion,  VideoFit? videoFit,  DefaultSelectionMethod? defaultSelection,  MusicCue? music,  String? pauseMusicId,  int? pauseMusicFadeOutMs,  String? choiceScreenId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoSettingsOverride() when $default != null:
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.showQuestion,_that.videoFit,_that.defaultSelection,_that.music,_that.pauseMusicId,_that.pauseMusicFadeOutMs,_that.choiceScreenId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? selectionTimeMs,  bool? pauseOnEnd,  bool? showTimer,  bool? showQuestion,  VideoFit? videoFit,  DefaultSelectionMethod? defaultSelection,  MusicCue? music,  String? pauseMusicId,  int? pauseMusicFadeOutMs,  String? choiceScreenId)  $default,) {final _that = this;
switch (_that) {
case _VideoSettingsOverride():
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.showQuestion,_that.videoFit,_that.defaultSelection,_that.music,_that.pauseMusicId,_that.pauseMusicFadeOutMs,_that.choiceScreenId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? selectionTimeMs,  bool? pauseOnEnd,  bool? showTimer,  bool? showQuestion,  VideoFit? videoFit,  DefaultSelectionMethod? defaultSelection,  MusicCue? music,  String? pauseMusicId,  int? pauseMusicFadeOutMs,  String? choiceScreenId)?  $default,) {final _that = this;
switch (_that) {
case _VideoSettingsOverride() when $default != null:
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.showQuestion,_that.videoFit,_that.defaultSelection,_that.music,_that.pauseMusicId,_that.pauseMusicFadeOutMs,_that.choiceScreenId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoSettingsOverride extends VideoSettingsOverride {
  const _VideoSettingsOverride({this.selectionTimeMs, this.pauseOnEnd, this.showTimer, this.showQuestion, this.videoFit, this.defaultSelection, this.music, this.pauseMusicId, this.pauseMusicFadeOutMs, this.choiceScreenId}): super._();
  factory _VideoSettingsOverride.fromJson(Map<String, dynamic> json) => _$VideoSettingsOverrideFromJson(json);

@override final  int? selectionTimeMs;
@override final  bool? pauseOnEnd;
@override final  bool? showTimer;
@override final  bool? showQuestion;
@override final  VideoFit? videoFit;
@override final  DefaultSelectionMethod? defaultSelection;
@override final  MusicCue? music;
@override final  String? pauseMusicId;
@override final  int? pauseMusicFadeOutMs;
@override final  String? choiceScreenId;

/// Create a copy of VideoSettingsOverride
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoSettingsOverrideCopyWith<_VideoSettingsOverride> get copyWith => __$VideoSettingsOverrideCopyWithImpl<_VideoSettingsOverride>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoSettingsOverrideToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoSettingsOverride&&(identical(other.selectionTimeMs, selectionTimeMs) || other.selectionTimeMs == selectionTimeMs)&&(identical(other.pauseOnEnd, pauseOnEnd) || other.pauseOnEnd == pauseOnEnd)&&(identical(other.showTimer, showTimer) || other.showTimer == showTimer)&&(identical(other.showQuestion, showQuestion) || other.showQuestion == showQuestion)&&(identical(other.videoFit, videoFit) || other.videoFit == videoFit)&&(identical(other.defaultSelection, defaultSelection) || other.defaultSelection == defaultSelection)&&(identical(other.music, music) || other.music == music)&&(identical(other.pauseMusicId, pauseMusicId) || other.pauseMusicId == pauseMusicId)&&(identical(other.pauseMusicFadeOutMs, pauseMusicFadeOutMs) || other.pauseMusicFadeOutMs == pauseMusicFadeOutMs)&&(identical(other.choiceScreenId, choiceScreenId) || other.choiceScreenId == choiceScreenId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,selectionTimeMs,pauseOnEnd,showTimer,showQuestion,videoFit,defaultSelection,music,pauseMusicId,pauseMusicFadeOutMs,choiceScreenId);
}

@override
String toString() {
    return 'VideoSettingsOverride(selectionTimeMs: $selectionTimeMs, pauseOnEnd: $pauseOnEnd, showTimer: $showTimer, showQuestion: $showQuestion, videoFit: $videoFit, defaultSelection: $defaultSelection, music: $music, pauseMusicId: $pauseMusicId, pauseMusicFadeOutMs: $pauseMusicFadeOutMs, choiceScreenId: $choiceScreenId)';
}


}

/// @nodoc
abstract mixin class _$VideoSettingsOverrideCopyWith<$Res> implements $VideoSettingsOverrideCopyWith<$Res> {
  factory _$VideoSettingsOverrideCopyWith(_VideoSettingsOverride value, $Res Function(_VideoSettingsOverride) _then) = __$VideoSettingsOverrideCopyWithImpl;
@override @useResult
$Res call({
 int? selectionTimeMs, bool? pauseOnEnd, bool? showTimer, bool? showQuestion, VideoFit? videoFit, DefaultSelectionMethod? defaultSelection, MusicCue? music, String? pauseMusicId, int? pauseMusicFadeOutMs, String? choiceScreenId
});


@override $MusicCueCopyWith<$Res>? get music;

}
/// @nodoc
class __$VideoSettingsOverrideCopyWithImpl<$Res>
    implements _$VideoSettingsOverrideCopyWith<$Res> {
  __$VideoSettingsOverrideCopyWithImpl(this._self, this._then);

  final _VideoSettingsOverride _self;
  final $Res Function(_VideoSettingsOverride) _then;

/// Create a copy of VideoSettingsOverride
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectionTimeMs = freezed,Object? pauseOnEnd = freezed,Object? showTimer = freezed,Object? showQuestion = freezed,Object? videoFit = freezed,Object? defaultSelection = freezed,Object? music = freezed,Object? pauseMusicId = freezed,Object? pauseMusicFadeOutMs = freezed,Object? choiceScreenId = freezed,}) {
  return _then(_VideoSettingsOverride(
selectionTimeMs: freezed == selectionTimeMs ? _self.selectionTimeMs : selectionTimeMs // ignore: cast_nullable_to_non_nullable
as int?,pauseOnEnd: freezed == pauseOnEnd ? _self.pauseOnEnd : pauseOnEnd // ignore: cast_nullable_to_non_nullable
as bool?,showTimer: freezed == showTimer ? _self.showTimer : showTimer // ignore: cast_nullable_to_non_nullable
as bool?,showQuestion: freezed == showQuestion ? _self.showQuestion : showQuestion // ignore: cast_nullable_to_non_nullable
as bool?,videoFit: freezed == videoFit ? _self.videoFit : videoFit // ignore: cast_nullable_to_non_nullable
as VideoFit?,defaultSelection: freezed == defaultSelection ? _self.defaultSelection : defaultSelection // ignore: cast_nullable_to_non_nullable
as DefaultSelectionMethod?,music: freezed == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as MusicCue?,pauseMusicId: freezed == pauseMusicId ? _self.pauseMusicId : pauseMusicId // ignore: cast_nullable_to_non_nullable
as String?,pauseMusicFadeOutMs: freezed == pauseMusicFadeOutMs ? _self.pauseMusicFadeOutMs : pauseMusicFadeOutMs // ignore: cast_nullable_to_non_nullable
as int?,choiceScreenId: freezed == choiceScreenId ? _self.choiceScreenId : choiceScreenId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of VideoSettingsOverride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MusicCueCopyWith<$Res>? get music {
    if (_self.music == null) {
    return null;
  }

  return $MusicCueCopyWith<$Res>(_self.music!, (value) {
    return _then(_self.copyWith(music: value));
  });
}
}

// dart format on
