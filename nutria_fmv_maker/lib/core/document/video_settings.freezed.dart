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
 bool get showTimer; VideoFit get videoFit; DefaultSelectionMethod get defaultSelection;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoSettings&&(identical(other.selectionTimeMs, _this.selectionTimeMs) || other.selectionTimeMs == _this.selectionTimeMs)&&(identical(other.pauseOnEnd, _this.pauseOnEnd) || other.pauseOnEnd == _this.pauseOnEnd)&&(identical(other.showTimer, _this.showTimer) || other.showTimer == _this.showTimer)&&(identical(other.videoFit, _this.videoFit) || other.videoFit == _this.videoFit)&&(identical(other.defaultSelection, _this.defaultSelection) || other.defaultSelection == _this.defaultSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VideoSettings;
  return Object.hash(runtimeType,_this.selectionTimeMs,_this.pauseOnEnd,_this.showTimer,_this.videoFit,_this.defaultSelection);
}

@override
String toString() {
  final _this = this as VideoSettings;
  return 'VideoSettings(selectionTimeMs: ${_this.selectionTimeMs}, pauseOnEnd: ${_this.pauseOnEnd}, showTimer: ${_this.showTimer}, videoFit: ${_this.videoFit}, defaultSelection: ${_this.defaultSelection})';
}


}

/// @nodoc
abstract mixin class $VideoSettingsCopyWith<$Res>  {
  factory $VideoSettingsCopyWith(VideoSettings value, $Res Function(VideoSettings) _then) = _$VideoSettingsCopyWithImpl;
@useResult
$Res call({
 int selectionTimeMs, bool pauseOnEnd, bool showTimer, VideoFit videoFit, DefaultSelectionMethod defaultSelection
});




}
/// @nodoc
class _$VideoSettingsCopyWithImpl<$Res>
    implements $VideoSettingsCopyWith<$Res> {
  _$VideoSettingsCopyWithImpl(this._self, this._then);

  final VideoSettings _self;
  final $Res Function(VideoSettings) _then;

/// Create a copy of VideoSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectionTimeMs = null,Object? pauseOnEnd = null,Object? showTimer = null,Object? videoFit = null,Object? defaultSelection = null,}) {
  return _then(VideoSettings(
selectionTimeMs: null == selectionTimeMs ? _self.selectionTimeMs : selectionTimeMs // ignore: cast_nullable_to_non_nullable
as int,pauseOnEnd: null == pauseOnEnd ? _self.pauseOnEnd : pauseOnEnd // ignore: cast_nullable_to_non_nullable
as bool,showTimer: null == showTimer ? _self.showTimer : showTimer // ignore: cast_nullable_to_non_nullable
as bool,videoFit: null == videoFit ? _self.videoFit : videoFit // ignore: cast_nullable_to_non_nullable
as VideoFit,defaultSelection: null == defaultSelection ? _self.defaultSelection : defaultSelection // ignore: cast_nullable_to_non_nullable
as DefaultSelectionMethod,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int selectionTimeMs,  bool pauseOnEnd,  bool showTimer,  VideoFit videoFit,  DefaultSelectionMethod defaultSelection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoSettings() when $default != null:
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.videoFit,_that.defaultSelection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int selectionTimeMs,  bool pauseOnEnd,  bool showTimer,  VideoFit videoFit,  DefaultSelectionMethod defaultSelection)  $default,) {final _that = this;
switch (_that) {
case _VideoSettings():
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.videoFit,_that.defaultSelection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int selectionTimeMs,  bool pauseOnEnd,  bool showTimer,  VideoFit videoFit,  DefaultSelectionMethod defaultSelection)?  $default,) {final _that = this;
switch (_that) {
case _VideoSettings() when $default != null:
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.videoFit,_that.defaultSelection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoSettings extends VideoSettings {
  const _VideoSettings({this.selectionTimeMs = 6000, this.pauseOnEnd = false, this.showTimer = true, this.videoFit = VideoFit.fit, this.defaultSelection = DefaultSelectionMethod.first}): super._();
  factory _VideoSettings.fromJson(Map<String, dynamic> json) => _$VideoSettingsFromJson(json);

/// Time, in milliseconds before the end of the video, when choices appear.
@override@JsonKey() final  int selectionTimeMs;
/// Whether playback pauses when the choices appear instead of auto-selecting.
@override@JsonKey() final  bool pauseOnEnd;
/// Whether the Player shows the remaining-time bar.
@override@JsonKey() final  bool showTimer;
@override@JsonKey() final  VideoFit videoFit;
@override@JsonKey() final  DefaultSelectionMethod defaultSelection;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoSettings&&(identical(other.selectionTimeMs, selectionTimeMs) || other.selectionTimeMs == selectionTimeMs)&&(identical(other.pauseOnEnd, pauseOnEnd) || other.pauseOnEnd == pauseOnEnd)&&(identical(other.showTimer, showTimer) || other.showTimer == showTimer)&&(identical(other.videoFit, videoFit) || other.videoFit == videoFit)&&(identical(other.defaultSelection, defaultSelection) || other.defaultSelection == defaultSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,selectionTimeMs,pauseOnEnd,showTimer,videoFit,defaultSelection);
}

@override
String toString() {
    return 'VideoSettings(selectionTimeMs: $selectionTimeMs, pauseOnEnd: $pauseOnEnd, showTimer: $showTimer, videoFit: $videoFit, defaultSelection: $defaultSelection)';
}


}

/// @nodoc
abstract mixin class _$VideoSettingsCopyWith<$Res> implements $VideoSettingsCopyWith<$Res> {
  factory _$VideoSettingsCopyWith(_VideoSettings value, $Res Function(_VideoSettings) _then) = __$VideoSettingsCopyWithImpl;
@override @useResult
$Res call({
 int selectionTimeMs, bool pauseOnEnd, bool showTimer, VideoFit videoFit, DefaultSelectionMethod defaultSelection
});




}
/// @nodoc
class __$VideoSettingsCopyWithImpl<$Res>
    implements _$VideoSettingsCopyWith<$Res> {
  __$VideoSettingsCopyWithImpl(this._self, this._then);

  final _VideoSettings _self;
  final $Res Function(_VideoSettings) _then;

/// Create a copy of VideoSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectionTimeMs = null,Object? pauseOnEnd = null,Object? showTimer = null,Object? videoFit = null,Object? defaultSelection = null,}) {
  return _then(_VideoSettings(
selectionTimeMs: null == selectionTimeMs ? _self.selectionTimeMs : selectionTimeMs // ignore: cast_nullable_to_non_nullable
as int,pauseOnEnd: null == pauseOnEnd ? _self.pauseOnEnd : pauseOnEnd // ignore: cast_nullable_to_non_nullable
as bool,showTimer: null == showTimer ? _self.showTimer : showTimer // ignore: cast_nullable_to_non_nullable
as bool,videoFit: null == videoFit ? _self.videoFit : videoFit // ignore: cast_nullable_to_non_nullable
as VideoFit,defaultSelection: null == defaultSelection ? _self.defaultSelection : defaultSelection // ignore: cast_nullable_to_non_nullable
as DefaultSelectionMethod,
  ));
}


}


/// @nodoc
mixin _$VideoSettingsOverride {

 int? get selectionTimeMs; bool? get pauseOnEnd; bool? get showTimer; VideoFit? get videoFit; DefaultSelectionMethod? get defaultSelection;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoSettingsOverride&&(identical(other.selectionTimeMs, _this.selectionTimeMs) || other.selectionTimeMs == _this.selectionTimeMs)&&(identical(other.pauseOnEnd, _this.pauseOnEnd) || other.pauseOnEnd == _this.pauseOnEnd)&&(identical(other.showTimer, _this.showTimer) || other.showTimer == _this.showTimer)&&(identical(other.videoFit, _this.videoFit) || other.videoFit == _this.videoFit)&&(identical(other.defaultSelection, _this.defaultSelection) || other.defaultSelection == _this.defaultSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VideoSettingsOverride;
  return Object.hash(runtimeType,_this.selectionTimeMs,_this.pauseOnEnd,_this.showTimer,_this.videoFit,_this.defaultSelection);
}

@override
String toString() {
  final _this = this as VideoSettingsOverride;
  return 'VideoSettingsOverride(selectionTimeMs: ${_this.selectionTimeMs}, pauseOnEnd: ${_this.pauseOnEnd}, showTimer: ${_this.showTimer}, videoFit: ${_this.videoFit}, defaultSelection: ${_this.defaultSelection})';
}


}

/// @nodoc
abstract mixin class $VideoSettingsOverrideCopyWith<$Res>  {
  factory $VideoSettingsOverrideCopyWith(VideoSettingsOverride value, $Res Function(VideoSettingsOverride) _then) = _$VideoSettingsOverrideCopyWithImpl;
@useResult
$Res call({
 int? selectionTimeMs, bool? pauseOnEnd, bool? showTimer, VideoFit? videoFit, DefaultSelectionMethod? defaultSelection
});




}
/// @nodoc
class _$VideoSettingsOverrideCopyWithImpl<$Res>
    implements $VideoSettingsOverrideCopyWith<$Res> {
  _$VideoSettingsOverrideCopyWithImpl(this._self, this._then);

  final VideoSettingsOverride _self;
  final $Res Function(VideoSettingsOverride) _then;

/// Create a copy of VideoSettingsOverride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectionTimeMs = freezed,Object? pauseOnEnd = freezed,Object? showTimer = freezed,Object? videoFit = freezed,Object? defaultSelection = freezed,}) {
  return _then(VideoSettingsOverride(
selectionTimeMs: freezed == selectionTimeMs ? _self.selectionTimeMs : selectionTimeMs // ignore: cast_nullable_to_non_nullable
as int?,pauseOnEnd: freezed == pauseOnEnd ? _self.pauseOnEnd : pauseOnEnd // ignore: cast_nullable_to_non_nullable
as bool?,showTimer: freezed == showTimer ? _self.showTimer : showTimer // ignore: cast_nullable_to_non_nullable
as bool?,videoFit: freezed == videoFit ? _self.videoFit : videoFit // ignore: cast_nullable_to_non_nullable
as VideoFit?,defaultSelection: freezed == defaultSelection ? _self.defaultSelection : defaultSelection // ignore: cast_nullable_to_non_nullable
as DefaultSelectionMethod?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? selectionTimeMs,  bool? pauseOnEnd,  bool? showTimer,  VideoFit? videoFit,  DefaultSelectionMethod? defaultSelection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoSettingsOverride() when $default != null:
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.videoFit,_that.defaultSelection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? selectionTimeMs,  bool? pauseOnEnd,  bool? showTimer,  VideoFit? videoFit,  DefaultSelectionMethod? defaultSelection)  $default,) {final _that = this;
switch (_that) {
case _VideoSettingsOverride():
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.videoFit,_that.defaultSelection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? selectionTimeMs,  bool? pauseOnEnd,  bool? showTimer,  VideoFit? videoFit,  DefaultSelectionMethod? defaultSelection)?  $default,) {final _that = this;
switch (_that) {
case _VideoSettingsOverride() when $default != null:
return $default(_that.selectionTimeMs,_that.pauseOnEnd,_that.showTimer,_that.videoFit,_that.defaultSelection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoSettingsOverride extends VideoSettingsOverride {
  const _VideoSettingsOverride({this.selectionTimeMs, this.pauseOnEnd, this.showTimer, this.videoFit, this.defaultSelection}): super._();
  factory _VideoSettingsOverride.fromJson(Map<String, dynamic> json) => _$VideoSettingsOverrideFromJson(json);

@override final  int? selectionTimeMs;
@override final  bool? pauseOnEnd;
@override final  bool? showTimer;
@override final  VideoFit? videoFit;
@override final  DefaultSelectionMethod? defaultSelection;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoSettingsOverride&&(identical(other.selectionTimeMs, selectionTimeMs) || other.selectionTimeMs == selectionTimeMs)&&(identical(other.pauseOnEnd, pauseOnEnd) || other.pauseOnEnd == pauseOnEnd)&&(identical(other.showTimer, showTimer) || other.showTimer == showTimer)&&(identical(other.videoFit, videoFit) || other.videoFit == videoFit)&&(identical(other.defaultSelection, defaultSelection) || other.defaultSelection == defaultSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,selectionTimeMs,pauseOnEnd,showTimer,videoFit,defaultSelection);
}

@override
String toString() {
    return 'VideoSettingsOverride(selectionTimeMs: $selectionTimeMs, pauseOnEnd: $pauseOnEnd, showTimer: $showTimer, videoFit: $videoFit, defaultSelection: $defaultSelection)';
}


}

/// @nodoc
abstract mixin class _$VideoSettingsOverrideCopyWith<$Res> implements $VideoSettingsOverrideCopyWith<$Res> {
  factory _$VideoSettingsOverrideCopyWith(_VideoSettingsOverride value, $Res Function(_VideoSettingsOverride) _then) = __$VideoSettingsOverrideCopyWithImpl;
@override @useResult
$Res call({
 int? selectionTimeMs, bool? pauseOnEnd, bool? showTimer, VideoFit? videoFit, DefaultSelectionMethod? defaultSelection
});




}
/// @nodoc
class __$VideoSettingsOverrideCopyWithImpl<$Res>
    implements _$VideoSettingsOverrideCopyWith<$Res> {
  __$VideoSettingsOverrideCopyWithImpl(this._self, this._then);

  final _VideoSettingsOverride _self;
  final $Res Function(_VideoSettingsOverride) _then;

/// Create a copy of VideoSettingsOverride
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectionTimeMs = freezed,Object? pauseOnEnd = freezed,Object? showTimer = freezed,Object? videoFit = freezed,Object? defaultSelection = freezed,}) {
  return _then(_VideoSettingsOverride(
selectionTimeMs: freezed == selectionTimeMs ? _self.selectionTimeMs : selectionTimeMs // ignore: cast_nullable_to_non_nullable
as int?,pauseOnEnd: freezed == pauseOnEnd ? _self.pauseOnEnd : pauseOnEnd // ignore: cast_nullable_to_non_nullable
as bool?,showTimer: freezed == showTimer ? _self.showTimer : showTimer // ignore: cast_nullable_to_non_nullable
as bool?,videoFit: freezed == videoFit ? _self.videoFit : videoFit // ignore: cast_nullable_to_non_nullable
as VideoFit?,defaultSelection: freezed == defaultSelection ? _self.defaultSelection : defaultSelection // ignore: cast_nullable_to_non_nullable
as DefaultSelectionMethod?,
  ));
}


}

// dart format on
