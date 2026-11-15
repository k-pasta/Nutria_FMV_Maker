// Contents of the About dialog: logo, version, description and links.
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_info.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:url_launcher/link.dart';

class AboutWindow extends StatelessWidget {
  const AboutWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/nutria_logo.svg',
          width: 150,
          height: 150,
          colorFilter:
              ColorFilter.mode(theme.cAccentButtonPressed, BlendMode.srcIn),
        ),
        const NutriaText(
          text: '$kAppName v$kAppVersion$kAppVersionSuffix',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: theme.dPanelPadding),
        NutriaText(
            text: t.infoProjectDescription,
            maxLines: 100,
            textAlign: TextAlign.justify),
        SizedBox(height: theme.dPanelPadding),
        Row(children: [
          Expanded(child: _LinkButton(uri: kGitHubUrl, label: t.helpGithub)),
          SizedBox(width: theme.dSectionPadding),
          Expanded(
              child: _LinkButton(
                  uri: kDocumentationUrl, label: t.helpDocumentation)),
        ]),
      ],
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({required this.uri, required this.label});

  final Uri uri;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Link(
      uri: uri,
      builder: (context, followLink) => NutriaButton(
        onTap: () => followLink?.call(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.dTextfieldPadding),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.only(right: theme.dPanelPadding),
              child: Icon(Icons.link, color: theme.cTextInactive),
            ),
            Flexible(child: NutriaText(text: label)),
          ]),
        ),
      ),
    );
  }
}
