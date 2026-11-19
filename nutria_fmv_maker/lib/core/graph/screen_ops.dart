// Editing designed screens (menus, answer screens, settings, saved games)
// and their styles, and keeping the screens a project must have.
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// Ready-made layouts. Applying one replaces the elements of a screen of
/// its [kind].
enum ScreenPreset {
  classicMenu(ScreenKind.menu),
  centeredMenu(ScreenKind.menu),
  sideMenu(ScreenKind.menu),
  bottomChoices(ScreenKind.choice),
  rowChoices(ScreenKind.choice),
  sideChoices(ScreenKind.choice),
  splitChoices(ScreenKind.endChoice),
  pieChoices(ScreenKind.endChoice),
  stackedChoices(ScreenKind.endChoice),
  classicPause(ScreenKind.pause),
  cornerPause(ScreenKind.pause),
  classicSettings(ScreenKind.settings),
  classicSaves(ScreenKind.saves);

  const ScreenPreset(this.kind);

  final ScreenKind kind;

  /// The layout a new screen of [kind] starts with.
  static ScreenPreset defaultFor(ScreenKind kind) => switch (kind) {
    ScreenKind.menu => classicMenu,
    ScreenKind.choice => bottomChoices,
    ScreenKind.endChoice => splitChoices,
    ScreenKind.pause => classicPause,
    ScreenKind.settings => classicSettings,
    ScreenKind.saves => classicSaves,
  };
}

/// One element of a preset: what, where (center), how wide, and (for the
/// answers) how they're laid out.
typedef _Place = ({
  ScreenElementKind kind,
  double x,
  double y,
  double width,
  FmvChoiceLayout layout,
});

_Place _at(
  ScreenElementKind kind,
  double x,
  double y,
  double width, [
  FmvChoiceLayout layout = FmvChoiceLayout.vertical,
]) => (kind: kind, x: x, y: y, width: width, layout: layout);

/// A column of [kinds] at [x], from [top] down, [step] apart.
List<_Place> _column(
  List<ScreenElementKind> kinds, {
  double x = 0.5,
  required double top,
  required double step,
  required double width,
}) => [
  for (final (i, kind) in kinds.indexed) _at(kind, x, top + i * step, width),
];

const _pauseButtons = [
  ScreenElementKind.resume,
  ScreenElementKind.save,
  ScreenElementKind.load,
  ScreenElementKind.settings,
  ScreenElementKind.mainMenu,
  ScreenElementKind.quit,
];

/// The elements of [preset].
List<_Place> _presetPlaces(ScreenPreset preset) => switch (preset) {
  ScreenPreset.classicMenu => [
    _at(ScreenElementKind.title, 0.5, 0.22, 0.7),
    _at(ScreenElementKind.description, 0.5, 0.34, 0.6),
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
    _at(ScreenElementKind.title, 0.5, 0.32, 0.8),
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
    _at(ScreenElementKind.title, 0.28, 0.2, 0.46),
    _at(ScreenElementKind.description, 0.28, 0.32, 0.46),
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
    _at(ScreenElementKind.question, 0.5, 0.42, 0.8),
    _at(ScreenElementKind.choices, 0.5, 0.68, 0.5),
    _at(ScreenElementKind.timer, 0.5, 0.94, 0.6),
  ],
  ScreenPreset.rowChoices => [
    _at(ScreenElementKind.question, 0.5, 0.62, 0.8),
    _at(ScreenElementKind.choices, 0.5, 0.8, 0.9, FmvChoiceLayout.horizontal),
    _at(ScreenElementKind.timer, 0.5, 0.95, 0.9),
  ],
  ScreenPreset.sideChoices => [
    _at(ScreenElementKind.question, 0.27, 0.25, 0.44),
    _at(ScreenElementKind.choices, 0.27, 0.58, 0.4),
    _at(ScreenElementKind.timer, 0.27, 0.92, 0.4),
  ],
  ScreenPreset.splitChoices => [
    _at(ScreenElementKind.question, 0.5, 0.12, 0.8),
    _at(ScreenElementKind.choices, 0.5, 0.5, 1, FmvChoiceLayout.columns),
  ],
  ScreenPreset.pieChoices => [
    _at(ScreenElementKind.question, 0.5, 0.5, 0.3),
    _at(ScreenElementKind.choices, 0.5, 0.5, 0.3, FmvChoiceLayout.radial),
  ],
  ScreenPreset.stackedChoices => [
    _at(ScreenElementKind.question, 0.5, 0.08, 0.8),
    _at(ScreenElementKind.choices, 0.5, 0.5, 0.8, FmvChoiceLayout.rows),
  ],
  ScreenPreset.classicPause => [
    _at(ScreenElementKind.title, 0.5, 0.2, 0.7),
    ..._column(_pauseButtons, top: 0.38, step: 0.09, width: 0.28),
  ],
  ScreenPreset.cornerPause => [
    _at(ScreenElementKind.title, 0.22, 0.16, 0.4),
    ..._column(_pauseButtons, x: 0.15, top: 0.5, step: 0.075, width: 0.22),
  ],
  ScreenPreset.classicSettings => [
    _at(ScreenElementKind.title, 0.5, 0.18, 0.7),
    ..._column(
      const [
        ScreenElementKind.volume,
        ScreenElementKind.subtitles,
        ScreenElementKind.fullScreen,
      ],
      top: 0.4,
      step: 0.13,
      width: 0.4,
    ),
    _at(ScreenElementKind.back, 0.5, 0.85, 0.22),
  ],
  ScreenPreset.classicSaves => [
    _at(ScreenElementKind.title, 0.5, 0.18, 0.7),
    _at(ScreenElementKind.saves, 0.5, 0.5, 0.45),
    _at(ScreenElementKind.back, 0.5, 0.85, 0.22),
  ],
};

List<ScreenElement> _elementsOf(ScreenPreset preset, String Function() newId) =>
    [
      for (final p in _presetPlaces(preset))
        ScreenElement(
          id: newId(),
          kind: p.kind,
          x: p.x,
          y: p.y,
          width: p.width,
          layout: p.layout,
        ),
    ];

/// Ids for the elements of a screen [screenId] starts with: the same every
/// time, so a new project is always the same document.
String Function() _seededIds(String screenId) {
  var n = 0;
  return () => '$screenId-${++n}';
}

/// A screen of [kind] with id [id] and [preset]'s (or the kind's default)
/// layout.
ScreenDesign newScreen(
  ScreenKind kind,
  String id, {
  String? name,
  ScreenPreset? preset,
  String Function()? newId,
}) => ScreenDesign(
  id: id,
  kind: kind,
  name: name,
  elements: _elementsOf(
    preset ?? ScreenPreset.defaultFor(kind),
    newId ?? _seededIds(id),
  ),
);

/// Edits on the designed screens and the styles.
extension ScreenOps on ProjectDocument {
  /// Screen [id], or `null`.
  ScreenDesign? screenById(String? id) =>
      screens.where((s) => s.id == id).firstOrNull;

  /// Every screen of [kind], the first one first.
  List<ScreenDesign> screensOf(ScreenKind kind) => [
    for (final s in screens)
      if (s.kind == kind) s,
  ];

  /// The first screen of [kind] (a default layout if the project has none,
  /// e.g. a settings screen before any Settings button).
  ScreenDesign screenOf(ScreenKind kind) =>
      screenById(kind.defaultId) ??
      screensOf(kind).firstOrNull ??
      newScreen(kind, kind.defaultId);

  /// Screen [id] if it's of [kind], else the first screen of [kind] (for
  /// settings naming a screen that was deleted).
  ScreenDesign resolveScreen(String id, ScreenKind kind) =>
      switch (screenById(id)) {
        final s? when s.kind == kind => s,
        _ => screenOf(kind),
      };

  /// Whether the project's menus have an element of one of [kinds].
  bool _menusHave(Set<ScreenElementKind> kinds) => screens.any(
    (s) =>
        (s.kind == ScreenKind.menu || s.kind == ScreenKind.pause) &&
        s.elements.any((e) => kinds.contains(e.kind)),
  );

  /// Whether the settings screen is used (a menu has a Settings button).
  bool get hasSettingsScreen => _menusHave(const {ScreenElementKind.settings});

  /// Whether the saves screen is used (a menu has Load or Save).
  bool get hasSavesScreen =>
      _menusHave(const {ScreenElementKind.load, ScreenElementKind.save});

  /// The screens and elements a project must have: a main menu, an answer
  /// screen of each kind and a pause menu; a settings screen once a menu
  /// has a Settings button, a saves screen once one has Load or Save; and
  /// on each screen its required elements ([kRequiredScreenElements]).
  ProjectDocument withRequiredScreens() {
    final list = [...screens];
    void ensure(ScreenKind kind) {
      if (!list.any((s) => s.kind == kind)) {
        list.add(newScreen(kind, kind.defaultId));
      }
    }

    ensure(ScreenKind.menu);
    ensure(ScreenKind.choice);
    ensure(ScreenKind.endChoice);
    ensure(ScreenKind.pause);
    var doc = copyWith(screens: list);
    if (doc.hasSettingsScreen) {
      if (!list.any((s) => s.kind == ScreenKind.settings)) {
        list.add(newScreen(ScreenKind.settings, ScreenKind.settings.defaultId));
      }
    }
    if (doc.hasSavesScreen) {
      if (!list.any((s) => s.kind == ScreenKind.saves)) {
        list.add(newScreen(ScreenKind.saves, ScreenKind.saves.defaultId));
      }
    }
    doc = copyWith(screens: [for (final s in list) _withRequired(s)]);
    return _same(doc) ? this : doc;
  }

  /// Whether [doc] has the same screens as this (so nothing changed).
  bool _same(ProjectDocument doc) {
    if (doc.screens.length != screens.length) return false;
    for (var i = 0; i < screens.length; i++) {
      if (!identical(doc.screens[i], screens[i]) &&
          doc.screens[i] != screens[i]) {
        return false;
      }
    }
    return true;
  }

  /// [screen] with any missing required element added where the kind's
  /// default layout puts it.
  static ScreenDesign _withRequired(ScreenDesign screen) {
    final missing = {
      for (final kind in kRequiredScreenElements[screen.kind]!)
        if (!screen.elements.any((e) => e.kind == kind)) kind,
    };
    if (missing.isEmpty) return screen;
    final defaults = newScreen(screen.kind, screen.id).elements;
    final ids = {for (final e in screen.elements) e.id};
    var n = 0;
    String freshId() {
      String id;
      do {
        id = '${screen.id}-r${++n}';
      } while (ids.contains(id));
      return id;
    }

    return screen.copyWith(
      elements: [
        ...screen.elements,
        for (final kind in missing)
          (defaults.where((e) => e.kind == kind).firstOrNull ??
                  ScreenElement(id: '', kind: kind))
              .copyWith(id: freshId()),
      ],
    );
  }

  ProjectDocument _editScreen(
    String id,
    ScreenDesign Function(ScreenDesign s) edit,
  ) {
    if (screenById(id) == null) return this;
    return copyWith(
      screens: [for (final s in screens) s.id == id ? edit(s) : s],
    );
  }

  /// The screen element [id] is on, or `null`.
  ScreenDesign? screenWithElement(String id) {
    for (final s in screens) {
      if (s.elements.any((e) => e.id == id)) return s;
    }
    return null;
  }

  /// Element [id], on whichever screen it is.
  ScreenElement? screenElement(String id) =>
      screenWithElement(id)?.elements.firstWhere((e) => e.id == id);

  ProjectDocument _element(
    String id,
    ScreenElement Function(ScreenElement e) edit,
  ) {
    final screen = screenWithElement(id);
    if (screen == null) return this;
    return _editScreen(
      screen.id,
      (s) => s.copyWith(
        elements: [for (final e in s.elements) e.id == id ? edit(e) : e],
      ),
    );
  }

  /// Whether element [id] can be removed: it isn't the only element of a
  /// kind its screen requires.
  bool canRemoveScreenElement(String id) {
    final screen = screenWithElement(id);
    if (screen == null) return false;
    final element = screen.elements.firstWhere((e) => e.id == id);
    if (!kRequiredScreenElements[screen.kind]!.contains(element.kind)) {
      return true;
    }
    return screen.elements.where((e) => e.kind == element.kind).length > 1;
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

  /// Adds an element of [kind] with id [id] to screen [screenId]: at
  /// ([x], [y]) if given, otherwise below the lowest one (or in the middle
  /// of an empty screen). A Settings, Load or Save button brings its
  /// screen along.
  ProjectDocument addScreenElement(
    String screenId,
    String id,
    ScreenElementKind kind, {
    double? x,
    double? y,
  }) {
    final screen = screenById(screenId);
    if (screen == null) return this;
    final lowest = screen.elements.fold<double?>(
      null,
      (low, e) => low == null || e.y > low ? e.y : low,
    );
    final below = lowest == null ? 0.5 : (lowest + 0.1).clamp(0.05, 0.95);
    return _editScreen(
      screenId,
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
    ).withRequiredScreens();
  }

  ProjectDocument moveScreenElement(String id, double x, double y) =>
      _element(id, (e) => e.copyWith(x: x.clamp(0, 1), y: y.clamp(0, 1)));

  ProjectDocument setScreenElementWidth(String id, double width) =>
      _element(id, (e) => e.copyWith(width: width.clamp(0.05, 1)));

  ProjectDocument setScreenElementGap(String id, double gap) =>
      _element(id, (e) => e.copyWith(gap: gap.clamp(0, 0.2)));

  ProjectDocument setScreenElementLayout(String id, FmvChoiceLayout layout) =>
      _element(id, (e) => e.copyWith(layout: layout));

  ProjectDocument setScreenElementTimerMode(String id, FmvTimerMode mode) =>
      _element(id, (e) => e.copyWith(timerMode: mode));

  ProjectDocument setScreenElementThickness(String id, double thickness) =>
      _element(id, (e) => e.copyWith(thickness: thickness.clamp(0.002, 0.1)));

  ProjectDocument setScreenElementStyle(String id, String? styleId) =>
      _element(id, (e) => e.copyWith(styleId: styleId));

  /// Sets the element's own text; empty goes back to the default.
  ProjectDocument setScreenElementText(String id, String text) =>
      _element(id, (e) => e.copyWith(text: text.trim().isEmpty ? null : text));

  /// Removes element [id], unless its screen requires it
  /// ([canRemoveScreenElement]).
  ProjectDocument removeScreenElement(String id) {
    if (!canRemoveScreenElement(id)) return this;
    final screen = screenWithElement(id)!;
    return _editScreen(
      screen.id,
      (s) => s.copyWith(
        elements: [
          for (final e in s.elements)
            if (e.id != id) e,
        ],
      ),
    );
  }

  ProjectDocument setScreenBackground(String screenId, String? mediaId) =>
      _editScreen(screenId, (s) => s.copyWith(backgroundId: mediaId));

  /// Replaces the elements of screen [screenId] with [preset]'s layout (if
  /// it's a layout for that kind of screen). [newId] makes the ids.
  ProjectDocument applyScreenPreset(
    String screenId,
    ScreenPreset preset,
    String Function() newId,
  ) {
    if (screenById(screenId)?.kind != preset.kind) return this;
    return _editScreen(
      screenId,
      (s) => s.copyWith(elements: _elementsOf(preset, newId)),
    ).withRequiredScreens();
  }

  /// Adds an answer screen of [kind] (one a project can have several of)
  /// with id [id], named [name], in the kind's default layout.
  ProjectDocument addScreen(
    ScreenKind kind,
    String id,
    String name,
    String Function() newId,
  ) {
    if (!kind.isMultiple || screenById(id) != null) return this;
    return copyWith(
      screens: [
        ...screens,
        newScreen(kind, id, name: name, newId: newId),
      ],
    );
  }

  /// Renames screen [id]; an empty name goes back to the kind's name.
  ProjectDocument renameScreen(String id, String name) => _editScreen(
    id,
    (s) => s.copyWith(name: name.trim().isEmpty ? null : name),
  );

  /// Whether screen [id] can be deleted: an answer screen other than the
  /// first of its kind.
  bool canRemoveScreen(String id) {
    final screen = screenById(id);
    return screen != null &&
        screen.kind.isMultiple &&
        screen.id != screen.kind.defaultId;
  }

  /// Deletes answer screen [id]; settings that used it go back to the
  /// first screen of its kind.
  ProjectDocument removeScreen(String id) {
    if (!canRemoveScreen(id)) return this;
    VideoSettings reset(VideoSettings s) => s.copyWith(
      choiceScreenId: s.choiceScreenId == id
          ? ScreenKind.choice.defaultId
          : s.choiceScreenId,
      endChoiceScreenId: s.endChoiceScreenId == id
          ? ScreenKind.endChoice.defaultId
          : s.endChoiceScreenId,
    );
    VideoSettingsOverride resetOverride(VideoSettingsOverride o) => o.copyWith(
      choiceScreenId: o.choiceScreenId == id ? null : o.choiceScreenId,
      endChoiceScreenId: o.endChoiceScreenId == id ? null : o.endChoiceScreenId,
    );
    return copyWith(
      screens: [
        for (final s in screens)
          if (s.id != id) s,
      ],
      settings: reset(settings),
      colorDefaults: {
        for (final MapEntry(:key, :value) in colorDefaults.entries)
          key: reset(value),
      },
      nodes: {
        for (final MapEntry(:key, :value) in nodes.entries)
          key: switch (value) {
            BranchedVideoNode() => value.copyWith(
              overrides: resetOverride(value.overrides),
            ),
            _ => value,
          },
      },
    );
  }

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
    return copyWith(
      styles: [
        for (final s in styles)
          if (s.id != id) s,
      ],
      screens: [
        for (final screen in screens)
          screen.copyWith(
            elements: [
              for (final e in screen.elements)
                e.styleId == id ? e.copyWith(styleId: null) : e,
            ],
          ),
      ],
    );
  }

  /// How many elements, on every screen, use style [id].
  int usesOfStyle(String id) => [
    for (final s in screens)
      for (final e in s.elements)
        if (styleOf(e).id == id) e,
  ].length;
}
