// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get boardImportedVideos => 'Médias Importés';

  @override
  String get libraryLargeThumbnails => 'Grandes miniatures';

  @override
  String get libraryThumbnails => 'Miniatures moyennes';

  @override
  String get librarySmallThumbnails => 'Petites miniatures';

  @override
  String get libraryListWithThumbnails => 'Liste avec miniatures';

  @override
  String get libraryList => 'Liste';

  @override
  String get librarySortDateAdded => 'Trier par date d’ajout';

  @override
  String get librarySortName => 'Trier par nom';

  @override
  String get librarySortType => 'Trier par type';

  @override
  String get libraryGroupNone => 'Ne pas grouper';

  @override
  String get libraryGroupKind => 'Grouper par genre';

  @override
  String get libraryGroupFileType => 'Grouper par type de fichier';

  @override
  String get fileLocateMissing => 'Localiser les fichiers manquants…';

  @override
  String get mediaFindMissing => 'Trouver le fichier manquant…';

  @override
  String get mediaReplace => 'Remplacer…';

  @override
  String tooltipMissingFile(String path) {
    return 'Introuvable : $path';
  }

  @override
  String get missingFilesTitle => 'Fichiers manquants';

  @override
  String get missingFilesMessage =>
      'Ces fichiers sont introuvables. Ils ont peut-être été déplacés ou renommés.';

  @override
  String get missingFilesNone => 'Tous les fichiers ont été trouvés.';

  @override
  String get missingFilesLocate => 'Chercher dans un dossier…';

  @override
  String notifyLocatedFiles(int found, int total) {
    return '$found fichiers manquants sur $total trouvés';
  }

  @override
  String get notifyNoMissingFiles => 'Aucun fichier ne manque';

  @override
  String notifyFileNameDiffers(String name) {
    return 'Le fichier choisi porte un autre nom : $name';
  }

  @override
  String get mediaUnlinkSubtitles => 'Délier les sous-titres';

  @override
  String tooltipHasSubtitles(String name) {
    return 'Sous-titres : $name';
  }

  @override
  String notifySubtitlesLonger(String time) {
    return 'Les sous-titres continuent $time après la fin de la vidéo';
  }

  @override
  String previewLinkedTo(String name) {
    return 'Liés à $name';
  }

  @override
  String get previewUnreadable => 'Ce fichier est illisible.';

  @override
  String get previewNoCues =>
      'Aucun sous-titre n’a été trouvé dans ce fichier.';

  @override
  String get previewFontSample =>
      'Portez ce vieux whisky au juge blond qui fume';

  @override
  String get prefAutoLinkSubtitles => 'Lier les sous-titres par nom';

  @override
  String get mediaKindVideo => 'Vidéos';

  @override
  String get mediaKindAudio => 'Audio';

  @override
  String get mediaKindImage => 'Images';

  @override
  String get mediaKindSubtitle => 'Sous-titres';

  @override
  String get mediaKindFont => 'Polices';

  @override
  String get boardPreferences => 'Préférences';

  @override
  String get boardProjectSettings => 'Valeurs par défaut';

  @override
  String get boardProject => 'Projet';

  @override
  String get projectInformation => 'Informations';

  @override
  String get projectLanguages => 'Langues';

  @override
  String get projectAddLanguage => 'Ajouter une langue…';

  @override
  String get projectMainLanguage => 'Principale';

  @override
  String get projectMakeMain => 'Définir comme langue principale';

  @override
  String get projectRemoveLanguage => 'Retirer cette langue';

  @override
  String get projectLanguagesNote =>
      'La première est la langue principale. S\'il y en a plusieurs, lier des sous-titres demande leur langue.';

  @override
  String get projectOverview => 'Aperçu';

  @override
  String get projectFile => 'Fichier';

  @override
  String get projectFilesUsed => 'Fichiers utilisés';

  @override
  String projectFilesSize(int count, String size) {
    return '$count · $size';
  }

  @override
  String projectUnreadable(int count) {
    return '$count des fichiers utilisés sont illisibles : la taille réelle est plus grande.';
  }

  @override
  String get projectShortest => 'Parcours le plus court';

  @override
  String get projectLongest => 'Parcours le plus long';

  @override
  String get projectNoEnding => 'Pas de fin';

  @override
  String get projectLoops => 'Sans limite (boucles)';

  @override
  String get projectReading => 'Lecture…';

  @override
  String get projectLengthNote =>
      'Les parcours comptent les vidéos du début à une fin, pas le temps des choix.';

  @override
  String projectUnknownLengths(int count) {
    return '$count vidéos de durée inconnue comptent pour 0:00.';
  }

  @override
  String get defaultsFirstColor => 'Couleur 1 et couleurs sans les leurs';

  @override
  String defaultsColor(int number) {
    return 'Couleur $number';
  }

  @override
  String tooltipAddColorDefaults(int number) {
    return 'Ajouter des valeurs par défaut pour la couleur $number';
  }

  @override
  String tooltipRemoveColorDefaults(int number) {
    return 'Supprimer les valeurs par défaut de la couleur $number';
  }

  @override
  String get variablesEmpty =>
      'Aucune variable pour l’instant. Ajoutez-en une avec +.';

  @override
  String get variableDefaultName => 'variable';

  @override
  String get variableName => 'Nom';

  @override
  String get variableNameError =>
      'Les noms doivent être uniques, commencer par une lettre et ne contenir que des lettres, chiffres, - et _';

  @override
  String get variableNameRejected =>
      'Les noms de variables commencent par une lettre et ne contiennent que des lettres, chiffres, - et _';

  @override
  String get variableMin => 'Minimum (vide : sans limite)';

  @override
  String get variableMax => 'Maximum (vide : sans limite)';

  @override
  String get variableInitialValue => 'Valeur initiale';

  @override
  String get variableTypeBool => 'Booléen';

  @override
  String get variableTypeInt => 'Entier';

  @override
  String get variableTypeFloat => 'Décimal';

  @override
  String get variableType => 'Type';

  @override
  String get variableTrue => 'Vrai';

  @override
  String get variableFalse => 'Faux';

  @override
  String get tooltipAddVariable => 'Ajouter une variable';

  @override
  String get tooltipDeleteVariable => 'Supprimer la variable';

  @override
  String get boardVariables => 'Variables';

  @override
  String get contextBranchingVideoNode => 'Vidéo Ramifié';

  @override
  String get contextChangeVariable => 'Modifier une variable';

  @override
  String get contextCompare => 'Comparer';

  @override
  String get logicTitleSet => 'Définir la variable';

  @override
  String get logicTitleIncrement => 'Incrémenter';

  @override
  String get logicTitleDecrement => 'Décrémenter';

  @override
  String get logicTitleToggle => 'Inverser';

  @override
  String get logicTitleAbsolute => 'Valeur absolue';

  @override
  String get logicTitleChange => 'Modifier la variable';

  @override
  String get logicTitleCompare => 'Comparer';

  @override
  String get logicOpSet => 'Définir';

  @override
  String get logicOpAdd => 'Ajouter';

  @override
  String get logicOpSubtract => 'Soustraire';

  @override
  String get logicOpMultiply => 'Multiplier';

  @override
  String get logicOpDivide => 'Diviser';

  @override
  String get logicOpPower => 'Puissance';

  @override
  String get logicOpAbsolute => 'Absolue';

  @override
  String get logicOpToggle => 'Inverser';

  @override
  String get logicOpAnd => 'Et';

  @override
  String get logicOpOr => 'Ou';

  @override
  String get logicOpXor => 'Ou exclusif';

  @override
  String get logicPickVariable => 'Choisir une variable…';

  @override
  String get logicMissingVariable => 'Variable supprimée';

  @override
  String get logicSearchVariables => 'Rechercher…';

  @override
  String get logicNoVariables =>
      'Aucune variable pour l’instant. Ajoutez-en dans la section Variables.';

  @override
  String get logicNewValueHint => 'Nouvelle valeur…';

  @override
  String get logicByValueHint => 'De…';

  @override
  String get logicValueHint => 'Valeur…';

  @override
  String get logicExpressionHint => 'ex. coins > 3 and has_key';

  @override
  String get logicAddCondition => 'Ajouter une condition';

  @override
  String get logicRemoveCondition => 'Retirer cette condition';

  @override
  String get logicMatchAll => 'Toutes';

  @override
  String get logicMatchAny => 'Une suffit';

  @override
  String get logicTrue => 'Vrai';

  @override
  String get logicFalse => 'Faux';

  @override
  String get logicUseExpression => 'Utiliser une expression';

  @override
  String get musicTrack => 'Musique';

  @override
  String get musicEndsWhen => 'Se termine';

  @override
  String get musicEndTrack => 'Fin du morceau';

  @override
  String get musicEndChoices => 'Choix affichés';

  @override
  String get musicEndVideo => 'Fin de la vidéo';

  @override
  String get musicEndLater => 'Autre musique';

  @override
  String get musicLoop => 'En boucle';

  @override
  String get musicFadeOut => 'Fondu';

  @override
  String get musicPauseWithVideo => 'Pause avec la vidéo';

  @override
  String get musicPause => 'Musique de pause';

  @override
  String get musicPauseFadeOut => 'Fondu de la pause';

  @override
  String get musicMenu => 'Musique du menu';

  @override
  String get musicRemove => 'Retirer cette musique';

  @override
  String get musicNone => 'Aucune';

  @override
  String get musicNoAudio =>
      'Aucun audio importé. Importez des fichiers audio dans Médias Importés.';

  @override
  String get musicPlayPreview => 'Écouter dans l\'aperçu';

  @override
  String get musicLoopNeverEnds =>
      'Un morceau en boucle ne s’arrête pas seul : il joue jusqu’à une autre musique.';

  @override
  String get musicDropAsMusic => 'Musique avec la vidéo';

  @override
  String get musicDropAsPause => 'Musique de pause (pendant le choix)';

  @override
  String get boardScreen => 'Conception du menu';

  @override
  String get viewStoryGraph => 'Graphe de l’histoire';

  @override
  String get viewScreens => 'Écrans';

  @override
  String get screenTitle => 'Titre';

  @override
  String get screenDescription => 'Description';

  @override
  String get screenStart => 'Commencer';

  @override
  String get screenLoad => 'Charger';

  @override
  String get screenSettings => 'Paramètres';

  @override
  String get screenCredits => 'Crédits';

  @override
  String get screenQuit => 'Quitter';

  @override
  String get screenDropBackground =>
      'Déposez ici une image ou une vidéo pour le fond';

  @override
  String get screenOpenDesigner => 'Ouvrir le concepteur d’écrans';

  @override
  String get screenBackground => 'Fond';

  @override
  String get screenNoBackground => 'Aucun fond';

  @override
  String get screenRemoveBackground => 'Retirer le fond';

  @override
  String get screenClassicLayout => 'Disposition classique';

  @override
  String get screenRemoveElement => 'Retirer cet élément';

  @override
  String get screenTextHint => 'Texte propre (sinon par défaut)…';

  @override
  String get screenWidth => 'Largeur';

  @override
  String get screenStyle => 'Style';

  @override
  String screenStyleNote(String name) {
    return 'Les changements ci-dessous valent pour tous les éléments au style $name.';
  }

  @override
  String get screenTextSize => 'Taille du texte';

  @override
  String get screenBold => 'Gras';

  @override
  String get screenDefaultFont => 'Police par défaut';

  @override
  String get screenTextColor => 'Couleur du texte';

  @override
  String get screenBackColor => 'Couleur du fond';

  @override
  String get screenBackOpacity => 'Opacité du fond';

  @override
  String get screenRoundness => 'Arrondi';

  @override
  String get screenPadding => 'Marge';

  @override
  String get screenSelectHint =>
      'Cliquez sur un élément pour le modifier. Faites glisser les éléments pour les déplacer ; ils s’alignent au centre et entre eux.';

  @override
  String get logicProblemNoVariable => 'Choisissez une variable.';

  @override
  String get logicProblemUnknownVariable => 'Cette variable a été supprimée.';

  @override
  String get logicProblemWrongOperation =>
      'Ne s’applique pas à ce type de variable.';

  @override
  String get logicProblemNoConditions => 'Ajoutez une condition.';

  @override
  String get logicProblemEmpty => 'Entrez une valeur. Sinon, rien ne change.';

  @override
  String get logicProblemExpression =>
      'Valeur illisible ou du mauvais type (nombre ou vrai/faux).';

  @override
  String logicProblemUnknownName(String name) {
    return 'Il n’y a pas de variable nommée $name.';
  }

  @override
  String get logicWarningRounded =>
      'Le résultat peut avoir des décimales ; il est arrondi.';

  @override
  String get prefSimpleMath => 'Calcul simple';

  @override
  String get prefAllowNoBrainers => 'Questions à une Réponse';

  @override
  String get prefAllowNoBrainersNote =>
      'Les nœuds à embranchements peuvent n\'offrir qu\'une réponse.';

  @override
  String get prefGroupAppearance => 'Apparence';

  @override
  String get prefGroupCanvas => 'Canevas';

  @override
  String get prefGroupStory => 'Logique de l\'Histoire';

  @override
  String get prefGroupMedia => 'Médias';

  @override
  String get notifyExportSingleChoice =>
      'Exporté, mais certaines questions n\'ont qu\'une réponse. Autorisez-les dans Préférences > Questions à une Réponse.';

  @override
  String get notifyExportLogicIssues =>
      'Certains nœuds logiques ont des problèmes ; le Player les ignorera';

  @override
  String get contextCompareNode => 'Comparaison de Valeur';

  @override
  String get contextMathNode => 'Mathématique';

  @override
  String get contextSetNode => 'Définition de Valeur';

  @override
  String get contextSimpleVideoNode => 'Vidéo Simple';

  @override
  String get dialogUnsavedChanges =>
      'Enregistrer les modifications de ce projet ?';

  @override
  String get dialogSave => 'Enregistrer';

  @override
  String get dialogDontSave => 'Ne pas enregistrer';

  @override
  String get essentialsCancel => 'Annuler';

  @override
  String get editDeleteSelectedNodes => 'Supprimer les Nœuds Sélectionnés';

  @override
  String get editDisconnectNodes => 'Déconnecter les nœuds sélectionnés';

  @override
  String get editRenameNode => 'Renommer le nœud';

  @override
  String get nodeRename => 'Renommer';

  @override
  String get contextComment => 'Commentaire';

  @override
  String get nodeAddComment => 'Ajouter un commentaire';

  @override
  String get commentEdit => 'Modifier le commentaire';

  @override
  String get commentDetach => 'Détacher du nœud';

  @override
  String get commentHint => 'Commentaire…';

  @override
  String get nodeRenameHint => 'Nom du nœud';

  @override
  String get nodeOriginDefaultName => 'Nœud d\'origine';

  @override
  String get nodeQuestion => 'Question';

  @override
  String get nodeQuestionHint => 'Question au-dessus des choix';

  @override
  String get editProjectSettings => 'Paramètres du Projet';

  @override
  String get editRedo => 'Rétablir';

  @override
  String get editCopy => 'Copier';

  @override
  String get editCut => 'Couper';

  @override
  String get windowMinimize => 'Réduire';

  @override
  String get windowMaximize => 'Agrandir';

  @override
  String get windowRestore => 'Restaurer';

  @override
  String get windowClose => 'Fermer';

  @override
  String get editPaste => 'Coller';

  @override
  String get editDuplicate => 'Dupliquer';

  @override
  String get editSelectAll => 'Tout sélectionner';

  @override
  String get editCollapseAll => 'Replier tous les nœuds';

  @override
  String get editToggleGridSnapping =>
      'Activer/Désactiver l\'Alignement sur la Grille';

  @override
  String get editUndo => 'Annuler';

  @override
  String get essentialsNo => 'Non';

  @override
  String get essentialsYes => 'Oui';

  @override
  String get fileExit => 'Quitter';

  @override
  String get fileExportProject => 'Exporter le projet';

  @override
  String get fileLoadProject => 'Charger un Projet';

  @override
  String get fileNewProject => 'Nouveau Projet';

  @override
  String get fileSaveProject => 'Enregistrer le Projet';

  @override
  String get fileSaveProjectAs => 'Enregistrer le Projet sous...';

  @override
  String get helpAbout => 'À propos de Nutria FMV Maker';

  @override
  String get helpDocumentation => 'Documentation';

  @override
  String get helpGithub => 'Github';

  @override
  String get infoProjectDescription =>
      '«Nutria FMV Maker» est un projet Flutter gratuit/open-source en cours de réalisation qui vise à rendre plus accessible le processus de création d\'expériences cinématographiques interactives. Il est publié sous licence GPLv3.';

  @override
  String get menuBarEdit => 'Édition';

  @override
  String get menuBarFile => 'Fichier';

  @override
  String get menuBarHelp => 'Aide';

  @override
  String get menuBarView => 'Afficage';

  @override
  String get nodeConvertToBranching => 'Convertir en Νœud Ramifié';

  @override
  String get nodeConvertToSimple => 'Convertir en Νœud Vidéo Simple';

  @override
  String get nodeNoVideo => 'Aucune vidéo';

  @override
  String get nodeThumbnailError => 'Pas de miniature';

  @override
  String notifyExportWarnings(int count) {
    return 'Exporté avec $count avertissements (vidéos manquantes ou choix non connectés)';
  }

  @override
  String notifyExported(String fileName) {
    return 'Exporté : $fileName';
  }

  @override
  String notifyFileError(String path) {
    return 'Impossible d\'accéder à $path';
  }

  @override
  String get notifyInvalidProject => 'Fichier de projet non valide';

  @override
  String get notifyNewerProject =>
      'Ce projet a été créé avec une version plus récente de Nutria FMV Maker';

  @override
  String get notifyOldProject =>
      'Ce projet a été créé avec une version plus ancienne et ne peut pas être ouvert';

  @override
  String notifySaved(String fileName) {
    return 'Enregistré : $fileName';
  }

  @override
  String get originProjectDescription => 'Description du projet';

  @override
  String get originProjectTitle => 'Titre du projet';

  @override
  String get originTitlePlaceHolder => 'Exemple de menu principal';

  @override
  String get overrideDefaultSelection => 'Choix par Défaut';

  @override
  String get overrideDefaultSelection_First => 'Premier';

  @override
  String get overrideDefaultSelection_Last => 'Dernier';

  @override
  String get overrideDefaultSelection_LastSelected => 'Dernier Choix';

  @override
  String get overrideDefaultSelection_Random => 'Aléatoire';

  @override
  String get overrideDefaultSelection_Specified => 'Choix Spécifié';

  @override
  String get overridePauseOnEnd => 'Pause à la Fin';

  @override
  String get overrideSelectionTime => 'Temps de sélection';

  @override
  String get overrideShowTimer => 'Afficher la Minuterie';

  @override
  String get overrideVideoFit => 'Ajustement Vidéo';

  @override
  String get overrideVideoFit_Fill => 'Remplir';

  @override
  String get overrideVideoFit_FillHeight => 'Remplir la Hauteur';

  @override
  String get overrideVideoFit_FillWidth => 'Remplir la Largeur';

  @override
  String get overrideVideoFit_Fit => 'Ajuster';

  @override
  String get overrideVideoFit_Stretch => 'Étirer';

  @override
  String get prefDefaultNodeType => 'Nouveaux nœuds vidéo';

  @override
  String get prefGridSize => 'Taille de la grille';

  @override
  String get prefGridSnapping => 'Aimanter à la grille';

  @override
  String get prefNoodleCurved => 'Courbes';

  @override
  String get prefNoodleStraight => 'Droites';

  @override
  String get prefNoodleStyle => 'Connexions';

  @override
  String get statusUnsavedFile => 'Fichier non enregistré';

  @override
  String get statusShowNotifications => 'Afficher toutes les notifications…';

  @override
  String get statusNotificationsTitle => 'Notifications';

  @override
  String get statusNoNotifications => 'Aucune notification pour l’instant.';

  @override
  String get videoMetadataDateCreated => 'Date de creation';

  @override
  String get videoMetadataDuration => 'Durée';

  @override
  String get videoMetadataFilePath => 'Chemin d\'accès';

  @override
  String get videoMetadataFileSize => 'Taille du fichier';

  @override
  String get videoMetadataFilename => 'Nom de fichier';

  @override
  String get videoMetadataFrameRate => 'Images par seconde';

  @override
  String get videoMetadataNamesBytes => 'Octets';

  @override
  String get videoMetadataNamesFps => 'IPS ';

  @override
  String get videoMetadataNamesGigabytes => 'Go';

  @override
  String get videoMetadataNamesKilobytes => 'Ko';

  @override
  String get videoMetadataNamesMegabytes => 'Mo';

  @override
  String get videoMetadataResolution => 'Résolution';

  @override
  String get videoNodeChoice => 'Choix';

  @override
  String get viewCustomTheme => 'Thème personnalisé';

  @override
  String get viewDarkTheme => 'Thème sombre';

  @override
  String get viewLanguage => 'Langue';

  @override
  String get viewLightTheme => 'Thème clair';

  @override
  String get viewProperties => 'Section Propriétés';

  @override
  String get viewFrameAll => 'Cadrer tous les nœuds';

  @override
  String get viewFrameSelected => 'Cadrer les nœuds sélectionnés';

  @override
  String get viewTheme => 'Thème';

  @override
  String get viewVideoPlayer => 'Section Lecteur Vidéo';

  @override
  String get editPlayPause => 'Lecture / pause de la vidéo';

  @override
  String get tooltipPickVideo => 'Choisir une vidéo';

  @override
  String get tooltipNodeSettings => 'Réglages du nœud';

  @override
  String get tooltipImportVideos => 'Importer des médias';

  @override
  String get tooltipBack5 => 'Reculer de 5 secondes (Ctrl+←)';

  @override
  String get tooltipPlayPause => 'Lecture / pause (Espace)';

  @override
  String get tooltipForward5 => 'Avancer de 5 secondes (Ctrl+→)';

  @override
  String get tooltipChoicesFromHere =>
      'Afficher les choix à partir de ce moment';

  @override
  String get tooltipVolume => 'Volume (Ctrl+↑ / Ctrl+↓)';

  @override
  String get tooltipShowLeftPanel => 'Afficher le panneau latéral (T)';

  @override
  String get tooltipShowRightPanel => 'Afficher le lecteur vidéo (N)';

  @override
  String get tooltipResetOverride => 'Utiliser le réglage du projet';

  @override
  String tooltipNodeColor(int number) {
    return 'Couleur $number';
  }
}
