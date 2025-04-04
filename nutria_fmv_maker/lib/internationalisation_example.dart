import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nutria_fmv_maker/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class InternationalisationExample extends StatelessWidget {
  const InternationalisationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale('en'),
      child: Center(
        child: Column(
          children: [
            // Display a localized string using AppLocalizations
            Text(AppLocalizations.of(context)!.helloWorld, style: TextStyle(color: Colors.white),),
            // IconButton to change the locale when pressed
            IconButton(
              onPressed: () {
                // Use the Provider package to read the LocaleProvider and change the locale to Greek
                context.read<LocaleProvider>().changeLocale(const Locale('el'));
              },
              icon: const Icon(Icons.language),
            ),
          ],
        ),
      ),
    );
  }
}
