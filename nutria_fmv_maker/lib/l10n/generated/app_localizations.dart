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
  /// **'Imported Media'**
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

  /// No description provided for @librarySortDateAdded.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date Added'**
  String get librarySortDateAdded;

  /// No description provided for @librarySortName.
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get librarySortName;

  /// No description provided for @librarySortType.
  ///
  /// In en, this message translates to:
  /// **'Sort by Type'**
  String get librarySortType;

  /// No description provided for @libraryGroupNone.
  ///
  /// In en, this message translates to:
  /// **'Don’t Group'**
  String get libraryGroupNone;

  /// No description provided for @libraryGroupKind.
  ///
  /// In en, this message translates to:
  /// **'Group by Kind'**
  String get libraryGroupKind;

  /// No description provided for @libraryGroupFileType.
  ///
  /// In en, this message translates to:
  /// **'Group by File Type'**
  String get libraryGroupFileType;

  /// No description provided for @fileLocateMissing.
  ///
  /// In en, this message translates to:
  /// **'Locate Missing Files…'**
  String get fileLocateMissing;

  /// No description provided for @mediaFindMissing.
  ///
  /// In en, this message translates to:
  /// **'Find Missing File…'**
  String get mediaFindMissing;

  /// No description provided for @mediaReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace…'**
  String get mediaReplace;

  /// No description provided for @tooltipMissingFile.
  ///
  /// In en, this message translates to:
  /// **'Not found: {path}'**
  String tooltipMissingFile(String path);

  /// No description provided for @missingFilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing Files'**
  String get missingFilesTitle;

  /// No description provided for @missingFilesMessage.
  ///
  /// In en, this message translates to:
  /// **'These files can’t be found. They may have been moved or renamed.'**
  String get missingFilesMessage;

  /// No description provided for @missingFilesNone.
  ///
  /// In en, this message translates to:
  /// **'Every file was found.'**
  String get missingFilesNone;

  /// No description provided for @missingFilesLocate.
  ///
  /// In en, this message translates to:
  /// **'Look in a Folder…'**
  String get missingFilesLocate;

  /// No description provided for @notifyLocatedFiles.
  ///
  /// In en, this message translates to:
  /// **'Found {found} of {total} missing files'**
  String notifyLocatedFiles(int found, int total);

  /// No description provided for @notifyNoMissingFiles.
  ///
  /// In en, this message translates to:
  /// **'No files are missing'**
  String get notifyNoMissingFiles;

  /// No description provided for @notifyFileNameDiffers.
  ///
  /// In en, this message translates to:
  /// **'The chosen file has another name: {name}'**
  String notifyFileNameDiffers(String name);

  /// No description provided for @mediaUnlinkSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Unlink Subtitles'**
  String get mediaUnlinkSubtitles;

  /// No description provided for @tooltipHasSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Subtitles: {name}'**
  String tooltipHasSubtitles(String name);

  /// No description provided for @notifySubtitlesLonger.
  ///
  /// In en, this message translates to:
  /// **'The subtitles go on {time} longer than the video'**
  String notifySubtitlesLonger(String time);

  /// No description provided for @previewLinkedTo.
  ///
  /// In en, this message translates to:
  /// **'Linked to {name}'**
  String previewLinkedTo(String name);

  /// No description provided for @previewUnreadable.
  ///
  /// In en, this message translates to:
  /// **'This file can’t be read.'**
  String get previewUnreadable;

  /// No description provided for @previewNoCues.
  ///
  /// In en, this message translates to:
  /// **'No subtitles were found in this file.'**
  String get previewNoCues;

  /// No description provided for @previewFontSample.
  ///
  /// In en, this message translates to:
  /// **'The quick brown fox jumps over the lazy dog'**
  String get previewFontSample;

  /// No description provided for @prefAutoLinkSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Link Subtitles by Name'**
  String get prefAutoLinkSubtitles;

  /// No description provided for @mediaKindVideo.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get mediaKindVideo;

  /// No description provided for @mediaKindAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get mediaKindAudio;

  /// No description provided for @mediaKindImage.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get mediaKindImage;

  /// No description provided for @mediaKindSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get mediaKindSubtitle;

  /// No description provided for @mediaKindFont.
  ///
  /// In en, this message translates to:
  /// **'Fonts'**
  String get mediaKindFont;

  /// No description provided for @boardPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get boardPreferences;

  /// No description provided for @boardProjectSettings.
  ///
  /// In en, this message translates to:
  /// **'Defaults'**
  String get boardProjectSettings;

  /// No description provided for @defaultsFirstColor.
  ///
  /// In en, this message translates to:
  /// **'Color 1 and colors without their own'**
  String get defaultsFirstColor;

  /// No description provided for @defaultsColor.
  ///
  /// In en, this message translates to:
  /// **'Color {number}'**
  String defaultsColor(int number);

  /// No description provided for @tooltipAddColorDefaults.
  ///
  /// In en, this message translates to:
  /// **'Add defaults for color {number}'**
  String tooltipAddColorDefaults(int number);

  /// No description provided for @tooltipRemoveColorDefaults.
  ///
  /// In en, this message translates to:
  /// **'Remove the defaults of color {number}'**
  String tooltipRemoveColorDefaults(int number);

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
  /// **'Names must be unique, start with a letter and use only letters, numbers, - and _'**
  String get variableNameError;

  /// No description provided for @variableNameRejected.
  ///
  /// In en, this message translates to:
  /// **'Variable names start with a letter and use only letters, numbers, - and _'**
  String get variableNameRejected;

  /// No description provided for @variableMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum (empty: no limit)'**
  String get variableMin;

  /// No description provided for @variableMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum (empty: no limit)'**
  String get variableMax;

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

  /// No description provided for @contextChangeVariable.
  ///
  /// In en, this message translates to:
  /// **'Change Variable'**
  String get contextChangeVariable;

  /// No description provided for @contextCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get contextCompare;

  /// No description provided for @logicTitleSet.
  ///
  /// In en, this message translates to:
  /// **'Set Variable'**
  String get logicTitleSet;

  /// No description provided for @logicTitleIncrement.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get logicTitleIncrement;

  /// No description provided for @logicTitleDecrement.
  ///
  /// In en, this message translates to:
  /// **'Decrement'**
  String get logicTitleDecrement;

  /// No description provided for @logicTitleToggle.
  ///
  /// In en, this message translates to:
  /// **'Toggle'**
  String get logicTitleToggle;

  /// No description provided for @logicTitleAbsolute.
  ///
  /// In en, this message translates to:
  /// **'Absolute'**
  String get logicTitleAbsolute;

  /// No description provided for @logicTitleChange.
  ///
  /// In en, this message translates to:
  /// **'Change Variable'**
  String get logicTitleChange;

  /// No description provided for @logicTitleCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get logicTitleCompare;

  /// No description provided for @logicOpSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get logicOpSet;

  /// No description provided for @logicOpAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get logicOpAdd;

  /// No description provided for @logicOpSubtract.
  ///
  /// In en, this message translates to:
  /// **'Subtract'**
  String get logicOpSubtract;

  /// No description provided for @logicOpMultiply.
  ///
  /// In en, this message translates to:
  /// **'Multiply'**
  String get logicOpMultiply;

  /// No description provided for @logicOpDivide.
  ///
  /// In en, this message translates to:
  /// **'Divide'**
  String get logicOpDivide;

  /// No description provided for @logicOpPower.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get logicOpPower;

  /// No description provided for @logicOpAbsolute.
  ///
  /// In en, this message translates to:
  /// **'Absolute'**
  String get logicOpAbsolute;

  /// No description provided for @logicOpToggle.
  ///
  /// In en, this message translates to:
  /// **'Toggle'**
  String get logicOpToggle;

  /// No description provided for @logicOpAnd.
  ///
  /// In en, this message translates to:
  /// **'And'**
  String get logicOpAnd;

  /// No description provided for @logicOpOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get logicOpOr;

  /// No description provided for @logicOpXor.
  ///
  /// In en, this message translates to:
  /// **'Either (Xor)'**
  String get logicOpXor;

  /// No description provided for @logicPickVariable.
  ///
  /// In en, this message translates to:
  /// **'Pick a Variable…'**
  String get logicPickVariable;

  /// No description provided for @logicMissingVariable.
  ///
  /// In en, this message translates to:
  /// **'Deleted Variable'**
  String get logicMissingVariable;

  /// No description provided for @logicSearchVariables.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get logicSearchVariables;

  /// No description provided for @logicNoVariables.
  ///
  /// In en, this message translates to:
  /// **'No variables yet. Add some in the Variables section.'**
  String get logicNoVariables;

  /// No description provided for @logicNewValueHint.
  ///
  /// In en, this message translates to:
  /// **'New value…'**
  String get logicNewValueHint;

  /// No description provided for @logicByValueHint.
  ///
  /// In en, this message translates to:
  /// **'By value…'**
  String get logicByValueHint;

  /// No description provided for @logicValueHint.
  ///
  /// In en, this message translates to:
  /// **'Value…'**
  String get logicValueHint;

  /// No description provided for @logicExpressionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. coins > 3 and has_key'**
  String get logicExpressionHint;

  /// No description provided for @logicAddCondition.
  ///
  /// In en, this message translates to:
  /// **'Add a condition'**
  String get logicAddCondition;

  /// No description provided for @logicRemoveCondition.
  ///
  /// In en, this message translates to:
  /// **'Remove this condition'**
  String get logicRemoveCondition;

  /// No description provided for @logicMatchAll.
  ///
  /// In en, this message translates to:
  /// **'All Must Hold'**
  String get logicMatchAll;

  /// No description provided for @logicMatchAny.
  ///
  /// In en, this message translates to:
  /// **'One Is Enough'**
  String get logicMatchAny;

  /// No description provided for @logicTrue.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get logicTrue;

  /// No description provided for @logicFalse.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get logicFalse;

  /// No description provided for @logicUseExpression.
  ///
  /// In en, this message translates to:
  /// **'Use an Expression'**
  String get logicUseExpression;

  /// No description provided for @musicTrack.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get musicTrack;

  /// No description provided for @musicEndsWhen.
  ///
  /// In en, this message translates to:
  /// **'Ends When'**
  String get musicEndsWhen;

  /// No description provided for @musicEndTrack.
  ///
  /// In en, this message translates to:
  /// **'Track Ends'**
  String get musicEndTrack;

  /// No description provided for @musicEndChoices.
  ///
  /// In en, this message translates to:
  /// **'Choices Appear'**
  String get musicEndChoices;

  /// No description provided for @musicEndVideo.
  ///
  /// In en, this message translates to:
  /// **'Video Ends'**
  String get musicEndVideo;

  /// No description provided for @musicEndLater.
  ///
  /// In en, this message translates to:
  /// **'Other Music Starts'**
  String get musicEndLater;

  /// No description provided for @musicLoop.
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get musicLoop;

  /// No description provided for @musicFadeOut.
  ///
  /// In en, this message translates to:
  /// **'Fade Out'**
  String get musicFadeOut;

  /// No description provided for @musicPauseWithVideo.
  ///
  /// In en, this message translates to:
  /// **'Pause With Video'**
  String get musicPauseWithVideo;

  /// No description provided for @musicPause.
  ///
  /// In en, this message translates to:
  /// **'Pause Music'**
  String get musicPause;

  /// No description provided for @musicPauseFadeOut.
  ///
  /// In en, this message translates to:
  /// **'Pause Music Fade Out'**
  String get musicPauseFadeOut;

  /// No description provided for @musicMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu Music'**
  String get musicMenu;

  /// No description provided for @musicRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove this music'**
  String get musicRemove;

  /// No description provided for @musicLoopNeverEnds.
  ///
  /// In en, this message translates to:
  /// **'A looping track never ends by itself: it plays until other music starts.'**
  String get musicLoopNeverEnds;

  /// No description provided for @musicDropAsMusic.
  ///
  /// In en, this message translates to:
  /// **'Music With the Video'**
  String get musicDropAsMusic;

  /// No description provided for @musicDropAsPause.
  ///
  /// In en, this message translates to:
  /// **'Pause Music (While Choosing)'**
  String get musicDropAsPause;

  /// No description provided for @logicProblemNoVariable.
  ///
  /// In en, this message translates to:
  /// **'Pick a variable.'**
  String get logicProblemNoVariable;

  /// No description provided for @logicProblemUnknownVariable.
  ///
  /// In en, this message translates to:
  /// **'This variable was deleted.'**
  String get logicProblemUnknownVariable;

  /// No description provided for @logicProblemWrongOperation.
  ///
  /// In en, this message translates to:
  /// **'This doesn’t work on this kind of variable.'**
  String get logicProblemWrongOperation;

  /// No description provided for @logicProblemNoConditions.
  ///
  /// In en, this message translates to:
  /// **'Add a condition.'**
  String get logicProblemNoConditions;

  /// No description provided for @logicProblemEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a value. Without one, nothing changes.'**
  String get logicProblemEmpty;

  /// No description provided for @logicProblemExpression.
  ///
  /// In en, this message translates to:
  /// **'This value can’t be read, or is the wrong kind (number or true/false).'**
  String get logicProblemExpression;

  /// No description provided for @logicProblemUnknownName.
  ///
  /// In en, this message translates to:
  /// **'There is no variable called {name}.'**
  String logicProblemUnknownName(String name);

  /// No description provided for @logicWarningRounded.
  ///
  /// In en, this message translates to:
  /// **'The result may have decimals; it is rounded to a whole number.'**
  String get logicWarningRounded;

  /// No description provided for @prefSimpleMath.
  ///
  /// In en, this message translates to:
  /// **'Simple Math'**
  String get prefSimpleMath;

  /// No description provided for @notifyExportLogicIssues.
  ///
  /// In en, this message translates to:
  /// **'Some logic nodes have problems; the Player will skip what they do'**
  String get notifyExportLogicIssues;

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
  /// **'Save the changes to this project?'**
  String get dialogUnsavedChanges;

  /// No description provided for @dialogSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get dialogSave;

  /// No description provided for @dialogDontSave.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Save'**
  String get dialogDontSave;

  /// No description provided for @essentialsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get essentialsCancel;

  /// No description provided for @editDeleteSelectedNodes.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected Node(s)'**
  String get editDeleteSelectedNodes;

  /// No description provided for @editDisconnectNodes.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Selected Node(s)'**
  String get editDisconnectNodes;

  /// No description provided for @editRenameNode.
  ///
  /// In en, this message translates to:
  /// **'Rename Node'**
  String get editRenameNode;

  /// No description provided for @nodeRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get nodeRename;

  /// No description provided for @contextComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get contextComment;

  /// No description provided for @nodeAddComment.
  ///
  /// In en, this message translates to:
  /// **'Add Comment'**
  String get nodeAddComment;

  /// No description provided for @commentEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Comment'**
  String get commentEdit;

  /// No description provided for @commentDetach.
  ///
  /// In en, this message translates to:
  /// **'Detach from Node'**
  String get commentDetach;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Comment…'**
  String get commentHint;

  /// No description provided for @nodeRenameHint.
  ///
  /// In en, this message translates to:
  /// **'Node name'**
  String get nodeRenameHint;

  /// No description provided for @nodeOriginDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Origin Node'**
  String get nodeOriginDefaultName;

  /// No description provided for @nodeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get nodeQuestion;

  /// No description provided for @nodeQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Question above the choices'**
  String get nodeQuestionHint;

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

  /// No description provided for @statusShowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Show All Notifications…'**
  String get statusShowNotifications;

  /// No description provided for @statusNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get statusNotificationsTitle;

  /// No description provided for @statusNoNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get statusNoNotifications;

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
  /// **'Import media'**
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
