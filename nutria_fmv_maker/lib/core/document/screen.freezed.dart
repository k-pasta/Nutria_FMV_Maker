// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScreenStyle {

 String get id; String get name;/// Text height, as a fraction of the screen height.
 double get fontSize; bool get bold;/// An imported font file, or `null` for the Player's own font.
 String? get fontId;/// ARGB.
 int get textColor; int get backgroundColor;/// 0 (no background) to 1.
 double get backgroundOpacity;/// Corner radius, as a fraction of the screen height.
 double get radius;/// Space around the text, as a fraction of the screen height.
 double get padding;
/// Create a copy of ScreenStyle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenStyleCopyWith<ScreenStyle> get copyWith => _$ScreenStyleCopyWithImpl<ScreenStyle>(this as ScreenStyle, _$identity);

  /// Serializes this ScreenStyle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScreenStyle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenStyle&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.fontSize, _this.fontSize) || other.fontSize == _this.fontSize)&&(identical(other.bold, _this.bold) || other.bold == _this.bold)&&(identical(other.fontId, _this.fontId) || other.fontId == _this.fontId)&&(identical(other.textColor, _this.textColor) || other.textColor == _this.textColor)&&(identical(other.backgroundColor, _this.backgroundColor) || other.backgroundColor == _this.backgroundColor)&&(identical(other.backgroundOpacity, _this.backgroundOpacity) || other.backgroundOpacity == _this.backgroundOpacity)&&(identical(other.radius, _this.radius) || other.radius == _this.radius)&&(identical(other.padding, _this.padding) || other.padding == _this.padding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScreenStyle;
  return Object.hash(runtimeType,_this.id,_this.name,_this.fontSize,_this.bold,_this.fontId,_this.textColor,_this.backgroundColor,_this.backgroundOpacity,_this.radius,_this.padding);
}

@override
String toString() {
  final _this = this as ScreenStyle;
  return 'ScreenStyle(id: ${_this.id}, name: ${_this.name}, fontSize: ${_this.fontSize}, bold: ${_this.bold}, fontId: ${_this.fontId}, textColor: ${_this.textColor}, backgroundColor: ${_this.backgroundColor}, backgroundOpacity: ${_this.backgroundOpacity}, radius: ${_this.radius}, padding: ${_this.padding})';
}


}

/// @nodoc
abstract mixin class $ScreenStyleCopyWith<$Res>  {
  factory $ScreenStyleCopyWith(ScreenStyle value, $Res Function(ScreenStyle) _then) = _$ScreenStyleCopyWithImpl;
@useResult
$Res call({
 String id, String name, double fontSize, bool bold, String? fontId, int textColor, int backgroundColor, double backgroundOpacity, double radius, double padding
});




}
/// @nodoc
class _$ScreenStyleCopyWithImpl<$Res>
    implements $ScreenStyleCopyWith<$Res> {
  _$ScreenStyleCopyWithImpl(this._self, this._then);

  final ScreenStyle _self;
  final $Res Function(ScreenStyle) _then;

/// Create a copy of ScreenStyle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? fontSize = null,Object? bold = null,Object? fontId = freezed,Object? textColor = null,Object? backgroundColor = null,Object? backgroundOpacity = null,Object? radius = null,Object? padding = null,}) {
  return _then(ScreenStyle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,bold: null == bold ? _self.bold : bold // ignore: cast_nullable_to_non_nullable
as bool,fontId: freezed == fontId ? _self.fontId : fontId // ignore: cast_nullable_to_non_nullable
as String?,textColor: null == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as int,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as int,backgroundOpacity: null == backgroundOpacity ? _self.backgroundOpacity : backgroundOpacity // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenStyle].
extension ScreenStylePatterns on ScreenStyle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenStyle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenStyle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenStyle value)  $default,){
final _that = this;
switch (_that) {
case _ScreenStyle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenStyle value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenStyle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double fontSize,  bool bold,  String? fontId,  int textColor,  int backgroundColor,  double backgroundOpacity,  double radius,  double padding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenStyle() when $default != null:
return $default(_that.id,_that.name,_that.fontSize,_that.bold,_that.fontId,_that.textColor,_that.backgroundColor,_that.backgroundOpacity,_that.radius,_that.padding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double fontSize,  bool bold,  String? fontId,  int textColor,  int backgroundColor,  double backgroundOpacity,  double radius,  double padding)  $default,) {final _that = this;
switch (_that) {
case _ScreenStyle():
return $default(_that.id,_that.name,_that.fontSize,_that.bold,_that.fontId,_that.textColor,_that.backgroundColor,_that.backgroundOpacity,_that.radius,_that.padding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double fontSize,  bool bold,  String? fontId,  int textColor,  int backgroundColor,  double backgroundOpacity,  double radius,  double padding)?  $default,) {final _that = this;
switch (_that) {
case _ScreenStyle() when $default != null:
return $default(_that.id,_that.name,_that.fontSize,_that.bold,_that.fontId,_that.textColor,_that.backgroundColor,_that.backgroundOpacity,_that.radius,_that.padding);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScreenStyle implements ScreenStyle {
  const _ScreenStyle({required this.id, required this.name, this.fontSize = 0.05, this.bold = false, this.fontId, this.textColor = 0xFFFFFFFF, this.backgroundColor = 0xFF000000, this.backgroundOpacity = 0.0, this.radius = 0.0, this.padding = 0.01});
  factory _ScreenStyle.fromJson(Map<String, dynamic> json) => _$ScreenStyleFromJson(json);

@override final  String id;
@override final  String name;
/// Text height, as a fraction of the screen height.
@override@JsonKey() final  double fontSize;
@override@JsonKey() final  bool bold;
/// An imported font file, or `null` for the Player's own font.
@override final  String? fontId;
/// ARGB.
@override@JsonKey() final  int textColor;
@override@JsonKey() final  int backgroundColor;
/// 0 (no background) to 1.
@override@JsonKey() final  double backgroundOpacity;
/// Corner radius, as a fraction of the screen height.
@override@JsonKey() final  double radius;
/// Space around the text, as a fraction of the screen height.
@override@JsonKey() final  double padding;

/// Create a copy of ScreenStyle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenStyleCopyWith<_ScreenStyle> get copyWith => __$ScreenStyleCopyWithImpl<_ScreenStyle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenStyleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenStyle&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.bold, bold) || other.bold == bold)&&(identical(other.fontId, fontId) || other.fontId == fontId)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.backgroundOpacity, backgroundOpacity) || other.backgroundOpacity == backgroundOpacity)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.padding, padding) || other.padding == padding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,fontSize,bold,fontId,textColor,backgroundColor,backgroundOpacity,radius,padding);
}

@override
String toString() {
    return 'ScreenStyle(id: $id, name: $name, fontSize: $fontSize, bold: $bold, fontId: $fontId, textColor: $textColor, backgroundColor: $backgroundColor, backgroundOpacity: $backgroundOpacity, radius: $radius, padding: $padding)';
}


}

/// @nodoc
abstract mixin class _$ScreenStyleCopyWith<$Res> implements $ScreenStyleCopyWith<$Res> {
  factory _$ScreenStyleCopyWith(_ScreenStyle value, $Res Function(_ScreenStyle) _then) = __$ScreenStyleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double fontSize, bool bold, String? fontId, int textColor, int backgroundColor, double backgroundOpacity, double radius, double padding
});




}
/// @nodoc
class __$ScreenStyleCopyWithImpl<$Res>
    implements _$ScreenStyleCopyWith<$Res> {
  __$ScreenStyleCopyWithImpl(this._self, this._then);

  final _ScreenStyle _self;
  final $Res Function(_ScreenStyle) _then;

/// Create a copy of ScreenStyle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? fontSize = null,Object? bold = null,Object? fontId = freezed,Object? textColor = null,Object? backgroundColor = null,Object? backgroundOpacity = null,Object? radius = null,Object? padding = null,}) {
  return _then(_ScreenStyle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,bold: null == bold ? _self.bold : bold // ignore: cast_nullable_to_non_nullable
as bool,fontId: freezed == fontId ? _self.fontId : fontId // ignore: cast_nullable_to_non_nullable
as String?,textColor: null == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as int,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as int,backgroundOpacity: null == backgroundOpacity ? _self.backgroundOpacity : backgroundOpacity // ignore: cast_nullable_to_non_nullable
as double,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ScreenElement {

 String get id; ScreenElementKind get kind; double get x; double get y; double get width;/// The style, or `null` for the default of its kind.
 String? get styleId;/// Text instead of the default (the project title, "Start", …).
 String? get text;
/// Create a copy of ScreenElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenElementCopyWith<ScreenElement> get copyWith => _$ScreenElementCopyWithImpl<ScreenElement>(this as ScreenElement, _$identity);

  /// Serializes this ScreenElement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScreenElement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenElement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.styleId, _this.styleId) || other.styleId == _this.styleId)&&(identical(other.text, _this.text) || other.text == _this.text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScreenElement;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.x,_this.y,_this.width,_this.styleId,_this.text);
}

@override
String toString() {
  final _this = this as ScreenElement;
  return 'ScreenElement(id: ${_this.id}, kind: ${_this.kind}, x: ${_this.x}, y: ${_this.y}, width: ${_this.width}, styleId: ${_this.styleId}, text: ${_this.text})';
}


}

/// @nodoc
abstract mixin class $ScreenElementCopyWith<$Res>  {
  factory $ScreenElementCopyWith(ScreenElement value, $Res Function(ScreenElement) _then) = _$ScreenElementCopyWithImpl;
@useResult
$Res call({
 String id, ScreenElementKind kind, double x, double y, double width, String? styleId, String? text
});




}
/// @nodoc
class _$ScreenElementCopyWithImpl<$Res>
    implements $ScreenElementCopyWith<$Res> {
  _$ScreenElementCopyWithImpl(this._self, this._then);

  final ScreenElement _self;
  final $Res Function(ScreenElement) _then;

/// Create a copy of ScreenElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? x = null,Object? y = null,Object? width = null,Object? styleId = freezed,Object? text = freezed,}) {
  return _then(ScreenElement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ScreenElementKind,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,styleId: freezed == styleId ? _self.styleId : styleId // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenElement].
extension ScreenElementPatterns on ScreenElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenElement value)  $default,){
final _that = this;
switch (_that) {
case _ScreenElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenElement value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ScreenElementKind kind,  double x,  double y,  double width,  String? styleId,  String? text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenElement() when $default != null:
return $default(_that.id,_that.kind,_that.x,_that.y,_that.width,_that.styleId,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ScreenElementKind kind,  double x,  double y,  double width,  String? styleId,  String? text)  $default,) {final _that = this;
switch (_that) {
case _ScreenElement():
return $default(_that.id,_that.kind,_that.x,_that.y,_that.width,_that.styleId,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ScreenElementKind kind,  double x,  double y,  double width,  String? styleId,  String? text)?  $default,) {final _that = this;
switch (_that) {
case _ScreenElement() when $default != null:
return $default(_that.id,_that.kind,_that.x,_that.y,_that.width,_that.styleId,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScreenElement implements ScreenElement {
  const _ScreenElement({required this.id, required this.kind, this.x = 0.5, this.y = 0.5, this.width = 0.3, this.styleId, this.text});
  factory _ScreenElement.fromJson(Map<String, dynamic> json) => _$ScreenElementFromJson(json);

@override final  String id;
@override final  ScreenElementKind kind;
@override@JsonKey() final  double x;
@override@JsonKey() final  double y;
@override@JsonKey() final  double width;
/// The style, or `null` for the default of its kind.
@override final  String? styleId;
/// Text instead of the default (the project title, "Start", …).
@override final  String? text;

/// Create a copy of ScreenElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenElementCopyWith<_ScreenElement> get copyWith => __$ScreenElementCopyWithImpl<_ScreenElement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenElementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenElement&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.styleId, styleId) || other.styleId == styleId)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,x,y,width,styleId,text);
}

@override
String toString() {
    return 'ScreenElement(id: $id, kind: $kind, x: $x, y: $y, width: $width, styleId: $styleId, text: $text)';
}


}

/// @nodoc
abstract mixin class _$ScreenElementCopyWith<$Res> implements $ScreenElementCopyWith<$Res> {
  factory _$ScreenElementCopyWith(_ScreenElement value, $Res Function(_ScreenElement) _then) = __$ScreenElementCopyWithImpl;
@override @useResult
$Res call({
 String id, ScreenElementKind kind, double x, double y, double width, String? styleId, String? text
});




}
/// @nodoc
class __$ScreenElementCopyWithImpl<$Res>
    implements _$ScreenElementCopyWith<$Res> {
  __$ScreenElementCopyWithImpl(this._self, this._then);

  final _ScreenElement _self;
  final $Res Function(_ScreenElement) _then;

/// Create a copy of ScreenElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? x = null,Object? y = null,Object? width = null,Object? styleId = freezed,Object? text = freezed,}) {
  return _then(_ScreenElement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ScreenElementKind,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,styleId: freezed == styleId ? _self.styleId : styleId // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MenuScreen {

 String? get backgroundId; List<ScreenElement> get elements;
/// Create a copy of MenuScreen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuScreenCopyWith<MenuScreen> get copyWith => _$MenuScreenCopyWithImpl<MenuScreen>(this as MenuScreen, _$identity);

  /// Serializes this MenuScreen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MenuScreen;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuScreen&&(identical(other.backgroundId, _this.backgroundId) || other.backgroundId == _this.backgroundId)&&const DeepCollectionEquality().equals(other.elements, _this.elements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MenuScreen;
  return Object.hash(runtimeType,_this.backgroundId,const DeepCollectionEquality().hash(_this.elements));
}

@override
String toString() {
  final _this = this as MenuScreen;
  return 'MenuScreen(backgroundId: ${_this.backgroundId}, elements: ${_this.elements})';
}


}

/// @nodoc
abstract mixin class $MenuScreenCopyWith<$Res>  {
  factory $MenuScreenCopyWith(MenuScreen value, $Res Function(MenuScreen) _then) = _$MenuScreenCopyWithImpl;
@useResult
$Res call({
 String? backgroundId, List<ScreenElement> elements
});




}
/// @nodoc
class _$MenuScreenCopyWithImpl<$Res>
    implements $MenuScreenCopyWith<$Res> {
  _$MenuScreenCopyWithImpl(this._self, this._then);

  final MenuScreen _self;
  final $Res Function(MenuScreen) _then;

/// Create a copy of MenuScreen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backgroundId = freezed,Object? elements = null,}) {
  return _then(MenuScreen(
backgroundId: freezed == backgroundId ? _self.backgroundId : backgroundId // ignore: cast_nullable_to_non_nullable
as String?,elements: null == elements ? _self.elements : elements // ignore: cast_nullable_to_non_nullable
as List<ScreenElement>,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuScreen].
extension MenuScreenPatterns on MenuScreen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuScreen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuScreen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuScreen value)  $default,){
final _that = this;
switch (_that) {
case _MenuScreen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuScreen value)?  $default,){
final _that = this;
switch (_that) {
case _MenuScreen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? backgroundId,  List<ScreenElement> elements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuScreen() when $default != null:
return $default(_that.backgroundId,_that.elements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? backgroundId,  List<ScreenElement> elements)  $default,) {final _that = this;
switch (_that) {
case _MenuScreen():
return $default(_that.backgroundId,_that.elements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? backgroundId,  List<ScreenElement> elements)?  $default,) {final _that = this;
switch (_that) {
case _MenuScreen() when $default != null:
return $default(_that.backgroundId,_that.elements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuScreen implements MenuScreen {
  const _MenuScreen({this.backgroundId,  List<ScreenElement> elements = const <ScreenElement>[]}): _elements = elements;
  factory _MenuScreen.fromJson(Map<String, dynamic> json) => _$MenuScreenFromJson(json);

@override final  String? backgroundId;
 final  List<ScreenElement> _elements;
@override@JsonKey() List<ScreenElement> get elements {
  if (_elements is EqualUnmodifiableListView) return _elements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_elements);
}


/// Create a copy of MenuScreen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuScreenCopyWith<_MenuScreen> get copyWith => __$MenuScreenCopyWithImpl<_MenuScreen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuScreenToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuScreen&&(identical(other.backgroundId, backgroundId) || other.backgroundId == backgroundId)&&const DeepCollectionEquality().equals(other.elements, _elements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,backgroundId,const DeepCollectionEquality().hash(_elements));
}

@override
String toString() {
    return 'MenuScreen(backgroundId: $backgroundId, elements: $elements)';
}


}

/// @nodoc
abstract mixin class _$MenuScreenCopyWith<$Res> implements $MenuScreenCopyWith<$Res> {
  factory _$MenuScreenCopyWith(_MenuScreen value, $Res Function(_MenuScreen) _then) = __$MenuScreenCopyWithImpl;
@override @useResult
$Res call({
 String? backgroundId, List<ScreenElement> elements
});




}
/// @nodoc
class __$MenuScreenCopyWithImpl<$Res>
    implements _$MenuScreenCopyWith<$Res> {
  __$MenuScreenCopyWithImpl(this._self, this._then);

  final _MenuScreen _self;
  final $Res Function(_MenuScreen) _then;

/// Create a copy of MenuScreen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backgroundId = freezed,Object? elements = null,}) {
  return _then(_MenuScreen(
backgroundId: freezed == backgroundId ? _self.backgroundId : backgroundId // ignore: cast_nullable_to_non_nullable
as String?,elements: null == elements ? _self._elements : elements // ignore: cast_nullable_to_non_nullable
as List<ScreenElement>,
  ));
}


}

// dart format on
