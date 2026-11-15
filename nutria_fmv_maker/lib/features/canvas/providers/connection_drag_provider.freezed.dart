// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_drag_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CanvasInteraction {

 HoverTarget get hover;/// The fixed end of the dragged noodle. `null` when not dragging.
 DragAnchor? get anchor;/// The free end of the dragged noodle, in canvas coordinates.
 Offset get pointer;
/// Create a copy of CanvasInteraction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CanvasInteractionCopyWith<CanvasInteraction> get copyWith => _$CanvasInteractionCopyWithImpl<CanvasInteraction>(this as CanvasInteraction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CanvasInteraction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CanvasInteraction&&(identical(other.hover, _this.hover) || other.hover == _this.hover)&&(identical(other.anchor, _this.anchor) || other.anchor == _this.anchor)&&(identical(other.pointer, _this.pointer) || other.pointer == _this.pointer));
}


@override
int get hashCode {
  final _this = this as CanvasInteraction;
  return Object.hash(runtimeType,_this.hover,_this.anchor,_this.pointer);
}

@override
String toString() {
  final _this = this as CanvasInteraction;
  return 'CanvasInteraction(hover: ${_this.hover}, anchor: ${_this.anchor}, pointer: ${_this.pointer})';
}


}

/// @nodoc
abstract mixin class $CanvasInteractionCopyWith<$Res>  {
  factory $CanvasInteractionCopyWith(CanvasInteraction value, $Res Function(CanvasInteraction) _then) = _$CanvasInteractionCopyWithImpl;
@useResult
$Res call({
 HoverTarget hover, DragAnchor? anchor, Offset pointer
});


$HoverTargetCopyWith<$Res> get hover;$DragAnchorCopyWith<$Res>? get anchor;

}
/// @nodoc
class _$CanvasInteractionCopyWithImpl<$Res>
    implements $CanvasInteractionCopyWith<$Res> {
  _$CanvasInteractionCopyWithImpl(this._self, this._then);

  final CanvasInteraction _self;
  final $Res Function(CanvasInteraction) _then;

/// Create a copy of CanvasInteraction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hover = null,Object? anchor = freezed,Object? pointer = null,}) {
  return _then(CanvasInteraction(
hover: null == hover ? _self.hover : hover // ignore: cast_nullable_to_non_nullable
as HoverTarget,anchor: freezed == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as DragAnchor?,pointer: null == pointer ? _self.pointer : pointer // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}
/// Create a copy of CanvasInteraction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoverTargetCopyWith<$Res> get hover {
  
  return $HoverTargetCopyWith<$Res>(_self.hover, (value) {
    return _then(_self.copyWith(hover: value));
  });
}/// Create a copy of CanvasInteraction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DragAnchorCopyWith<$Res>? get anchor {
    if (_self.anchor == null) {
    return null;
  }

  return $DragAnchorCopyWith<$Res>(_self.anchor!, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}


/// Adds pattern-matching-related methods to [CanvasInteraction].
extension CanvasInteractionPatterns on CanvasInteraction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CanvasInteraction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CanvasInteraction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CanvasInteraction value)  $default,){
final _that = this;
switch (_that) {
case _CanvasInteraction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CanvasInteraction value)?  $default,){
final _that = this;
switch (_that) {
case _CanvasInteraction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HoverTarget hover,  DragAnchor? anchor,  Offset pointer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CanvasInteraction() when $default != null:
return $default(_that.hover,_that.anchor,_that.pointer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HoverTarget hover,  DragAnchor? anchor,  Offset pointer)  $default,) {final _that = this;
switch (_that) {
case _CanvasInteraction():
return $default(_that.hover,_that.anchor,_that.pointer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HoverTarget hover,  DragAnchor? anchor,  Offset pointer)?  $default,) {final _that = this;
switch (_that) {
case _CanvasInteraction() when $default != null:
return $default(_that.hover,_that.anchor,_that.pointer);case _:
  return null;

}
}

}

/// @nodoc


class _CanvasInteraction implements CanvasInteraction {
  const _CanvasInteraction({this.hover = const HoverTarget.none(), this.anchor, this.pointer = Offset.zero});
  

@override@JsonKey() final  HoverTarget hover;
/// The fixed end of the dragged noodle. `null` when not dragging.
@override final  DragAnchor? anchor;
/// The free end of the dragged noodle, in canvas coordinates.
@override@JsonKey() final  Offset pointer;

/// Create a copy of CanvasInteraction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CanvasInteractionCopyWith<_CanvasInteraction> get copyWith => __$CanvasInteractionCopyWithImpl<_CanvasInteraction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CanvasInteraction&&(identical(other.hover, hover) || other.hover == hover)&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.pointer, pointer) || other.pointer == pointer));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hover,anchor,pointer);
}

@override
String toString() {
    return 'CanvasInteraction(hover: $hover, anchor: $anchor, pointer: $pointer)';
}


}

/// @nodoc
abstract mixin class _$CanvasInteractionCopyWith<$Res> implements $CanvasInteractionCopyWith<$Res> {
  factory _$CanvasInteractionCopyWith(_CanvasInteraction value, $Res Function(_CanvasInteraction) _then) = __$CanvasInteractionCopyWithImpl;
@override @useResult
$Res call({
 HoverTarget hover, DragAnchor? anchor, Offset pointer
});


@override $HoverTargetCopyWith<$Res> get hover;@override $DragAnchorCopyWith<$Res>? get anchor;

}
/// @nodoc
class __$CanvasInteractionCopyWithImpl<$Res>
    implements _$CanvasInteractionCopyWith<$Res> {
  __$CanvasInteractionCopyWithImpl(this._self, this._then);

  final _CanvasInteraction _self;
  final $Res Function(_CanvasInteraction) _then;

/// Create a copy of CanvasInteraction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hover = null,Object? anchor = freezed,Object? pointer = null,}) {
  return _then(_CanvasInteraction(
hover: null == hover ? _self.hover : hover // ignore: cast_nullable_to_non_nullable
as HoverTarget,anchor: freezed == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as DragAnchor?,pointer: null == pointer ? _self.pointer : pointer // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}

/// Create a copy of CanvasInteraction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HoverTargetCopyWith<$Res> get hover {
  
  return $HoverTargetCopyWith<$Res>(_self.hover, (value) {
    return _then(_self.copyWith(hover: value));
  });
}/// Create a copy of CanvasInteraction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DragAnchorCopyWith<$Res>? get anchor {
    if (_self.anchor == null) {
    return null;
  }

  return $DragAnchorCopyWith<$Res>(_self.anchor!, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}

// dart format on
