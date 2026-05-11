import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/data/sources/team_data_source.dart';
import 'package:aqua_steward/features/team/domain/entities/team.dart';
import 'package:aqua_steward/features/team/domain/repositories/team_repository_interface.dart';

class TeamRepositoryImpl implements ITeamRepository {
  final ITeamDataSource dataSource;

  TeamRepositoryImpl(this.dataSource);

  @override
  // Delega la obtención del equipo al DataSource.
  Future<Result<List<Team>>> getTeam({
    required String depositId,
    required String token,
  }) {
    return dataSource.getTeam(depositId: depositId, token: token);
  }

  @override
  // Delega la invitación de un miembro al DataSource.
  Future<Result<bool>> inviteMember({
    required String depositId,
    required String email,
    required String role,
    required String token,
  }) async {
    final result = await dataSource.invite(
      depositId: depositId,
      email: email,
      role: role,
      token: token,
    );
    if (result.isSuccess) return Result.success(true);
    return Result.failure(result.error);
  }

  @override
  // Delega la eliminación de un miembro al DataSource.
  Future<Result<void>> deleteMember({
    required String depositId,
    required String userId,
    required String token,
  }) {
    return dataSource.delete(
      depositId: depositId,
      userId: userId,
      token: token,
    );
  }

  @override
  // Delega la actualización del rol de un miembro al DataSource.
  Future<Result<void>> updateMember({
    required String depositId,
    required String userId,
    required String role,
    required String token,
  }) {
    return dataSource.update(
      depositId: depositId,
      userId: userId,
      role: role,
      token: token,
    );
  }

  @override
  // Delega la obtención de invitaciones pendientes al DataSource.
  Future<Result<List<Map<String, dynamic>>>> getInvitations({
    required String token,
  }) {
    return dataSource.getInvitations(token: token);
  }

  @override
  // Delega la aceptación de una invitación al DataSource.
  Future<Result<void>> acceptInvitation({
    required String depositId,
    required String token,
  }) {
    return dataSource.acceptInvitation(depositId: depositId, token: token);
  }

  @override
  // Delega el rechazo de una invitación al DataSource.
  Future<Result<void>> rejectInvitation({
    required String depositId,
    required String token,
  }) {
    return dataSource.rejectInvitation(depositId: depositId, token: token);
  }
}
