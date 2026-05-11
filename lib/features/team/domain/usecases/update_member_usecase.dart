import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

// Caso de Uso que encapsula la lógica de actualización del rol de un miembro.
class UpdateMemberUseCase {
  final ITeamRepository repository;

  UpdateMemberUseCase(this.repository);

  // Ejecuta la actualización delegando al repositorio el ID del depósito, usuario y nuevo rol.
  Future<Result<void>> call({
    required String depositId,
    required String userId,
    required String role,
    required String token,
  }) {
    return repository.updateMember(
      depositId: depositId,
      userId: userId,
      role: role,
      token: token,
    );
  }
}
