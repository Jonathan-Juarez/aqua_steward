import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/domain/repositories/auth_repository_interface.dart';

// Caso de Uso que encapsula la lógica de registro de nuevos usuarios.
class SignupUseCase {
  final IAuthRepository repository;

  SignupUseCase(this.repository);

  // Ejecuta la petición de registro delegando los datos del usuario al repositorio.
  Future<Result<void>> call({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) {
    // Retorna el resultado de la operación de registro procesado por la capa de datos.
    return repository.signupUser(
      name: name,
      lastName: lastName,
      email: email,
      password: password,
    );
  }
}
