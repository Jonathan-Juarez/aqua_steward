import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

// Caso de Uso para rechazar una invitación a un depósito.
class RejectInvitationUseCase {
  final ITeamRepository repository;

  RejectInvitationUseCase(this.repository);

  // Ejecuta el rechazo de la invitación al depósito indicado.
  Future<Result<void>> call({
    required String depositId,
    required String token,
  }) {
    return repository.rejectInvitation(
      depositId: depositId,
      token: token,
    );
  }
}
