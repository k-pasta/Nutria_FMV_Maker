import 'package:flutter/material.dart';

class NoodleData {
  // final String outputKnotID;
  final bool startLocked;
  final Offset startPosition;
  final Offset endPosition;
  final bool endLocked;
  NoodleData({
    // required this.outputKnotID;
    required this.startPosition,
    required this.endPosition,
    this.startLocked = true,
    this.endLocked = true,
  });

  NoodleData copyWith({
    Offset? startPosition,
    Offset? endPosition,
    bool? startLocked,
    bool? endLocked,
  }) {
    return NoodleData(
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      startLocked: startLocked ?? this.startLocked,
      endLocked: endLocked ?? this.endLocked,
    );
  }
}
