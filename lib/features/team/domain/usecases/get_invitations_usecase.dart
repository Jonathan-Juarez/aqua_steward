import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

// Caso de Uso para obtener las invitaciones pendientes del usuario autenticado.
class GetInvitationsUseCase {
  final ITeamRepository repository;

  GetInvitationsUseCase(this.repository);

  // Ejecuta la consulta de invitaciones pendientes.
  Future<Result<List<Map<String, dynamic>>>> call({required String token}) {
    return repository.getInvitations(token: token);
  }
}
