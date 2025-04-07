

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import '../static_data/data_static_properties.dart';
import 'nutria_button.dart';
import 'nutria_text.dart';

class AppInfoWindow extends StatelessWidget {
  const AppInfoWindow({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
        final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset(
          'assets/icons/nutria_logo.svg',
          width: 150,
          height: 150,
          colorFilter: ColorFilter.mode(
              theme.cAccentButtonPressed, BlendMode.srcIn),
        ),
        NutriaText(
          text:
              'Nutria FMV Maker v${DataStaticProperties.softwareVersion}.${DataStaticProperties.softwareSubVersion}${DataStaticProperties.softwareVersionSuffix}',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: theme.dPanelPadding,
        ),
        NutriaText(
            text:
                ' \"Nutria FMV Maker\" is an in-the-making free/open-source Flutter project aiming to make the process of creating interactive movie experiences more accessible, published under the GPLv3 license.',
            maxLines: 100,
            textAlign: TextAlign.justify),
        SizedBox(
          height: theme.dPanelPadding,
        ),
        NutriaText(
            text:
                'FFmpeg is bundled under the GPLv3 license.',
            maxLines: 100,
            textAlign: TextAlign.justify),
        SizedBox(
          height: theme.dPanelPadding,
        ),
        Row(
          children: [
            Expanded(
              child: Link(
                uri: Uri.parse(
                    DataStaticProperties.gitHubPath),
                builder: (context, followLink) =>
                    NutriaButton(
                  onTap: () => followLink!(),
                  child: Padding(
                     padding: EdgeInsets.symmetric(
                        horizontal: theme.dTextfieldPadding),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: theme
                                    .dPanelPadding),
                            child: Icon(
                              Icons.link,
                              color: theme.cTextInactive,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: NutriaText(
                              text: 'Github repository',),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: theme.dSectionPadding,
            ),
            Expanded(
              child: Link(
                uri: Uri.parse(
                    DataStaticProperties.documentationPath),
                builder: (context, followLink) =>
                    NutriaButton(
                  onTap: () => followLink!(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: theme.dTextfieldPadding),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: theme
                                    .dPanelPadding),
                            child: Icon(
                              Icons.link,
                              color: theme.cTextInactive,
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: NutriaText(
                              text: 'Documentation'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}