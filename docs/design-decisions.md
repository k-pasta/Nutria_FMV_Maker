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

### Phase 1d: notification history
- **Right-click the status bar** for "Show All Notifications…". It opens a
  window listing them newest first, with the time (hh:mm:ss) in small, quiet
  text on the left.
- **Only this session's notifications** are kept, at most 200. They are not
  saved to disk. **Ask:** do you want them kept across restarts?
- No "clear" button for now; closing the app clears them.

## Phase 2: Defaults and color presets
- **"Project Settings" is now "Defaults"** (Greek "Προεπιλογές", French
  "Valeurs par défaut"). Only the label changed; the code still calls it
  project settings.
- **There are 6 colors**, so "the first plus 5 more" covers all of them.
  Each group's color is fixed, and the + button adds the lowest color that
  has no group yet. Its tooltip names that color ("Add defaults for color 3").
- **A new group starts as a copy of the first color's defaults.** After
  that it is independent: changing the first group doesn't change it.
  **Ask:** should groups follow the first group for the settings you haven't
  changed in them, like node overrides do?
- **Layout:**
  - With no extra groups, the section looks as before, plus the + button.
  - With groups, each has a thin bar of its color at the left and a title.
    The titles are "Color 1 and colors without their own" and "Color N".
  - Each extra group has an × button to remove it; that is one undo step.
- **Node color squares** show a faint "…" (new theme token `cSwatchMark`,
  black at 35%) on colors that have their own group.
- **What a node plays with:** its own overrides, then its color's group,
  then the first group. The node's "overridden" accent still means "this
  node overrides it", not "its color group differs".
- **Export:** the Player knows nothing about colors. Each node's exported
  overrides are its own, plus every setting where its color's group
  differs from the first group. The output is unchanged for projects
  without groups (the golden test still passes).
- **Saving:** stored as `colorDefaults` in `.nfmv`. Older files load with
  no groups, so the format version did not change.
- Not checked in the real app yet; widget tests render text as boxes.

## Phase 3a: Imported Media (kinds, sorting, grouping)
- **"Imported Videos" is now "Imported Media".** The + button imports
  videos, audio (mp3, wav, ogg, flac, m4a, aac, opus, wma), images (png,
  jpg, webp, bmp, gif), subtitles (srt) and fonts (ttf, otf). A node's
  "pick video" still shows only videos.
- **The kind comes from the file extension** and isn't stored. Unknown
  extensions count as videos, because older projects only had videos.
- **`.nfmv` is now format version 2.** The list is called `media` instead
  of `videos`. Version 1 files are upgraded when opened and saved as
  version 2, so an older Maker can't open them afterwards.
- **In code,** `VideoAsset` became `MediaAsset` and `document.videos`
  became `document.media`.
- **Sorting and grouping are in the library's right-click menu,** under the
  view sizes, separated by thin lines. They are saved as preferences.
  - Sort by date added (import order, the default), name, or type. Type
    means kind, then extension, then name.
  - Group by nothing (the default), kind, or file type. Each group has a
    title row with an arrow and a count; clicking it collapses the group.
    Collapsed groups are remembered only until the app closes.
- **Pictures:**
  - Images show the picture itself.
  - Audio, subtitles and fonts show an icon of their kind.
  - The plain list view now shows a small kind icon before each name,
    videos included.
- **Only videos** can be dropped on the canvas or on a node. Clicking a
  file that isn't a video does nothing yet; Phase 3c adds previews.
- **Right-click menus now fit their real size** in the window. Before, they
  used a fixed size estimate, so the longer library menu could go off the
  bottom.

## Phase 3b: missing files
- **After opening a project**, a window lists the files that can't be
  found, with their old paths. It has a "Look in a Folder…" button. The
  list updates as files are found, and says "Every file was found." at the
  end.
- **File > Locate Missing Files…** asks for a folder and looks only in that
  folder, not its subfolders. It matches file names, ignoring upper and
  lower case. A notice says how many were found ("Found 2 of 3 missing
  files"). It is one undo step. With nothing missing, it only says so.
- **In the library,** a missing file has its name in the accent color, a
  dimmed picture with a broken-link icon, and a tooltip with the old path.
- **Right-click a file:**
  - "Find Missing File…" (missing files only) asks for one file of the
    same kind. If its name differs, a notice says so, and the file is
    used anyway.
  - "Replace…" (every file) does the same without the notice.
  - Both keep the file's place in the project, so nodes using it follow.
    Each is one undo step.
- **When files are checked:** whenever the list of files changes (import,
  relink, undo, open). A file that disappears while the app is open shows
  as missing only after the next such change. **Ask:** should the app also
  check again when its window regains focus?
- **Replacing with a file that is already imported** keeps both entries.
  They aren't merged.

## Phase 3c: previews and subtitles
- **Clicking any file previews it:**
  - Videos as before.
  - Audio plays in the player, with the transport controls and its
    details. The picture area shows a note icon.
  - Images show the picture.
  - Fonts show sample text in the font, in three sizes. The sample is a
    pangram in the app's language.
  - Subtitles list every line, each with a small, quiet "0:09.000 –
    0:12.500" time range above it.
- **Space and the other player keys** work only for videos and audio.
- **Linking subtitles:**
  - Drop a subtitle file on a video in the library, or on a video node,
    which links it to that node's video.
  - Importing a video and a subtitle file with the same name (ignoring
    extension and case) links them automatically. This is the new
    preference "Link Subtitles by Name", on by default. It applies when
    importing, not to files already imported.
- **A video has at most one subtitle file,** and a subtitle file belongs to
  at most one video. Linking it to another video moves it. **Ask:** do
  you want several languages per video later?
- **Linked subtitles** are hidden from the list. The video shows a "CC"
  icon, a tooltip with the file name, and "Unlink Subtitles" on
  right-click, which lists the file again.
- **"Longer than the video" notice:** after a drop, if the last subtitle
  ends after the video, a notice says by how much ("The subtitles go on
  0:03 longer than the video"). Automatic links don't check this.
- **Protocol:**
  - The exported node gets an optional `"subtitles"` path. It is written
    only when set, so older Players ignore it.
  - The SubRip parser lives in the shared package (`parseSrt`), so the
    Player can show subtitles exactly as the Maker reads them.
  - The Player still needs to show them. That is part of the Player
    update you haven't approved yet.
- **Not done yet:** subtitles over the video in the Maker's own preview,
  and audio tags such as title and artist. Audio shows what the media
  details already show: duration, codec, bitrate, sample rate, channels
  and size.

## Phase 4a: bold and italic
- **Where it works:** choices, the question, and the project title and
  description on the origin node. Comments get it too (Phase 4b).
- **How it looks while typing:** `**bold**` shows bold and `*italic*`
  shows italic. The asterisks stay visible but faint, so the cursor never
  jumps over hidden characters. **Ask:** would you rather hide the
  asterisks except next to the cursor? It looks cleaner, but editing near
  them gets confusing.
- **Ctrl+B / Ctrl+I** make the selection bold or italic, or plain again if
  it already is.
  - Spaces at the ends of the selection stay outside the markers.
  - With nothing selected, they insert an empty pair with the cursor
    inside.
  - `***both***` works.
- **Rules,** shared with the Player in the protocol package
  (`parseInlineMarkdown`):
  - A marker opens only before non-space text and closes only after it.
  - Markers without a partner stay plain text, so `2 * 3 * 4` is
    unchanged.
  - Four or more asterisks are plain text.
- **Export** keeps the asterisks in the text. The Player has to show the
  styles and hide the asterisks. It can call the same parser, or
  `plainTextOf` until it styles text.
- No underline or other markdown, as you asked for bold and italic only.

## Phase 4b: comment nodes
- **Creating one:**
  - Right-click the canvas and pick "Comment".
  - Or right-click a node and pick "Add Comment", which attaches it to
    that node. The entry is hidden when the node already has one.
  - Either way, the comment opens for typing.
- **Looks:** the node card color, no strip, no knots, and text that grows
  with what you write. When selected, the outline uses the faint text
  color, since comments have no color of their own.
- **Editing:**
  - A comment shows its formatted text, so it can be grabbed anywhere to
    move it.
  - Double-click, F2 or "Edit Comment" opens it for typing. Enter makes a
    new line. Escape or a click elsewhere ends typing.
  - One typing session is one undo step. Ctrl+B and Ctrl+I work.
  - **Ask:** should a single click on a selected comment start typing?
- **Attaching:**
  - Drag a comment so that its middle is over a node without a comment.
    The node lights up, and dropping attaches it.
  - An attached comment sits right above the node, 5 units away (the
    gap between a node and its settings), and takes the node's width.
  - Dragging the node moves the comment. Dragging either edge of the
    comment resizes the node, so the width can be changed along the whole
    height.
- **Detaching:** drag the comment away, or right-click it and pick "Detach
  from Node". It keeps its current place and width.
- **Deleting a node deletes its comment.** **Ask:** or should the comment
  stay behind on its own?
- **Copying a node** copies its comment too. A comment copied on its own
  comes off its node.
- **Saved** in `.nfmv` as a new node type. **Never exported**; the Player
  doesn't know about comments.
- Not measured with the drag performance test yet.

### Real-app check after Phases 2–4
I ran a profile build with a demo project and checked:
- The Defaults groups, the library kinds and the missing-file window.
- The subtitle and font previews.
- Bold and italic in questions, choices and comments.
- An attached comment above its node, and editing a comment by
  double-click.

Fixed from what I saw:
- **Missing files** now show a clean tile with a broken-link icon, and
  their name in the accent color. The faded "No thumbnail" text used to
  show through the icon.
- **A free comment** now takes its whole width instead of shrinking to its
  text.
- **Multi-line fields** no longer show a "38/500" character counter.

## Phase 5: logic nodes

### Phase 5a: protocol
Everything here lives in the shared package, so the Player computes exactly
what the Maker checks.
- **Expressions** (`FmvExpression`): numbers, `true`/`false`, variable
  names, `+ - * / ^ ( )`, comparisons `< <= > >= == !=`, and `and`, `or`,
  `not`.
  - `&&`, `||`, `!` and the display symbols `× ÷ −` are accepted too, and
    `=` means "equals".
  - Power is right-associative, so `2^3^2` is 512.
  - Errors give their position, so the Maker can mark the exact spot.
- **Variable names with `-`:** `a-b` reads as the name only if such a
  variable exists; otherwise it means a minus b.
- **Storing results:**
  - Whole-number variables round half away from zero (2.5 becomes 3,
    −2.5 becomes −3).
  - Min and max clamp after every change.
  - A division by zero, or an invalid expression, leaves the variable
    unchanged.
  - In a compare node, anything that can't be evaluated counts as false.
- **Change operations:** set, add, subtract, multiply, divide, power,
  absolute, toggle, and, or, xor. This is your Set and Edit merged into
  one node, without nor, nand and xnor, as proposed.
- **Compare node:** condition rows with All or Any, or one expression that
  replaces them.
- **File format:**
  - A "Variables" section, written only when there are variables.
  - Nodes get `"type": "change"` or `"compare"`. Video nodes are written
    exactly as before, with no type.
  - Variables are referenced by name, which is easier to read and debug.
- **Player:** `FmvVariableState` is a ready-made runtime it can use
  directly.
  - **Old Players can't play files that contain logic nodes:** they would
    read them as video nodes without a video.
  - The Player needs the update you haven't approved yet.

### Phase 5b/5c: logic nodes in the Maker
- **Adding them:** right-click the canvas for "Change Variable" or
  "Compare". They get the last color, as you asked.
- **Their titles** come from what they do: "Set Variable", "Increment"
  (add 1), "Decrement" (subtract 1), "Toggle", "Absolute", otherwise
  "Change Variable", and "Compare". Renaming them works like any node.
- **Change Variable** has three rows:
  - A variable picker: a button that opens a list with a search field.
    Type to filter, and Enter takes the first match.
  - The operation: arrows, with every option on right-click.
  - The value, which is hidden for Toggle and Absolute.
  - Picking a true/false variable switches an operation that doesn't fit
    to "Set", and starts the value at true.
- **Compare** has two rows per condition:
  - The variable picker, with × when there are several conditions.
  - The comparison and the value.
  - Below them, + adds a condition. With two or more, a button switches
    between "All Must Hold" and "One Is Enough".
  - Last come the True and False rows with their knots.
- **Knots:** the input, and a Change node's output, are level with the
  first row. True and False are level with their rows, as tested.
- **Simple Math** (a preference, on by default):
  - A value must be one number, true/false, or one variable name.
  - Power, absolute, and/or/xor and the expression mode are hidden.
  - True/false values become a True/False button.
  - With it off, values are full expressions, and Compare can use one
    expression (node settings: "Use an Expression").
- **Problems** show the field in the accent color, with a tooltip saying
  what's wrong: no variable, deleted variable, a name that doesn't exist,
  wrong kind. The rounding warning is also a tooltip on the value.
  **Ask:** I chose tooltips over the error line above the node that you
  described, because an extra row would move the knots. Is that OK?
- **Export:** problems are reported ("Some logic nodes have problems…"),
  but the nodes are exported anyway.
- **Not done yet (5d):**
  - Colouring the expression text.
  - Tab completion of variable names.
  - Showing `*` as `×`.

### Phase 5d: the expression field
- **While typing, the text is coloured:**
  - Variable names are bright and bold.
  - Operators and brackets are faint.
  - Unknown characters are in the accent color.
  - The first mistake gets a wavy accent underline, at its exact position.
- **`*` shows as `×`.** It is still stored as `*`.
- **Tab completes** the variable name being typed, choosing the shortest
  one that matches, ignoring case.
  - The rest of that name shows faintly after the cursor, but only when
    the cursor is at the end of the text, so cursor positions always
    match the typed text.
  - Tab inside a value never moves to the next field. **Ask:** should Tab
    move on when there is nothing to complete?
- **`&&` and `||` are not shown as ∧ and ∨.** Replacing two characters
  with one would make the cursor jump. `and`, `or` and `not` can be typed
  as words.
- No separate "simple math" colouring: in simple math the same field
  just accepts less.

### Real-app check of the logic nodes, and a framing fix
- Logic nodes looked right in the real app: their titles, the
  operation stepper, knots level with the first row, and the wavy
  underline under an unknown name.
- **Fixed: "Frame All" and opening a project ignored the side panels.**
  The panels lie over the canvas, so nodes were fitted and centred on
  the whole window, and some ended up under a panel. Framing, the
  starting view and "paste at the view's centre" now use the part
  between the open panels. This bug was there before this session.

## Phase 6: music
- **Dropping audio from Imported Media:**
  - On the origin node: menu music. A "Menu Music" row with × appears
    under the title and description.
  - On a simple video node: the music that goes with its video.
  - On a branched node: a small menu asks "Music With the Video" or
    "Pause Music (While Choosing)", as you described.
- **Music with a video** has these rows in the node's settings:
  - The track, with × to remove it. Clicking the name plays it in the
    preview, and the same goes for the other music rows.
  - **Ends When:** Track Ends, Choices Appear, Video Ends, or **Other Music
    Starts**. The last one is the "continues until a later node changes
    it" option I proposed, so music can span several clips.
  - **Loop:** Yes/No. With Loop and "Track Ends" together, a quiet note
    above the rows says a looping track never ends by itself.
  - **Fade Out:** steps of 0, 0.25, 0.5, 1, 2, 3 or 5 s, and the same on
    right-click. **Ask:** do you want a typed number field instead?
  - **Pause With Video:** pauses while the video waits at its end.
- **Pause music** (branched nodes): the track, and "Pause Music Fade Out".
  It always loops while the viewer chooses, as you said.
- **Menu music** always loops. It has no fade setting yet; the Player
  gets 1 s.
- **Music can only be set by dropping.** **Ask:** should there also be a
  picker in the settings?
- **Converting a node keeps its music.** Turning a branched node into a
  simple one drops its pause music, since simple nodes have none.
- **Copying nodes** brings their audio along, like their videos.
- **Protocol:** optional `"music"` and `"pauseMusic"` on nodes, and
  `"menuMusic"` in ProjectInfo. Older Players ignore them. The Player
  still has to play them, which is part of the Player update.
