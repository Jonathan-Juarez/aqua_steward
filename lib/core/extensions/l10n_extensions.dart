import 'package:flutter/widgets.dart';
import 'package:aqua_steward/l10n/app_localizations.dart';

// Extension para acceder a las traducciones de la app. Es útil para no tener que escribir AppLocalizations.of(context) cada vez que se necesita una traducción.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
