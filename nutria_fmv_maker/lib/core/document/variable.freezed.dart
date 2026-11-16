// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
Variable _$VariableFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'boolean':
          return BoolVariable.fromJson(
            json
          );
                case 'integer':
          return IntVariable.fromJson(
            json
          );
                case 'decimal':
          return DecimalVariable.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'Variable',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$Variable {

 String get id; String get name; Object get initial;
/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VariableCopyWith<Variable> get copyWith => _$VariableCopyWithImpl<Variable>(this as Variable, _$identity);

  /// Serializes this Variable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Variable;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Variable&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.initial, _this.initial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Variable;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.initial));
}

@override
String toString() {
  final _this = this as Variable;
  return 'Variable(id: ${_this.id}, name: ${_this.name}, initial: ${_this.initial})';
}


}

/// @nodoc
abstract mixin class $VariableCopyWith<$Res>  {
  factory $VariableCopyWith(Variable value, $Res Function(Variable) _then) = _$VariableCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$VariableCopyWithImpl<$Res>
    implements $VariableCopyWith<$Res> {
  _$VariableCopyWithImpl(this._self, this._then);

  final Variable _self;
  final $Res Function(Variable) _then;

/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Variable].
extension VariablePatterns on Variable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BoolVariable value)?  boolean,TResult Function( IntVariable value)?  integer,TResult Function( DecimalVariable value)?  decimal,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BoolVariable() when boolean != null:
return boolean(_that);case IntVariable() when integer != null:
return integer(_that);case DecimalVariable() when decimal != null:
return decimal(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BoolVariable value)  boolean,required TResult Function( IntVariable value)  integer,required TResult Function( DecimalVariable value)  decimal,}){
final _that = this;
switch (_that) {
case BoolVariable():
return boolean(_that);case IntVariable():
return integer(_that);case DecimalVariable():
return decimal(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BoolVariable value)?  boolean,TResult? Function( IntVariable value)?  integer,TResult? Function( DecimalVariable value)?  decimal,}){
final _that = this;
switch (_that) {
case BoolVariable() when boolean != null:
return boolean(_that);case IntVariable() when integer != null:
return integer(_that);case DecimalVariable() when decimal != null:
return decimal(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String name,  bool initial)?  boolean,TResult Function( String id,  String name,  int initial)?  integer,TResult Function( String id,  String name,  double initial)?  decimal,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BoolVariable() when boolean != null:
return boolean(_that.id,_that.name,_that.initial);case IntVariable() when integer != null:
return integer(_that.id,_that.name,_that.initial);case DecimalVariable() when decimal != null:
return decimal(_that.id,_that.name,_that.initial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String name,  bool initial)  boolean,required TResult Function( String id,  String name,  int initial)  integer,required TResult Function( String id,  String name,  double initial)  decimal,}) {final _that = this;
switch (_that) {
case BoolVariable():
return boolean(_that.id,_that.name,_that.initial);case IntVariable():
return integer(_that.id,_that.name,_that.initial);case DecimalVariable():
return decimal(_that.id,_that.name,_that.initial);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String name,  bool initial)?  boolean,TResult? Function( String id,  String name,  int initial)?  integer,TResult? Function( String id,  String name,  double initial)?  decimal,}) {final _that = this;
switch (_that) {
case BoolVariable() when boolean != null:
return boolean(_that.id,_that.name,_that.initial);case IntVariable() when integer != null:
return integer(_that.id,_that.name,_that.initial);case DecimalVariable() when decimal != null:
return decimal(_that.id,_that.name,_that.initial);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class BoolVariable extends Variable {
  const BoolVariable({required this.id, required this.name, this.initial = false,  String? $type}): $type = $type ?? 'boolean',super._();
  factory BoolVariable.fromJson(Map<String, dynamic> json) => _$BoolVariableFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  bool initial;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoolVariableCopyWith<BoolVariable> get copyWith => _$BoolVariableCopyWithImpl<BoolVariable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoolVariableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BoolVariable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.initial, initial) || other.initial == initial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,initial);
}

@override
String toString() {
    return 'Variable.boolean(id: $id, name: $name, initial: $initial)';
}


}

/// @nodoc
abstract mixin class $BoolVariableCopyWith<$Res> implements $VariableCopyWith<$Res> {
  factory $BoolVariableCopyWith(BoolVariable value, $Res Function(BoolVariable) _then) = _$BoolVariableCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool initial
});




}
/// @nodoc
class _$BoolVariableCopyWithImpl<$Res>
    implements $BoolVariableCopyWith<$Res> {
  _$BoolVariableCopyWithImpl(this._self, this._then);

  final BoolVariable _self;
  final $Res Function(BoolVariable) _then;

/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? initial = null,}) {
  return _then(BoolVariable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class IntVariable extends Variable {
  const IntVariable({required this.id, required this.name, this.initial = 0,  String? $type}): $type = $type ?? 'integer',super._();
  factory IntVariable.fromJson(Map<String, dynamic> json) => _$IntVariableFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  int initial;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntVariableCopyWith<IntVariable> get copyWith => _$IntVariableCopyWithImpl<IntVariable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntVariableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is IntVariable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.initial, initial) || other.initial == initial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,initial);
}

@override
String toString() {
    return 'Variable.integer(id: $id, name: $name, initial: $initial)';
}


}

/// @nodoc
abstract mixin class $IntVariableCopyWith<$Res> implements $VariableCopyWith<$Res> {
  factory $IntVariableCopyWith(IntVariable value, $Res Function(IntVariable) _then) = _$IntVariableCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int initial
});




}
/// @nodoc
class _$IntVariableCopyWithImpl<$Res>
    implements $IntVariableCopyWith<$Res> {
  _$IntVariableCopyWithImpl(this._self, this._then);

  final IntVariable _self;
  final $Res Function(IntVariable) _then;

/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? initial = null,}) {
  return _then(IntVariable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class DecimalVariable extends Variable {
  const DecimalVariable({required this.id, required this.name, this.initial = 0.0,  String? $type}): $type = $type ?? 'decimal',super._();
  factory DecimalVariable.fromJson(Map<String, dynamic> json) => _$DecimalVariableFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  double initial;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DecimalVariableCopyWith<DecimalVariable> get copyWith => _$DecimalVariableCopyWithImpl<DecimalVariable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DecimalVariableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DecimalVariable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.initial, initial) || other.initial == initial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,initial);
}

@override
String toString() {
    return 'Variable.decimal(id: $id, name: $name, initial: $initial)';
}


}

/// @nodoc
abstract mixin class $DecimalVariableCopyWith<$Res> implements $VariableCopyWith<$Res> {
  factory $DecimalVariableCopyWith(DecimalVariable value, $Res Function(DecimalVariable) _then) = _$DecimalVariableCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double initial
});




}
/// @nodoc
class _$DecimalVariableCopyWithImpl<$Res>
    implements $DecimalVariableCopyWith<$Res> {
  _$DecimalVariableCopyWithImpl(this._self, this._then);

  final DecimalVariable _self;
  final $Res Function(DecimalVariable) _then;

/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? initial = null,}) {
  return _then(DecimalVariable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
