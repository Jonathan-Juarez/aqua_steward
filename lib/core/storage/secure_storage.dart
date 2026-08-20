import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Administra el almacenamiento cifrado de la sesión del usuario mediante Android Keystore / iOS Keychain.
class SecureStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'auth_user_data';

  // Configura el backend nativo de cifrado para Android e iOS.
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Guarda el token de autenticación de forma cifrada.
  static Future<bool> saveToken(String token) => _write(_tokenKey, token);

  /// Obtiene el token de autenticación almacenado, o null si no existe o no se pudo leer.
  static Future<String?> getToken() => _read(_tokenKey);

  /// Guarda los datos del usuario serializados en formato JSON.
  static Future<bool> saveUserData(String jsonUserData) =>
      _write(_userDataKey, jsonUserData);

  /// Obtiene los datos del usuario almacenados, o null si no existen o no se pudieron leer.
  static Future<String?> getUserData() => _read(_userDataKey);

  /// Elimina toda la información de sesión almacenada.
  static Future<void> clearSession() async {
    try {
      await _storage.deleteAll();
    } catch (error) {
      debugPrint('[SecureStorage] Error al limpiar la sesión: $error');
    }
  }

  /// Escribe un valor cifrado; nunca lanza excepciones hacia el llamador.
  static Future<bool> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return true;
    } catch (error) {
      debugPrint('Error al escribir "$key": $error');
      return false;
    }
  }

  /// Lee un valor cifrado; devuelve null ante cualquier fallo en lugar de lanzar.
  static Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      debugPrint('Error al leer "$key": $error');
      return null;
    }
  }
}
