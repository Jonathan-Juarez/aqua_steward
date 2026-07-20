import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user_data';

  /// Guarda el token de autenticación de forma cifrada.
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Lee el token cifrado almacenado.
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Guarda los datos del usuario formateados en JSON.
  static Future<void> saveUserData(String jsonUserData) async {
    await _storage.write(key: _userKey, value: jsonUserData);
  }

  /// Lee los datos del usuario almacenados.
  static Future<String?> getUserData() async {
    return await _storage.read(key: _userKey);
  }

  /// Elimina los datos de sesión seguros al cerrar sesión.
  static Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
