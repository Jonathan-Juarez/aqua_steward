import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/entities/team.dart';

abstract class ITeamRepository {
  // Contrato para agregar un miembro.
  Future<Result<bool>> inviteMember({
    required String depositId,
    required String email,
    required String role,
    required String token,
  });

  // Contrato para obtener el equipo.
  Future<Result<List<Team>>> getTeam({
    required String depositId,
    required String token,
  });

  // Contrato para eliminar un miembro.
  Future<Result<void>> deleteMember({
    required String depositId,
    required String userId,
    required String token,
  });

  // Contrato para actualizar el rol de un miembro.
  Future<Result<void>> updateMember({
    required String depositId,
    required String userId,
    required String role,
    required String token,
  });

  // Contrato para obtener las invitaciones pendientes del usuario.
  Future<Result<List<Map<String, dynamic>>>> getInvitations({
    required String token,
  });

  // Contrato para aceptar una invitación a un depósito.
  Future<Result<void>> acceptInvitation({
    required String depositId,
    required String token,
  });

  // Contrato para rechazar una invitación a un depósito.
  Future<Result<void>> rejectInvitation({
    required String depositId,
    required String token,
  });
}
