// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panel_layout_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PanelLayout {

 double get left; double get right;/// Widths the user is dragging towards, before limits are applied.
/// Remembered so a panel reopens at the size it had.
 double get intendedLeft; double get intendedRight; bool get leftClosed; bool get rightClosed; LeftPanelSection get section;
/// Create a copy of PanelLayout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanelLayoutCopyWith<PanelLayout> get copyWith => _$PanelLayoutCopyWithImpl<PanelLayout>(this as PanelLayout, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PanelLayout;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelLayout&&(identical(other.left, _this.left) || other.left == _this.left)&&(identical(other.right, _this.right) || other.right == _this.right)&&(identical(other.intendedLeft, _this.intendedLeft) || other.intendedLeft == _this.intendedLeft)&&(identical(other.intendedRight, _this.intendedRight) || other.intendedRight == _this.intendedRight)&&(identical(other.leftClosed, _this.leftClosed) || other.leftClosed == _this.leftClosed)&&(identical(other.rightClosed, _this.rightClosed) || other.rightClosed == _this.rightClosed)&&(identical(other.section, _this.section) || other.section == _this.section));
}


@override
int get hashCode {
  final _this = this as PanelLayout;
  return Object.hash(runtimeType,_this.left,_this.right,_this.intendedLeft,_this.intendedRight,_this.leftClosed,_this.rightClosed,_this.section);
}

@override
String toString() {
  final _this = this as PanelLayout;
  return 'PanelLayout(left: ${_this.left}, right: ${_this.right}, intendedLeft: ${_this.intendedLeft}, intendedRight: ${_this.intendedRight}, leftClosed: ${_this.leftClosed}, rightClosed: ${_this.rightClosed}, section: ${_this.section})';
}


}

/// @nodoc
abstract mixin class $PanelLayoutCopyWith<$Res>  {
  factory $PanelLayoutCopyWith(PanelLayout value, $Res Function(PanelLayout) _then) = _$PanelLayoutCopyWithImpl;
@useResult
$Res call({
 double left, double right, double intendedLeft, double intendedRight, bool leftClosed, bool rightClosed, LeftPanelSection section
});




}
/// @nodoc
class _$PanelLayoutCopyWithImpl<$Res>
    implements $PanelLayoutCopyWith<$Res> {
  _$PanelLayoutCopyWithImpl(this._self, this._then);

  final PanelLayout _self;
  final $Res Function(PanelLayout) _then;

/// Create a copy of PanelLayout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? left = null,Object? right = null,Object? intendedLeft = null,Object? intendedRight = null,Object? leftClosed = null,Object? rightClosed = null,Object? section = null,}) {
  return _then(PanelLayout(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,right: null == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as double,intendedLeft: null == intendedLeft ? _self.intendedLeft : intendedLeft // ignore: cast_nullable_to_non_nullable
as double,intendedRight: null == intendedRight ? _self.intendedRight : intendedRight // ignore: cast_nullable_to_non_nullable
as double,leftClosed: null == leftClosed ? _self.leftClosed : leftClosed // ignore: cast_nullable_to_non_nullable
as bool,rightClosed: null == rightClosed ? _self.rightClosed : rightClosed // ignore: cast_nullable_to_non_nullable
as bool,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as LeftPanelSection,
  ));
}

}


/// Adds pattern-matching-related methods to [PanelLayout].
extension PanelLayoutPatterns on PanelLayout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanelLayout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanelLayout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanelLayout value)  $default,){
final _that = this;
switch (_that) {
case _PanelLayout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanelLayout value)?  $default,){
final _that = this;
switch (_that) {
case _PanelLayout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double left,  double right,  double intendedLeft,  double intendedRight,  bool leftClosed,  bool rightClosed,  LeftPanelSection section)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanelLayout() when $default != null:
return $default(_that.left,_that.right,_that.intendedLeft,_that.intendedRight,_that.leftClosed,_that.rightClosed,_that.section);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double left,  double right,  double intendedLeft,  double intendedRight,  bool leftClosed,  bool rightClosed,  LeftPanelSection section)  $default,) {final _that = this;
switch (_that) {
case _PanelLayout():
return $default(_that.left,_that.right,_that.intendedLeft,_that.intendedRight,_that.leftClosed,_that.rightClosed,_that.section);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double left,  double right,  double intendedLeft,  double intendedRight,  bool leftClosed,  bool rightClosed,  LeftPanelSection section)?  $default,) {final _that = this;
switch (_that) {
case _PanelLayout() when $default != null:
return $default(_that.left,_that.right,_that.intendedLeft,_that.intendedRight,_that.leftClosed,_that.rightClosed,_that.section);case _:
  return null;

}
}

}

/// @nodoc


class _PanelLayout extends PanelLayout {
  const _PanelLayout({this.left = 300, this.right = 300, this.intendedLeft = 300, this.intendedRight = 300, this.leftClosed = false, this.rightClosed = false, this.section = LeftPanelSection.videos}): super._();
  

@override@JsonKey() final  double left;
@override@JsonKey() final  double right;
/// Widths the user is dragging towards, before limits are applied.
/// Remembered so a panel reopens at the size it had.
@override@JsonKey() final  double intendedLeft;
@override@JsonKey() final  double intendedRight;
@override@JsonKey() final  bool leftClosed;
@override@JsonKey() final  bool rightClosed;
@override@JsonKey() final  LeftPanelSection section;

/// Create a copy of PanelLayout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanelLayoutCopyWith<_PanelLayout> get copyWith => __$PanelLayoutCopyWithImpl<_PanelLayout>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanelLayout&&(identical(other.left, left) || other.left == left)&&(identical(other.right, right) || other.right == right)&&(identical(other.intendedLeft, intendedLeft) || other.intendedLeft == intendedLeft)&&(identical(other.intendedRight, intendedRight) || other.intendedRight == intendedRight)&&(identical(other.leftClosed, leftClosed) || other.leftClosed == leftClosed)&&(identical(other.rightClosed, rightClosed) || other.rightClosed == rightClosed)&&(identical(other.section, section) || other.section == section));
}


@override
int get hashCode {
    return Object.hash(runtimeType,left,right,intendedLeft,intendedRight,leftClosed,rightClosed,section);
}

@override
String toString() {
    return 'PanelLayout(left: $left, right: $right, intendedLeft: $intendedLeft, intendedRight: $intendedRight, leftClosed: $leftClosed, rightClosed: $rightClosed, section: $section)';
}


}

/// @nodoc
abstract mixin class _$PanelLayoutCopyWith<$Res> implements $PanelLayoutCopyWith<$Res> {
  factory _$PanelLayoutCopyWith(_PanelLayout value, $Res Function(_PanelLayout) _then) = __$PanelLayoutCopyWithImpl;
@override @useResult
$Res call({
 double left, double right, double intendedLeft, double intendedRight, bool leftClosed, bool rightClosed, LeftPanelSection section
});




}
/// @nodoc
class __$PanelLayoutCopyWithImpl<$Res>
    implements _$PanelLayoutCopyWith<$Res> {
  __$PanelLayoutCopyWithImpl(this._self, this._then);

  final _PanelLayout _self;
  final $Res Function(_PanelLayout) _then;

/// Create a copy of PanelLayout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? left = null,Object? right = null,Object? intendedLeft = null,Object? intendedRight = null,Object? leftClosed = null,Object? rightClosed = null,Object? section = null,}) {
  return _then(_PanelLayout(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,right: null == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as double,intendedLeft: null == intendedLeft ? _self.intendedLeft : intendedLeft // ignore: cast_nullable_to_non_nullable
as double,intendedRight: null == intendedRight ? _self.intendedRight : intendedRight // ignore: cast_nullable_to_non_nullable
as double,leftClosed: null == leftClosed ? _self.leftClosed : leftClosed // ignore: cast_nullable_to_non_nullable
as bool,rightClosed: null == rightClosed ? _self.rightClosed : rightClosed // ignore: cast_nullable_to_non_nullable
as bool,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as LeftPanelSection,
  ));
}


}

// dart format on
