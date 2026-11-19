// Entry point: initializes native plugins and preferences, then starts the app.
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nutria_fmv_maker/app/app.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Required before any media_kit Player is created.
  MediaKit.ensureInitialized();
  // Loaded up front so preferences can be read synchronously.
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const NutriaApp(),
    ),
  );
}
