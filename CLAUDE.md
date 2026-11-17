# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Nutria FMV Maker is a GPLv3 Flutter **desktop** app (Windows is the main target) for authoring interactive movies (branching video stories) in a node-graph editor. It is one part of "Nutria FMV":
- **Maker** (this repo): the editor. It saves projects as `.nfmv` and exports playable `.fmv` files.
- **Player** (separate repo, `k-pasta/Nutria_FMV_Player`): plays `.fmv` files.
- **Protocol**: the `.fmv` JSON format shared by both apps.

The Flutter project lives in `nutria_fmv_maker/`, not at the repo root. Run every `flutter`/`dart` command from there; from the root they fail with misleading errors (for example "generate flag not turned on").

The `.fmv` format itself is the pure-Dart package `packages/nutria_fmv_protocol/` (no dependencies, SDK `^3.5` so the Player can use it), which the Maker depends on by path.

## Commands

```sh
cd nutria_fmv_maker
flutter pub get                    # also regenerates lib/l10n/generated (pubspec has generate: true)
flutter run -d windows
flutter analyze                    # or: dart analyze
flutter test                       # unit + widget tests
flutter test test/features/node_widgets_test.dart --plain-name "<test name>"
dart run build_runner build --delete-conflicting-outputs   # after changing @riverpod / @freezed / JSON models

# The shared .fmv package
cd ../packages/nutria_fmv_protocol && dart test

# Frame timings on a generated 300-node project, profile mode, both themes:
flutter drive --profile -d windows --driver=test_driver/perf_driver.dart --target=integration_test/drag_performance_test.dart
# results: build/integration_response_data.json
```

## Environment gotchas

- **Generated files are committed**: `*.g.dart`, `*.freezed.dart` (build_runner) and `lib/l10n/generated/` (gen-l10n). Never hand-edit them.
- **Localizations:** `.arb` files are in `lib/l10n/` (`app_en.arb` is the template; also `el`, `fr`). Add every new string to all three. Import `package:nutria_fmv_maker/l10n/generated/app_localizations.dart` (not the old `flutter_gen` synthetic package).
  - If `AppLocalizations` suddenly goes missing, run `flutter pub get`, which regenerates the files.
  - Two Flutter processes on the project at once (VS Code plus a terminal) can delete the folder mid-generation. They can also break Windows builds with "Cannot open source file ... ephemeral\cpp_client_wrapper"; just rerun.
- `MediaKit.ensureInitialized()` and a preloaded `SharedPreferences` (overriding `sharedPreferencesProvider`) are required in `main()` before `runApp`.
- **No FFmpeg.**
  - Thumbnails come from `fc_native_video_thumbnail` (background thread, queued two at a time).
  - Metadata comes from `media_metadata`.
  - Don't use `media_metadata` for thumbnails: on Windows it runs on the UI thread and freezes the app.
- **Known Flutter Windows engine bug:** a `Tooltip` wrapped around a `Slider` crashes `flutter_windows.dll` when the window is resized. Put tooltips on plain widgets only.
- **Windows clipboard:** it can be "busy" (another app has it open). `SystemClipboardService` retries and never throws; keep it that way.
- **Imports:** use `package:material_ui/material_ui.dart`, not `package:flutter/material.dart` (deprecated in 3.47), and `package:` imports only.

## Architecture

Layers, each depending only on those above it:

```
lib/
  core/       pure Dart (no Flutter, no Riverpod, no IO): the document model and all edit logic
  services/   IO behind small interfaces, each provided by a Riverpod provider (tests override them)
  features/   Riverpod notifiers/selectors (providers/) and the widgets that use them (widgets/)
  ui/         presentational design system: values in, callbacks out. Never imports Riverpod
              (test/ui/ui_widgets_test.dart enforces this) or features/
  app/        app.dart (MaterialApp), app_commands.dart, app_menus.dart, app_shortcuts.dart
```

### Document and undo (`core/`, `features/project/providers/`)
- `ProjectDocument` (freezed, immutable) holds:
  - `nodes` (`Map<String, Node>`) and `edges` (connections are `Edge(from: PortRef, to: PortRef)`, not stored on nodes)
  - `videos` (`VideoAsset`, absolute path), `info` (title and description), `settings` (`VideoSettings`, the project defaults), `variables`
- `Node` is a sealed freezed union: `OriginNode` (exactly one, can't be deleted or copied), `SimpleVideoNode` and `BranchedVideoNode`.
  - A branched node has `choices`; each choice's `id` is also its output port key.
  - Per-node `VideoSettingsOverride` overrides the project settings.
- All edits are pure functions in `core/graph/`:
  - `graph_ops.dart`: nodes, edges, choices, videos
  - `fragment.dart`: copy/paste
  - `variable_ops.dart`: variables
- `documentProvider` (`DocumentNotifier`) is the **only** way to change the document: `apply(label, (doc) => newDoc, {mergeKey})`, or `beginTransaction`, several `apply` calls, then `commit` for a whole gesture.
  - History is snapshot-based (`core/history/document_timeline.dart`).
  - Text fields pass a per-focus `mergeKey`, so one typing session is one undo step.
  - `isDirty` compares document identity with the saved one.
- `GraphEditor` (`graphEditorProvider`) has one method per user command; each is one undo step. Gestures that need state live in their own notifiers (`nodeGestureProvider`, `connectionDragProvider`, `marqueeProvider`).
- **Selectors** (`document_selectors.dart`) give widgets narrow slices: `nodeProvider(id)`, `nodeContentProvider(id)` (the node without its position), `projectDocumentProvider`, and others.
  - Compare documents **by identity**, never with `==`: a freezed deep compare on every frame of a drag is what made dragging slow.
- **Editor-only state** is never saved and never undone: selection, canvas view, connection drag, overlays, panel layout, preferences (persisted in `SharedPreferences`), clipboard state.

### Canvas and nodes
- `CanvasView` is an `InteractiveViewer` with pan and scale turned off, over a 2,000,000px `SizedBox`.
  - Zoom, middle-drag/Shift-drag panning, box selection and animated framing (`CanvasViewController.frame`, `canvas_framing.dart`) are handled by the app.
  - Node positions are relative to `kCanvasCenter`; `CanvasSpace` converts screen positions to canvas positions.
- **Performance-critical node rendering** (`node_layer.dart`):
  - Moving a node rebuilds only its `Positioned`: the content is a cached widget that watches `nodeContentProvider`.
  - Each node is behind a `RepaintBoundary`.
  - Don't add blurred shadows or animated decorations per node or per control. Themes with elevation use `RaisedEdge` (a painted 1px edge) for controls.
  - Check changes with the perf test above; a drag frame should stay well under 16ms build and raster.
- **Geometry** (`features/nodes/node_layout.dart`): `NodeMetrics` and `NodeLayout` compute knot positions from fixed row heights and a cached measurement of the wrapped file name. Widgets and the pure `noodlesFor` (connection lines) both use them, so knots and lines always agree.
- Laid-out node sizes are recorded in `NodeBounds` (no rebuilds) for box selection and framing.
- **To add a node type:** add a variant to `Node`; handle it in the switches the compiler flags (`ports.dart`, `node_registry.dart`, `node_layout.dart`, `fmv_exporter.dart`, `fragment.dart`); add a body widget.

### File formats
- **`.nfmv`** (`core/serialization/nfmv_codec.dart`): the `ProjectDocument` JSON with `formatVersion` (`kNfmvFormatVersion`), plus video paths relative to the project file.
  - New fields need defaults so older files still load.
  - Older formats are rejected, not migrated, unless an upgrade step is added in `decode`.
- **`.fmv`**: the format (`FmvProject`: `{ProjectInfo, ProjectSettings, Nodes}`), writing it and lenient reading live in `packages/nutria_fmv_protocol`, shared with the Player.
  - `core/protocol/fmv_exporter.dart` only maps a `ProjectDocument` to an `FmvProject`: nodes reachable from the origin, with sequential ids from `001` (playback starts at the first node), and only connected choices.
  - Any change to the package is a protocol change for both apps; `test/core/golden/` pins the Maker's output.
  - Keep the package Dart 3.5-compatible.
  - Variables are not exported yet.

### UI, theme, shortcuts
- **Theme:** `AppTheme` (`ui/theme/app_theme.dart`) is a `ThemeExtension` holding every color (`c…`) and size (`d…`); widgets read it with `context.appTheme`. Presets are in `app_theme_presets.dart` (dark is the default, light, and "custom", the seed of a future accessible theme).
  - Never hard-code colors or sizes.
  - Node colors are per theme: `theme.swatch(node.swatch)`.
  - `dElevation > 0` turns on shadows on nodes and raised controls.
  - `test/ui/theme_contrast_test.dart` enforces WCAG contrast minimums for each preset.
  - Adding a token means touching the constructor default, the field and `copyWith` in `AppTheme`.
- **Components:** use the `Nutria*` widgets in `ui/widgets/`:
  - `NutriaButton` (give icon-only buttons a `tooltip`; a test checks this) and `NutriaTextField`
  - `NutriaNumberField` (arrows plus typing; accepts a comma as decimal point) and `NutriaSettingRow` (`options` gives a right-click menu of all values)
  - `NutriaContextMenuArea`, `showNutriaChoiceDialog`, and others
- **Shortcuts:** all commands go through `AppCommands`. The key table is in `app_shortcuts.dart`; the menus show the same activators.
  - `NutriaTextField` swallows every character key and keeps Ctrl+C/X/V/A for its own text, so single-key app shortcuts (T, N, F, Space, …) never fire while typing.
  - `AppShell` takes focus back when nothing else has it.

## Conventions
- **Comments:** each file starts with a one-line `//` header saying what it's for. Public types and notifier methods get `///` docs. Comment the *why*. No commented-out code or `print`.
- **Widgets:** feature widgets are `ConsumerWidget`s that `ref.watch(...select(...))` narrowly. Each gesture callback calls one notifier or `GraphEditor` method; rules and algorithms belong in `core/` or a notifier.
- **Lints:** `flutter_lints` plus `riverpod_lint` (analyzer plugin), `always_use_package_imports`, `avoid_print`, `directives_ordering`, `prefer_const_constructors`, `prefer_final_locals`, `unawaited_futures`. Keep `flutter analyze` clean.

## Tests
- `test/core/`: pure unit tests. `fixtures.dart` has `storyFixture()` and `sequentialIds()`.
- `test/features/harness.dart`: `Harness.create()` gives a `ProviderContainer` with in-memory fakes (`MemoryProjectFiles`, `FakePlayer`).
- `test/features/app_tester.dart`: `pumpApp(tester, {overrides, mediaInfo, player, startView})` pumps the whole app in a 1600x900 window with fake services.
  - It resets the view so canvas (0, 0) is centered at 100%; pass `startView: true` to keep the startup framing.
  - Video file names on nodes contain zero-width spaces (so they wrap anywhere): find them with `NodeMetrics.wrappable(name)` or `kNoVideo`.
- `test/features/narrow_window_test.dart` shrinks the window for every left-panel section and fails on any overflow.
- Widget tests use the test font, so text renders as boxes. Check the real look with `flutter run`.
