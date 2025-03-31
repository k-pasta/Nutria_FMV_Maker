import 'package:flutter_svg/svg.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nutria_fmv_maker/fvp_example.dart';
import 'package:nutria_fmv_maker/providers/project_version_provider.dart';

import 'providers/keyboard_provider.dart';
import 'custom_widgets/nutria_menu_bar.dart';
import 'custom_widgets/nutria_split_view.dart';
import 'custom_widgets/video_collection.dart';
import 'providers/app_settings_provider.dart';
import 'providers/video_player_provider.dart';

import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/nodes_provider.dart';
import 'video_section.dart';
import 'providers/ui_state_provider.dart';
import 'models/app_theme.dart';
import 'providers/grid_canvas_provider.dart';
import 'grid_canvas.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ChangeNotifierProvider(create: (context) => GridCanvasProvider()),
      ChangeNotifierProvider(create: (context) => NodesProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => UiStateProvider()),
      ChangeNotifierProvider(create: (context) => AppSettingsProvider()),
      ChangeNotifierProvider(create: (context) => VideoPlayerProvider()),
      ChangeNotifierProvider(create: (context) => KeyboardProvider()),
      ChangeNotifierProvider(create: (context) => ProjectVersionProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Flutter Demo',
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
            menuButtonTheme: MenuButtonThemeData(
              style: ButtonStyle(
                  // splashFactory: null,
                  // backgroundColor: WidgetStatePropertyAll(Colors.red),
                  // overlayColor: WidgetStatePropertyAll(Colors.red)
                  ),
            ),
            menuTheme: MenuThemeData(
              style: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(theme.cPanel),
                  shape: WidgetStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 0, vertical: 16))),
            ),
            fontFamily: 'SourceSans',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                  fontWeight: FontWeight.w600), // Default weight for bodyLarge
              bodyMedium: TextStyle(
                  fontWeight: FontWeight.w600), // Default weight for bodyMedium
              bodySmall: TextStyle(
                  fontWeight: FontWeight.w600), // Default weight for bodySmall
              headlineLarge: TextStyle(
                  fontWeight:
                      FontWeight.w800), // Default weight for headlineLarge
            ),
          ),
          home: MyHomePage(apptitle: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.apptitle});
  final String apptitle;

  @override
  Widget build(BuildContext context) {
    // AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Scaffold(
      backgroundColor: theme.cBackground,
// backgroundColor: Colors.white,

// body: VideoMetadataWidget(videoFilePath: "C:\\Users\\cgbook\\Desktop\\Eykolo_anoigma_roughcut_4.mp4",),
      body: const WindowsAppLayout(),
    );
  }
}

class WindowsAppLayout extends StatelessWidget {
  const WindowsAppLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Column(
      children: [
        const NutriaMenuBar(),
        Expanded(
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: Focus(
              autofocus: true,
              onFocusChange: (gotFocus) {
                if (gotFocus) {
                  print('got focus');
                } else {
                  print('lost focus');
                }
              },
              parentNode: context.read<UiStateProvider>().parentfocusNode,
              child: Stack(
                children: [
                  const GridCanvas(),
                  NutriaSplitView(
                    rightChild: VideoSection(),
                    leftChild: VideoCollection(),
                  ),
                  Positioned.fill(
                    //UI fader
                    child: Selector<UiStateProvider, bool>(
                      selector: (context, uiStateProvider) =>
                          uiStateProvider.isModalOrMenuOpen,
                      builder: (context, isModalOrMenuOpen, child) {
                        if (isModalOrMenuOpen) {
                          return Container(
                            color: Colors.black45, //TODO de-hardcode
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: -theme.dMenuBarHeight + theme.dLogoPadding,
                    left: theme.dLogoPadding,
                    child: SvgPicture.asset(
                      'assets/icons/nutria_logo_top.svg',
                      width: 100,
                      height: (theme.dMenuBarHeight - theme.dLogoPadding) * 2,
                      colorFilter: ColorFilter.mode(theme.cAccentButton,
                          BlendMode.srcIn), // Optional color change
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
