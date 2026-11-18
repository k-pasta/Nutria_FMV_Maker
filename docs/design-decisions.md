# Design decisions to review

Decisions made while working on my own, newest round first. Each entry says
what was decided and why. **"Ask"** marks questions I would have asked you;
change any of them and I'll adapt.

## Fifth round (from the big feature list)

### Phase 1a: bug fixes
- **Tooltip and focus:** the error hint on the variable name now keeps the
  field (and its focus) when it appears or disappears. Other tooltips are
  unchanged (cheaper), so this only applies where a hint comes and goes
  while typing (`NutriaTooltip(stable: true)`).
- **Text field right-click menu:** our own menu (Cut, Copy, Paste, Select
  all) replaces Flutter's. It is always screen-sized, whatever the zoom.
  Cut/Copy only appear when text is selected. Labels come from Flutter's
  translations, so Greek and French work without new strings.
- **Overridden selection time:** the number shows in the accent color, like
  other overridden values.
- **Menu dimmer:** now stays while moving between menus (open menus are
  counted instead of a single open/closed flag).

### Phase 1b: variables
- **Name rules:** a letter first, then letters, digits, `-` and `_`.
  "Letter" includes any script (Greek, accented letters), so names can be
  in your language. **Ask:** should names be ASCII only? That would make
  future expressions slightly simpler to type on any keyboard.
- **Rejected characters:** the field keeps its previous text and the status
  bar says why. Names loaded from older projects that break the rules (e.g.
  "variable 1" with a space) are flagged red, like duplicates; nothing is
  renamed automatically.
- **New default names:** `variable_1`, `variable_2`, …
- **Layout:** line 1: name, type stepper, delete. Line 2: the value; for
  numbers `[min] value [max]`.
- **Min/max:** small square fields showing `−∞` / `+∞` when empty (no
  limit); click and type. No popup: fewer clicks, same look.
- **Clamping:** the initial value, arrows and typing stay inside the limits.
  A minimum larger than the maximum is shown red and doesn't clamp until
  fixed (so typing "1" on the way to "15" doesn't destroy the value).
- **Changing the type drops the limits.** **Ask:** keep them when switching
  between int and float?
- Limits are saved in `.nfmv` but not exported yet (Phase 5).

### Phase 1c: node editing
- **Rename:** F2 (first selected node), right-click > Rename, or
  double-click the color strip. The strip becomes a text field; Enter or a
  click elsewhere keeps the name, Escape restores it, and the whole edit is
  one undo step. An empty name removes it (the strip goes thin again).
- **Double-click is only on the strip**, not the whole node: a double-click
  detector on the body would delay every single click on nodes by ~300 ms.
  A side effect: a single click on the strip itself waits for that delay.
- **Origin name:** new projects store no name; the origin shows the
  translated "Origin Node" and its strip is always tall. Existing projects
  keep their stored "Origin Node" text (it can be cleared by renaming).
- **F2 also works while typing in a field.** It ends that typing and starts
  renaming the selected node. **Ask:** should F2 be ignored inside fields?
- **Ctrl+Delete** disconnects everything into and out of the selected nodes
  (Edit menu and node menu "Disconnect"). Chosen over Alt+Delete: Ctrl is
  the common "stronger variant" modifier, as you suggested.
- **Alt+drag** on a node pulls its first unconnected output; if all are
  connected, the first output (picking up its connection, like dragging its
  knot). **Alt+hover** grows that knot. Untested on Windows: a lone Alt
  press may briefly focus the window's system menu. **Ask:** tell me if it
  does and I'll suppress it.
- **Question:** a Yes/No row in a branched node's settings. When on, a field
  above the choices (no output). Stored in the project; exported as an
  optional `"question"` key only when not empty. The current Player ignores
  it, so old Players still work.
