import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/api_client.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';

abstract class IAuthDataSource {
  // Contrato para la petición de registro de usuario.
  Future<Result<void>> signup({
    required String name,
    required String lastName,
    required String email,
    required String password,
  });

  // Contrato para la petición de inicio de sesión. Retorna el UserModel construido o error.
  Future<Result<UserModel>> signin({
    required String email,
    required String password,
  });

  // Contrato para la petición de restablecimiento de contraseña.
  Future<Result<void>> resetPassword({
    required String email,
    required String password,
  });

  // Contrato para la petición de actualización de perfil.
  Future<Result<void>> update({
    required String id,
    String? name,
    String? lastName,
    required String token,
  });

  Future<Result<void>> delete({required String email, required String token});
}

class AuthDataSource implements IAuthDataSource {
  @override
  // Realiza el registro del usuario y retorna el resultado de la petición de red.
  Future<Result<void>> signup({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) => ApiClient.post(
    '/api/auth/signup',
    body: UserModel(
      name: name,
      last_name: lastName,
      email: email,
      password: password,
    ).toMap(),
  );

  @override
  // Ejecuta la petición de inicio de sesión y retorna el UserModel mapeado o el error.
  Future<Result<UserModel>> signin({
    required String email,
    required String password,
  }) => ApiClient.post(
    '/api/auth/signin',
    body: UserModel(email: email, password: password).toMap(),
    fromJson: (data) {
      final map = data as Map<String, dynamic>;
      if (map.containsKey('user')) {
        final userMap = Map<String, dynamic>.from(map['user']);
        userMap['token'] = map['token'];
        return UserModel.fromMap(userMap);
      }
      return UserModel.fromMap(map);
    },
  );

  @override
  // Invocación a la petición de red para el restablecimiento de contraseña.
  Future<Result<void>> resetPassword({
    required String email,
    required String password,
  }) => ApiClient.put(
    '/api/auth/restore-password',
    body: UserModel(email: email, password: password).toMap(),
  );

  @override
  // Actualiza los datos de perfil del usuario a través de una petición HTTP PUT.
  Future<Result<void>> update({
    required String id,
    String? name,
    String? lastName,
    required String token,
  }) => ApiClient.put(
    '/api/auth/update-user',
    token: token,
    body: {
      'id': id,
      'data': UserModel(name: name, last_name: lastName).toMap(),
    },
  );

  @override
  Future<Result<void>> delete({required String email, required String token}) =>
      ApiClient.delete(
        '/api/auth/delete-user',
        token: token,
        body: {'email': email},
      );
}
