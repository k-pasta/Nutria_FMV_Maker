import 'package:first_actual_tests/main.dart';
import 'package:flutter/material.dart';
import 'package:first_actual_tests/providers/home_screen_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      origin: context.watch<HomeScreenProvider>().signalingMousePosition,
      scale: context.watch<HomeScreenProvider>().zoomlevel,
// alignment: Alignment(0, 0),

      child: GestureDetector(
        // onHover: (PointerHoverEvent) {PointerHoverEvent.delta.},
        // onEnter: (_){print('entered');},
        // onExit: (_){print('exited');},
        child: SizedBox(
          width: 100,
          height: 100,
          child: Container(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
