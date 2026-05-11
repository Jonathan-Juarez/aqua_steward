import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';
import 'package:aqua_steward/features/auth/data/sources/auth_data_source.dart';
import 'package:aqua_steward/features/auth/domain/repositories/auth_repository_interface.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  // Delega el registro del usuario al DataSource retornando el resultado de la operación.
  Future<Result<void>> signupUser({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) {
    return dataSource.signup(
      name: name,
      lastName: lastName,
      email: email,
      password: password,
    );
  }

  @override
  // Delega el inicio de sesión al DataSource y propaga el UserModel envuelto en Result.
  Future<Result<UserModel>> signinUser({
    required String email,
    required String password,
  }) {
    return dataSource.signin(email: email, password: password);
  }

  @override
  // Delega el restablecimiento de contraseña a la fuente de datos externa de la red.
  Future<Result<void>> resetPassword({
    required String email,
    required String password,
  }) {
    return dataSource.resetPassword(email: email, password: password);
  }

  @override
  // Delega la actualización del perfil del usuario al DataSource.
  Future<Result<void>> updateUser({
    required String id,
    String? name,
    String? lastName,
  }) {
    return dataSource.update(id: id, name: name, lastName: lastName);
  }
}
