import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/entities/team.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

// Caso de Uso que encapsula la obtención de los miembros del equipo de un depósito.
class GetMembersUseCase {
  final ITeamRepository repository;

  GetMembersUseCase(this.repository);

  // Ejecuta la obtención delegando al repositorio el ID del depósito.
  Future<Result<List<Team>>> call({
    required String depositId,
    required String token,
  }) {
    return repository.getTeam(depositId: depositId, token: token);
  }
}
