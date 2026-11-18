// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get boardImportedVideos => 'Imported Media';

  @override
  String get libraryLargeThumbnails => 'Large Thumbnails';

  @override
  String get libraryThumbnails => 'Medium Thumbnails';

  @override
  String get librarySmallThumbnails => 'Small Thumbnails';

  @override
  String get libraryListWithThumbnails => 'List with Thumbnails';

  @override
  String get libraryList => 'List';

  @override
  String get librarySortDateAdded => 'Sort by Date Added';

  @override
  String get librarySortName => 'Sort by Name';

  @override
  String get librarySortType => 'Sort by Type';

  @override
  String get libraryGroupNone => 'Don’t Group';

  @override
  String get libraryGroupKind => 'Group by Kind';

  @override
  String get libraryGroupFileType => 'Group by File Type';

  @override
  String get fileLocateMissing => 'Locate Missing Files…';

  @override
  String get mediaFindMissing => 'Find Missing File…';

  @override
  String get mediaReplace => 'Replace…';

  @override
  String tooltipMissingFile(String path) {
    return 'Not found: $path';
  }

  @override
  String get missingFilesTitle => 'Missing Files';

  @override
  String get missingFilesMessage =>
      'These files can’t be found. They may have been moved or renamed.';

  @override
  String get missingFilesNone => 'Every file was found.';

  @override
  String get missingFilesLocate => 'Look in a Folder…';

  @override
  String notifyLocatedFiles(int found, int total) {
    return 'Found $found of $total missing files';
  }

  @override
  String get notifyNoMissingFiles => 'No files are missing';

  @override
  String notifyFileNameDiffers(String name) {
    return 'The chosen file has another name: $name';
  }

  @override
  String get mediaKindVideo => 'Videos';

  @override
  String get mediaKindAudio => 'Audio';

  @override
  String get mediaKindImage => 'Images';

  @override
  String get mediaKindSubtitle => 'Subtitles';

  @override
  String get mediaKindFont => 'Fonts';

  @override
  String get boardPreferences => 'Preferences';

  @override
  String get boardProjectSettings => 'Defaults';

  @override
  String get defaultsFirstColor => 'Color 1 and colors without their own';

  @override
  String defaultsColor(int number) {
    return 'Color $number';
  }

  @override
  String tooltipAddColorDefaults(int number) {
    return 'Add defaults for color $number';
  }

  @override
  String tooltipRemoveColorDefaults(int number) {
    return 'Remove the defaults of color $number';
  }

  @override
  String get variablesEmpty => 'No variables yet. Add one with +.';

  @override
  String get variableDefaultName => 'variable';

  @override
  String get variableName => 'Name';

  @override
  String get variableNameError =>
      'Names must be unique, start with a letter and use only letters, numbers, - and _';

  @override
  String get variableNameRejected =>
      'Variable names start with a letter and use only letters, numbers, - and _';

  @override
  String get variableMin => 'Minimum (empty: no limit)';

  @override
  String get variableMax => 'Maximum (empty: no limit)';

  @override
  String get variableInitialValue => 'Initial value';

  @override
  String get variableTypeBool => 'Bool';

  @override
  String get variableTypeInt => 'Int';

  @override
  String get variableTypeFloat => 'Float';

  @override
  String get variableType => 'Type';

  @override
  String get variableTrue => 'True';

  @override
  String get variableFalse => 'False';

  @override
  String get tooltipAddVariable => 'Add a variable';

  @override
  String get tooltipDeleteVariable => 'Delete the variable';

  @override
  String get boardVariables => 'Variables';

  @override
  String get contextBranchingVideoNode => 'Branching Video';

  @override
  String get contextCompareNode => 'Compare Value';

  @override
  String get contextMathNode => 'Math';

  @override
  String get contextSetNode => 'Set Value';

  @override
  String get contextSimpleVideoNode => 'Simple Video';

  @override
  String get dialogUnsavedChanges => 'Save the changes to this project?';

  @override
  String get dialogSave => 'Save';

  @override
  String get dialogDontSave => 'Don\'t Save';

  @override
  String get essentialsCancel => 'Cancel';

  @override
  String get editDeleteSelectedNodes => 'Delete Selected Node(s)';

  @override
  String get editDisconnectNodes => 'Disconnect Selected Node(s)';

  @override
  String get editRenameNode => 'Rename Node';

  @override
  String get nodeRename => 'Rename';

  @override
  String get nodeRenameHint => 'Node name';

  @override
  String get nodeOriginDefaultName => 'Origin Node';

  @override
  String get nodeQuestion => 'Question';

  @override
  String get nodeQuestionHint => 'Question above the choices';

  @override
  String get editProjectSettings => 'Project Settings';

  @override
  String get editRedo => 'Redo';

  @override
  String get editCopy => 'Copy';

  @override
  String get editPaste => 'Paste';

  @override
  String get editDuplicate => 'Duplicate';

  @override
  String get editSelectAll => 'Select All';

  @override
  String get editCollapseAll => 'Collapse All Nodes';

  @override
  String get editToggleGridSnapping => 'Toggle Grid Snapping';

  @override
  String get editUndo => 'Undo';

  @override
  String get essentialsNo => 'No';

  @override
  String get essentialsYes => 'Yes';

  @override
  String get fileExit => 'Exit';

  @override
  String get fileExportProject => 'Export Project';

  @override
  String get fileLoadProject => 'Load Project';

  @override
  String get fileNewProject => 'New Project';

  @override
  String get fileSaveProject => 'Save Project';

  @override
  String get fileSaveProjectAs => 'Save Project as';

  @override
  String get helpAbout => 'About Nutria FMV Maker';

  @override
  String get helpDocumentation => 'Documentation';

  @override
  String get helpGithub => 'Github';

  @override
  String get infoProjectDescription =>
      '«Nutria FMV Maker» is an in-the-making free/open-source Flutter project aiming to make the process of creating interactive movie experiences more accessible, published under the GPLv3 license.';

  @override
  String get menuBarEdit => 'Edit';

  @override
  String get menuBarFile => 'File';

  @override
  String get menuBarHelp => 'Help';

  @override
  String get menuBarView => 'View';

  @override
  String get nodeConvertToBranching => 'Convert to Branching Node';

  @override
  String get nodeConvertToSimple => 'Convert to Simple Video Node';

  @override
  String get nodeNoVideo => 'No Video';

  @override
  String get nodeThumbnailError => 'No thumbnail';

  @override
  String notifyExportWarnings(int count) {
    return 'Exported with $count warnings (missing videos or unconnected choices)';
  }

  @override
  String notifyExported(String fileName) {
    return 'Exported $fileName';
  }

  @override
  String notifyFileError(String path) {
    return 'Could not access $path';
  }

  @override
  String get notifyInvalidProject => 'Not a valid project file';

  @override
  String get notifyNewerProject =>
      'This project was made with a newer version of Nutria FMV Maker';

  @override
  String get notifyOldProject =>
      'This project was made with an older version and can\'t be opened';

  @override
  String notifySaved(String fileName) {
    return 'Saved $fileName';
  }

  @override
  String get originProjectDescription => 'Project Description';

  @override
  String get originProjectTitle => 'Project Title';

  @override
  String get originTitlePlaceHolder => 'Main Menu Placeholder';

  @override
  String get overrideDefaultSelection => 'Default Selection';

  @override
  String get overrideDefaultSelection_First => 'First';

  @override
  String get overrideDefaultSelection_Last => 'Last';

  @override
  String get overrideDefaultSelection_LastSelected => 'Last Selected';

  @override
  String get overrideDefaultSelection_Random => 'Random';

  @override
  String get overrideDefaultSelection_Specified => 'Specified';

  @override
  String get overridePauseOnEnd => 'Pause on End';

  @override
  String get overrideSelectionTime => 'Selection Time';

  @override
  String get overrideShowTimer => 'Show Timer';

  @override
  String get overrideVideoFit => 'Video Fit';

  @override
  String get overrideVideoFit_Fill => 'Fill';

  @override
  String get overrideVideoFit_FillHeight => 'Fill Height';

  @override
  String get overrideVideoFit_FillWidth => 'Fill Width';

  @override
  String get overrideVideoFit_Fit => 'Fit';

  @override
  String get overrideVideoFit_Stretch => 'Stretch';

  @override
  String get prefDefaultNodeType => 'New Video Nodes';

  @override
  String get prefGridSize => 'Grid Size';

  @override
  String get prefGridSnapping => 'Grid Snapping';

  @override
  String get prefNoodleCurved => 'Curved';

  @override
  String get prefNoodleStraight => 'Straight';

  @override
  String get prefNoodleStyle => 'Connections';

  @override
  String get statusUnsavedFile => 'Unsaved File';

  @override
  String get statusShowNotifications => 'Show All Notifications…';

  @override
  String get statusNotificationsTitle => 'Notifications';

  @override
  String get statusNoNotifications => 'No notifications yet.';

  @override
  String get videoMetadataDateCreated => 'Date Created';

  @override
  String get videoMetadataDuration => 'Duration';

  @override
  String get videoMetadataFilePath => 'File Path';

  @override
  String get videoMetadataFileSize => 'File Size';

  @override
  String get videoMetadataFilename => 'Filename';

  @override
  String get videoMetadataFrameRate => 'Frame Rate';

  @override
  String get videoMetadataNamesBytes => 'Bytes';

  @override
  String get videoMetadataNamesFps => 'fps';

  @override
  String get videoMetadataNamesGigabytes => 'GB';

  @override
  String get videoMetadataNamesKilobytes => 'KB';

  @override
  String get videoMetadataNamesMegabytes => 'MB';

  @override
  String get videoMetadataResolution => 'Resolution';

  @override
  String get videoNodeChoice => 'Option';

  @override
  String get viewCustomTheme => 'Custom Theme';

  @override
  String get viewDarkTheme => 'Dark Theme';

  @override
  String get viewLanguage => 'Language';

  @override
  String get viewLightTheme => 'Light Theme';

  @override
  String get viewProperties => 'Properties Section';

  @override
  String get viewFrameAll => 'Frame All Nodes';

  @override
  String get viewFrameSelected => 'Frame Selected Nodes';

  @override
  String get viewTheme => 'Theme';

  @override
  String get viewVideoPlayer => 'Video Player Section';

  @override
  String get editPlayPause => 'Play / Pause Video';

  @override
  String get tooltipPickVideo => 'Choose a video';

  @override
  String get tooltipNodeSettings => 'Node settings';

  @override
  String get tooltipImportVideos => 'Import media';

  @override
  String get tooltipBack5 => 'Back 5 seconds (Ctrl+←)';

  @override
  String get tooltipPlayPause => 'Play / pause (Space)';

  @override
  String get tooltipForward5 => 'Forward 5 seconds (Ctrl+→)';

  @override
  String get tooltipChoicesFromHere => 'Show the choices from this moment on';

  @override
  String get tooltipVolume => 'Volume (Ctrl+↑ / Ctrl+↓)';

  @override
  String get tooltipShowLeftPanel => 'Show the side panel (T)';

  @override
  String get tooltipShowRightPanel => 'Show the video player (N)';

  @override
  String get tooltipResetOverride => 'Use the project setting';

  @override
  String tooltipNodeColor(int number) {
    return 'Color $number';
  }
}
