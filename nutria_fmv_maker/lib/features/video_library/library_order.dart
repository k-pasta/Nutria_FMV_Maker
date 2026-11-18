// The order and grouping of the media library's entries (pure).
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';

/// One titled run of library entries. [key] is `null` when the library
/// isn't grouped, a [MediaKind] when grouped by kind, or the extension
/// (a `String`) when grouped by file type.
typedef LibraryGroup = ({Object? key, List<MediaAsset> media});

/// [media] (in import order) sorted by [sort] and split by [grouping].
/// Empty groups are left out.
List<LibraryGroup> libraryGroups(
  List<MediaAsset> media,
  LibrarySort sort,
  LibraryGrouping grouping,
) {
  final sorted = [...media];
  int byName(MediaAsset a, MediaAsset b) {
    final names = a.fileName.toLowerCase().compareTo(b.fileName.toLowerCase());
    return names != 0 ? names : a.path.compareTo(b.path);
  }

  int byType(MediaAsset a, MediaAsset b) {
    final kinds = a.kind.index.compareTo(b.kind.index);
    if (kinds != 0) return kinds;
    final extensions = a.extension.compareTo(b.extension);
    return extensions != 0 ? extensions : byName(a, b);
  }

  switch (sort) {
    // Import order is date added; a stable sort keeps it within ties.
    case LibrarySort.dateAdded:
      break;
    case LibrarySort.name:
      _stableSort(sorted, byName);
    case LibrarySort.type:
      _stableSort(sorted, byType);
  }

  switch (grouping) {
    case LibraryGrouping.none:
      return [(key: null, media: sorted)];
    case LibraryGrouping.kind:
      return [
        for (final kind in MediaKind.values)
          if (sorted.where((m) => m.kind == kind).toList() case final list
              when list.isNotEmpty)
            (key: kind, media: list),
      ];
    case LibraryGrouping.fileType:
      final extensions = {for (final m in sorted) m.extension}.toList()
        ..sort((a, b) {
          final kinds = mediaKindOfExtension(a).index.compareTo(
            mediaKindOfExtension(b).index,
          );
          return kinds != 0 ? kinds : a.compareTo(b);
        });
      return [
        for (final extension in extensions)
          (
            key: extension,
            media: [
              for (final m in sorted)
                if (m.extension == extension) m,
            ],
          ),
      ];
  }
}

/// A stable merge sort (`List.sort` isn't guaranteed to be stable).
void _stableSort<T>(List<T> list, int Function(T a, T b) compare) {
  if (list.length < 2) return;
  final middle = list.length ~/ 2;
  final left = list.sublist(0, middle);
  final right = list.sublist(middle);
  _stableSort(left, compare);
  _stableSort(right, compare);
  var i = 0, j = 0, k = 0;
  while (i < left.length && j < right.length) {
    list[k++] = compare(left[i], right[j]) <= 0 ? left[i++] : right[j++];
  }
  while (i < left.length) {
    list[k++] = left[i++];
  }
  while (j < right.length) {
    list[k++] = right[j++];
  }
}
