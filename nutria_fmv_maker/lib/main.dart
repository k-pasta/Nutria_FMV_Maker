import 'package:nutria_fmv_maker/custom_nodes_example.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_textfield.dart';
import 'package:nutria_fmv_maker/internationalisation_example.dart';
import 'package:nutria_fmv_maker/menu_bar.dart';
import 'package:nutria_fmv_maker/models/node_data.dart';
import 'package:nutria_fmv_maker/providers/locale_provider.dart';
import 'package:nutria_fmv_maker/providers/theme_provider.dart';
import 'package:nutria_fmv_maker/providers/nodes_provider.dart';
import 'package:nutria_fmv_maker/thumbnail_example.dart';
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
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ChangeNotifierProvider(create: (context) => GridCanvasProvider()),
      ChangeNotifierProvider(create: (context) => NodesProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          title: 'Flutter Demo',
          theme: ThemeData(
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
    AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Scaffold(
        backgroundColor: theme.cBackground,
// backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(apptitle),
        ),
        // body: GridCanvas(),
        // body: const InternationalisationExample(),
        // body: MyMenuBar()
        // body: CustomNodesExample()
        // body: SizedBox(
        //     width: 1000,
        //     height: 1000,
        //     // color: Colors.red,
        //     child: Stack(clipBehavior: Clip.none, children: [
        //       Positioned.fill(
        //           child: Container(
        //         color: Colors.red,
        //       )),
        //       VideoNode(
        //           nodeData: VideoNodeData(
        //               position: Offset(0, 0),
        //               id: 'aaa',
        //               videoDataId: 'videoDataPath videoDataPath videoDataPath')),
        //       SizedBox(
        //         width: 50,
        //         height: 50,
        //       ),
        //     ]))
        body: GridCanvas(),
        // body: ThumbnailExample()
        );
  }
}
