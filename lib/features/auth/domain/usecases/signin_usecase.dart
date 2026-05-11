import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';
import 'package:aqua_steward/features/auth/domain/repositories/auth_repository_interface.dart';

// Caso de Uso que encapsula la lógica de inicio de sesión. Retorna datos o error a través de Result.
class SigninUseCase {
  final IAuthRepository repository;

  SigninUseCase(this.repository);

  // Ejecuta la autenticación delegando al repositorio el inicio de sesión del usuario.
  Future<Result<UserModel>> call({
    required String email,
    required String password,
  }) {
    // Retorna directamente el objeto Result obtenido desde la capa de datos.
    return repository.signinUser(email: email, password: password);
  }
}
