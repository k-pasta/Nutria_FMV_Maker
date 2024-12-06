import 'package:nutria_fmv_maker/providers/nodes_provider.dart';

import './providers/grid_canvas_provider.dart';

import './grid_canvas.dart';
import './providers/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
      ChangeNotifierProvider(create: (context) => GridCanvasProvider()),
      ChangeNotifierProvider(create: (context) => NodesProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(apptitle: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.apptitle});
  final String apptitle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(apptitle),
        ),
        body: GridCanvas()

        // Container(
        //   color: Colors.red,
        //   child: Stack(
        //     clipBehavior: Clip.none,
        //     children: [
        //       HomeScreenBody(),
        //       // Positioned(
        //       //   bottom: 0,
        //       //   child: Slider(
        //       //     value: context.watch<HomeScreenProvider>().zoomlevel,
        //       //     onChanged: ((value) {
        //       //       print(value);
        //       //       context.read<HomeScreenProvider>().setZoomLevel(value);
        //       //     }),
        //       //   ),
        //       // )
        //       Listener(
        //         onPointerSignal: (pointerSignal) {
        //           if (pointerSignal is PointerScrollEvent) {
        //             // do something when scrolled
        //             // print(pointerSignal.scrollDelta.dx);
        //             // if (pointerSignal.scrollDelta.dy>0){
        //             //   print('down');
        //                                 context.read<HomeScreenProvider>().doZoomIn(pointerSignal.scrollDelta.dy);
        //                                 context.read<HomeScreenProvider>().setMousePosition(pointerSignal.localPosition);
        //             // }
        //             // if (pointerSignal.scrollDelta.dy<0){
        //             //   print('up');
        //             // }

        //           }
        //           // print('gotevent');
        //         },
        //         child: Container(
        //           color: Colors.black12,

        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        );
  }
}
