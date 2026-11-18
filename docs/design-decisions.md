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
