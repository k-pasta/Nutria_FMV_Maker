/// script for all enums concerning the UI state

import '../custom_widgets/imported_videos_board.dart';
import '../custom_widgets/left_section.dart';
import '../custom_widgets/nutria_split_view.dart';
import '../providers/theme_provider.dart';
import '../custom_widgets/video_collection_elements/video_collection_entry.dart';
import '../custom_widgets/nutria_button.dart';
import 'app_theme.dart';
import '../custom_widgets/nutria_text.dart';

/// Used to update UI colors of [NutriaButton] on desktop
enum ButtonStateType { hovered, pressed, normal }

/// Used for a [NutriaButton] that can be iterated upwards or downwards
/// "none" is used to reset the state to unhovered
enum ButtonHoverSide { left, right, none }

/// Used in the [NutriaText] widget
/// Each state has a corresponding color in app_theme.dart [AppTheme]
enum NutriaTextState { normal, accented, inactive }

/// Used in the [NutriaText] widget
/// Each state has a corresponding color in app_theme.dart [AppTheme]
enum NutriaTextStyle { normal, bold, italic, boldItalic }

///Used in [VideoCollectionEntry], to show the selection status of an imported video file icon in the [ImportedVideosBoard] widget
enum VideoFileState { none, hovered, selected, active }

/// Used by [ThemeProvider] for picking themes
enum ThemeType { dark, light, custom }

/// Used by [NutriaSplitView] to distinguish between different sides on desktop
enum AreaSide { left, right }

/// Used by [LeftSection] for distinguishing between the various menus in the left panel on desktop
enum LeftPanelSection {
  videos,
  variables,
  projectSettings,
  preferences,
}
