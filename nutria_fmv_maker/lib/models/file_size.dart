
import 'enums_data.dart';

class FileSize {
  final double size;
  final FileSizeUnit unit;
  
  FileSize(this.size, this.unit);

  @override
  String toString() {
    return '$size ${unit.toString().split('.').last}';
  }
}

