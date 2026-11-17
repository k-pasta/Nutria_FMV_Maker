// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get boardImportedVideos => 'Vidéos Importées';

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
  String get boardPreferences => 'Préférences';

  @override
  String get boardProjectSettings => 'Paramètres du Projet';

  @override
  String get variablesEmpty =>
      'Aucune variable pour l’instant. Ajoutez-en une avec +.';

  @override
  String get variableDefaultName => 'variable';

  @override
  String get variableName => 'Nom';

  @override
  String get variableNameError => 'Chaque variable a besoin de son propre nom';

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
  String get editPreferences => 'Préférences';

  @override
  String get editProjectSettings => 'Paramètres du Projet';

  @override
  String get editRedo => 'Rétablir';

  @override
  String get editCopy => 'Copier';

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
  String get fileRecentProjects => 'Projets Récents';

  @override
  String get fileSaveProject => 'Enregistrer le Projet';

  @override
  String get fileSaveProjectAs => 'Enregistrer le Projet sous...';

  @override
  String get filename => 'Nom du Fichier';

  @override
  String get helloWorld => 'Salut Monde!';

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
  String get overrideUnknown => 'Forçage Inconnu';

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
  String get overrideVideoFit_FitHeight => 'Ajuster à la Hauteur';

  @override
  String get overrideVideoFit_FitWidth => 'Ajuster à la Largeur';

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
  String get videoMetadataAspectRatio => 'Rapport de Forme';

  @override
  String get videoMetadataAudioBitDepth => 'Bit Depth Audio';

  @override
  String get videoMetadataAudioChannels => 'Canaux audio';

  @override
  String get videoMetadataAudioCodecFormat => 'Format du codec audio';

  @override
  String get videoMetadataAudioSampleRate => 'Taux d\'Έchantillonnage Αudio';

  @override
  String get videoMetadataBitrate => 'Bitrate';

  @override
  String get videoMetadataCodecFormat => 'Format du codec';

  @override
  String get videoMetadataColorProfile => 'Profil de couleur';

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
  String get videoMetadataTimecode => 'Timecode';

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
  String get tooltipImportVideos => 'Importer des vidéos';

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

  @override
  String get z => 'z';
}
