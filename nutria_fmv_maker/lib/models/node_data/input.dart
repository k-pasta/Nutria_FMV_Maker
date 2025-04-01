import 'package:json_annotation/json_annotation.dart';

part 'input.g.dart';

@JsonSerializable()
class Input {
  final bool isBeingTargeted;
  final bool isBeingDragged;

  const Input({
    this.isBeingTargeted = false,
    this.isBeingDragged = false,
  });

  Input copyWith({
    bool? isBeingTargeted,
    bool? isBeingDragged,
  }) {
    return Input(
      isBeingTargeted: isBeingTargeted ?? this.isBeingTargeted,
      isBeingDragged: isBeingDragged ?? this.isBeingDragged,
    );
  }
  
//JsonSerializable encode and decode methods
factory Input.fromJson(Map<String, dynamic> json) => _$InputFromJson(json);

Map<String, dynamic> toJson() => _$InputToJson(this);

}