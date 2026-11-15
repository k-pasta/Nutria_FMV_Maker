// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selection_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectionState {

 Set<String> get selected;/// Nodes brought to the front, most recent last. Drawn above the others.
 List<String> get raised;
/// Create a copy of SelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectionStateCopyWith<SelectionState> get copyWith => _$SelectionStateCopyWithImpl<SelectionState>(this as SelectionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SelectionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectionState&&const DeepCollectionEquality().equals(other.selected, _this.selected)&&const DeepCollectionEquality().equals(other.raised, _this.raised));
}


@override
int get hashCode {
  final _this = this as SelectionState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.selected),const DeepCollectionEquality().hash(_this.raised));
}

@override
String toString() {
  final _this = this as SelectionState;
  return 'SelectionState(selected: ${_this.selected}, raised: ${_this.raised})';
}


}

/// @nodoc
abstract mixin class $SelectionStateCopyWith<$Res>  {
  factory $SelectionStateCopyWith(SelectionState value, $Res Function(SelectionState) _then) = _$SelectionStateCopyWithImpl;
@useResult
$Res call({
 Set<String> selected, List<String> raised
});




}
/// @nodoc
class _$SelectionStateCopyWithImpl<$Res>
    implements $SelectionStateCopyWith<$Res> {
  _$SelectionStateCopyWithImpl(this._self, this._then);

  final SelectionState _self;
  final $Res Function(SelectionState) _then;

/// Create a copy of SelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selected = null,Object? raised = null,}) {
  return _then(SelectionState(
selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as Set<String>,raised: null == raised ? _self.raised : raised // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectionState].
extension SelectionStatePatterns on SelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectionState value)  $default,){
final _that = this;
switch (_that) {
case _SelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _SelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> selected,  List<String> raised)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectionState() when $default != null:
return $default(_that.selected,_that.raised);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> selected,  List<String> raised)  $default,) {final _that = this;
switch (_that) {
case _SelectionState():
return $default(_that.selected,_that.raised);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> selected,  List<String> raised)?  $default,) {final _that = this;
switch (_that) {
case _SelectionState() when $default != null:
return $default(_that.selected,_that.raised);case _:
  return null;

}
}

}

/// @nodoc


class _SelectionState implements SelectionState {
  const _SelectionState({ Set<String> selected = const <String>{},  List<String> raised = const <String>[]}): _selected = selected,_raised = raised;
  

 final  Set<String> _selected;
@override@JsonKey() Set<String> get selected {
  if (_selected is EqualUnmodifiableSetView) return _selected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selected);
}

/// Nodes brought to the front, most recent last. Drawn above the others.
 final  List<String> _raised;
/// Nodes brought to the front, most recent last. Drawn above the others.
@override@JsonKey() List<String> get raised {
  if (_raised is EqualUnmodifiableListView) return _raised;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_raised);
}


/// Create a copy of SelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectionStateCopyWith<_SelectionState> get copyWith => __$SelectionStateCopyWithImpl<_SelectionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectionState&&const DeepCollectionEquality().equals(other.selected, _selected)&&const DeepCollectionEquality().equals(other.raised, _raised));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_selected),const DeepCollectionEquality().hash(_raised));
}

@override
String toString() {
    return 'SelectionState(selected: $selected, raised: $raised)';
}


}

/// @nodoc
abstract mixin class _$SelectionStateCopyWith<$Res> implements $SelectionStateCopyWith<$Res> {
  factory _$SelectionStateCopyWith(_SelectionState value, $Res Function(_SelectionState) _then) = __$SelectionStateCopyWithImpl;
@override @useResult
$Res call({
 Set<String> selected, List<String> raised
});




}
/// @nodoc
class __$SelectionStateCopyWithImpl<$Res>
    implements _$SelectionStateCopyWith<$Res> {
  __$SelectionStateCopyWithImpl(this._self, this._then);

  final _SelectionState _self;
  final $Res Function(_SelectionState) _then;

/// Create a copy of SelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selected = null,Object? raised = null,}) {
  return _then(_SelectionState(
selected: null == selected ? _self._selected : selected // ignore: cast_nullable_to_non_nullable
as Set<String>,raised: null == raised ? _self._raised : raised // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
