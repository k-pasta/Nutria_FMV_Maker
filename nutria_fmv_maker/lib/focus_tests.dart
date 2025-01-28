import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_textfield.dart';

class FocusTests extends StatelessWidget {
  const FocusTests({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        NutriaTextfield(),
        NutriaTextfield(),
        NutriaTextfield(),
        NutriaTextfield(),
      ],
    );
  }
}

class MyForm extends StatelessWidget {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            focusNode: focusNode1,
            // onSubmitted: (_) => focusNode1.nextFocus(), // Moves to the next focus node
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Field 1'),
          ),
          TextField(
            focusNode: focusNode2,
            // onSubmitted: (_) => focusNode2.nextFocus(),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Field 2'),
          ),
          TextField(
            focusNode: focusNode3,
            // onSubmitted: (_) => focusNode3.nextFocus(),
            decoration: InputDecoration(labelText: 'Field 3'),
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}