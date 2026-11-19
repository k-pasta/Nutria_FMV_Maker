// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Choice {

 String get id; String get text;
/// Create a copy of Choice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoiceCopyWith<Choice> get copyWith => _$ChoiceCopyWithImpl<Choice>(this as Choice, _$identity);

  /// Serializes this Choice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Choice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Choice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Choice;
  return Object.hash(runtimeType,_this.id,_this.text);
}

@override
String toString() {
  final _this = this as Choice;
  return 'Choice(id: ${_this.id}, text: ${_this.text})';
}


}

/// @nodoc
abstract mixin class $ChoiceCopyWith<$Res>  {
  factory $ChoiceCopyWith(Choice value, $Res Function(Choice) _then) = _$ChoiceCopyWithImpl;
@useResult
$Res call({
 String id, String text
});




}
/// @nodoc
class _$ChoiceCopyWithImpl<$Res>
    implements $ChoiceCopyWith<$Res> {
  _$ChoiceCopyWithImpl(this._self, this._then);

  final Choice _self;
  final $Res Function(Choice) _then;

/// Create a copy of Choice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,}) {
  return _then(Choice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Choice].
extension ChoicePatterns on Choice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Choice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Choice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Choice value)  $default,){
final _that = this;
switch (_that) {
case _Choice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Choice value)?  $default,){
final _that = this;
switch (_that) {
case _Choice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Choice() when $default != null:
return $default(_that.id,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text)  $default,) {final _that = this;
switch (_that) {
case _Choice():
return $default(_that.id,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text)?  $default,) {final _that = this;
switch (_that) {
case _Choice() when $default != null:
return $default(_that.id,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Choice implements Choice {
  const _Choice({required this.id, this.text = ''});
  factory _Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);

@override final  String id;
@override@JsonKey() final  String text;

/// Create a copy of Choice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChoiceCopyWith<_Choice> get copyWith => __$ChoiceCopyWithImpl<_Choice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Choice&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,text);
}

@override
String toString() {
    return 'Choice(id: $id, text: $text)';
}


}

/// @nodoc
abstract mixin class _$ChoiceCopyWith<$Res> implements $ChoiceCopyWith<$Res> {
  factory _$ChoiceCopyWith(_Choice value, $Res Function(_Choice) _then) = __$ChoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String text
});




}
/// @nodoc
class __$ChoiceCopyWithImpl<$Res>
    implements _$ChoiceCopyWith<$Res> {
  __$ChoiceCopyWithImpl(this._self, this._then);

  final _Choice _self;
  final $Res Function(_Choice) _then;

/// Create a copy of Choice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,}) {
  return _then(_Choice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LogicCondition {

 String get id; String? get variableId; FmvComparison get comparison; String get value;
/// Create a copy of LogicCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogicConditionCopyWith<LogicCondition> get copyWith => _$LogicConditionCopyWithImpl<LogicCondition>(this as LogicCondition, _$identity);

  /// Serializes this LogicCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LogicCondition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogicCondition&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.variableId, _this.variableId) || other.variableId == _this.variableId)&&(identical(other.comparison, _this.comparison) || other.comparison == _this.comparison)&&(identical(other.value, _this.value) || other.value == _this.value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LogicCondition;
  return Object.hash(runtimeType,_this.id,_this.variableId,_this.comparison,_this.value);
}

@override
String toString() {
  final _this = this as LogicCondition;
  return 'LogicCondition(id: ${_this.id}, variableId: ${_this.variableId}, comparison: ${_this.comparison}, value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $LogicConditionCopyWith<$Res>  {
  factory $LogicConditionCopyWith(LogicCondition value, $Res Function(LogicCondition) _then) = _$LogicConditionCopyWithImpl;
@useResult
$Res call({
 String id, String? variableId, FmvComparison comparison, String value
});




}
/// @nodoc
class _$LogicConditionCopyWithImpl<$Res>
    implements $LogicConditionCopyWith<$Res> {
  _$LogicConditionCopyWithImpl(this._self, this._then);

  final LogicCondition _self;
  final $Res Function(LogicCondition) _then;

/// Create a copy of LogicCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? variableId = freezed,Object? comparison = null,Object? value = null,}) {
  return _then(LogicCondition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variableId: freezed == variableId ? _self.variableId : variableId // ignore: cast_nullable_to_non_nullable
as String?,comparison: null == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as FmvComparison,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LogicCondition].
extension LogicConditionPatterns on LogicCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogicCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogicCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogicCondition value)  $default,){
final _that = this;
switch (_that) {
case _LogicCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogicCondition value)?  $default,){
final _that = this;
switch (_that) {
case _LogicCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? variableId,  FmvComparison comparison,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogicCondition() when $default != null:
return $default(_that.id,_that.variableId,_that.comparison,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? variableId,  FmvComparison comparison,  String value)  $default,) {final _that = this;
switch (_that) {
case _LogicCondition():
return $default(_that.id,_that.variableId,_that.comparison,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? variableId,  FmvComparison comparison,  String value)?  $default,) {final _that = this;
switch (_that) {
case _LogicCondition() when $default != null:
return $default(_that.id,_that.variableId,_that.comparison,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogicCondition implements LogicCondition {
  const _LogicCondition({required this.id, this.variableId, this.comparison = FmvComparison.equal, this.value = ''});
  factory _LogicCondition.fromJson(Map<String, dynamic> json) => _$LogicConditionFromJson(json);

@override final  String id;
@override final  String? variableId;
@override@JsonKey() final  FmvComparison comparison;
@override@JsonKey() final  String value;

/// Create a copy of LogicCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogicConditionCopyWith<_LogicCondition> get copyWith => __$LogicConditionCopyWithImpl<_LogicCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogicConditionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogicCondition&&(identical(other.id, id) || other.id == id)&&(identical(other.variableId, variableId) || other.variableId == variableId)&&(identical(other.comparison, comparison) || other.comparison == comparison)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,variableId,comparison,value);
}

@override
String toString() {
    return 'LogicCondition(id: $id, variableId: $variableId, comparison: $comparison, value: $value)';
}


}

/// @nodoc
abstract mixin class _$LogicConditionCopyWith<$Res> implements $LogicConditionCopyWith<$Res> {
  factory _$LogicConditionCopyWith(_LogicCondition value, $Res Function(_LogicCondition) _then) = __$LogicConditionCopyWithImpl;
@override @useResult
$Res call({
 String id, String? variableId, FmvComparison comparison, String value
});




}
/// @nodoc
class __$LogicConditionCopyWithImpl<$Res>
    implements _$LogicConditionCopyWith<$Res> {
  __$LogicConditionCopyWithImpl(this._self, this._then);

  final _LogicCondition _self;
  final $Res Function(_LogicCondition) _then;

/// Create a copy of LogicCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? variableId = freezed,Object? comparison = null,Object? value = null,}) {
  return _then(_LogicCondition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variableId: freezed == variableId ? _self.variableId : variableId // ignore: cast_nullable_to_non_nullable
as String?,comparison: null == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as FmvComparison,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

Node _$NodeFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'origin':
          return OriginNode.fromJson(
            json
          );
                case 'simpleVideo':
          return SimpleVideoNode.fromJson(
            json
          );
                case 'branchedVideo':
          return BranchedVideoNode.fromJson(
            json
          );
                case 'comment':
          return CommentNode.fromJson(
            json
          );
                case 'changeVariable':
          return ChangeVariableNode.fromJson(
            json
          );
                case 'compare':
          return CompareNode.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'Node',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$Node {

 String get id; Position get position; double get width; String? get name; int get swatch; bool get isExpanded;
/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodeCopyWith<Node> get copyWith => _$NodeCopyWithImpl<Node>(this as Node, _$identity);

  /// Serializes this Node to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Node;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Node&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.swatch, _this.swatch) || other.swatch == _this.swatch)&&(identical(other.isExpanded, _this.isExpanded) || other.isExpanded == _this.isExpanded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Node;
  return Object.hash(runtimeType,_this.id,_this.position,_this.width,_this.name,_this.swatch,_this.isExpanded);
}

@override
String toString() {
  final _this = this as Node;
  return 'Node(id: ${_this.id}, position: ${_this.position}, width: ${_this.width}, name: ${_this.name}, swatch: ${_this.swatch}, isExpanded: ${_this.isExpanded})';
}


}

/// @nodoc
abstract mixin class $NodeCopyWith<$Res>  {
  factory $NodeCopyWith(Node value, $Res Function(Node) _then) = _$NodeCopyWithImpl;
@useResult
$Res call({
 String id, Position position, double width, String? name, int swatch, bool isExpanded
});


$PositionCopyWith<$Res> get position;

}
/// @nodoc
class _$NodeCopyWithImpl<$Res>
    implements $NodeCopyWith<$Res> {
  _$NodeCopyWithImpl(this._self, this._then);

  final Node _self;
  final $Res Function(Node) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? position = null,Object? width = null,Object? name = freezed,Object? swatch = null,Object? isExpanded = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,swatch: null == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as int,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [Node].
extension NodePatterns on Node {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OriginNode value)?  origin,TResult Function( SimpleVideoNode value)?  simpleVideo,TResult Function( BranchedVideoNode value)?  branchedVideo,TResult Function( CommentNode value)?  comment,TResult Function( ChangeVariableNode value)?  changeVariable,TResult Function( CompareNode value)?  compare,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OriginNode() when origin != null:
return origin(_that);case SimpleVideoNode() when simpleVideo != null:
return simpleVideo(_that);case BranchedVideoNode() when branchedVideo != null:
return branchedVideo(_that);case CommentNode() when comment != null:
return comment(_that);case ChangeVariableNode() when changeVariable != null:
return changeVariable(_that);case CompareNode() when compare != null:
return compare(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OriginNode value)  origin,required TResult Function( SimpleVideoNode value)  simpleVideo,required TResult Function( BranchedVideoNode value)  branchedVideo,required TResult Function( CommentNode value)  comment,required TResult Function( ChangeVariableNode value)  changeVariable,required TResult Function( CompareNode value)  compare,}){
final _that = this;
switch (_that) {
case OriginNode():
return origin(_that);case SimpleVideoNode():
return simpleVideo(_that);case BranchedVideoNode():
return branchedVideo(_that);case CommentNode():
return comment(_that);case ChangeVariableNode():
return changeVariable(_that);case CompareNode():
return compare(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OriginNode value)?  origin,TResult? Function( SimpleVideoNode value)?  simpleVideo,TResult? Function( BranchedVideoNode value)?  branchedVideo,TResult? Function( CommentNode value)?  comment,TResult? Function( ChangeVariableNode value)?  changeVariable,TResult? Function( CompareNode value)?  compare,}){
final _that = this;
switch (_that) {
case OriginNode() when origin != null:
return origin(_that);case SimpleVideoNode() when simpleVideo != null:
return simpleVideo(_that);case BranchedVideoNode() when branchedVideo != null:
return branchedVideo(_that);case CommentNode() when comment != null:
return comment(_that);case ChangeVariableNode() when changeVariable != null:
return changeVariable(_that);case CompareNode() when compare != null:
return compare(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? menuMusicId,  String? pauseMenuMusicId)?  origin,TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? videoId,  VideoSettingsOverride overrides)?  simpleVideo,TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? videoId,  VideoSettingsOverride overrides,  List<Choice> choices,  String question)?  branchedVideo,TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String text,  String? attachedTo)?  comment,TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? variableId,  FmvChangeOperation operation,  String value)?  changeVariable,TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  List<LogicCondition> conditions,  bool matchAny,  String? expression)?  compare,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OriginNode() when origin != null:
return origin(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.menuMusicId,_that.pauseMenuMusicId);case SimpleVideoNode() when simpleVideo != null:
return simpleVideo(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.videoId,_that.overrides);case BranchedVideoNode() when branchedVideo != null:
return branchedVideo(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.videoId,_that.overrides,_that.choices,_that.question);case CommentNode() when comment != null:
return comment(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.text,_that.attachedTo);case ChangeVariableNode() when changeVariable != null:
return changeVariable(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.variableId,_that.operation,_that.value);case CompareNode() when compare != null:
return compare(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.conditions,_that.matchAny,_that.expression);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? menuMusicId,  String? pauseMenuMusicId)  origin,required TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? videoId,  VideoSettingsOverride overrides)  simpleVideo,required TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? videoId,  VideoSettingsOverride overrides,  List<Choice> choices,  String question)  branchedVideo,required TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String text,  String? attachedTo)  comment,required TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? variableId,  FmvChangeOperation operation,  String value)  changeVariable,required TResult Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  List<LogicCondition> conditions,  bool matchAny,  String? expression)  compare,}) {final _that = this;
switch (_that) {
case OriginNode():
return origin(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.menuMusicId,_that.pauseMenuMusicId);case SimpleVideoNode():
return simpleVideo(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.videoId,_that.overrides);case BranchedVideoNode():
return branchedVideo(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.videoId,_that.overrides,_that.choices,_that.question);case CommentNode():
return comment(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.text,_that.attachedTo);case ChangeVariableNode():
return changeVariable(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.variableId,_that.operation,_that.value);case CompareNode():
return compare(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.conditions,_that.matchAny,_that.expression);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? menuMusicId,  String? pauseMenuMusicId)?  origin,TResult? Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? videoId,  VideoSettingsOverride overrides)?  simpleVideo,TResult? Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? videoId,  VideoSettingsOverride overrides,  List<Choice> choices,  String question)?  branchedVideo,TResult? Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String text,  String? attachedTo)?  comment,TResult? Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  String? variableId,  FmvChangeOperation operation,  String value)?  changeVariable,TResult? Function( String id,  Position position,  double width,  String? name,  int swatch,  bool isExpanded,  List<LogicCondition> conditions,  bool matchAny,  String? expression)?  compare,}) {final _that = this;
switch (_that) {
case OriginNode() when origin != null:
return origin(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.menuMusicId,_that.pauseMenuMusicId);case SimpleVideoNode() when simpleVideo != null:
return simpleVideo(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.videoId,_that.overrides);case BranchedVideoNode() when branchedVideo != null:
return branchedVideo(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.videoId,_that.overrides,_that.choices,_that.question);case CommentNode() when comment != null:
return comment(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.text,_that.attachedTo);case ChangeVariableNode() when changeVariable != null:
return changeVariable(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.variableId,_that.operation,_that.value);case CompareNode() when compare != null:
return compare(_that.id,_that.position,_that.width,_that.name,_that.swatch,_that.isExpanded,_that.conditions,_that.matchAny,_that.expression);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class OriginNode extends Node {
  const OriginNode({required this.id, required this.position, this.width = kDefaultNodeWidth, this.name, this.swatch = 1, this.isExpanded = false, this.menuMusicId, this.pauseMenuMusicId,  String? $type}): $type = $type ?? 'origin',super._();
  factory OriginNode.fromJson(Map<String, dynamic> json) => _$OriginNodeFromJson(json);

@override final  String id;
@override final  Position position;
@override@JsonKey() final  double width;
@override final  String? name;
@override@JsonKey() final  int swatch;
@override@JsonKey() final  bool isExpanded;
/// Imported audio that loops in the main menu, if any.
 final  String? menuMusicId;
/// Imported audio that loops in the pause menu (the viewer paused the
/// story), if any. Pause music at the end of a video is a setting.
 final  String? pauseMenuMusicId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OriginNodeCopyWith<OriginNode> get copyWith => _$OriginNodeCopyWithImpl<OriginNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OriginNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OriginNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.name, name) || other.name == name)&&(identical(other.swatch, swatch) || other.swatch == swatch)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded)&&(identical(other.menuMusicId, menuMusicId) || other.menuMusicId == menuMusicId)&&(identical(other.pauseMenuMusicId, pauseMenuMusicId) || other.pauseMenuMusicId == pauseMenuMusicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,position,width,name,swatch,isExpanded,menuMusicId,pauseMenuMusicId);
}

@override
String toString() {
    return 'Node.origin(id: $id, position: $position, width: $width, name: $name, swatch: $swatch, isExpanded: $isExpanded, menuMusicId: $menuMusicId, pauseMenuMusicId: $pauseMenuMusicId)';
}


}

/// @nodoc
abstract mixin class $OriginNodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory $OriginNodeCopyWith(OriginNode value, $Res Function(OriginNode) _then) = _$OriginNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, Position position, double width, String? name, int swatch, bool isExpanded, String? menuMusicId, String? pauseMenuMusicId
});


@override $PositionCopyWith<$Res> get position;

}
/// @nodoc
class _$OriginNodeCopyWithImpl<$Res>
    implements $OriginNodeCopyWith<$Res> {
  _$OriginNodeCopyWithImpl(this._self, this._then);

  final OriginNode _self;
  final $Res Function(OriginNode) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? width = null,Object? name = freezed,Object? swatch = null,Object? isExpanded = null,Object? menuMusicId = freezed,Object? pauseMenuMusicId = freezed,}) {
  return _then(OriginNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,swatch: null == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as int,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,menuMusicId: freezed == menuMusicId ? _self.menuMusicId : menuMusicId // ignore: cast_nullable_to_non_nullable
as String?,pauseMenuMusicId: freezed == pauseMenuMusicId ? _self.pauseMenuMusicId : pauseMenuMusicId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class SimpleVideoNode extends Node {
  const SimpleVideoNode({required this.id, required this.position, this.width = kDefaultNodeWidth, this.name, this.swatch = 0, this.isExpanded = false, this.videoId, this.overrides = const VideoSettingsOverride(),  String? $type}): $type = $type ?? 'simpleVideo',super._();
  factory SimpleVideoNode.fromJson(Map<String, dynamic> json) => _$SimpleVideoNodeFromJson(json);

@override final  String id;
@override final  Position position;
@override@JsonKey() final  double width;
@override final  String? name;
@override@JsonKey() final  int swatch;
@override@JsonKey() final  bool isExpanded;
 final  String? videoId;
@JsonKey() final  VideoSettingsOverride overrides;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimpleVideoNodeCopyWith<SimpleVideoNode> get copyWith => _$SimpleVideoNodeCopyWithImpl<SimpleVideoNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SimpleVideoNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SimpleVideoNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.name, name) || other.name == name)&&(identical(other.swatch, swatch) || other.swatch == swatch)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded)&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.overrides, overrides) || other.overrides == overrides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,position,width,name,swatch,isExpanded,videoId,overrides);
}

@override
String toString() {
    return 'Node.simpleVideo(id: $id, position: $position, width: $width, name: $name, swatch: $swatch, isExpanded: $isExpanded, videoId: $videoId, overrides: $overrides)';
}


}

/// @nodoc
abstract mixin class $SimpleVideoNodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory $SimpleVideoNodeCopyWith(SimpleVideoNode value, $Res Function(SimpleVideoNode) _then) = _$SimpleVideoNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, Position position, double width, String? name, int swatch, bool isExpanded, String? videoId, VideoSettingsOverride overrides
});


@override $PositionCopyWith<$Res> get position;$VideoSettingsOverrideCopyWith<$Res> get overrides;

}
/// @nodoc
class _$SimpleVideoNodeCopyWithImpl<$Res>
    implements $SimpleVideoNodeCopyWith<$Res> {
  _$SimpleVideoNodeCopyWithImpl(this._self, this._then);

  final SimpleVideoNode _self;
  final $Res Function(SimpleVideoNode) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? width = null,Object? name = freezed,Object? swatch = null,Object? isExpanded = null,Object? videoId = freezed,Object? overrides = null,}) {
  return _then(SimpleVideoNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,swatch: null == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as int,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,videoId: freezed == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String?,overrides: null == overrides ? _self.overrides : overrides // ignore: cast_nullable_to_non_nullable
as VideoSettingsOverride,
  ));
}

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoSettingsOverrideCopyWith<$Res> get overrides {
  
  return $VideoSettingsOverrideCopyWith<$Res>(_self.overrides, (value) {
    return _then(_self.copyWith(overrides: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class BranchedVideoNode extends Node {
  const BranchedVideoNode({required this.id, required this.position, this.width = kDefaultNodeWidth, this.name, this.swatch = 0, this.isExpanded = false, this.videoId, this.overrides = const VideoSettingsOverride(),  List<Choice> choices = const <Choice>[], this.question = '',  String? $type}): _choices = choices,$type = $type ?? 'branchedVideo',super._();
  factory BranchedVideoNode.fromJson(Map<String, dynamic> json) => _$BranchedVideoNodeFromJson(json);

@override final  String id;
@override final  Position position;
@override@JsonKey() final  double width;
@override final  String? name;
@override@JsonKey() final  int swatch;
@override@JsonKey() final  bool isExpanded;
 final  String? videoId;
@JsonKey() final  VideoSettingsOverride overrides;
 final  List<Choice> _choices;
@JsonKey() List<Choice> get choices {
  if (_choices is EqualUnmodifiableListView) return _choices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choices);
}

/// A question shown above the choices, with no output of its own, when
/// the "Show Question" setting is on.
@JsonKey() final  String question;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchedVideoNodeCopyWith<BranchedVideoNode> get copyWith => _$BranchedVideoNodeCopyWithImpl<BranchedVideoNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchedVideoNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchedVideoNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.name, name) || other.name == name)&&(identical(other.swatch, swatch) || other.swatch == swatch)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded)&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.overrides, overrides) || other.overrides == overrides)&&const DeepCollectionEquality().equals(other.choices, _choices)&&(identical(other.question, question) || other.question == question));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,position,width,name,swatch,isExpanded,videoId,overrides,const DeepCollectionEquality().hash(_choices),question);
}

@override
String toString() {
    return 'Node.branchedVideo(id: $id, position: $position, width: $width, name: $name, swatch: $swatch, isExpanded: $isExpanded, videoId: $videoId, overrides: $overrides, choices: $choices, question: $question)';
}


}

/// @nodoc
abstract mixin class $BranchedVideoNodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory $BranchedVideoNodeCopyWith(BranchedVideoNode value, $Res Function(BranchedVideoNode) _then) = _$BranchedVideoNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, Position position, double width, String? name, int swatch, bool isExpanded, String? videoId, VideoSettingsOverride overrides, List<Choice> choices, String question
});


@override $PositionCopyWith<$Res> get position;$VideoSettingsOverrideCopyWith<$Res> get overrides;

}
/// @nodoc
class _$BranchedVideoNodeCopyWithImpl<$Res>
    implements $BranchedVideoNodeCopyWith<$Res> {
  _$BranchedVideoNodeCopyWithImpl(this._self, this._then);

  final BranchedVideoNode _self;
  final $Res Function(BranchedVideoNode) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? width = null,Object? name = freezed,Object? swatch = null,Object? isExpanded = null,Object? videoId = freezed,Object? overrides = null,Object? choices = null,Object? question = null,}) {
  return _then(BranchedVideoNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,swatch: null == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as int,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,videoId: freezed == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String?,overrides: null == overrides ? _self.overrides : overrides // ignore: cast_nullable_to_non_nullable
as VideoSettingsOverride,choices: null == choices ? _self._choices : choices // ignore: cast_nullable_to_non_nullable
as List<Choice>,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoSettingsOverrideCopyWith<$Res> get overrides {
  
  return $VideoSettingsOverrideCopyWith<$Res>(_self.overrides, (value) {
    return _then(_self.copyWith(overrides: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class CommentNode extends Node {
  const CommentNode({required this.id, required this.position, this.width = kDefaultNodeWidth, this.name, this.swatch = 0, this.isExpanded = false, this.text = '', this.attachedTo,  String? $type}): $type = $type ?? 'comment',super._();
  factory CommentNode.fromJson(Map<String, dynamic> json) => _$CommentNodeFromJson(json);

@override final  String id;
@override final  Position position;
@override@JsonKey() final  double width;
@override final  String? name;
@override@JsonKey() final  int swatch;
@override@JsonKey() final  bool isExpanded;
/// The text, with `**bold**` and `*italic*`.
@JsonKey() final  String text;
/// The node it is attached to, if any. A node has at most one.
 final  String? attachedTo;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentNodeCopyWith<CommentNode> get copyWith => _$CommentNodeCopyWithImpl<CommentNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.name, name) || other.name == name)&&(identical(other.swatch, swatch) || other.swatch == swatch)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded)&&(identical(other.text, text) || other.text == text)&&(identical(other.attachedTo, attachedTo) || other.attachedTo == attachedTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,position,width,name,swatch,isExpanded,text,attachedTo);
}

@override
String toString() {
    return 'Node.comment(id: $id, position: $position, width: $width, name: $name, swatch: $swatch, isExpanded: $isExpanded, text: $text, attachedTo: $attachedTo)';
}


}

/// @nodoc
abstract mixin class $CommentNodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory $CommentNodeCopyWith(CommentNode value, $Res Function(CommentNode) _then) = _$CommentNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, Position position, double width, String? name, int swatch, bool isExpanded, String text, String? attachedTo
});


@override $PositionCopyWith<$Res> get position;

}
/// @nodoc
class _$CommentNodeCopyWithImpl<$Res>
    implements $CommentNodeCopyWith<$Res> {
  _$CommentNodeCopyWithImpl(this._self, this._then);

  final CommentNode _self;
  final $Res Function(CommentNode) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? width = null,Object? name = freezed,Object? swatch = null,Object? isExpanded = null,Object? text = null,Object? attachedTo = freezed,}) {
  return _then(CommentNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,swatch: null == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as int,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,attachedTo: freezed == attachedTo ? _self.attachedTo : attachedTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ChangeVariableNode extends Node {
  const ChangeVariableNode({required this.id, required this.position, this.width = kDefaultNodeWidth, this.name, this.swatch = kLogicNodeSwatch, this.isExpanded = false, this.variableId, this.operation = FmvChangeOperation.set, this.value = '',  String? $type}): $type = $type ?? 'changeVariable',super._();
  factory ChangeVariableNode.fromJson(Map<String, dynamic> json) => _$ChangeVariableNodeFromJson(json);

@override final  String id;
@override final  Position position;
@override@JsonKey() final  double width;
@override final  String? name;
@override@JsonKey() final  int swatch;
@override@JsonKey() final  bool isExpanded;
 final  String? variableId;
@JsonKey() final  FmvChangeOperation operation;
@JsonKey() final  String value;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeVariableNodeCopyWith<ChangeVariableNode> get copyWith => _$ChangeVariableNodeCopyWithImpl<ChangeVariableNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeVariableNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeVariableNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.name, name) || other.name == name)&&(identical(other.swatch, swatch) || other.swatch == swatch)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded)&&(identical(other.variableId, variableId) || other.variableId == variableId)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,position,width,name,swatch,isExpanded,variableId,operation,value);
}

@override
String toString() {
    return 'Node.changeVariable(id: $id, position: $position, width: $width, name: $name, swatch: $swatch, isExpanded: $isExpanded, variableId: $variableId, operation: $operation, value: $value)';
}


}

/// @nodoc
abstract mixin class $ChangeVariableNodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory $ChangeVariableNodeCopyWith(ChangeVariableNode value, $Res Function(ChangeVariableNode) _then) = _$ChangeVariableNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, Position position, double width, String? name, int swatch, bool isExpanded, String? variableId, FmvChangeOperation operation, String value
});


@override $PositionCopyWith<$Res> get position;

}
/// @nodoc
class _$ChangeVariableNodeCopyWithImpl<$Res>
    implements $ChangeVariableNodeCopyWith<$Res> {
  _$ChangeVariableNodeCopyWithImpl(this._self, this._then);

  final ChangeVariableNode _self;
  final $Res Function(ChangeVariableNode) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? width = null,Object? name = freezed,Object? swatch = null,Object? isExpanded = null,Object? variableId = freezed,Object? operation = null,Object? value = null,}) {
  return _then(ChangeVariableNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,swatch: null == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as int,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,variableId: freezed == variableId ? _self.variableId : variableId // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as FmvChangeOperation,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class CompareNode extends Node {
  const CompareNode({required this.id, required this.position, this.width = kDefaultNodeWidth, this.name, this.swatch = kLogicNodeSwatch, this.isExpanded = false,  List<LogicCondition> conditions = const <LogicCondition>[], this.matchAny = false, this.expression,  String? $type}): _conditions = conditions,$type = $type ?? 'compare',super._();
  factory CompareNode.fromJson(Map<String, dynamic> json) => _$CompareNodeFromJson(json);

@override final  String id;
@override final  Position position;
@override@JsonKey() final  double width;
@override final  String? name;
@override@JsonKey() final  int swatch;
@override@JsonKey() final  bool isExpanded;
 final  List<LogicCondition> _conditions;
@JsonKey() List<LogicCondition> get conditions {
  if (_conditions is EqualUnmodifiableListView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditions);
}

@JsonKey() final  bool matchAny;
 final  String? expression;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompareNodeCopyWith<CompareNode> get copyWith => _$CompareNodeCopyWithImpl<CompareNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompareNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CompareNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.name, name) || other.name == name)&&(identical(other.swatch, swatch) || other.swatch == swatch)&&(identical(other.isExpanded, isExpanded) || other.isExpanded == isExpanded)&&const DeepCollectionEquality().equals(other.conditions, _conditions)&&(identical(other.matchAny, matchAny) || other.matchAny == matchAny)&&(identical(other.expression, expression) || other.expression == expression));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,position,width,name,swatch,isExpanded,const DeepCollectionEquality().hash(_conditions),matchAny,expression);
}

@override
String toString() {
    return 'Node.compare(id: $id, position: $position, width: $width, name: $name, swatch: $swatch, isExpanded: $isExpanded, conditions: $conditions, matchAny: $matchAny, expression: $expression)';
}


}

/// @nodoc
abstract mixin class $CompareNodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory $CompareNodeCopyWith(CompareNode value, $Res Function(CompareNode) _then) = _$CompareNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, Position position, double width, String? name, int swatch, bool isExpanded, List<LogicCondition> conditions, bool matchAny, String? expression
});


@override $PositionCopyWith<$Res> get position;

}
/// @nodoc
class _$CompareNodeCopyWithImpl<$Res>
    implements $CompareNodeCopyWith<$Res> {
  _$CompareNodeCopyWithImpl(this._self, this._then);

  final CompareNode _self;
  final $Res Function(CompareNode) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? width = null,Object? name = freezed,Object? swatch = null,Object? isExpanded = null,Object? conditions = null,Object? matchAny = null,Object? expression = freezed,}) {
  return _then(CompareNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,swatch: null == swatch ? _self.swatch : swatch // ignore: cast_nullable_to_non_nullable
as int,isExpanded: null == isExpanded ? _self.isExpanded : isExpanded // ignore: cast_nullable_to_non_nullable
as bool,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<LogicCondition>,matchAny: null == matchAny ? _self.matchAny : matchAny // ignore: cast_nullable_to_non_nullable
as bool,expression: freezed == expression ? _self.expression : expression // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

// dart format on
