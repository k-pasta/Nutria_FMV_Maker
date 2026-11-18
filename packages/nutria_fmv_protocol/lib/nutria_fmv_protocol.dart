/// The Nutria FMV Protocol: the .fmv file that Nutria FMV Maker exports and
/// Nutria FMV Player plays.
///
/// Read a file with [FmvProject.decode], write one with
/// [FmvProject.encode]. Changing what these read or write changes the
/// protocol for both apps.
library;

export 'src/enums.dart';
export 'src/fmv_project.dart';
export 'src/inline_markdown.dart';
export 'src/srt.dart';
