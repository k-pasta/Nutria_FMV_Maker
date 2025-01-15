import 'package:flutter/material.dart';

import 'custom_widgets/nutria_button.dart';
import 'custom_widgets/nutria_textfield.dart';

class CustomNodesExample extends StatelessWidget {
  const CustomNodesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          
          children: [
        
          Row(
            children: [
              Expanded(
                  child: NutriaButton.leftRight(
                child: Text('text'),
                onTapLeft: () {
                  print('Left');
                },
                onTapRight: () {
                  print('Right');
                },
              )),
              Expanded(
                  child: NutriaButton(
                child: Text('text'),
                onTap: () {},
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(width:MediaQuery.of(context).size.width, child:NutriaTextfield()),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(width:MediaQuery.of(context).size.width, child:NutriaTextfield()),
          )
        ]),
      );
  }
}