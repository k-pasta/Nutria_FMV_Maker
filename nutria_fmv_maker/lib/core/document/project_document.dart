// The complete, saveable state of a project: the single source of truth for undo.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';

part 'project_document.freezed.dart';
part 'project_document.g.dart';

/// Version of the `.nfmv` format written by this code. Bump it when the
/// format changes and add an upgrade step in `nfmv_codec.dart`.
const int kNfmvFormatVersion = 4;

/// Id of the origin node in a new project.
const String kOriginNodeId = 'origin';

/// Information shown on the Player's start screen.
@freezed
abstract class ProjectInfo with _$ProjectInfo {
  const factory ProjectInfo({
    String? title,
    String? description,

    /// The story's languages as codes (see `kFmvLanguageNames`), the main one
    /// first. Empty: not said (one language).
    @Default(<String>[]) List<String> languages,
  }) = _ProjectInfo;

  factory ProjectInfo.fromJson(Map<String, dynamic> json) =>
      _$ProjectInfoFromJson(json);
}

/// How many colors, after the first, can have their own defaults.
const kMaxColorDefaults = 5;

/// Media by id, built once per document (documents never change).
final _mediaIndex = Expando<Map<String, MediaAsset>>('media by id');

/// Everything that is saved to `.nfmv`, undone by undo, and exported to `.fmv`.
///
/// Immutable: every edit produces a new document (see `core/graph/graph_ops.dart`),
/// which is what makes snapshot-based undo cheap and safe.
@freezed
abstract class ProjectDocument with _$ProjectDocument {
  const ProjectDocument._();

  const factory ProjectDocument({
    @Default(kNfmvFormatVersion) int formatVersion,
    @Default(ProjectInfo()) ProjectInfo info,

    /// The defaults: for the first color, and every color without its own
    /// entry in [colorDefaults].
    @Default(VideoSettings()) VideoSettings settings,

    /// Defaults for other colors, by swatch index (1 to [kMaxColorDefaults]).
    /// Missing in older files, hence empty.
    @Default(<int, VideoSettings>{}) Map<int, VideoSettings> colorDefaults,

    /// Nodes by id. Insertion order is kept but carries no meaning.
    @Default(<String, Node>{}) Map<String, Node> nodes,
    @Default(<Edge>[]) List<Edge> edges,

    /// Imported files, in import order (which is also "date added").
    @Default(<MediaAsset>[]) List<MediaAsset> media,

    /// Named values for the story. Missing in older files, hence empty.
    @Default(<Variable>[]) List<Variable> variables,

    /// The main menu's design. Missing in older files, hence empty.
    @Default(ScreenDesign()) ScreenDesign menuScreen,

    /// How the answers are shown over the video, and the pause menu.
    @Default(ScreenDesign()) ScreenDesign choiceScreen,
    @Default(ScreenDesign()) ScreenDesign pauseScreen,

    /// Styles of screen elements. Older files get the defaults.
    @Default(kDefaultScreenStyles) List<ScreenStyle> styles,
  }) = _ProjectDocument;

  factory ProjectDocument.fromJson(Map<String, dynamic> json) =>
      _$ProjectDocumentFromJson(json);

  /// A new project containing only the origin node.
  factory ProjectDocument.empty() => const ProjectDocument(
    nodes: {
      kOriginNodeId: Node.origin(
        id: kOriginNodeId,
        // No name: shown as the localized "Origin Node".
        position: Position(150, 250),
      ),
    },
  );

  /// The defaults a node of color [swatch] starts from.
  VideoSettings defaultsFor(int swatch) => colorDefaults[swatch] ?? settings;

  /// The single origin node (the story's start).
  OriginNode get origin => nodes.values.whereType<OriginNode>().first;

  /// Looks up an imported file, or `null` if [id] is null or unknown.
  /// Indexed: widgets and noodles look videos up on every frame of a drag.
  MediaAsset? mediaById(String? id) {
    if (id == null) return null;
    final index = _mediaIndex[this] ??= {
      for (final asset in media) asset.id: asset,
    };
    return index[id];
  }
}
