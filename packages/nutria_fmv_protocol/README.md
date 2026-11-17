# nutria_fmv_protocol

The **Nutria FMV Protocol**: the `.fmv` file that Nutria FMV Maker exports and
Nutria FMV Player plays. Pure Dart with no dependencies, so both apps share one
definition of the format.

```dart
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

final project = FmvProject.decode(await File(path).readAsString());
final first = project.nodes[project.startNodeId]!;
final settings = project.settings.withOverrides(first.overrides);
```

- `FmvProject`: `info`, `settings`, and `nodes` in file order; playback
  starts at the first node.
- `FmvNode`: a video, then either `choices` (each with a `target`) or a
  single `target`; no target ends the story. `overrides` replace project
  settings for that node.
- Reading is lenient (missing values get defaults; enum values are matched
  ignoring case, spaces, dashes and underscores, so `"fill width"` and
  `"fillWidth"` both work). Writing always uses the enum names.

## Using it from the Player

```yaml
dependencies:
  nutria_fmv_protocol:
    git:
      url: https://github.com/k-pasta/Nutria_FMV_Maker
      path: packages/nutria_fmv_protocol
```

or, with both repositories checked out side by side,
`path: ../../Nutria_FMV_Maker/packages/nutria_fmv_protocol`.

The SDK constraint is `^3.5.0` so the Player can use it on its current
toolchain; keep the code free of newer language features.

## Tests

```sh
dart test
```
