

import 'package:json_annotation/json_annotation.dart';

part 'output.g.dart';

@JsonSerializable()
class Output {
  final String? targetNodeId;
  @OutputDataConverter()
  final Object? outputData;
  final bool isBeingTargeted;
  final bool isBeingDragged;

  const Output({
    this.targetNodeId,
    this.outputData,
    this.isBeingTargeted = false,
    this.isBeingDragged = false,
  });

  Output copyWith({
    String? Function()? targetNodeId,
    Object? Function()? outputData,
    bool? isBeingTargeted,
    bool? isBeingDragged,
  }) {
    return Output(
      targetNodeId: targetNodeId != null ? targetNodeId() : this.targetNodeId,
      outputData: outputData != null ? outputData() : this.outputData,
      isBeingTargeted: isBeingTargeted ?? this.isBeingTargeted,
      isBeingDragged: isBeingDragged ?? this.isBeingDragged,
    );
  }
  
//JsonSerializable encode and decode methods
factory Output.fromJson(Map<String, dynamic> json) => _$OutputFromJson(json);

Map<String, dynamic> toJson() => _$OutputToJson(this);


}

/// Custom converter to handle outputData, which can be either a String or a double
class OutputDataConverter implements JsonConverter<Object?, dynamic> {
  const OutputDataConverter();

  @override
  Object? fromJson(dynamic json) {
    if (json is String) {
      return json;
    } else if (json is num) {
      return json.toDouble(); // Convert number to double if it's not already
    }
    return null;
  }

  @override
  dynamic toJson(Object? object) {
    if (object is String) {
      return object;
    } else if (object is double) {
      return object;
    }
    return null; // Handle other cases as necessary
  }
}