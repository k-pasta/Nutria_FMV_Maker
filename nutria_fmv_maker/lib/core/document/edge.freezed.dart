// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortRef {

 String get nodeId; String get port;
/// Create a copy of PortRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortRefCopyWith<PortRef> get copyWith => _$PortRefCopyWithImpl<PortRef>(this as PortRef, _$identity);

  /// Serializes this PortRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PortRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortRef&&(identical(other.nodeId, _this.nodeId) || other.nodeId == _this.nodeId)&&(identical(other.port, _this.port) || other.port == _this.port));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PortRef;
  return Object.hash(runtimeType,_this.nodeId,_this.port);
}

@override
String toString() {
  final _this = this as PortRef;
  return 'PortRef(nodeId: ${_this.nodeId}, port: ${_this.port})';
}


}

/// @nodoc
abstract mixin class $PortRefCopyWith<$Res>  {
  factory $PortRefCopyWith(PortRef value, $Res Function(PortRef) _then) = _$PortRefCopyWithImpl;
@useResult
$Res call({
 String nodeId, String port
});




}
/// @nodoc
class _$PortRefCopyWithImpl<$Res>
    implements $PortRefCopyWith<$Res> {
  _$PortRefCopyWithImpl(this._self, this._then);

  final PortRef _self;
  final $Res Function(PortRef) _then;

/// Create a copy of PortRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodeId = null,Object? port = null,}) {
  return _then(PortRef(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PortRef].
extension PortRefPatterns on PortRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortRef value)  $default,){
final _that = this;
switch (_that) {
case _PortRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortRef value)?  $default,){
final _that = this;
switch (_that) {
case _PortRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nodeId,  String port)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortRef() when $default != null:
return $default(_that.nodeId,_that.port);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nodeId,  String port)  $default,) {final _that = this;
switch (_that) {
case _PortRef():
return $default(_that.nodeId,_that.port);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nodeId,  String port)?  $default,) {final _that = this;
switch (_that) {
case _PortRef() when $default != null:
return $default(_that.nodeId,_that.port);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortRef implements PortRef {
  const _PortRef({required this.nodeId, required this.port});
  factory _PortRef.fromJson(Map<String, dynamic> json) => _$PortRefFromJson(json);

@override final  String nodeId;
@override final  String port;

/// Create a copy of PortRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortRefCopyWith<_PortRef> get copyWith => __$PortRefCopyWithImpl<_PortRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortRef&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.port, port) || other.port == port));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,nodeId,port);
}

@override
String toString() {
    return 'PortRef(nodeId: $nodeId, port: $port)';
}


}

/// @nodoc
abstract mixin class _$PortRefCopyWith<$Res> implements $PortRefCopyWith<$Res> {
  factory _$PortRefCopyWith(_PortRef value, $Res Function(_PortRef) _then) = __$PortRefCopyWithImpl;
@override @useResult
$Res call({
 String nodeId, String port
});




}
/// @nodoc
class __$PortRefCopyWithImpl<$Res>
    implements _$PortRefCopyWith<$Res> {
  __$PortRefCopyWithImpl(this._self, this._then);

  final _PortRef _self;
  final $Res Function(_PortRef) _then;

/// Create a copy of PortRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodeId = null,Object? port = null,}) {
  return _then(_PortRef(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Edge {

 PortRef get from; PortRef get to; EdgeKind get kind;
/// Create a copy of Edge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EdgeCopyWith<Edge> get copyWith => _$EdgeCopyWithImpl<Edge>(this as Edge, _$identity);

  /// Serializes this Edge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Edge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Edge&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Edge;
  return Object.hash(runtimeType,_this.from,_this.to,_this.kind);
}

@override
String toString() {
  final _this = this as Edge;
  return 'Edge(from: ${_this.from}, to: ${_this.to}, kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $EdgeCopyWith<$Res>  {
  factory $EdgeCopyWith(Edge value, $Res Function(Edge) _then) = _$EdgeCopyWithImpl;
@useResult
$Res call({
 PortRef from, PortRef to, EdgeKind kind
});


$PortRefCopyWith<$Res> get from;$PortRefCopyWith<$Res> get to;

}
/// @nodoc
class _$EdgeCopyWithImpl<$Res>
    implements $EdgeCopyWith<$Res> {
  _$EdgeCopyWithImpl(this._self, this._then);

  final Edge _self;
  final $Res Function(Edge) _then;

/// Create a copy of Edge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? kind = null,}) {
  return _then(Edge(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as PortRef,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as PortRef,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as EdgeKind,
  ));
}
/// Create a copy of Edge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortRefCopyWith<$Res> get from {
  
  return $PortRefCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}/// Create a copy of Edge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortRefCopyWith<$Res> get to {
  
  return $PortRefCopyWith<$Res>(_self.to, (value) {
    return _then(_self.copyWith(to: value));
  });
}
}


/// Adds pattern-matching-related methods to [Edge].
extension EdgePatterns on Edge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Edge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Edge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Edge value)  $default,){
final _that = this;
switch (_that) {
case _Edge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Edge value)?  $default,){
final _that = this;
switch (_that) {
case _Edge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PortRef from,  PortRef to,  EdgeKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Edge() when $default != null:
return $default(_that.from,_that.to,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PortRef from,  PortRef to,  EdgeKind kind)  $default,) {final _that = this;
switch (_that) {
case _Edge():
return $default(_that.from,_that.to,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PortRef from,  PortRef to,  EdgeKind kind)?  $default,) {final _that = this;
switch (_that) {
case _Edge() when $default != null:
return $default(_that.from,_that.to,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Edge implements Edge {
  const _Edge({required this.from, required this.to, this.kind = EdgeKind.flow});
  factory _Edge.fromJson(Map<String, dynamic> json) => _$EdgeFromJson(json);

@override final  PortRef from;
@override final  PortRef to;
@override@JsonKey() final  EdgeKind kind;

/// Create a copy of Edge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EdgeCopyWith<_Edge> get copyWith => __$EdgeCopyWithImpl<_Edge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EdgeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Edge&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,from,to,kind);
}

@override
String toString() {
    return 'Edge(from: $from, to: $to, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$EdgeCopyWith<$Res> implements $EdgeCopyWith<$Res> {
  factory _$EdgeCopyWith(_Edge value, $Res Function(_Edge) _then) = __$EdgeCopyWithImpl;
@override @useResult
$Res call({
 PortRef from, PortRef to, EdgeKind kind
});


@override $PortRefCopyWith<$Res> get from;@override $PortRefCopyWith<$Res> get to;

}
/// @nodoc
class __$EdgeCopyWithImpl<$Res>
    implements _$EdgeCopyWith<$Res> {
  __$EdgeCopyWithImpl(this._self, this._then);

  final _Edge _self;
  final $Res Function(_Edge) _then;

/// Create a copy of Edge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? kind = null,}) {
  return _then(_Edge(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as PortRef,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as PortRef,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as EdgeKind,
  ));
}

/// Create a copy of Edge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortRefCopyWith<$Res> get from {
  
  return $PortRefCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}/// Create a copy of Edge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PortRefCopyWith<$Res> get to {
  
  return $PortRefCopyWith<$Res>(_self.to, (value) {
    return _then(_self.copyWith(to: value));
  });
}
}

// dart format on
