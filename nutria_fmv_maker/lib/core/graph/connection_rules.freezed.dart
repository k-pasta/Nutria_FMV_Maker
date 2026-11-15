// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HoverTarget {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoverTarget);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HoverTarget()';
}


}

/// @nodoc
class $HoverTargetCopyWith<$Res>  {
$HoverTargetCopyWith(HoverTarget _, $Res Function(HoverTarget) __);
}


/// Adds pattern-matching-related methods to [HoverTarget].
extension HoverTargetPatterns on HoverTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HoverNone value)?  none,TResult Function( HoverNode value)?  node,TResult Function( HoverInput value)?  input,TResult Function( HoverOutput value)?  output,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HoverNone() when none != null:
return none(_that);case HoverNode() when node != null:
return node(_that);case HoverInput() when input != null:
return input(_that);case HoverOutput() when output != null:
return output(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HoverNone value)  none,required TResult Function( HoverNode value)  node,required TResult Function( HoverInput value)  input,required TResult Function( HoverOutput value)  output,}){
final _that = this;
switch (_that) {
case HoverNone():
return none(_that);case HoverNode():
return node(_that);case HoverInput():
return input(_that);case HoverOutput():
return output(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HoverNone value)?  none,TResult? Function( HoverNode value)?  node,TResult? Function( HoverInput value)?  input,TResult? Function( HoverOutput value)?  output,}){
final _that = this;
switch (_that) {
case HoverNone() when none != null:
return none(_that);case HoverNode() when node != null:
return node(_that);case HoverInput() when input != null:
return input(_that);case HoverOutput() when output != null:
return output(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function( String nodeId)?  node,TResult Function( String nodeId)?  input,TResult Function( PortRef port)?  output,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HoverNone() when none != null:
return none();case HoverNode() when node != null:
return node(_that.nodeId);case HoverInput() when input != null:
return input(_that.nodeId);case HoverOutput() when output != null:
return output(_that.port);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function( String nodeId)  node,required TResult Function( String nodeId)  input,required TResult Function( PortRef port)  output,}) {final _that = this;
switch (_that) {
case HoverNone():
return none();case HoverNode():
return node(_that.nodeId);case HoverInput():
return input(_that.nodeId);case HoverOutput():
return output(_that.port);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function( String nodeId)?  node,TResult? Function( String nodeId)?  input,TResult? Function( PortRef port)?  output,}) {final _that = this;
switch (_that) {
case HoverNone() when none != null:
return none();case HoverNode() when node != null:
return node(_that.nodeId);case HoverInput() when input != null:
return input(_that.nodeId);case HoverOutput() when output != null:
return output(_that.port);case _:
  return null;

}
}

}

/// @nodoc


class HoverNone implements HoverTarget {
  const HoverNone();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoverNone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HoverTarget.none()';
}


}




/// @nodoc


class HoverNode implements HoverTarget {
  const HoverNode(this.nodeId);
  

 final  String nodeId;

/// Create a copy of HoverTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoverNodeCopyWith<HoverNode> get copyWith => _$HoverNodeCopyWithImpl<HoverNode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoverNode&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,nodeId);
}

@override
String toString() {
    return 'HoverTarget.node(nodeId: $nodeId)';
}


}

/// @nodoc
abstract mixin class $HoverNodeCopyWith<$Res> implements $HoverTargetCopyWith<$Res> {
  factory $HoverNodeCopyWith(HoverNode value, $Res Function(HoverNode) _then) = _$HoverNodeCopyWithImpl;
@useResult
$Res call({
 String nodeId
});




}
/// @nodoc
class _$HoverNodeCopyWithImpl<$Res>
    implements $HoverNodeCopyWith<$Res> {
  _$HoverNodeCopyWithImpl(this._self, this._then);

  final HoverNode _self;
  final $Res Function(HoverNode) _then;

/// Create a copy of HoverTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? nodeId = null,}) {
  return _then(HoverNode(
null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HoverInput implements HoverTarget {
  const HoverInput(this.nodeId);
  

 final  String nodeId;

/// Create a copy of HoverTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoverInputCopyWith<HoverInput> get copyWith => _$HoverInputCopyWithImpl<HoverInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoverInput&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,nodeId);
}

@override
String toString() {
    return 'HoverTarget.input(nodeId: $nodeId)';
}


}

/// @nodoc
abstract mixin class $HoverInputCopyWith<$Res> implements $HoverTargetCopyWith<$Res> {
  factory $HoverInputCopyWith(HoverInput value, $Res Function(HoverInput) _then) = _$HoverInputCopyWithImpl;
@useResult
$Res call({
 String nodeId
});




}
/// @nodoc
class _$HoverInputCopyWithImpl<$Res>
    implements $HoverInputCopyWith<$Res> {
  _$HoverInputCopyWithImpl(this._self, this._then);

  final HoverInput _self;
  final $Res Function(HoverInput) _then;

/// Create a copy of HoverTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? nodeId = null,}) {
  return _then(HoverInput(
null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HoverOutput implements HoverTarget {
  const HoverOutput(this.port);
  

 final  PortRef port;

/// Create a copy of HoverTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoverOutputCopyWith<HoverOutput> get copyWith => _$HoverOutputCopyWithImpl<HoverOutput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HoverOutput&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode {
    return Object.hash(runtimeType,port);
}

@override
String toString() {
    return 'HoverTarget.output(port: $port)';
}


}

/// @nodoc
abstract mixin class $HoverOutputCopyWith<$Res> implements $HoverTargetCopyWith<$Res> {
  factory $HoverOutputCopyWith(HoverOutput value, $Res Function(HoverOutput) _then) = _$HoverOutputCopyWithImpl;
@useResult
$Res call({
 PortRef port
});


$PortRefCopyWith<$Res> get port;

}
/// @nodoc
class _$HoverOutputCopyWithImpl<$Res>
    implements $HoverOutputCopyWith<$Res> {
  _$HoverOutputCopyWithImpl(this._self, this._then);

  final HoverOutput _self;
  final $Res Function(HoverOutput) _then;

/// Create a copy of HoverTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? port = null,}) {
  return _then(HoverOutput(
null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as PortRef,
  ));
}

/// Create a copy of HoverTarget
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortRefCopyWith<$Res> get port {
  
  return $PortRefCopyWith<$Res>(_self.port, (value) {
    return _then(_self.copyWith(port: value));
  });
}
}

/// @nodoc
mixin _$DragAnchor {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DragAnchor);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DragAnchor()';
}


}

/// @nodoc
class $DragAnchorCopyWith<$Res>  {
$DragAnchorCopyWith(DragAnchor _, $Res Function(DragAnchor) __);
}


/// Adds pattern-matching-related methods to [DragAnchor].
extension DragAnchorPatterns on DragAnchor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AnchorOutput value)?  output,TResult Function( AnchorInput value)?  input,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AnchorOutput() when output != null:
return output(_that);case AnchorInput() when input != null:
return input(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AnchorOutput value)  output,required TResult Function( AnchorInput value)  input,}){
final _that = this;
switch (_that) {
case AnchorOutput():
return output(_that);case AnchorInput():
return input(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AnchorOutput value)?  output,TResult? Function( AnchorInput value)?  input,}){
final _that = this;
switch (_that) {
case AnchorOutput() when output != null:
return output(_that);case AnchorInput() when input != null:
return input(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PortRef port)?  output,TResult Function( String nodeId)?  input,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AnchorOutput() when output != null:
return output(_that.port);case AnchorInput() when input != null:
return input(_that.nodeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PortRef port)  output,required TResult Function( String nodeId)  input,}) {final _that = this;
switch (_that) {
case AnchorOutput():
return output(_that.port);case AnchorInput():
return input(_that.nodeId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PortRef port)?  output,TResult? Function( String nodeId)?  input,}) {final _that = this;
switch (_that) {
case AnchorOutput() when output != null:
return output(_that.port);case AnchorInput() when input != null:
return input(_that.nodeId);case _:
  return null;

}
}

}

/// @nodoc


class AnchorOutput extends DragAnchor {
  const AnchorOutput(this.port): super._();
  

 final  PortRef port;

/// Create a copy of DragAnchor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnchorOutputCopyWith<AnchorOutput> get copyWith => _$AnchorOutputCopyWithImpl<AnchorOutput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AnchorOutput&&(identical(other.port, port) || other.port == port));
}


@override
int get hashCode {
    return Object.hash(runtimeType,port);
}

@override
String toString() {
    return 'DragAnchor.output(port: $port)';
}


}

/// @nodoc
abstract mixin class $AnchorOutputCopyWith<$Res> implements $DragAnchorCopyWith<$Res> {
  factory $AnchorOutputCopyWith(AnchorOutput value, $Res Function(AnchorOutput) _then) = _$AnchorOutputCopyWithImpl;
@useResult
$Res call({
 PortRef port
});


$PortRefCopyWith<$Res> get port;

}
/// @nodoc
class _$AnchorOutputCopyWithImpl<$Res>
    implements $AnchorOutputCopyWith<$Res> {
  _$AnchorOutputCopyWithImpl(this._self, this._then);

  final AnchorOutput _self;
  final $Res Function(AnchorOutput) _then;

/// Create a copy of DragAnchor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? port = null,}) {
  return _then(AnchorOutput(
null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as PortRef,
  ));
}

/// Create a copy of DragAnchor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortRefCopyWith<$Res> get port {
  
  return $PortRefCopyWith<$Res>(_self.port, (value) {
    return _then(_self.copyWith(port: value));
  });
}
}

/// @nodoc


class AnchorInput extends DragAnchor {
  const AnchorInput(this.nodeId): super._();
  

 final  String nodeId;

/// Create a copy of DragAnchor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnchorInputCopyWith<AnchorInput> get copyWith => _$AnchorInputCopyWithImpl<AnchorInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AnchorInput&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,nodeId);
}

@override
String toString() {
    return 'DragAnchor.input(nodeId: $nodeId)';
}


}

/// @nodoc
abstract mixin class $AnchorInputCopyWith<$Res> implements $DragAnchorCopyWith<$Res> {
  factory $AnchorInputCopyWith(AnchorInput value, $Res Function(AnchorInput) _then) = _$AnchorInputCopyWithImpl;
@useResult
$Res call({
 String nodeId
});




}
/// @nodoc
class _$AnchorInputCopyWithImpl<$Res>
    implements $AnchorInputCopyWith<$Res> {
  _$AnchorInputCopyWithImpl(this._self, this._then);

  final AnchorInput _self;
  final $Res Function(AnchorInput) _then;

/// Create a copy of DragAnchor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? nodeId = null,}) {
  return _then(AnchorInput(
null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
