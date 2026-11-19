// The fonts both apps ship, and their licences.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// This package's name, for fonts and assets it holds.
const kScreensPackage = 'nutria_fmv_screens';

/// The licence file of each built-in font (all SIL Open Font License 1.1).
const _licenceFiles = {
  'inter': 'inter-OFL.txt',
  'manrope': 'manrope-OFL.txt',
  'ebGaramond': 'ebgaramond-OFL.txt',
  'comfortaa': 'comfortaa-OFL.txt',
  'jetBrainsMono': 'jetbrainsmono-OFL.txt',
};

/// [style] in built-in font [name] (a key of [kFmvBuiltInFonts]), or
/// [style] unchanged for an unknown name. The fonts are variable, so the
/// weight is also set as a variation.
TextStyle builtInFontStyle(String name, TextStyle style) {
  final family = kFmvBuiltInFonts[name];
  if (family == null) return style;
  return style.copyWith(
    fontFamily: family,
    package: kScreensPackage,
    fontVariations: [
      FontVariation('wght', style.fontWeight == FontWeight.bold ? 700 : 400),
    ],
  );
}

/// Adds the built-in fonts' licences to the app's licence page. Call once
/// at startup.
void registerScreenFontLicences() {
  LicenseRegistry.addLicense(() async* {
    for (final MapEntry(key: name, value: file) in _licenceFiles.entries) {
      final text = await rootBundle.loadString(
        'packages/$kScreensPackage/fonts/$file',
      );
      yield LicenseEntryWithLineBreaks([kFmvBuiltInFonts[name]!], text);
    }
  });
}
