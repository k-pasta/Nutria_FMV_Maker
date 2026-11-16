// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get boardImportedVideos => 'Εισαγόμενα βίντεο';

  @override
  String get libraryLargeThumbnails => 'Μεγάλες Μικρογραφίες';

  @override
  String get libraryThumbnails => 'Μεσαίες Μικρογραφίες';

  @override
  String get librarySmallThumbnails => 'Μικρές Μικρογραφίες';

  @override
  String get libraryListWithThumbnails => 'Λίστα με Μικρογραφίες';

  @override
  String get libraryList => 'Λίστα';

  @override
  String get boardPreferences => 'Προτιμήσεις';

  @override
  String get boardProjectSettings => 'Ρυθμίσεις Πρότζεκτ';

  @override
  String get boardVariables => 'Μεταβλητές';

  @override
  String get contextBranchingVideoNode => 'Βιντεο Πολλαπλών Επιλογών';

  @override
  String get contextCompareNode => 'Σύγκριση Τιμής';

  @override
  String get contextMathNode => 'Μαθηματικά';

  @override
  String get contextSetNode => 'Ορισμός Τιμής';

  @override
  String get contextSimpleVideoNode => 'Απλό Βίντεο';

  @override
  String get dialogUnsavedChanges => 'Απόρριψη μη αποθηκευμένων αλλαγών;';

  @override
  String get editDeleteSelectedNodes => 'Διαγραφή Επελεγμένων Κόμβων';

  @override
  String get editPreferences => 'Προτιμήσεις';

  @override
  String get editProjectSettings => 'Ρυθμίσεις Πρότζεκτ';

  @override
  String get editRedo => 'Επανάληψη';

  @override
  String get editCopy => 'Αντιγραφή';

  @override
  String get editPaste => 'Επικόλληση';

  @override
  String get editDuplicate => 'Διπλασιασμός';

  @override
  String get editSelectAll => 'Επιλογή Όλων';

  @override
  String get editCollapseAll => 'Σύμπτυξη Όλων των Κόμβων';

  @override
  String get editToggleGridSnapping => 'Ενεργοποίηση/Απενεργοποίηση Πλέγματος';

  @override
  String get editUndo => 'Αναίρεση';

  @override
  String get essentialsNo => 'Όχι';

  @override
  String get essentialsYes => 'Ναι';

  @override
  String get fileExit => 'Έξοδος';

  @override
  String get fileExportProject => 'Εξαγωγή έργου';

  @override
  String get fileLoadProject => 'Άνοιγμα ';

  @override
  String get fileNewProject => 'Νέο Πρότζεκτ';

  @override
  String get fileRecentProjects => 'Πρόσφατα Πρότζεκτ';

  @override
  String get fileSaveProject => 'Αποθήκευση Πρότζεκτ';

  @override
  String get fileSaveProjectAs => 'Αποθήκευση Πρότζεκτ ως';

  @override
  String get filename => 'File Name';

  @override
  String get helloWorld => 'Γεια σου κοσμε!';

  @override
  String get helpAbout => 'Σχετικά με το Nutria FMV Maker';

  @override
  String get helpDocumentation => 'Documentation';

  @override
  String get helpGithub => 'Github';

  @override
  String get infoProjectDescription =>
      'To «Nutria FMV Maker» είναι ένα υπό διαμόρφωση ελεύθερο λογισμικό ανοικτού κώδικα γραμμένο σε Flutter, που στοχεύει να κάνει τη διαδικασία κατασκευής διαδραστικών ταινιών πιο προσιτή. Δημοσιεύεται υπό την άδεια GPLv3';

  @override
  String get menuBarEdit => 'Επεξεργασία';

  @override
  String get menuBarFile => 'Αρχείο';

  @override
  String get menuBarHelp => 'Βοήθεια';

  @override
  String get menuBarView => 'Προβολή';

  @override
  String get nodeConvertToBranching => 'Μετατροπή σε Διακλαδικό Κόμβο';

  @override
  String get nodeConvertToSimple => 'Μετατροπή σε Απλό Κόμβο Βίντεο';

  @override
  String get nodeNoVideo => 'Χωρίς βίντεο';

  @override
  String get nodeThumbnailError => 'Χωρίς μικρογραφία';

  @override
  String notifyExportWarnings(int count) {
    return 'Η εξαγωγή έγινε με $count προειδοποιήσεις (βίντεο που λείπουν ή επιλογές χωρίς σύνδεση)';
  }

  @override
  String notifyExported(String fileName) {
    return 'Έγινε εξαγωγή: $fileName';
  }

  @override
  String notifyFileError(String path) {
    return 'Αδυναμία πρόσβασης στο $path';
  }

  @override
  String get notifyInvalidProject => 'Μη έγκυρο αρχείο έργου';

  @override
  String get notifyNewerProject =>
      'Το έργο δημιουργήθηκε με νεότερη έκδοση του Nutria FMV Maker';

  @override
  String get notifyOldProject =>
      'Το έργο δημιουργήθηκε με παλαιότερη έκδοση και δεν μπορεί να ανοίξει';

  @override
  String notifySaved(String fileName) {
    return 'Αποθηκεύτηκε: $fileName';
  }

  @override
  String get originProjectDescription => 'Περιγραφή Πρότζεκτ';

  @override
  String get originProjectTitle => 'Τίτλος Πρότζεκτ';

  @override
  String get originTitlePlaceHolder => 'Παράδειγμα Κεντρικού Μενού';

  @override
  String get overrideDefaultSelection => 'Αυτόματη Επιλογή';

  @override
  String get overrideDefaultSelection_First => 'Πρώτη';

  @override
  String get overrideDefaultSelection_Last => 'Τελευταία';

  @override
  String get overrideDefaultSelection_LastSelected => 'Τελευτάια Επιλογή';

  @override
  String get overrideDefaultSelection_Random => 'Τυχαία';

  @override
  String get overrideDefaultSelection_Specified => 'Καθορισμένη';

  @override
  String get overridePauseOnEnd => 'Παύση στο Τέλος';

  @override
  String get overrideSelectionTime => 'Χρόνος Επιλογής';

  @override
  String get overrideShowTimer => 'Εμφάνιση Χρόνου Επιλογής';

  @override
  String get overrideUnknown => 'Άγνωστη Παράκαμψη';

  @override
  String get overrideVideoFit => 'Προσαρμογή Βίντεο';

  @override
  String get overrideVideoFit_Fill => 'Γέμισμα';

  @override
  String get overrideVideoFit_FillHeight => 'Γέμισμα Ύψους';

  @override
  String get overrideVideoFit_FillWidth => 'Γέμισμα Πλάτους';

  @override
  String get overrideVideoFit_Fit => 'Προσαρμογή';

  @override
  String get overrideVideoFit_FitHeight => 'Προσαρμογή στο Ύψος';

  @override
  String get overrideVideoFit_FitWidth => 'Προσαρμογή στο Πλάτος';

  @override
  String get overrideVideoFit_Stretch => 'Παραμόρφωση';

  @override
  String get prefDefaultNodeType => 'Νέοι κόμβοι βίντεο';

  @override
  String get prefGridSize => 'Μέγεθος πλέγματος';

  @override
  String get prefGridSnapping => 'Κούμπωμα στο πλέγμα';

  @override
  String get prefNoodleCurved => 'Καμπύλες';

  @override
  String get prefNoodleStraight => 'Ευθείες';

  @override
  String get prefNoodleStyle => 'Συνδέσεις';

  @override
  String get statusUnsavedFile => 'Μη αποθηκευμένο αρχείο';

  @override
  String get videoMetadataAspectRatio => 'Αναλογία Διαστάσεων';

  @override
  String get videoMetadataAudioBitDepth => 'Bit Depth Ήχου';

  @override
  String get videoMetadataAudioChannels => 'Κανάλια Ήχου';

  @override
  String get videoMetadataAudioCodecFormat => 'Φορμάτ Κωδικοποίησης ΄Ήχου';

  @override
  String get videoMetadataAudioSampleRate => 'Sample Rate Ήχου';

  @override
  String get videoMetadataBitrate => 'Bitrate';

  @override
  String get videoMetadataCodecFormat => 'Φορμάτ Κωδικοποίησης';

  @override
  String get videoMetadataColorProfile => 'Χρωματικό Προφίλ';

  @override
  String get videoMetadataDateCreated => 'Ημερομηνία Τροποποίησης';

  @override
  String get videoMetadataDuration => 'Διάρκεια';

  @override
  String get videoMetadataFilePath => 'Θέση Αρχείου';

  @override
  String get videoMetadataFileSize => 'Μέγεθος Αρχείου';

  @override
  String get videoMetadataFilename => 'Όνομα Αρχείου';

  @override
  String get videoMetadataFrameRate => 'Ρυθμός Καρέ';

  @override
  String get videoMetadataNamesBytes => 'Bytes';

  @override
  String get videoMetadataNamesFps => 'καρέ/δευτερόλεπτο';

  @override
  String get videoMetadataNamesGigabytes => 'GB';

  @override
  String get videoMetadataNamesKilobytes => 'KB';

  @override
  String get videoMetadataNamesMegabytes => 'MB';

  @override
  String get videoMetadataResolution => 'Ανάλυση';

  @override
  String get videoMetadataTimecode => 'Μορφή Timecode';

  @override
  String get videoNodeChoice => 'Επιλογή';

  @override
  String get viewCustomTheme => 'Προσαρμοσμένο Θέμα';

  @override
  String get viewDarkTheme => 'Σκούρο Θέμα';

  @override
  String get viewLanguage => 'Γλώσσα';

  @override
  String get viewLightTheme => 'Ανοιχτό Θέμα';

  @override
  String get viewProperties => 'Στήλη Προτιμήσεων';

  @override
  String get viewFrameAll => 'Προβολή Όλων των Κόμβων';

  @override
  String get viewFrameSelected => 'Προβολή Επιλεγμένων Κόμβων';

  @override
  String get viewTheme => 'Θέμα';

  @override
  String get viewVideoPlayer => 'Στήλη Βίντεο';

  @override
  String get z => 'z';
}
