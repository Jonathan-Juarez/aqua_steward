import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

// Caso de Uso que encapsula la lógica de invitación de un miembro al equipo.
class InviteMemberUseCase {
  final ITeamRepository repository;

  InviteMemberUseCase(this.repository);

  // Ejecuta la invitación delegando al repositorio el email y rol del nuevo miembro.
  Future<Result<bool>> call({
    required String depositId,
    required String email,
    required String role,
    required String token,
  }) {
    return repository.inviteMember(
      depositId: depositId,
      email: email,
      role: role,
      token: token,
    );
  }
}
