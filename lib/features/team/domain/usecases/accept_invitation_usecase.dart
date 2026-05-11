import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

// Caso de Uso para aceptar una invitación a un depósito.
class AcceptInvitationUseCase {
  final ITeamRepository repository;

  AcceptInvitationUseCase(this.repository);

  // Ejecuta la aceptación de la invitación al depósito indicado.
  Future<Result<void>> call({
    required String depositId,
    required String token,
  }) {
    return repository.acceptInvitation(
      depositId: depositId,
      token: token,
    );
  }
}
