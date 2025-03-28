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
}