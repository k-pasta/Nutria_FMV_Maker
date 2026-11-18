// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Preferences {

/// Snap nodes to the grid while moving them (Shift does it temporarily).
 bool get gridSnapping; double get gridSize; DefaultNodeType get defaultNodeType; ThemeChoice get theme; String get languageCode; NoodleStyle get noodleStyle; LibraryView get libraryView; LibrarySort get librarySort; LibraryGrouping get libraryGrouping;/// Link a video and a subtitle file of the same name when importing.
 bool get autoLinkSubtitles;
/// Create a copy of Preferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesCopyWith<Preferences> get copyWith => _$PreferencesCopyWithImpl<Preferences>(this as Preferences, _$identity);

  /// Serializes this Preferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Preferences;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Preferences&&(identical(other.gridSnapping, _this.gridSnapping) || other.gridSnapping == _this.gridSnapping)&&(identical(other.gridSize, _this.gridSize) || other.gridSize == _this.gridSize)&&(identical(other.defaultNodeType, _this.defaultNodeType) || other.defaultNodeType == _this.defaultNodeType)&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode)&&(identical(other.noodleStyle, _this.noodleStyle) || other.noodleStyle == _this.noodleStyle)&&(identical(other.libraryView, _this.libraryView) || other.libraryView == _this.libraryView)&&(identical(other.librarySort, _this.librarySort) || other.librarySort == _this.librarySort)&&(identical(other.libraryGrouping, _this.libraryGrouping) || other.libraryGrouping == _this.libraryGrouping)&&(identical(other.autoLinkSubtitles, _this.autoLinkSubtitles) || other.autoLinkSubtitles == _this.autoLinkSubtitles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Preferences;
  return Object.hash(runtimeType,_this.gridSnapping,_this.gridSize,_this.defaultNodeType,_this.theme,_this.languageCode,_this.noodleStyle,_this.libraryView,_this.librarySort,_this.libraryGrouping,_this.autoLinkSubtitles);
}

@override
String toString() {
  final _this = this as Preferences;
  return 'Preferences(gridSnapping: ${_this.gridSnapping}, gridSize: ${_this.gridSize}, defaultNodeType: ${_this.defaultNodeType}, theme: ${_this.theme}, languageCode: ${_this.languageCode}, noodleStyle: ${_this.noodleStyle}, libraryView: ${_this.libraryView}, librarySort: ${_this.librarySort}, libraryGrouping: ${_this.libraryGrouping}, autoLinkSubtitles: ${_this.autoLinkSubtitles})';
}


}

/// @nodoc
abstract mixin class $PreferencesCopyWith<$Res>  {
  factory $PreferencesCopyWith(Preferences value, $Res Function(Preferences) _then) = _$PreferencesCopyWithImpl;
@useResult
$Res call({
 bool gridSnapping, double gridSize, DefaultNodeType defaultNodeType, ThemeChoice theme, String languageCode, NoodleStyle noodleStyle, LibraryView libraryView, LibrarySort librarySort, LibraryGrouping libraryGrouping, bool autoLinkSubtitles
});




}
/// @nodoc
class _$PreferencesCopyWithImpl<$Res>
    implements $PreferencesCopyWith<$Res> {
  _$PreferencesCopyWithImpl(this._self, this._then);

  final Preferences _self;
  final $Res Function(Preferences) _then;

/// Create a copy of Preferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gridSnapping = null,Object? gridSize = null,Object? defaultNodeType = null,Object? theme = null,Object? languageCode = null,Object? noodleStyle = null,Object? libraryView = null,Object? librarySort = null,Object? libraryGrouping = null,Object? autoLinkSubtitles = null,}) {
  return _then(Preferences(
gridSnapping: null == gridSnapping ? _self.gridSnapping : gridSnapping // ignore: cast_nullable_to_non_nullable
as bool,gridSize: null == gridSize ? _self.gridSize : gridSize // ignore: cast_nullable_to_non_nullable
as double,defaultNodeType: null == defaultNodeType ? _self.defaultNodeType : defaultNodeType // ignore: cast_nullable_to_non_nullable
as DefaultNodeType,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeChoice,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,noodleStyle: null == noodleStyle ? _self.noodleStyle : noodleStyle // ignore: cast_nullable_to_non_nullable
as NoodleStyle,libraryView: null == libraryView ? _self.libraryView : libraryView // ignore: cast_nullable_to_non_nullable
as LibraryView,librarySort: null == librarySort ? _self.librarySort : librarySort // ignore: cast_nullable_to_non_nullable
as LibrarySort,libraryGrouping: null == libraryGrouping ? _self.libraryGrouping : libraryGrouping // ignore: cast_nullable_to_non_nullable
as LibraryGrouping,autoLinkSubtitles: null == autoLinkSubtitles ? _self.autoLinkSubtitles : autoLinkSubtitles // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Preferences].
extension PreferencesPatterns on Preferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Preferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Preferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Preferences value)  $default,){
final _that = this;
switch (_that) {
case _Preferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Preferences value)?  $default,){
final _that = this;
switch (_that) {
case _Preferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool gridSnapping,  double gridSize,  DefaultNodeType defaultNodeType,  ThemeChoice theme,  String languageCode,  NoodleStyle noodleStyle,  LibraryView libraryView,  LibrarySort librarySort,  LibraryGrouping libraryGrouping,  bool autoLinkSubtitles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Preferences() when $default != null:
return $default(_that.gridSnapping,_that.gridSize,_that.defaultNodeType,_that.theme,_that.languageCode,_that.noodleStyle,_that.libraryView,_that.librarySort,_that.libraryGrouping,_that.autoLinkSubtitles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool gridSnapping,  double gridSize,  DefaultNodeType defaultNodeType,  ThemeChoice theme,  String languageCode,  NoodleStyle noodleStyle,  LibraryView libraryView,  LibrarySort librarySort,  LibraryGrouping libraryGrouping,  bool autoLinkSubtitles)  $default,) {final _that = this;
switch (_that) {
case _Preferences():
return $default(_that.gridSnapping,_that.gridSize,_that.defaultNodeType,_that.theme,_that.languageCode,_that.noodleStyle,_that.libraryView,_that.librarySort,_that.libraryGrouping,_that.autoLinkSubtitles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool gridSnapping,  double gridSize,  DefaultNodeType defaultNodeType,  ThemeChoice theme,  String languageCode,  NoodleStyle noodleStyle,  LibraryView libraryView,  LibrarySort librarySort,  LibraryGrouping libraryGrouping,  bool autoLinkSubtitles)?  $default,) {final _that = this;
switch (_that) {
case _Preferences() when $default != null:
return $default(_that.gridSnapping,_that.gridSize,_that.defaultNodeType,_that.theme,_that.languageCode,_that.noodleStyle,_that.libraryView,_that.librarySort,_that.libraryGrouping,_that.autoLinkSubtitles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Preferences implements Preferences {
  const _Preferences({this.gridSnapping = false, this.gridSize = kDefaultGridSize, this.defaultNodeType = DefaultNodeType.branchedVideo, this.theme = ThemeChoice.dark, this.languageCode = 'en', this.noodleStyle = NoodleStyle.straight, this.libraryView = LibraryView.thumbnails, this.librarySort = LibrarySort.dateAdded, this.libraryGrouping = LibraryGrouping.none, this.autoLinkSubtitles = true});
  factory _Preferences.fromJson(Map<String, dynamic> json) => _$PreferencesFromJson(json);

/// Snap nodes to the grid while moving them (Shift does it temporarily).
@override@JsonKey() final  bool gridSnapping;
@override@JsonKey() final  double gridSize;
@override@JsonKey() final  DefaultNodeType defaultNodeType;
@override@JsonKey() final  ThemeChoice theme;
@override@JsonKey() final  String languageCode;
@override@JsonKey() final  NoodleStyle noodleStyle;
@override@JsonKey() final  LibraryView libraryView;
@override@JsonKey() final  LibrarySort librarySort;
@override@JsonKey() final  LibraryGrouping libraryGrouping;
/// Link a video and a subtitle file of the same name when importing.
@override@JsonKey() final  bool autoLinkSubtitles;

/// Create a copy of Preferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreferencesCopyWith<_Preferences> get copyWith => __$PreferencesCopyWithImpl<_Preferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Preferences&&(identical(other.gridSnapping, gridSnapping) || other.gridSnapping == gridSnapping)&&(identical(other.gridSize, gridSize) || other.gridSize == gridSize)&&(identical(other.defaultNodeType, defaultNodeType) || other.defaultNodeType == defaultNodeType)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.noodleStyle, noodleStyle) || other.noodleStyle == noodleStyle)&&(identical(other.libraryView, libraryView) || other.libraryView == libraryView)&&(identical(other.librarySort, librarySort) || other.librarySort == librarySort)&&(identical(other.libraryGrouping, libraryGrouping) || other.libraryGrouping == libraryGrouping)&&(identical(other.autoLinkSubtitles, autoLinkSubtitles) || other.autoLinkSubtitles == autoLinkSubtitles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,gridSnapping,gridSize,defaultNodeType,theme,languageCode,noodleStyle,libraryView,librarySort,libraryGrouping,autoLinkSubtitles);
}

@override
String toString() {
    return 'Preferences(gridSnapping: $gridSnapping, gridSize: $gridSize, defaultNodeType: $defaultNodeType, theme: $theme, languageCode: $languageCode, noodleStyle: $noodleStyle, libraryView: $libraryView, librarySort: $librarySort, libraryGrouping: $libraryGrouping, autoLinkSubtitles: $autoLinkSubtitles)';
}


}

/// @nodoc
abstract mixin class _$PreferencesCopyWith<$Res> implements $PreferencesCopyWith<$Res> {
  factory _$PreferencesCopyWith(_Preferences value, $Res Function(_Preferences) _then) = __$PreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool gridSnapping, double gridSize, DefaultNodeType defaultNodeType, ThemeChoice theme, String languageCode, NoodleStyle noodleStyle, LibraryView libraryView, LibrarySort librarySort, LibraryGrouping libraryGrouping, bool autoLinkSubtitles
});




}
/// @nodoc
class __$PreferencesCopyWithImpl<$Res>
    implements _$PreferencesCopyWith<$Res> {
  __$PreferencesCopyWithImpl(this._self, this._then);

  final _Preferences _self;
  final $Res Function(_Preferences) _then;

/// Create a copy of Preferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gridSnapping = null,Object? gridSize = null,Object? defaultNodeType = null,Object? theme = null,Object? languageCode = null,Object? noodleStyle = null,Object? libraryView = null,Object? librarySort = null,Object? libraryGrouping = null,Object? autoLinkSubtitles = null,}) {
  return _then(_Preferences(
gridSnapping: null == gridSnapping ? _self.gridSnapping : gridSnapping // ignore: cast_nullable_to_non_nullable
as bool,gridSize: null == gridSize ? _self.gridSize : gridSize // ignore: cast_nullable_to_non_nullable
as double,defaultNodeType: null == defaultNodeType ? _self.defaultNodeType : defaultNodeType // ignore: cast_nullable_to_non_nullable
as DefaultNodeType,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeChoice,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,noodleStyle: null == noodleStyle ? _self.noodleStyle : noodleStyle // ignore: cast_nullable_to_non_nullable
as NoodleStyle,libraryView: null == libraryView ? _self.libraryView : libraryView // ignore: cast_nullable_to_non_nullable
as LibraryView,librarySort: null == librarySort ? _self.librarySort : librarySort // ignore: cast_nullable_to_non_nullable
as LibrarySort,libraryGrouping: null == libraryGrouping ? _self.libraryGrouping : libraryGrouping // ignore: cast_nullable_to_non_nullable
as LibraryGrouping,autoLinkSubtitles: null == autoLinkSubtitles ? _self.autoLinkSubtitles : autoLinkSubtitles // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
