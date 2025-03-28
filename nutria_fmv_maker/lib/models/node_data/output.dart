class Output {
  final String? targetNodeId;
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
}