import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/domain/repositories/auth_repository_interface.dart';

/// Caso de Uso que encapsula exclusivamente el reestablecimiento de contraseñas.
class ResetPasswordUseCase {
  final IAuthRepository Irepository;

  ResetPasswordUseCase(this.Irepository);

  /// Ejecuta la acción en el repositorio invocando los parámetros requeridos.
  Future<Result<void>> call({
    required String email,
    required String password,
  }) {
    // Retorna el resultado del restablecimiento de contraseña desde la capa de datos.
    return Irepository.resetPassword(
      email: email,
      password: password,
    );
  }
}
