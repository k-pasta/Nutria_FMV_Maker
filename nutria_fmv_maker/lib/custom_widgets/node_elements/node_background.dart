import 'package:flutter/material.dart';

import '../../static_data/ui_static_properties.dart';

///The base of the Stack that creates the node. We use this to accept clicks outside the box that the node occupies.
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