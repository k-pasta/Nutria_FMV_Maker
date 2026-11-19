// Editing designed screens (main menu, choice screen, pause menu) and their
// styles.
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';

/// Ready-made layouts. Applying one replaces the elements of its [screen].
enum ScreenPreset {
  classicMenu(ScreenKind.menu),
  centeredMenu(ScreenKind.menu),
  sideMenu(ScreenKind.menu),
  bottomChoices(ScreenKind.choice),
  sideChoices(ScreenKind.choice),
  classicPause(ScreenKind.pause),
  cornerPause(ScreenKind.pause);

  const ScreenPreset(this.screen);

  final ScreenKind screen;
}

/// One element of a preset: what, where (center) and how wide.
typedef _Place = (ScreenElementKind kind, double x, double y, double width);

/// A column of [kinds] at [x], from [top] down, [step] apart.
List<_Place> _column(
  List<ScreenElementKind> kinds, {
  double x = 0.5,
  required double top,
  required double step,
  required double width,
}) => [for (final (i, kind) in kinds.indexed) (kind, x, top + i * step, width)];

/// The elements of [preset].
List<_Place> _presetPlaces(ScreenPreset preset) => switch (preset) {
  ScreenPreset.classicMenu => [
    (ScreenElementKind.title, 0.5, 0.22, 0.7),
    (ScreenElementKind.description, 0.5, 0.34, 0.6),
    ..._column(
      const [
        ScreenElementKind.start,
        ScreenElementKind.load,
        ScreenElementKind.settings,
        ScreenElementKind.quit,
      ],
      top: 0.55,
      step: 0.1,
      width: 0.28,
    ),
  ],
  ScreenPreset.centeredMenu => [
    (ScreenElementKind.title, 0.5, 0.32, 0.8),
    ..._column(
      const [
        ScreenElementKind.start,
        ScreenElementKind.load,
        ScreenElementKind.quit,
      ],
      top: 0.52,
      step: 0.09,
      width: 0.22,
    ),
  ],
  ScreenPreset.sideMenu => [
    (ScreenElementKind.title, 0.28, 0.2, 0.46),
    (ScreenElementKind.description, 0.28, 0.32, 0.46),
    ..._column(
      const [
        ScreenElementKind.start,
        ScreenElementKind.load,
        ScreenElementKind.settings,
        ScreenElementKind.credits,
        ScreenElementKind.quit,
      ],
      x: 0.18,
      top: 0.5,
      step: 0.09,
      width: 0.24,
    ),
  ],
  ScreenPreset.bottomChoices => [
    (ScreenElementKind.question, 0.5, 0.6, 0.8),
    (ScreenElementKind.choices, 0.5, 0.8, 0.5),
    (ScreenElementKind.timer, 0.5, 0.96, 0.6),
  ],
  ScreenPreset.sideChoices => [
    (ScreenElementKind.question, 0.27, 0.25, 0.44),
    (ScreenElementKind.choices, 0.27, 0.58, 0.4),
    (ScreenElementKind.timer, 0.27, 0.92, 0.4),
  ],
  ScreenPreset.classicPause => [
    (ScreenElementKind.title, 0.5, 0.2, 0.7),
    ..._column(
      const [
        ScreenElementKind.resume,
        ScreenElementKind.save,
        ScreenElementKind.load,
        ScreenElementKind.settings,
        ScreenElementKind.mainMenu,
        ScreenElementKind.quit,
      ],
      top: 0.38,
      step: 0.09,
      width: 0.28,
    ),
  ],
  ScreenPreset.cornerPause => [
    (ScreenElementKind.title, 0.22, 0.16, 0.4),
    ..._column(
      const [
        ScreenElementKind.resume,
        ScreenElementKind.save,
        ScreenElementKind.load,
        ScreenElementKind.settings,
        ScreenElementKind.mainMenu,
        ScreenElementKind.quit,
      ],
      x: 0.15,
      top: 0.5,
      step: 0.075,
      width: 0.22,
    ),
  ],
};

/// Edits on the designed screens and the styles.
extension ScreenOps on ProjectDocument {
  /// The design of [screen].
  ScreenDesign screenOf(ScreenKind screen) => switch (screen) {
    ScreenKind.menu => menuScreen,
    ScreenKind.choice => choiceScreen,
    ScreenKind.pause => pauseScreen,
  };

  ProjectDocument _screen(
    ScreenKind screen,
    ScreenDesign Function(ScreenDesign s) edit,
  ) => switch (screen) {
    ScreenKind.menu => copyWith(menuScreen: edit(menuScreen)),
    ScreenKind.choice => copyWith(choiceScreen: edit(choiceScreen)),
    ScreenKind.pause => copyWith(pauseScreen: edit(pauseScreen)),
  };

  /// The screen element [id] is on, or `null`.
  ScreenKind? screenKindOf(String id) {
    for (final kind in ScreenKind.values) {
      if (screenOf(kind).elements.any((e) => e.id == id)) return kind;
    }
    return null;
  }

  /// Element [id], on whichever screen it is.
  ScreenElement? screenElement(String id) {
    final kind = screenKindOf(id);
    return kind == null
        ? null
        : screenOf(kind).elements.firstWhere((e) => e.id == id);
  }

  ProjectDocument _element(
    String id,
    ScreenElement Function(ScreenElement e) edit,
  ) {
    final kind = screenKindOf(id);
    if (kind == null) return this;
    return _screen(
      kind,
      (s) => s.copyWith(
        elements: [for (final e in s.elements) e.id == id ? edit(e) : e],
      ),
    );
  }

  /// The style element [element] uses (its own, or its kind's default).
  ScreenStyle styleOf(ScreenElement element) {
    final id = element.styleId ?? defaultStyleIdFor(element.kind);
    return styles.where((s) => s.id == id).firstOrNull ??
        styles
            .where((s) => s.id == defaultStyleIdFor(element.kind))
            .firstOrNull ??
        kDefaultScreenStyles.firstWhere(
          (s) => s.id == defaultStyleIdFor(element.kind),
        );
  }

  /// Adds an element of [kind] with id [id] to [screen]: at ([x], [y]) if
  /// given, otherwise below the lowest one (or in the middle of an empty
  /// screen).
  ProjectDocument addScreenElement(
    ScreenKind screen,
    String id,
    ScreenElementKind kind, {
    double? x,
    double? y,
  }) {
    final lowest = screenOf(screen).elements.fold<double?>(
      null,
      (low, e) => low == null || e.y > low ? e.y : low,
    );
    final below = lowest == null ? 0.5 : (lowest + 0.1).clamp(0.05, 0.95);
    return _screen(
      screen,
      (s) => s.copyWith(
        elements: [
          ...s.elements,
          ScreenElement(
            id: id,
            kind: kind,
            x: (x ?? 0.5).clamp(0, 1),
            y: (y ?? below).clamp(0, 1),
          ),
        ],
      ),
    );
  }

  ProjectDocument moveScreenElement(String id, double x, double y) =>
      _element(id, (e) => e.copyWith(x: x.clamp(0, 1), y: y.clamp(0, 1)));

  ProjectDocument setScreenElementWidth(String id, double width) =>
      _element(id, (e) => e.copyWith(width: width.clamp(0.05, 1)));

  ProjectDocument setScreenElementGap(String id, double gap) =>
      _element(id, (e) => e.copyWith(gap: gap.clamp(0, 0.2)));

  ProjectDocument setScreenElementStyle(String id, String? styleId) =>
      _element(id, (e) => e.copyWith(styleId: styleId));

  /// Sets the element's own text; empty goes back to the default.
  ProjectDocument setScreenElementText(String id, String text) =>
      _element(id, (e) => e.copyWith(text: text.trim().isEmpty ? null : text));

  ProjectDocument removeScreenElement(String id) {
    final kind = screenKindOf(id);
    if (kind == null) return this;
    return _screen(
      kind,
      (s) => s.copyWith(
        elements: [
          for (final e in s.elements)
            if (e.id != id) e,
        ],
      ),
    );
  }

  ProjectDocument setScreenBackground(ScreenKind screen, String? mediaId) =>
      _screen(screen, (s) => s.copyWith(backgroundId: mediaId));

  /// The main menu's background.
  ProjectDocument setMenuBackground(String? mediaId) =>
      setScreenBackground(ScreenKind.menu, mediaId);

  /// Replaces the elements of [preset]'s screen with its layout. [newId]
  /// makes the ids.
  ProjectDocument applyScreenPreset(
    ScreenPreset preset,
    String Function() newId,
  ) => _screen(
    preset.screen,
    (s) => s.copyWith(
      elements: [
        for (final (kind, x, y, width) in _presetPlaces(preset))
          ScreenElement(id: newId(), kind: kind, x: x, y: y, width: width),
      ],
    ),
  );

  /// The classic main menu: title and description near the top, a column
  /// of buttons below.
  ProjectDocument applyClassicMenu(String Function() newId) =>
      applyScreenPreset(ScreenPreset.classicMenu, newId);

  /// Edits style [id].
  ProjectDocument editScreenStyle(
    String id,
    ScreenStyle Function(ScreenStyle s) edit,
  ) => copyWith(styles: [for (final s in styles) s.id == id ? edit(s) : s]);

  /// Adds a copy of style [fromId] as style [id] named [name].
  ProjectDocument duplicateScreenStyle(String fromId, String id, String name) {
    final from = styles.where((s) => s.id == fromId).firstOrNull;
    if (from == null) return this;
    return copyWith(
      styles: [
        ...styles,
        from.copyWith(id: id, name: name),
      ],
    );
  }

  /// Renames style [id]; an empty name is ignored.
  ProjectDocument renameScreenStyle(String id, String name) =>
      name.trim().isEmpty
      ? this
      : editScreenStyle(id, (s) => s.copyWith(name: name));

  /// Whether style [id] is one every project has (they can't be deleted:
  /// elements fall back to them).
  static bool isBuiltInStyle(String id) =>
      kDefaultScreenStyles.any((s) => s.id == id);

  /// Deletes style [id]; elements using it go back to their kind's default.
  /// Built-in styles stay.
  ProjectDocument removeScreenStyle(String id) {
    if (isBuiltInStyle(id)) return this;
    var doc = copyWith(
      styles: [
        for (final s in styles)
          if (s.id != id) s,
      ],
    );
    for (final kind in ScreenKind.values) {
      doc = doc._screen(
        kind,
        (s) => s.copyWith(
          elements: [
            for (final e in s.elements)
              e.styleId == id ? e.copyWith(styleId: null) : e,
          ],
        ),
      );
    }
    return doc;
  }

  /// How many elements, on every screen, use style [id].
  int usesOfStyle(String id) => [
    for (final kind in ScreenKind.values)
      for (final e in screenOf(kind).elements)
        if (styleOf(e).id == id) e,
  ].length;
}
