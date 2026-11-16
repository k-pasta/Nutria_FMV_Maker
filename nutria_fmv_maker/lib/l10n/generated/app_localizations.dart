import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @boardImportedVideos.
  ///
  /// In en, this message translates to:
  /// **'Imported Videos'**
  String get boardImportedVideos;

  /// No description provided for @libraryLargeThumbnails.
  ///
  /// In en, this message translates to:
  /// **'Large Thumbnails'**
  String get libraryLargeThumbnails;

  /// No description provided for @libraryThumbnails.
  ///
  /// In en, this message translates to:
  /// **'Medium Thumbnails'**
  String get libraryThumbnails;

  /// No description provided for @librarySmallThumbnails.
  ///
  /// In en, this message translates to:
  /// **'Small Thumbnails'**
  String get librarySmallThumbnails;

  /// No description provided for @libraryListWithThumbnails.
  ///
  /// In en, this message translates to:
  /// **'List with Thumbnails'**
  String get libraryListWithThumbnails;

  /// No description provided for @libraryList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get libraryList;

  /// No description provided for @boardPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get boardPreferences;

  /// No description provided for @boardProjectSettings.
  ///
  /// In en, this message translates to:
  /// **'Project Settings'**
  String get boardProjectSettings;

  /// No description provided for @variablesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No variables yet. Add one with +.'**
  String get variablesEmpty;

  /// No description provided for @variableDefaultName.
  ///
  /// In en, this message translates to:
  /// **'variable'**
  String get variableDefaultName;

  /// No description provided for @variableName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get variableName;

  /// No description provided for @variableNameError.
  ///
  /// In en, this message translates to:
  /// **'Each variable needs its own name'**
  String get variableNameError;

  /// No description provided for @variableInitialValue.
  ///
  /// In en, this message translates to:
  /// **'Initial value'**
  String get variableInitialValue;

  /// No description provided for @variableTypeBool.
  ///
  /// In en, this message translates to:
  /// **'Bool'**
  String get variableTypeBool;

  /// No description provided for @variableTypeInt.
  ///
  /// In en, this message translates to:
  /// **'Int'**
  String get variableTypeInt;

  /// No description provided for @variableTypeFloat.
  ///
  /// In en, this message translates to:
  /// **'Float'**
  String get variableTypeFloat;

  /// No description provided for @variableType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get variableType;

  /// No description provided for @variableTrue.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get variableTrue;

  /// No description provided for @variableFalse.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get variableFalse;

  /// No description provided for @tooltipAddVariable.
  ///
  /// In en, this message translates to:
  /// **'Add a variable'**
  String get tooltipAddVariable;

  /// No description provided for @tooltipDeleteVariable.
  ///
  /// In en, this message translates to:
  /// **'Delete the variable'**
  String get tooltipDeleteVariable;

  /// No description provided for @boardVariables.
  ///
  /// In en, this message translates to:
  /// **'Variables'**
  String get boardVariables;

  /// No description provided for @contextBranchingVideoNode.
  ///
  /// In en, this message translates to:
  /// **'Branching Video'**
  String get contextBranchingVideoNode;

  /// No description provided for @contextCompareNode.
  ///
  /// In en, this message translates to:
  /// **'Compare Value'**
  String get contextCompareNode;

  /// No description provided for @contextMathNode.
  ///
  /// In en, this message translates to:
  /// **'Math'**
  String get contextMathNode;

  /// No description provided for @contextSetNode.
  ///
  /// In en, this message translates to:
  /// **'Set Value'**
  String get contextSetNode;

  /// No description provided for @contextSimpleVideoNode.
  ///
  /// In en, this message translates to:
  /// **'Simple Video'**
  String get contextSimpleVideoNode;

  /// No description provided for @dialogUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get dialogUnsavedChanges;

  /// No description provided for @editDeleteSelectedNodes.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected Node(s)'**
  String get editDeleteSelectedNodes;

  /// No description provided for @editPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get editPreferences;

  /// No description provided for @editProjectSettings.
  ///
  /// In en, this message translates to:
  /// **'Project Settings'**
  String get editProjectSettings;

  /// No description provided for @editRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get editRedo;

  /// No description provided for @editCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get editCopy;

  /// No description provided for @editPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get editPaste;

  /// No description provided for @editDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get editDuplicate;

  /// No description provided for @editSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get editSelectAll;

  /// No description provided for @editCollapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse All Nodes'**
  String get editCollapseAll;

  /// No description provided for @editToggleGridSnapping.
  ///
  /// In en, this message translates to:
  /// **'Toggle Grid Snapping'**
  String get editToggleGridSnapping;

  /// No description provided for @editUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get editUndo;

  /// No description provided for @essentialsNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get essentialsNo;

  /// No description provided for @essentialsYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get essentialsYes;

  /// No description provided for @fileExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get fileExit;

  /// No description provided for @fileExportProject.
  ///
  /// In en, this message translates to:
  /// **'Export Project'**
  String get fileExportProject;

  /// No description provided for @fileLoadProject.
  ///
  /// In en, this message translates to:
  /// **'Load Project'**
  String get fileLoadProject;

  /// No description provided for @fileNewProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get fileNewProject;

  /// No description provided for @fileRecentProjects.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get fileRecentProjects;

  /// No description provided for @fileSaveProject.
  ///
  /// In en, this message translates to:
  /// **'Save Project'**
  String get fileSaveProject;

  /// No description provided for @fileSaveProjectAs.
  ///
  /// In en, this message translates to:
  /// **'Save Project as'**
  String get fileSaveProjectAs;

  /// No description provided for @filename.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get filename;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @helpAbout.
  ///
  /// In en, this message translates to:
  /// **'About Nutria FMV Maker'**
  String get helpAbout;

  /// No description provided for @helpDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get helpDocumentation;

  /// No description provided for @helpGithub.
  ///
  /// In en, this message translates to:
  /// **'Github'**
  String get helpGithub;

  /// No description provided for @infoProjectDescription.
  ///
  /// In en, this message translates to:
  /// **'«Nutria FMV Maker» is an in-the-making free/open-source Flutter project aiming to make the process of creating interactive movie experiences more accessible, published under the GPLv3 license.'**
  String get infoProjectDescription;

  /// No description provided for @menuBarEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get menuBarEdit;

  /// No description provided for @menuBarFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get menuBarFile;

  /// No description provided for @menuBarHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get menuBarHelp;

  /// No description provided for @menuBarView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get menuBarView;

  /// No description provided for @nodeConvertToBranching.
  ///
  /// In en, this message translates to:
  /// **'Convert to Branching Node'**
  String get nodeConvertToBranching;

  /// No description provided for @nodeConvertToSimple.
  ///
  /// In en, this message translates to:
  /// **'Convert to Simple Video Node'**
  String get nodeConvertToSimple;

  /// No description provided for @nodeNoVideo.
  ///
  /// In en, this message translates to:
  /// **'No Video'**
  String get nodeNoVideo;

  /// No description provided for @nodeThumbnailError.
  ///
  /// In en, this message translates to:
  /// **'No thumbnail'**
  String get nodeThumbnailError;

  /// No description provided for @notifyExportWarnings.
  ///
  /// In en, this message translates to:
  /// **'Exported with {count} warnings (missing videos or unconnected choices)'**
  String notifyExportWarnings(int count);

  /// No description provided for @notifyExported.
  ///
  /// In en, this message translates to:
  /// **'Exported {fileName}'**
  String notifyExported(String fileName);

  /// No description provided for @notifyFileError.
  ///
  /// In en, this message translates to:
  /// **'Could not access {path}'**
  String notifyFileError(String path);

  /// No description provided for @notifyInvalidProject.
  ///
  /// In en, this message translates to:
  /// **'Not a valid project file'**
  String get notifyInvalidProject;

  /// No description provided for @notifyNewerProject.
  ///
  /// In en, this message translates to:
  /// **'This project was made with a newer version of Nutria FMV Maker'**
  String get notifyNewerProject;

  /// No description provided for @notifyOldProject.
  ///
  /// In en, this message translates to:
  /// **'This project was made with an older version and can\'t be opened'**
  String get notifyOldProject;

  /// No description provided for @notifySaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {fileName}'**
  String notifySaved(String fileName);

  /// No description provided for @originProjectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project Description'**
  String get originProjectDescription;

  /// No description provided for @originProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Title'**
  String get originProjectTitle;

  /// No description provided for @originTitlePlaceHolder.
  ///
  /// In en, this message translates to:
  /// **'Main Menu Placeholder'**
  String get originTitlePlaceHolder;

  /// No description provided for @overrideDefaultSelection.
  ///
  /// In en, this message translates to:
  /// **'Default Selection'**
  String get overrideDefaultSelection;

  /// No description provided for @overrideDefaultSelection_First.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get overrideDefaultSelection_First;

  /// No description provided for @overrideDefaultSelection_Last.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get overrideDefaultSelection_Last;

  /// No description provided for @overrideDefaultSelection_LastSelected.
  ///
  /// In en, this message translates to:
  /// **'Last Selected'**
  String get overrideDefaultSelection_LastSelected;

  /// No description provided for @overrideDefaultSelection_Random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get overrideDefaultSelection_Random;

  /// No description provided for @overrideDefaultSelection_Specified.
  ///
  /// In en, this message translates to:
  /// **'Specified'**
  String get overrideDefaultSelection_Specified;

  /// No description provided for @overridePauseOnEnd.
  ///
  /// In en, this message translates to:
  /// **'Pause on End'**
  String get overridePauseOnEnd;

  /// No description provided for @overrideSelectionTime.
  ///
  /// In en, this message translates to:
  /// **'Selection Time'**
  String get overrideSelectionTime;

  /// No description provided for @overrideShowTimer.
  ///
  /// In en, this message translates to:
  /// **'Show Timer'**
  String get overrideShowTimer;

  /// No description provided for @overrideUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown Override'**
  String get overrideUnknown;

  /// No description provided for @overrideVideoFit.
  ///
  /// In en, this message translates to:
  /// **'Video Fit'**
  String get overrideVideoFit;

  /// No description provided for @overrideVideoFit_Fill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get overrideVideoFit_Fill;

  /// No description provided for @overrideVideoFit_FillHeight.
  ///
  /// In en, this message translates to:
  /// **'Fill Height'**
  String get overrideVideoFit_FillHeight;

  /// No description provided for @overrideVideoFit_FillWidth.
  ///
  /// In en, this message translates to:
  /// **'Fill Width'**
  String get overrideVideoFit_FillWidth;

  /// No description provided for @overrideVideoFit_Fit.
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get overrideVideoFit_Fit;

  /// No description provided for @overrideVideoFit_FitHeight.
  ///
  /// In en, this message translates to:
  /// **'Fit Height'**
  String get overrideVideoFit_FitHeight;

  /// No description provided for @overrideVideoFit_FitWidth.
  ///
  /// In en, this message translates to:
  /// **'Fit Width'**
  String get overrideVideoFit_FitWidth;

  /// No description provided for @overrideVideoFit_Stretch.
  ///
  /// In en, this message translates to:
  /// **'Stretch'**
  String get overrideVideoFit_Stretch;

  /// No description provided for @prefDefaultNodeType.
  ///
  /// In en, this message translates to:
  /// **'New Video Nodes'**
  String get prefDefaultNodeType;

  /// No description provided for @prefGridSize.
  ///
  /// In en, this message translates to:
  /// **'Grid Size'**
  String get prefGridSize;

  /// No description provided for @prefGridSnapping.
  ///
  /// In en, this message translates to:
  /// **'Grid Snapping'**
  String get prefGridSnapping;

  /// No description provided for @prefNoodleCurved.
  ///
  /// In en, this message translates to:
  /// **'Curved'**
  String get prefNoodleCurved;

  /// No description provided for @prefNoodleStraight.
  ///
  /// In en, this message translates to:
  /// **'Straight'**
  String get prefNoodleStraight;

  /// No description provided for @prefNoodleStyle.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get prefNoodleStyle;

  /// No description provided for @statusUnsavedFile.
  ///
  /// In en, this message translates to:
  /// **'Unsaved File'**
  String get statusUnsavedFile;

  /// No description provided for @videoMetadataAspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get videoMetadataAspectRatio;

  /// No description provided for @videoMetadataAudioBitDepth.
  ///
  /// In en, this message translates to:
  /// **'Audio Bit Depth'**
  String get videoMetadataAudioBitDepth;

  /// No description provided for @videoMetadataAudioChannels.
  ///
  /// In en, this message translates to:
  /// **'Audio Channels'**
  String get videoMetadataAudioChannels;

  /// No description provided for @videoMetadataAudioCodecFormat.
  ///
  /// In en, this message translates to:
  /// **'Audio Codec Format'**
  String get videoMetadataAudioCodecFormat;

  /// No description provided for @videoMetadataAudioSampleRate.
  ///
  /// In en, this message translates to:
  /// **'Audio Sample Rate'**
  String get videoMetadataAudioSampleRate;

  /// No description provided for @videoMetadataBitrate.
  ///
  /// In en, this message translates to:
  /// **'Bitrate'**
  String get videoMetadataBitrate;

  /// No description provided for @videoMetadataCodecFormat.
  ///
  /// In en, this message translates to:
  /// **'Codec Format'**
  String get videoMetadataCodecFormat;

  /// No description provided for @videoMetadataColorProfile.
  ///
  /// In en, this message translates to:
  /// **'Color Profile'**
  String get videoMetadataColorProfile;

  /// No description provided for @videoMetadataDateCreated.
  ///
  /// In en, this message translates to:
  /// **'Date Created'**
  String get videoMetadataDateCreated;

  /// No description provided for @videoMetadataDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get videoMetadataDuration;

  /// No description provided for @videoMetadataFilePath.
  ///
  /// In en, this message translates to:
  /// **'File Path'**
  String get videoMetadataFilePath;

  /// No description provided for @videoMetadataFileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get videoMetadataFileSize;

  /// No description provided for @videoMetadataFilename.
  ///
  /// In en, this message translates to:
  /// **'Filename'**
  String get videoMetadataFilename;

  /// No description provided for @videoMetadataFrameRate.
  ///
  /// In en, this message translates to:
  /// **'Frame Rate'**
  String get videoMetadataFrameRate;

  /// No description provided for @videoMetadataNamesBytes.
  ///
  /// In en, this message translates to:
  /// **'Bytes'**
  String get videoMetadataNamesBytes;

  /// No description provided for @videoMetadataNamesFps.
  ///
  /// In en, this message translates to:
  /// **'fps'**
  String get videoMetadataNamesFps;

  /// No description provided for @videoMetadataNamesGigabytes.
  ///
  /// In en, this message translates to:
  /// **'GB'**
  String get videoMetadataNamesGigabytes;

  /// No description provided for @videoMetadataNamesKilobytes.
  ///
  /// In en, this message translates to:
  /// **'KB'**
  String get videoMetadataNamesKilobytes;

  /// No description provided for @videoMetadataNamesMegabytes.
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get videoMetadataNamesMegabytes;

  /// No description provided for @videoMetadataResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get videoMetadataResolution;

  /// No description provided for @videoMetadataTimecode.
  ///
  /// In en, this message translates to:
  /// **'Timecode'**
  String get videoMetadataTimecode;

  /// No description provided for @videoNodeChoice.
  ///
  /// In en, this message translates to:
  /// **'Option'**
  String get videoNodeChoice;

  /// No description provided for @viewCustomTheme.
  ///
  /// In en, this message translates to:
  /// **'Custom Theme'**
  String get viewCustomTheme;

  /// No description provided for @viewDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get viewDarkTheme;

  /// No description provided for @viewLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get viewLanguage;

  /// No description provided for @viewLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get viewLightTheme;

  /// No description provided for @viewProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties Section'**
  String get viewProperties;

  /// No description provided for @viewFrameAll.
  ///
  /// In en, this message translates to:
  /// **'Frame All Nodes'**
  String get viewFrameAll;

  /// No description provided for @viewFrameSelected.
  ///
  /// In en, this message translates to:
  /// **'Frame Selected Nodes'**
  String get viewFrameSelected;

  /// No description provided for @viewTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get viewTheme;

  /// No description provided for @viewVideoPlayer.
  ///
  /// In en, this message translates to:
  /// **'Video Player Section'**
  String get viewVideoPlayer;

  /// No description provided for @editPlayPause.
  ///
  /// In en, this message translates to:
  /// **'Play / Pause Video'**
  String get editPlayPause;

  /// No description provided for @tooltipPickVideo.
  ///
  /// In en, this message translates to:
  /// **'Choose a video'**
  String get tooltipPickVideo;

  /// No description provided for @tooltipNodeSettings.
  ///
  /// In en, this message translates to:
  /// **'Node settings'**
  String get tooltipNodeSettings;

  /// No description provided for @tooltipImportVideos.
  ///
  /// In en, this message translates to:
  /// **'Import videos'**
  String get tooltipImportVideos;

  /// No description provided for @tooltipBack5.
  ///
  /// In en, this message translates to:
  /// **'Back 5 seconds (Ctrl+←)'**
  String get tooltipBack5;

  /// No description provided for @tooltipPlayPause.
  ///
  /// In en, this message translates to:
  /// **'Play / pause (Space)'**
  String get tooltipPlayPause;

  /// No description provided for @tooltipForward5.
  ///
  /// In en, this message translates to:
  /// **'Forward 5 seconds (Ctrl+→)'**
  String get tooltipForward5;

  /// No description provided for @tooltipChoicesFromHere.
  ///
  /// In en, this message translates to:
  /// **'Show the choices from this moment on'**
  String get tooltipChoicesFromHere;

  /// No description provided for @tooltipVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume (Ctrl+↑ / Ctrl+↓)'**
  String get tooltipVolume;

  /// No description provided for @tooltipShowLeftPanel.
  ///
  /// In en, this message translates to:
  /// **'Show the side panel (T)'**
  String get tooltipShowLeftPanel;

  /// No description provided for @tooltipShowRightPanel.
  ///
  /// In en, this message translates to:
  /// **'Show the video player (N)'**
  String get tooltipShowRightPanel;

  /// No description provided for @tooltipResetOverride.
  ///
  /// In en, this message translates to:
  /// **'Use the project setting'**
  String get tooltipResetOverride;

  /// No description provided for @tooltipNodeColor.
  ///
  /// In en, this message translates to:
  /// **'Color {number}'**
  String tooltipNodeColor(int number);

  /// No description provided for @z.
  ///
  /// In en, this message translates to:
  /// **'z'**
  String get z;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['el', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
