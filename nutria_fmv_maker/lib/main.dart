// Entry point: initializes native plugins and preferences, then starts the app.
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nutria_fmv_maker/app/app.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/services/window_service.dart';
import 'package:nutria_fmv_screens/nutria_fmv_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Required before any media_kit Player is created.
  MediaKit.ensureInitialized();
  // On Windows the app draws its own title bar, in the menu bar.
  await NativeWindowControls.instance.init();
  // The licences of the fonts screens can use, for Help > About.
  registerScreenFontLicences();
  // Loaded up front so preferences can be read synchronously.
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const NutriaApp(),
    ),
  );
}
