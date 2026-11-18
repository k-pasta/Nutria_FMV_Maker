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
