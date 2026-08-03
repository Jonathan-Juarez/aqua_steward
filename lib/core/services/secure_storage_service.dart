import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Servicio de almacenamiento de sesión con cifrado AES_GCM (Android Keystore / iOS Keychain).
// Si el almacenamiento seguro falla o no encuentra el dato, consulta automáticamente SharedPreferences.
class SecureStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user_data';

  // Backend cifrado con respaldo por hardware.
  static const FlutterSecureStorage _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Fallback sin cifrado para dispositivos con Keystore defectuoso.
  static final SharedPreferencesAsync _fallback = SharedPreferencesAsync();

  // Bandera en memoria para evitar reintentos fallidos durante la misma ejecución.
  static bool _keystoreFailed = false;

  // Escribe un valor en el almacenamiento seguro. Si falla, usa fallback.
  static Future<void> _write(String key, String value) async {
    if (!_keystoreFailed) {
      try {
        await _secure.write(key: key, value: value);
        // Éxito en Keystore: elimina cualquier dato previo que pudiera quedar en fallback.
        await _fallback.remove(key);
        return;
      } catch (e) {
        _onKeystoreError(e);
      }
    }
    await _fallback.setString(key, value);
  }

  // Lee un valor del almacenamiento seguro. Si es null o falla, consulta fallback.
  static Future<String?> _read(String key) async {
    if (!_keystoreFailed) {
      try {
        final secureValue = await _secure.read(key: key);
        if (secureValue != null) {
          return secureValue;
        }
      } catch (e) {
        _onKeystoreError(e);
      }
    }
    // Si el valor no estaba en Keystore o Keystore falló, consulta en SharedPreferences.
    return await _fallback.getString(key);
  }

  // Guarda el token de autenticación.
  static Future<void> saveToken(String token) async => _write(_tokenKey, token);

  // Lee el token almacenado.
  static Future<String?> getToken() async => _read(_tokenKey);

  // Guarda los datos del usuario formateados en JSON.
  static Future<void> saveUserData(String jsonUserData) async =>
      _write(_userKey, jsonUserData);

  // Lee los datos del usuario almacenados.
  static Future<String?> getUserData() async => _read(_userKey);

  // Elimina los datos de sesión al cerrar sesión.
  static Future<void> clearSession() async {
    try {
      await _secure.delete(key: _tokenKey);
      await _secure.delete(key: _userKey);
    } catch (_) {}
    await _fallback.remove(_tokenKey);
    await _fallback.remove(_userKey);
  }

  // Marca el Keystore como no disponible y registra el error.
  static void _onKeystoreError(Object error) {
    _keystoreFailed = true;
    debugPrint(
      '[SecureStorageService] Keystore no disponible, '
      'usando SharedPreferences como fallback. Error: $error',
    );
  }
}
