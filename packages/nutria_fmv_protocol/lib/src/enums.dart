// The named values of playback settings, as written in .fmv files.

/// How a video is scaled to the screen.
enum FmvVideoFit {
  fit,
  fitWidth,
  fitHeight,
  fill,
  fillWidth,
  fillHeight,
  stretch;

  /// Reads a written value; `null` if unknown. Lenient, see [fmvEnumKey].
  static FmvVideoFit? parse(Object? value) => _parse(values, value);
}

/// Which choice is taken when the viewer doesn't pick one in time.
enum FmvDefaultSelection {
  first,
  last,
  lastSelected,
  random,
  specified;

  /// Reads a written value; `null` if unknown. Lenient, see [fmvEnumKey].
  static FmvDefaultSelection? parse(Object? value) => _parse(values, value);
}

/// The form enum values are compared in: lower case, without spaces, dashes
/// or underscores. Files are written with the enum names ("fillWidth"), and
/// readers also accept older spellings such as "fill width" or "FillWidth".
String fmvEnumKey(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');

T? _parse<T extends Enum>(List<T> values, Object? value) {
  if (value is! String) return null;
  final key = fmvEnumKey(value);
  for (final candidate in values) {
    if (fmvEnumKey(candidate.name) == key) return candidate;
  }
  return null;
}
