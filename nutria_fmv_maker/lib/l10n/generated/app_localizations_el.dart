// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get boardImportedMedia => 'Εισαγόμενα Πολυμέσα';

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
  String get librarySortDateAdded => 'Ταξινόμηση κατά Ημερομηνία Προσθήκης';

  @override
  String get librarySortName => 'Ταξινόμηση κατά Όνομα';

  @override
  String get librarySortType => 'Ταξινόμηση κατά Τύπο';

  @override
  String get libraryGroupNone => 'Χωρίς Ομαδοποίηση';

  @override
  String get libraryGroupKind => 'Ομαδοποίηση κατά Είδος';

  @override
  String get libraryGroupFileType => 'Ομαδοποίηση κατά Τύπο Αρχείου';

  @override
  String get fileLocateMissing => 'Εντοπισμός Αρχείων που Λείπουν…';

  @override
  String get mediaFindMissing => 'Εύρεση Αρχείου που Λείπει…';

  @override
  String get mediaReplace => 'Αντικατάσταση…';

  @override
  String tooltipMissingFile(String path) {
    return 'Δεν βρέθηκε: $path';
  }

  @override
  String get missingFilesTitle => 'Αρχεία που Λείπουν';

  @override
  String get missingFilesMessage =>
      'Αυτά τα αρχεία δεν βρέθηκαν. Ίσως μετακινήθηκαν ή μετονομάστηκαν.';

  @override
  String get missingFilesNone => 'Όλα τα αρχεία βρέθηκαν.';

  @override
  String get missingFilesLocate => 'Αναζήτηση σε Φάκελο…';

  @override
  String notifyLocatedFiles(int found, int total) {
    return 'Βρέθηκαν $found από $total αρχεία που έλειπαν';
  }

  @override
  String get notifyNoMissingFiles => 'Δεν λείπει κανένα αρχείο';

  @override
  String notifyFileNameDiffers(String name) {
    return 'Το αρχείο που επιλέξατε έχει άλλο όνομα: $name';
  }

  @override
  String get mediaUnlinkSubtitles => 'Αποσύνδεση Υποτίτλων';

  @override
  String tooltipHasSubtitles(String name) {
    return 'Υπότιτλοι: $name';
  }

  @override
  String notifySubtitlesLonger(String time) {
    return 'Οι υπότιτλοι συνεχίζουν $time μετά το τέλος του βίντεο';
  }

  @override
  String previewLinkedTo(String name) {
    return 'Συνδεδεμένοι με $name';
  }

  @override
  String get previewUnreadable => 'Αυτό το αρχείο δεν διαβάζεται.';

  @override
  String get previewNoCues => 'Δεν βρέθηκαν υπότιτλοι σε αυτό το αρχείο.';

  @override
  String get previewFontSample => 'Ξεσκεπάζω την ψυχοφθόρα βδελυγμία';

  @override
  String get prefAutoLinkSubtitles => 'Σύνδεση Υποτίτλων κατά Όνομα';

  @override
  String get mediaKindVideo => 'Βίντεο';

  @override
  String get mediaKindAudio => 'Ήχος';

  @override
  String get mediaKindImage => 'Εικόνες';

  @override
  String get mediaKindSubtitle => 'Υπότιτλοι';

  @override
  String get mediaKindFont => 'Γραμματοσειρές';

  @override
  String get boardPreferences => 'Προτιμήσεις';

  @override
  String get boardProjectSettings => 'Προεπιλογές';

  @override
  String get boardProject => 'Έργο';

  @override
  String get projectInformation => 'Πληροφορίες';

  @override
  String get projectLanguages => 'Γλώσσες';

  @override
  String get projectAddLanguage => 'Προσθήκη Γλώσσας…';

  @override
  String get projectMainLanguage => 'Κύρια';

  @override
  String get projectMakeMain => 'Ορισμός ως Κύρια Γλώσσα';

  @override
  String get projectRemoveLanguage => 'Αφαίρεση γλώσσας';

  @override
  String get projectLanguagesNote =>
      'Η πρώτη είναι η κύρια γλώσσα. Με περισσότερες από μία, η σύνδεση υποτίτλων ρωτά σε ποια γλώσσα είναι.';

  @override
  String get projectOverview => 'Επισκόπηση';

  @override
  String get projectProblems => 'Προβλήματα';

  @override
  String get projectNoProblems =>
      'Κανένα στο κομμάτι της ιστορίας που φτάνει η αρχή.';

  @override
  String get projectNodes => 'Κόμβοι';

  @override
  String projectNodeCounts(int total, int main, int inactive) {
    return '$total ($main στον κύριο κλάδο, $inactive εκτός)';
  }

  @override
  String projectWay(String time, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count βίντεο',
      one: '1 βίντεο',
    );
    return '$time · $_temp0';
  }

  @override
  String get issueMissingVideo => 'Χωρίς βίντεο';

  @override
  String get issueUnconnectedChoice =>
      'Μια απάντηση με κείμενο δεν οδηγεί πουθενά';

  @override
  String get issueInvalidLogic => 'Λογική που δεν μπορεί να εκτελεστεί';

  @override
  String get issueSingleChoice =>
      'Μόνο μία απάντηση (το «Επιτρέπονται προφανείς» είναι κλειστό)';

  @override
  String get nodeUntitled => 'Κόμβος χωρίς όνομα';

  @override
  String dialogExportProblems(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count προβλήματα',
      one: 'Ένα πρόβλημα',
    );
    return '$_temp0 στο κομμάτι της ιστορίας που φτάνει η αρχή:\n$list\n\nΕξαγωγή παρ’ όλα αυτά;';
  }

  @override
  String get dialogExportAnyway => 'Εξαγωγή';

  @override
  String get editSelectOutsideMain => 'Επιλογή Κόμβων Εκτός Κύριου Κλάδου';

  @override
  String get projectFile => 'Αρχείο';

  @override
  String get projectFilesUsed => 'Αρχεία σε Χρήση';

  @override
  String projectFilesSize(int count, String size) {
    return '$count · $size';
  }

  @override
  String projectUnreadable(int count) {
    return '$count από τα αρχεία σε χρήση δεν διαβάζονται, οπότε το μέγεθος είναι μικρότερο από το πραγματικό.';
  }

  @override
  String get projectShortest => 'Συντομότερη Διαδρομή';

  @override
  String get projectLongest => 'Μακρύτερη Διαδρομή';

  @override
  String get projectNoEnding => 'Χωρίς τέλος';

  @override
  String get projectLoops => 'Χωρίς όριο (βρόχοι)';

  @override
  String get projectReading => 'Ανάγνωση…';

  @override
  String get projectLengthNote =>
      'Οι διαδρομές μετρούν τα βίντεο από την αρχή ως ένα τέλος, όχι τον χρόνο των επιλογών.';

  @override
  String projectUnknownLengths(int count) {
    return '$count βίντεο άγνωστης διάρκειας μετρούν ως 0:00.';
  }

  @override
  String get defaultsFirstColor => 'Χρώμα 1 και χρώματα χωρίς δικές τους';

  @override
  String defaultsColor(int number) {
    return 'Χρώμα $number';
  }

  @override
  String tooltipAddColorDefaults(int number) {
    return 'Προσθήκη προεπιλογών για το χρώμα $number';
  }

  @override
  String tooltipRemoveColorDefaults(int number) {
    return 'Αφαίρεση των προεπιλογών του χρώματος $number';
  }

  @override
  String get variablesEmpty =>
      'Δεν υπάρχουν μεταβλητές ακόμα. Προσθέστε μία με το +.';

  @override
  String get variableDefaultName => 'μεταβλητή';

  @override
  String get variableName => 'Όνομα';

  @override
  String get variableNameError =>
      'Τα ονόματα πρέπει να είναι μοναδικά, να αρχίζουν με γράμμα και να περιέχουν μόνο γράμματα, αριθμούς, - και _';

  @override
  String get variableNameRejected =>
      'Τα ονόματα μεταβλητών αρχίζουν με γράμμα και περιέχουν μόνο γράμματα, αριθμούς, - και _';

  @override
  String get variableMin => 'Ελάχιστο (κενό: χωρίς όριο)';

  @override
  String get variableMax => 'Μέγιστο (κενό: χωρίς όριο)';

  @override
  String get variableInitialValue => 'Αρχική τιμή';

  @override
  String get variableTypeBool => 'Λογική';

  @override
  String get variableTypeInt => 'Ακέραια';

  @override
  String get variableTypeFloat => 'Δεκαδική';

  @override
  String get variableType => 'Τύπος';

  @override
  String get variableTrue => 'Αληθής';

  @override
  String get variableFalse => 'Ψευδής';

  @override
  String get tooltipAddVariable => 'Προσθήκη μεταβλητής';

  @override
  String get tooltipDeleteVariable => 'Διαγραφή της μεταβλητής';

  @override
  String get boardVariables => 'Μεταβλητές';

  @override
  String get contextBranchingVideoNode => 'Βιντεο Πολλαπλών Επιλογών';

  @override
  String get contextChangeVariable => 'Μαθηματικά';

  @override
  String get contextCompare => 'Σύγκριση';

  @override
  String get logicTitleSet => 'Ορισμός Μεταβλητής';

  @override
  String get logicTitleIncrement => 'Αύξηση';

  @override
  String get logicTitleDecrement => 'Μείωση';

  @override
  String get logicTitleToggle => 'Εναλλαγή';

  @override
  String get logicTitleAbsolute => 'Απόλυτη Τιμή';

  @override
  String get logicTitleChange => 'Μαθηματικά';

  @override
  String get logicTitleCompare => 'Σύγκριση';

  @override
  String get logicOpSet => 'Ορισμός';

  @override
  String get logicOpAdd => 'Πρόσθεση';

  @override
  String get logicOpSubtract => 'Αφαίρεση';

  @override
  String get logicOpMultiply => 'Πολλαπλασιασμός';

  @override
  String get logicOpDivide => 'Διαίρεση';

  @override
  String get logicOpPower => 'Δύναμη';

  @override
  String get logicOpAbsolute => 'Απόλυτη';

  @override
  String get logicOpToggle => 'Εναλλαγή';

  @override
  String get logicOpAnd => 'Και';

  @override
  String get logicOpOr => 'Ή';

  @override
  String get logicOpXor => 'Αποκλειστικό Ή';

  @override
  String get logicPickVariable => 'Επιλογή Μεταβλητής…';

  @override
  String get logicMissingVariable => 'Διαγραμμένη Μεταβλητή';

  @override
  String get logicSearchVariables => 'Αναζήτηση…';

  @override
  String get logicNoVariables =>
      'Δεν υπάρχουν μεταβλητές ακόμα. Προσθέστε στην ενότητα Μεταβλητές.';

  @override
  String get logicNewValueHint => 'Νέα τιμή…';

  @override
  String get logicByValueHint => 'Κατά…';

  @override
  String get logicValueHint => 'Τιμή…';

  @override
  String get logicExpressionHint => 'π.χ. coins > 3 and has_key';

  @override
  String get logicAddCondition => 'Προσθήκη συνθήκης';

  @override
  String get logicRemoveCondition => 'Αφαίρεση συνθήκης';

  @override
  String get logicMatchAll => 'Να Ισχύουν Όλες';

  @override
  String get logicMatchAny => 'Αρκεί Μία';

  @override
  String get logicTrue => 'Αληθές';

  @override
  String get logicFalse => 'Ψευδές';

  @override
  String get logicUseExpression => 'Χρήση Έκφρασης';

  @override
  String get musicTrack => 'Μουσική';

  @override
  String get musicEndsWhen => 'Τελειώνει Όταν';

  @override
  String get musicEndTrack => 'Τελειώσει το Κομμάτι';

  @override
  String get musicEndChoices => 'Εμφανιστούν οι Επιλογές';

  @override
  String get musicEndVideo => 'Τελειώσει το Βίντεο';

  @override
  String get musicEndLater => 'Ξεκινήσει Άλλη Μουσική';

  @override
  String get musicLoop => 'Επανάληψη';

  @override
  String get musicFadeOut => 'Σβήσιμο';

  @override
  String get musicPauseWithVideo => 'Παύση με το Βίντεο';

  @override
  String get musicPause => 'Μουσική Παύσης';

  @override
  String get musicPauseFadeOut => 'Σβήσιμο Μουσικής Παύσης';

  @override
  String get musicMenu => 'Μουσική Μενού';

  @override
  String get musicPauseMenu => 'Μουσική Μενού Παύσης';

  @override
  String get musicRemove => 'Αφαίρεση μουσικής';

  @override
  String get musicNone => 'Καμία';

  @override
  String get musicNoAudio =>
      'Δεν έχει εισαχθεί ήχος. Εισάγετε αρχεία ήχου στα Εισαγόμενα Πολυμέσα.';

  @override
  String get musicPlayPreview => 'Αναπαραγωγή στην Προεπισκόπηση';

  @override
  String get musicLoopNeverEnds =>
      'Ένα κομμάτι σε επανάληψη δεν τελειώνει μόνο του: παίζει μέχρι να ξεκινήσει άλλη μουσική.';

  @override
  String get musicDropAsMusic => 'Μουσική με το Βίντεο';

  @override
  String get musicDropAsPause => 'Μουσική Παύσης (στις Επιλογές)';

  @override
  String get viewStoryGraph => 'Γράφημα Ιστορίας';

  @override
  String get viewScreens => 'Οθόνες';

  @override
  String get screenTitle => 'Τίτλος';

  @override
  String get screenDescription => 'Περιγραφή';

  @override
  String get screenStart => 'Έναρξη';

  @override
  String get screenLoad => 'Φόρτωση';

  @override
  String get screenSettings => 'Ρυθμίσεις';

  @override
  String get screenCredits => 'Συντελεστές';

  @override
  String get screenQuit => 'Έξοδος';

  @override
  String get screenQuestion => 'Ερώτηση';

  @override
  String get screenChoices => 'Απαντήσεις';

  @override
  String get screenTimer => 'Χρονόμετρο';

  @override
  String get screenResume => 'Συνέχεια';

  @override
  String get screenSave => 'Αποθήκευση';

  @override
  String get screenMainMenu => 'Κύριο Μενού';

  @override
  String get screenKindMenu => 'Κύριο Μενού';

  @override
  String get screenKindChoice => 'Οθόνη Επιλογών';

  @override
  String get screenKindPause => 'Μενού Παύσης';

  @override
  String get screenScreens => 'Οθόνες';

  @override
  String get screenStyles => 'Στυλ';

  @override
  String get screenNewStyle => 'Νέο Στυλ';

  @override
  String screenNewStyleName(int number) {
    return 'Στυλ $number';
  }

  @override
  String screenStyleUses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count στοιχεία',
      one: '1 στοιχείο',
      zero: 'δεν χρησιμοποιείται',
    );
    return '$_temp0';
  }

  @override
  String get screenDeleteStyle => 'Διαγραφή στυλ';

  @override
  String get screenRenameHint => 'Όνομα στυλ';

  @override
  String get screenPresets => 'Διατάξεις';

  @override
  String get screenPresetClassicMenu => 'Κλασική';

  @override
  String get screenPresetCenteredMenu => 'Στο Κέντρο';

  @override
  String get screenPresetSideMenu => 'Στο Πλάι';

  @override
  String get screenPresetBottomChoices => 'Απαντήσεις Κάτω';

  @override
  String get screenPresetSideChoices => 'Απαντήσεις στο Πλάι';

  @override
  String get screenPresetClassicPause => 'Κλασική';

  @override
  String get screenPresetCornerPause => 'Στη Γωνία';

  @override
  String screenReplaceLayout(String name) {
    return 'Αντικατάσταση των στοιχείων αυτής της οθόνης με τη διάταξη «$name»; Μπορείτε να το αναιρέσετε.';
  }

  @override
  String get screenReplace => 'Αντικατάσταση';

  @override
  String get screenVideoBehind => 'Το βίντεο είναι πίσω από αυτή την οθόνη';

  @override
  String get screenPreviewAnswers => 'Απαντήσεις';

  @override
  String get screenPreviewLong => 'Μεγάλες Απαντήσεις';

  @override
  String get screenPreviewQuestion => 'Με Ερώτηση';

  @override
  String screenSampleAnswer(int number) {
    return 'Απάντηση $number';
  }

  @override
  String screenSampleLongAnswer(int number) {
    return 'Απάντηση $number, αρκετά μεγάλη ώστε να χρειάζεται δεύτερη γραμμή';
  }

  @override
  String get screenSampleQuestion => 'Ποια πόρτα ανοίγεις;';

  @override
  String get screenGap => 'Απόσταση';

  @override
  String get screenSwitchToDesigner => 'Σχεδίαση Οθονών (Ctrl+2)';

  @override
  String get screenSwitchToGraph => 'Γράφος Ιστορίας (Ctrl+1)';

  @override
  String get screenDesign => 'Σχεδίαση';

  @override
  String get screenStyleHint =>
      'Κάντε κλικ σε ένα στυλ στη λίστα για να το αλλάξετε, ή σε ένα στοιχείο στην οθόνη για να αλλάξετε αυτό και το στυλ του.';

  @override
  String get screenPickColor => 'Επιλογή Χρώματος';

  @override
  String get screenDropBackground =>
      'Ρίξτε εδώ μια εικόνα ή ένα βίντεο για φόντο';

  @override
  String get screenBackground => 'Φόντο';

  @override
  String get screenNoBackground => 'Χωρίς Φόντο';

  @override
  String get screenRemoveBackground => 'Αφαίρεση φόντου';

  @override
  String get screenRemoveElement => 'Αφαίρεση στοιχείου';

  @override
  String get screenTextHint => 'Δικό του κείμενο (αλλιώς το προεπιλεγμένο)…';

  @override
  String get screenWidth => 'Πλάτος';

  @override
  String get screenStyle => 'Στυλ';

  @override
  String screenStyleNote(String name) {
    return 'Οι αλλαγές παρακάτω ισχύουν για κάθε στοιχείο με στυλ $name.';
  }

  @override
  String get screenTextSize => 'Μέγεθος Κειμένου';

  @override
  String get screenBold => 'Έντονα';

  @override
  String get screenDefaultFont => 'Προεπιλεγμένη Γραμματοσειρά';

  @override
  String get screenTextColor => 'Χρώμα κειμένου';

  @override
  String get screenBackColor => 'Χρώμα φόντου';

  @override
  String get screenBackOpacity => 'Αδιαφάνεια Φόντου';

  @override
  String get screenRoundness => 'Στρογγύλεμα';

  @override
  String get screenPadding => 'Περιθώριο';

  @override
  String get screenSelectHint =>
      'Κάντε κλικ σε ένα στοιχείο για να το αλλάξετε. Σύρετε τα στοιχεία για να τα μετακινήσετε· κουμπώνουν στο κέντρο και μεταξύ τους.';

  @override
  String get screenKindEndChoice => 'Οθόνη Επιλογής σε Παύση';

  @override
  String get screenKindSettings => 'Οθόνη Ρυθμίσεων';

  @override
  String get screenKindSaves => 'Οθόνη Αποθηκεύσεων';

  @override
  String get screenKindEndChoiceHint =>
      'Εμφανίζεται πάνω στο τελευταίο καρέ όταν ένα βίντεο περιμένει απάντηση (Παύση στο Τέλος).';

  @override
  String get screenBack => 'Πίσω';

  @override
  String get screenVolume => 'Ένταση';

  @override
  String get screenSubtitles => 'Υπότιτλοι';

  @override
  String get screenFullScreen => 'Πλήρης Οθόνη';

  @override
  String get screenSaves => 'Αποθηκευμένα Παιχνίδια';

  @override
  String get screenOn => 'Ναι';

  @override
  String get screenOff => 'Όχι';

  @override
  String get screenNoSaves => 'Δεν υπάρχουν αποθηκεύσεις';

  @override
  String get screenSampleSave => 'Αποθήκευση, σήμερα 21:14';

  @override
  String get screenPresetRowChoices => 'Απαντήσεις σε Σειρά';

  @override
  String get screenPresetSplitChoices => 'Χωρισμένη Οθόνη';

  @override
  String get screenPresetPieChoices => 'Πίτα';

  @override
  String get screenPresetStackedChoices => 'Λωρίδες';

  @override
  String get screenPresetClassicSettings => 'Κλασικές Ρυθμίσεις';

  @override
  String get screenPresetClassicSaves => 'Κλασικές Αποθηκεύσεις';

  @override
  String get screenNewChoiceScreen => 'Νέα Οθόνη Επιλογής';

  @override
  String get screenNewEndChoiceScreen => 'Νέα Οθόνη Επιλογής σε Παύση';

  @override
  String screenNewScreenName(String kind, int number) {
    return '$kind $number';
  }

  @override
  String get screenRename => 'Μετονομασία';

  @override
  String get screenDeleteScreen => 'Διαγραφή Οθόνης';

  @override
  String get screenNotUsed => 'δεν χρησιμοποιείται';

  @override
  String get screenNameHint => 'Όνομα οθόνης';

  @override
  String get screenRequiredElement =>
      'Η οθόνη το χρειάζεται, οπότε δεν αφαιρείται.';

  @override
  String get screenLayout => 'Διάταξη';

  @override
  String get screenLayoutVertical => 'Η μία κάτω από την άλλη';

  @override
  String get screenLayoutHorizontal => 'Δίπλα-δίπλα';

  @override
  String get screenLayoutColumns => 'Πλήρης οθόνη, σε στήλες';

  @override
  String get screenLayoutRows => 'Πλήρης οθόνη, σε λωρίδες';

  @override
  String get screenLayoutRadial => 'Πλήρης οθόνη, σαν πίτα';

  @override
  String get screenTimerMode => 'Αδειάζει';

  @override
  String get screenTimerToStart => 'Προς τα αριστερά';

  @override
  String get screenTimerToMiddle => 'Προς τη μέση';

  @override
  String get screenTimerFromMiddle => 'Από τη μέση';

  @override
  String get screenThickness => 'Πάχος';

  @override
  String get screenBarColor => 'Χρώμα μπάρας';

  @override
  String get screenTrackColor => 'Χρώμα φόντου μπάρας';

  @override
  String get screenBlur => 'Θόλωμα';

  @override
  String get screenFont => 'Γραμματοσειρά';

  @override
  String get screenBuiltInFonts => 'Γραμματοσειρές του Nutria FMV';

  @override
  String get screenImportedFonts => 'Εισαγόμενες γραμματοσειρές';

  @override
  String get screenFullScreenPreview =>
      'Προεπισκόπηση σε Πλήρη Οθόνη (Esc για κλείσιμο)';

  @override
  String get screenPercentNote =>
      'Οι αριθμοί είναι ποσοστά της οθόνης: τα πλάτη του πλάτους της, τα άλλα μεγέθη του ύψους της.';

  @override
  String get screenText => 'Κείμενο';

  @override
  String get screenBackdrop => 'Από πίσω';

  @override
  String get screenBackdropNone => 'Τίποτα';

  @override
  String get screenBackdropFrame => 'Καρέ του προβολέα';

  @override
  String get screenOverlayNote =>
      'Σε οθόνη επιλογής το φόντο μπαίνει πάνω από το βίντεο: μια εικόνα με διάφανα σημεία μπορεί να το πλαισιώσει.';

  @override
  String get screenFadeIn => 'Εμφάνιση (δ)';

  @override
  String get screenFadeInNote =>
      'Όταν ένα βίντεο περιμένει απάντηση χωρίς χρόνο επιλογής πριν το τέλος, η εμφάνιση ξεκινά τόσο νωρίτερα από το τέλος.';

  @override
  String get screenFadeOut => 'Απόσβεση (δ)';

  @override
  String get screenEntrance => 'Είσοδος';

  @override
  String get screenEntranceFade => 'Σβήνοντας';

  @override
  String get screenEntranceSlideUp => 'Ανεβαίνοντας';

  @override
  String get screenEntranceZoom => 'Μεγαλώνοντας';

  @override
  String get screenEffect => 'Εφέ';

  @override
  String get screenEffectNone => 'Κανένα';

  @override
  String get screenEffectDarken => 'Σκούρεμα βίντεο';

  @override
  String get screenEffectBlur => 'Θόλωμα βίντεο';

  @override
  String get screenEffectVignette => 'Σκοτεινές άκρες';

  @override
  String get screenEffectPulse => 'Οι απαντήσεις «αναπνέουν»';

  @override
  String get screenRotation => 'Περιστροφή (°)';

  @override
  String get overrideChoiceScreen => 'Οθόνη Επιλογής';

  @override
  String get overrideEndChoiceScreen => 'Οθόνη Επιλογής σε Παύση';

  @override
  String get logicProblemNoVariable => 'Επιλέξτε μεταβλητή.';

  @override
  String get logicProblemUnknownVariable => 'Αυτή η μεταβλητή διαγράφηκε.';

  @override
  String get logicProblemWrongOperation =>
      'Δεν ταιριάζει σε αυτό το είδος μεταβλητής.';

  @override
  String get logicProblemNoConditions => 'Προσθέστε μια συνθήκη.';

  @override
  String get logicProblemEmpty =>
      'Δώστε μια τιμή. Χωρίς αυτή, τίποτα δεν αλλάζει.';

  @override
  String get logicProblemExpression =>
      'Η τιμή δεν διαβάζεται ή είναι λάθος είδους (αριθμός ή αληθές/ψευδές).';

  @override
  String logicProblemUnknownName(String name) {
    return 'Δεν υπάρχει μεταβλητή με όνομα $name.';
  }

  @override
  String get logicWarningRounded =>
      'Το αποτέλεσμα μπορεί να έχει δεκαδικά· στρογγυλοποιείται.';

  @override
  String get prefSimpleMath => 'Απλά Μαθηματικά';

  @override
  String get prefAllowNoBrainers => 'Ερωτήσεις μίας Απάντησης';

  @override
  String get prefAllowNoBrainersNote =>
      'Οι κόμβοι διακλάδωσης μπορούν να έχουν μία μόνο απάντηση.';

  @override
  String get prefGroupAppearance => 'Εμφάνιση';

  @override
  String get prefGroupCanvas => 'Καμβάς';

  @override
  String get prefGroupStory => 'Λογική Ιστορίας';

  @override
  String get prefGroupMedia => 'Πολυμέσα';

  @override
  String get notifyExportSingleChoice =>
      'Εξήχθη, αλλά κάποιες ερωτήσεις έχουν μία μόνο απάντηση. Επιτρέψτε τις από Προτιμήσεις > Ερωτήσεις μίας Απάντησης.';

  @override
  String get notifyExportLogicIssues =>
      'Κάποιοι κόμβοι λογικής έχουν προβλήματα· το Player θα τους παραλείψει';

  @override
  String get contextSimpleVideoNode => 'Απλό Βίντεο';

  @override
  String get dialogUnsavedChanges => 'Αποθήκευση των αλλαγών του έργου;';

  @override
  String get dialogSave => 'Αποθήκευση';

  @override
  String get dialogDontSave => 'Χωρίς αποθήκευση';

  @override
  String get essentialsCancel => 'Ακύρωση';

  @override
  String get editDeleteSelectedNodes => 'Διαγραφή Επελεγμένων Κόμβων';

  @override
  String get editDisconnectNodes => 'Αποσύνδεση Επιλεγμένων Κόμβων';

  @override
  String get editRenameNode => 'Μετονομασία Κόμβου';

  @override
  String get nodeRename => 'Μετονομασία';

  @override
  String get contextComment => 'Σχόλιο';

  @override
  String get nodeAddComment => 'Προσθήκη Σχολίου';

  @override
  String get commentEdit => 'Επεξεργασία Σχολίου';

  @override
  String get commentDetach => 'Αποσύνδεση από τον Κόμβο';

  @override
  String get commentHint => 'Σχόλιο…';

  @override
  String get nodeRenameHint => 'Όνομα κόμβου';

  @override
  String get nodeOriginDefaultName => 'Αρχικός Κόμβος';

  @override
  String get nodeQuestion => 'Ερώτηση';

  @override
  String get nodeQuestionHint => 'Ερώτηση';

  @override
  String get editRedo => 'Επανάληψη';

  @override
  String get editCopy => 'Αντιγραφή';

  @override
  String get editCut => 'Αποκοπή';

  @override
  String get windowMinimize => 'Ελαχιστοποίηση';

  @override
  String get windowMaximize => 'Μεγιστοποίηση';

  @override
  String get windowRestore => 'Επαναφορά';

  @override
  String get windowClose => 'Κλείσιμο';

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
  String get fileSaveProject => 'Αποθήκευση Πρότζεκτ';

  @override
  String get fileSaveProjectAs => 'Αποθήκευση Πρότζεκτ ως';

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
  String get overrideShowQuestion => 'Εμφάνιση Ερώτησης';

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
  String get statusShowNotifications => 'Εμφάνιση Όλων των Ειδοποιήσεων…';

  @override
  String get statusNotificationsTitle => 'Ειδοποιήσεις';

  @override
  String get statusNoNotifications => 'Δεν υπάρχουν ειδοποιήσεις ακόμα.';

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
  String get editPlayPause => 'Αναπαραγωγή / Παύση Βίντεο';

  @override
  String get tooltipPickVideo => 'Επιλογή βίντεο';

  @override
  String get tooltipNodeSettings => 'Ρυθμίσεις κόμβου';

  @override
  String get tooltipImportVideos => 'Εισαγωγή πολυμέσων';

  @override
  String get tooltipBack5 => 'Πίσω 5 δευτερόλεπτα (Ctrl+←)';

  @override
  String get tooltipPlayPause => 'Αναπαραγωγή / παύση (Space)';

  @override
  String get tooltipForward5 => 'Μπροστά 5 δευτερόλεπτα (Ctrl+→)';

  @override
  String get tooltipChoicesFromHere =>
      'Εμφάνιση των επιλογών από αυτή τη στιγμή';

  @override
  String get tooltipVolume => 'Ένταση (Ctrl+↑ / Ctrl+↓)';

  @override
  String get tooltipShowLeftPanel => 'Εμφάνιση πλαϊνής στήλης (T)';

  @override
  String get tooltipShowRightPanel => 'Εμφάνιση προβολής βίντεο (N)';

  @override
  String get tooltipResetOverride => 'Χρήση της ρύθμισης του έργου';

  @override
  String tooltipNodeColor(int number) {
    return 'Χρώμα $number';
  }
}
