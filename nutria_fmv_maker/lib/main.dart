import 'package:media_kit/media_kit.dart';
import 'package:menu_bar/menu_bar.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:nutria_fmv_maker/context_menu_example.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_menu_bar.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_split_view.dart';
import 'package:nutria_fmv_maker/providers/app_settings_provider.dart';
import 'package:nutria_fmv_maker/stack_update_test.dart';

import './custom_widgets/nutria_textfield.dart';
import './internationalisation_example.dart';
import './models/node_data.dart';
import './providers/locale_provider.dart';
import './providers/theme_provider.dart';
import './providers/nodes_provider.dart';
import 'media_kit_example.dart';
import 'multi_split_view_example.dart';
import 'providers/ui_state_provider.dart';
import 'thumbnail_example.dart';
import 'custom_widgets/nutria_button.dart';
import 'custom_widgets/video_node.dart';
import 'models/app_theme.dart';
import './providers/grid_canvas_provider.dart';
import './grid_canvas.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
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

      // body: const MenuExample(),
      // body: const Stack(children: [ SizedBox(height: 2000, width: 2000,),
      //   TestNode(
      //       nodeData: VideoNodeData(
      //           id: 'x', position: Offset(0, 0), videoDataId: 'a'))
      // ]),

      // body: StackUpdateTest(),
      // body: const MyScreen(),
      body:  RightClickMenuExample(),
      
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
                  const NutriaSplitView(
                    rightChild: MyScreen(),
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
