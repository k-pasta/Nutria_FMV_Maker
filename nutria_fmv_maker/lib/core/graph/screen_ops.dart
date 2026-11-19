// Editing designed screens and their styles.
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';

/// Edits on the main menu screen and the styles.
extension ScreenOps on ProjectDocument {
  ProjectDocument _menu(MenuScreen Function(MenuScreen s) edit) =>
      copyWith(menuScreen: edit(menuScreen));

  ProjectDocument _element(
    String id,
    ScreenElement Function(ScreenElement e) edit,
  ) => _menu(
    (s) => s.copyWith(
      elements: [for (final e in s.elements) e.id == id ? edit(e) : e],
    ),
  );

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

  /// Adds an element of [kind] with id [id], below the lowest one (or in
  /// the middle of an empty screen).
  ProjectDocument addScreenElement(String id, ScreenElementKind kind) {
    final lowest = menuScreen.elements.fold<double?>(
      null,
      (low, e) => low == null || e.y > low ? e.y : low,
    );
    final y = lowest == null ? 0.5 : (lowest + 0.1).clamp(0.05, 0.95);
    return _menu(
      (s) => s.copyWith(
        elements: [
          ...s.elements,
          ScreenElement(id: id, kind: kind, y: y),
        ],
      ),
    );
  }

  ProjectDocument moveScreenElement(String id, double x, double y) =>
      _element(id, (e) => e.copyWith(x: x.clamp(0, 1), y: y.clamp(0, 1)));

  ProjectDocument setScreenElementWidth(String id, double width) =>
      _element(id, (e) => e.copyWith(width: width.clamp(0.05, 1)));

  ProjectDocument setScreenElementStyle(String id, String? styleId) =>
      _element(id, (e) => e.copyWith(styleId: styleId));

  /// Sets the element's own text; empty goes back to the default.
  ProjectDocument setScreenElementText(String id, String text) =>
      _element(id, (e) => e.copyWith(text: text.trim().isEmpty ? null : text));

  ProjectDocument removeScreenElement(String id) => _menu(
    (s) => s.copyWith(
      elements: [
        for (final e in s.elements)
          if (e.id != id) e,
      ],
    ),
  );

  ProjectDocument setMenuBackground(String? mediaId) =>
      _menu((s) => s.copyWith(backgroundId: mediaId));

  /// Replaces the elements with the classic layout: title and description
  /// near the top, a column of buttons below. [newId] makes the ids.
  ProjectDocument applyClassicMenu(String Function() newId) => _menu(
    (s) => s.copyWith(
      elements: [
        ScreenElement(
          id: newId(),
          kind: ScreenElementKind.title,
          y: 0.22,
          width: 0.7,
        ),
        ScreenElement(
          id: newId(),
          kind: ScreenElementKind.description,
          y: 0.34,
          width: 0.6,
        ),
        for (final (i, kind) in [
          ScreenElementKind.start,
          ScreenElementKind.load,
          ScreenElementKind.settings,
          ScreenElementKind.quit,
        ].indexed)
          ScreenElement(
            id: newId(),
            kind: kind,
            y: 0.55 + i * 0.1,
            width: 0.28,
          ),
      ],
    ),
  );

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
}
