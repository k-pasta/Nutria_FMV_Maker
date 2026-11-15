# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Nutria FMV Maker is a GPLv3 Flutter **desktop** app (Windows is the primary target) for authoring interactive movies (branching video narratives) through a node-graph editor. It is one part of the "Nutria FMV" system:
- **Maker** (this repo): the node editor. It saves projects as `.nfmv` and exports playable `.fmv` files.
- **Player** (separate repo, `k-pasta/Nutria_FMV_Player`): plays `.fmv` files.
- **Protocol**: the `.fmv` JSON format shared by the two apps.

The Flutter project is in the `nutria_fmv_maker/` subdirectory, not at the repo root. Run every `flutter`/`dart` command from there.

## Commands

```sh
cd nutria_fmv_maker
flutter pub get
flutter run -d windows                 # main dev target
flutter build windows
flutter analyze                        # lints: flutter_lints (analysis_options.yaml)
dart run build_runner build --delete-conflicting-outputs   # regenerate *.g.dart (json_serializable)
flutter gen-l10n                       # regenerate localizations (also runs automatically on build, since `generate: true`)
flutter test                           # run all tests
flutter test test/widget_test.dart --plain-name "<test name>"   # run a single test
```

`test/widget_test.dart` is still the default counter template and fails against the real app. There is no meaningful test suite yet.

## Environment gotchas

- **FFprobe path is hard-coded.** `DataStaticProperties.ffprobePath` in `lib/static_data/data_static_properties.dart` is an absolute path to `nutria_fmv_maker/ffmpeg/bin` (marked `TODO IMPORTANT`). Video metadata retrieval (`utilities/video_metadata_retriever.dart`, using `ffmpeg_helper`) breaks on other machines or checkouts until this is changed. The bundled FFmpeg is a GPLv3 static Windows build.
- `MediaKit.ensureInitialized()` must run before `runApp`. Video playback uses `media_kit`, not `video_player`, because `video_player` has no Windows desktop support.
- Thumbnails come from `fc_native_video_thumbnail` (OS-native) and are written to the temp dir (`tmp_path`).
- Localizations are imported as `package:flutter_gen/gen_l10n/app_localizations.dart` (synthetic package). The ARB files are in `lib/i10n/` (`app_en.arb` is the template; `app_el.arb` and `app_fr.arb` are the others). Add new strings to all three files.

## Architecture

### State: Provider with immutable models
All app state lives in `ChangeNotifier`s registered in a single `MultiProvider` in `lib/main.dart`. The most important providers are:
- `NodesProvider`: the core document state. It holds the `List<NodeData>` of nodes and the `List<VideoData>` of imported videos, and handles node CRUD, selection, dragging and resizing, noodle (connection) dragging, "lazy connection" target detection, per-node overrides, and video import.
- `ProjectVersionProvider`: save/load of `.nfmv` and export to `.fmv`. It also detects unsaved changes by comparing serialized strings.
- `GridCanvasProvider`: the canvas `TransformationController`, plus zoom and pan.
- `UiStateProvider`, `AppSettingsProvider`, `KeyboardProvider` (modifier keys), `VideoPlayerProvider`, `ThemeProvider`, `LocaleProvider`, `NotificationProvider` (messages in the bottom info bar).

The node models are **immutable** and updated through `copyWith`, then swapped into the provider's list followed by `notifyListeners()`. Widgets subscribe narrowly with `Selector`, often selecting a `Tuple` from the `tuple` package. Avoid broad `context.watch<NodesProvider>()` in node widgets, because it causes the performance problems this design was built to avoid.

### Node model hierarchy (`lib/models/node_data/`)
```
NodeData (position, id, intendedPosition, isSelected, isBeingHovered)
└─ BaseNodeData (nodeName, nodeWidth, outputs: List<Output>, input, swatch, isExpanded)
   ├─ OriginNodeData          start node (project title/description), cannot be deleted
   └─ VideoNodeData           videoDataId + overrides
      ├─ SimpleVideoNodeData   a single output (linear "pseudo-edit")
      └─ BranchedVideoNodeData 2–10 outputs, created automatically from the option texts
```
- `intendedPosition` and `intendedNodeWidth` hold the unsnapped values that grid snapping and default-width snapping work from.
- Connections are stored on the output side (`Output.targetNodeId`). Input and output knot positions are computed from the theme (`inputPosition(theme)` / `outputPosition(theme, i)`).
- Per-node settings that override the project defaults are the sealed `VideoNodeOverride` subclasses in `video_node_overrides.dart`: selectionTime, pauseOnEnd, showTimer, videoFit, defaultSelection. `VideoNodeOverrideConverter` handles their JSON. Project settings are a list of the same override types.
- Models use `json_serializable` (`*.g.dart` is generated; do not hand-edit it) plus custom converters in `models/converters/` for `Offset` and `Color`.

### Canvas rendering (`lib/grid_canvas.dart`)
- The canvas is an `InteractiveViewer` with infinite boundary margins over a large fixed-size `SizedBox` (`UiStaticProperties.canvasSize`). Scroll zoom is handled manually through `GridCanvasProvider`.
- Node widgets are **cached** in a parallel `List<Widget>` keyed by `ValueKey(nodeId)`. `_updateNodes` reuses existing widgets and only builds new ones, driven by a `Selector` on `NodesProvider.iDsandTypes`. Each node widget then selects its own data by id. When adding a node type, extend `_addNodeById` along with the type switches in `ProjectVersionProvider` (load/save use a `'type'` discriminator string).
- Knots and noodles stick out past node bounds, so hit-testing outside a parent relies on `defer_pointer` and invisible overlay hit areas.
- Painters are in `lib/painters/` (adaptive dot grid, noodles, stripes).

### File formats (`ProjectVersionProvider`)
- **`.nfmv`** (project save): `{ "nodes": [ {"type": "<ClassName>", ...toJson()} ], "videos": [VideoData...] }`.
- **`.fmv`** (export for the Player): nodes are traversed from the origin and given simplified sequential ids (`utilities/simplify_node_tree.dart`), and `videoDataId` is replaced with the absolute video path. The output is `{ "ProjectInfo": <origin toJsonExport>, "ProjectSettings": {overrideName: jsonValue}, "Nodes": { "<id>": { "video", "choices": [{option, target}], "overrides": {...} } } }`. Changes to this structure break the separate Player app.
- Video references are absolute paths, so projects are not portable between machines (a known limitation).

### Theming and constants
- The app uses a custom theme system instead of Material theming. `AppTheme` (`lib/models/app_theme.dart`) holds all colors (`c*`) and dimensions (`d*`), and `ThemeProvider` supplies the current one (dark by default, plus an experimental light theme). Read colors and sizes from `theme` instead of hard-coding them.
- Fixed layout and data constants are in `lib/static_data/ui_static_properties.dart` and `data_static_properties.dart`.
- UI components are custom `Nutria*` widgets in `lib/custom_widgets/` (button, text, textfield, slider, menu bar, split view, context menu). Prefer them over raw Material widgets.

### Leftover / scratch files
`lib/fvp_example.dart`, `internationalisation_example.dart`, `thumbnail_example.dart`, `video_metadata_tests.dart`, `noodle.dart` and `noodle_painter_current.dart` are experiments that no other file imports. `video_player_section.dart` is live (imported by `windows_app_layout.dart`). `lib/base_classes/command.dart` defines a `Command` (execute/undo) interface meant for undo/redo, but nothing implements it yet.
