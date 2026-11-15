// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShellOverlays {

 bool get menuOpen; bool get contextMenuOpen; AppModal? get modal;
/// Create a copy of ShellOverlays
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShellOverlaysCopyWith<ShellOverlays> get copyWith => _$ShellOverlaysCopyWithImpl<ShellOverlays>(this as ShellOverlays, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShellOverlays;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShellOverlays&&(identical(other.menuOpen, _this.menuOpen) || other.menuOpen == _this.menuOpen)&&(identical(other.contextMenuOpen, _this.contextMenuOpen) || other.contextMenuOpen == _this.contextMenuOpen)&&(identical(other.modal, _this.modal) || other.modal == _this.modal));
}


@override
int get hashCode {
  final _this = this as ShellOverlays;
  return Object.hash(runtimeType,_this.menuOpen,_this.contextMenuOpen,_this.modal);
}

@override
String toString() {
  final _this = this as ShellOverlays;
  return 'ShellOverlays(menuOpen: ${_this.menuOpen}, contextMenuOpen: ${_this.contextMenuOpen}, modal: ${_this.modal})';
}


}

/// @nodoc
abstract mixin class $ShellOverlaysCopyWith<$Res>  {
  factory $ShellOverlaysCopyWith(ShellOverlays value, $Res Function(ShellOverlays) _then) = _$ShellOverlaysCopyWithImpl;
@useResult
$Res call({
 bool menuOpen, bool contextMenuOpen, AppModal? modal
});




}
/// @nodoc
class _$ShellOverlaysCopyWithImpl<$Res>
    implements $ShellOverlaysCopyWith<$Res> {
  _$ShellOverlaysCopyWithImpl(this._self, this._then);

  final ShellOverlays _self;
  final $Res Function(ShellOverlays) _then;

/// Create a copy of ShellOverlays
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuOpen = null,Object? contextMenuOpen = null,Object? modal = freezed,}) {
  return _then(ShellOverlays(
menuOpen: null == menuOpen ? _self.menuOpen : menuOpen // ignore: cast_nullable_to_non_nullable
as bool,contextMenuOpen: null == contextMenuOpen ? _self.contextMenuOpen : contextMenuOpen // ignore: cast_nullable_to_non_nullable
as bool,modal: freezed == modal ? _self.modal : modal // ignore: cast_nullable_to_non_nullable
as AppModal?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShellOverlays].
extension ShellOverlaysPatterns on ShellOverlays {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShellOverlays value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShellOverlays() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShellOverlays value)  $default,){
final _that = this;
switch (_that) {
case _ShellOverlays():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShellOverlays value)?  $default,){
final _that = this;
switch (_that) {
case _ShellOverlays() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool menuOpen,  bool contextMenuOpen,  AppModal? modal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShellOverlays() when $default != null:
return $default(_that.menuOpen,_that.contextMenuOpen,_that.modal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool menuOpen,  bool contextMenuOpen,  AppModal? modal)  $default,) {final _that = this;
switch (_that) {
case _ShellOverlays():
return $default(_that.menuOpen,_that.contextMenuOpen,_that.modal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool menuOpen,  bool contextMenuOpen,  AppModal? modal)?  $default,) {final _that = this;
switch (_that) {
case _ShellOverlays() when $default != null:
return $default(_that.menuOpen,_that.contextMenuOpen,_that.modal);case _:
  return null;

}
}

}

/// @nodoc


class _ShellOverlays extends ShellOverlays {
  const _ShellOverlays({this.menuOpen = false, this.contextMenuOpen = false, this.modal}): super._();
  

@override@JsonKey() final  bool menuOpen;
@override@JsonKey() final  bool contextMenuOpen;
@override final  AppModal? modal;

/// Create a copy of ShellOverlays
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShellOverlaysCopyWith<_ShellOverlays> get copyWith => __$ShellOverlaysCopyWithImpl<_ShellOverlays>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShellOverlays&&(identical(other.menuOpen, menuOpen) || other.menuOpen == menuOpen)&&(identical(other.contextMenuOpen, contextMenuOpen) || other.contextMenuOpen == contextMenuOpen)&&(identical(other.modal, modal) || other.modal == modal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,menuOpen,contextMenuOpen,modal);
}

@override
String toString() {
    return 'ShellOverlays(menuOpen: $menuOpen, contextMenuOpen: $contextMenuOpen, modal: $modal)';
}


}

/// @nodoc
abstract mixin class _$ShellOverlaysCopyWith<$Res> implements $ShellOverlaysCopyWith<$Res> {
  factory _$ShellOverlaysCopyWith(_ShellOverlays value, $Res Function(_ShellOverlays) _then) = __$ShellOverlaysCopyWithImpl;
@override @useResult
$Res call({
 bool menuOpen, bool contextMenuOpen, AppModal? modal
});




}
/// @nodoc
class __$ShellOverlaysCopyWithImpl<$Res>
    implements _$ShellOverlaysCopyWith<$Res> {
  __$ShellOverlaysCopyWithImpl(this._self, this._then);

  final _ShellOverlays _self;
  final $Res Function(_ShellOverlays) _then;

/// Create a copy of ShellOverlays
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuOpen = null,Object? contextMenuOpen = null,Object? modal = freezed,}) {
  return _then(_ShellOverlays(
menuOpen: null == menuOpen ? _self.menuOpen : menuOpen // ignore: cast_nullable_to_non_nullable
as bool,contextMenuOpen: null == contextMenuOpen ? _self.contextMenuOpen : contextMenuOpen // ignore: cast_nullable_to_non_nullable
as bool,modal: freezed == modal ? _self.modal : modal // ignore: cast_nullable_to_non_nullable
as AppModal?,
  ));
}


}

// dart format on
