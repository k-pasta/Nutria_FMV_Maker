import 'package:flutter/material.dart';

import '../../static_data/ui_static_properties.dart';

class NodeBackground extends StatelessWidget {
  const NodeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return 
              IgnorePointer(
                child: SizedBox(
                  height:
                      1000, //TODO De-Hardcode when it is possible to calculate max height
                  width: UiStaticProperties.nodeMaxWidth +
                      UiStaticProperties.nodePadding * 2,
                  child: Container(color: Colors.transparent),
                ),
              );
  }
}