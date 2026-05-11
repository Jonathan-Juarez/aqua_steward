import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

// Caso de Uso que encapsula la lógica de eliminación de un miembro del equipo.
class DeleteMemberUseCase {
  final ITeamRepository repository;

  DeleteMemberUseCase(this.repository);

  // Ejecuta la eliminación delegando al repositorio el ID del depósito y del usuario.
  Future<Result<void>> call({
    required String depositId,
    required String userId,
    required String token,
  }) {
    return repository.deleteMember(
      depositId: depositId,
      userId: userId,
      token: token,
    );
  }
}
