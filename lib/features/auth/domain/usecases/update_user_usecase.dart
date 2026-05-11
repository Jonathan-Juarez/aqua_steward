import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/auth/domain/repositories/auth_repository_interface.dart';

// Caso de Uso que encapsula la lógica de actualización del perfil de usuario.
class UpdateUserUseCase {
  final IAuthRepository repository;

  UpdateUserUseCase(this.repository);

  // Ejecuta la actualización delegando al repositorio el ID y datos de perfil del usuario.
  Future<Result<void>> call({
    required String id,
    String? name,
    String? lastName,
  }) {
    // Retorna el resultado de la actualización de perfil procesado por la capa de datos.
    return repository.updateUser(id: id, name: name, lastName: lastName);
  }
}
