import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  // Mapa de idiomas soportados (El inglés no está completo).
  static const Map<String, Locale> _locales = {
    'es': Locale('es', ''),
    'en': Locale('en', ''),
  };

  Locale _currentLocale;

  LanguageProvider(this._currentLocale);

  // Carga el idioma guardado al iniciar la app.
  static Future<LanguageProvider> load() async {
    final prefshared = SharedPreferencesAsync();
    final savedLanguage = await prefshared.getString(_languageKey) ?? 'es';
    return LanguageProvider(_locales[savedLanguage] ?? const Locale('es', ''));
  }

  // Idioma activo de la app.
  Locale get locale => _currentLocale;

  // Cambia el idioma, lo guarda en disco y notifica a los listeners.
  Future<void> setLanguage(String languageCode) async {
    if (!_locales.containsKey(languageCode)) return;
    // Se actualiza el idioma actual.
    _currentLocale = _locales[languageCode]!;
    // Se guarda el idioma actual.
    final prefshared = SharedPreferencesAsync();
    await prefshared.setString(_languageKey, languageCode);

    notifyListeners();
  }
}
