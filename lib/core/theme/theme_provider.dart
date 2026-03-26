import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Clave para guardar la preferencia en SharedPreferences.
  static const String _themeKey = 'selected_theme';

  // Mapa que relaciona el nombre del tema con su ThemeMode.
  static const Map<String, ThemeMode> _themeModes = {
    'system': ThemeMode.system,
    'light': ThemeMode.light,
    'dark': ThemeMode.dark,
  };

  ThemeMode _currentTheme;

  ThemeProvider(this._currentTheme);

  // Carga el tema guardado al iniciar la app.
  static Future<ThemeProvider> load() async {
    // SharedPreferencesAsync es la API recomendada a partir de shared_preferences 2.3.0+.
    final prefshared = SharedPreferencesAsync();
    final savedTheme = await prefshared.getString(_themeKey) ?? 'system';
    return ThemeProvider(_themeModes[savedTheme] ?? ThemeMode.system);
  }

  // Tema activo de la app.
  ThemeMode get themeMode => _currentTheme;

  // Cambia el tema, lo guarda en disco y notifica a los listeners.
  Future<void> setTheme(String themeName) async {
    _currentTheme = _themeModes[themeName] ?? ThemeMode.system;
    final prefshared = SharedPreferencesAsync();
    await prefshared.setString(_themeKey, themeName);
    //Se notifica a los listeners que el tema ha cambiado.
    notifyListeners();
  }
}
