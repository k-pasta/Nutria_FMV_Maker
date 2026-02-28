
import 'enums_data.dart';

/// Represents a file size with a numerical value and a unit of measurement.
class FileSize {
  final double size;
  final FileSizeUnit unit;
  
  FileSize(this.size, this.unit);

  /// Returns a human-readable string representation of the file size
  /// in the format "<size> <unit>", using the enum's name as the unit.
  @override
  String toString() {
    return '$size ${unit.toString().split('.').last}';
  }
}

