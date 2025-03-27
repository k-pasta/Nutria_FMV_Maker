class SnapSettings {
  final bool gridSnapping;
  final double gridSize;

  const SnapSettings({
    required this.gridSnapping,
    this.gridSize = 50,
  });

  SnapSettings copyWith({
    bool? gridSnapping,
    double? gridSize,
  }) {
    return SnapSettings(
      gridSnapping: gridSnapping ?? this.gridSnapping,
      gridSize: gridSize ?? this.gridSize,
    );
  }
}