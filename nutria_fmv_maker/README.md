# Nutria FMV Maker (Flutter project)

The node editor of Nutria FMV. For what the project is, see the
[repository README](../README.md) and the
[documentation](https://rigascg.com/nutriafmvdocs/).

## Development

Windows desktop is the main target. Run every command from this folder:

```sh
flutter pub get
flutter run -d windows
flutter test
dart run build_runner build --delete-conflicting-outputs   # after editing @riverpod / @freezed models
```

Code layout, conventions and known pitfalls are described in
[`../CLAUDE.md`](../CLAUDE.md).
