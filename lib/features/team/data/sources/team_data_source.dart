import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/api_client.dart';
import 'package:aqua_steward/features/team/data/models/team_model.dart';

abstract class ITeamDataSource {
  // Contrato para obtener los miembros del equipo de un depósito.
  Future<Result<List<TeamModel>>> getTeam({
    required String depositId,
    required String token,
  });

  // Contrato para invitar a un miembro al equipo.
  Future<Result<void>> invite({
    required String depositId,
    required String email,
    required String role,
    required String token,
  });

  // Contrato para eliminar un miembro del equipo.
  Future<Result<void>> delete({
    required String depositId,
    required String userId,
    required String token,
  });

  // Contrato para actualizar el rol de un miembro del equipo.
  Future<Result<void>> update({
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

  // Contrato para abandonar un depósito.
  Future<Result<void>> leaveDeposit({
    required String depositId,
    required String token,
  });
}

class TeamDataSourceImpl implements ITeamDataSource {
  @override
  // Obtiene los miembros del equipo mediante GET /:depositId.
  Future<Result<List<TeamModel>>> getTeam({
    required String depositId,
    required String token,
  }) => ApiClient.get(
    '/api/team/$depositId',
    token: token,
    fromJson: (data) =>
        (data as List).map((m) => TeamModel.fromMap(m)).toList(),
  );

  @override
  // Invita a un miembro al equipo mediante POST /:depositId/invite.
  Future<Result<void>> invite({
    required String depositId,
    required String email,
    required String role,
    required String token,
  }) => ApiClient.post(
    '/api/team/$depositId/invite',
    token: token,
    body: {'email': email, 'role': role},
  );

  @override
  // Elimina un miembro del equipo mediante DELETE /:depositId/members/:userId.
  Future<Result<void>> delete({
    required String depositId,
    required String userId,
    required String token,
  }) => ApiClient.delete('/api/team/$depositId/members/$userId', token: token);

  @override
  // Actualiza el rol de un miembro mediante PUT /:depositId/members/:userId.
  Future<Result<void>> update({
    required String depositId,
    required String userId,
    required String role,
    required String token,
  }) => ApiClient.put(
    '/api/team/$depositId/members/$userId',
    token: token,
    body: {'role': role},
  );

  @override
  // Obtiene las invitaciones pendientes del usuario autenticado.
  Future<Result<List<Map<String, dynamic>>>> getInvitations({
    required String token,
  }) => ApiClient.get(
    '/api/team/invitations',
    token: token,
    fromJson: (data) =>
        (data as List).map((e) => Map<String, dynamic>.from(e)).toList(),
  );

  @override
  // Acepta una invitación pendiente mediante PUT /:depositId/accept.
  Future<Result<void>> acceptInvitation({
    required String depositId,
    required String token,
  }) => ApiClient.put('/api/team/$depositId/accept', token: token);

  @override
  // Rechaza una invitación pendiente mediante DELETE /:depositId/reject.
  Future<Result<void>> rejectInvitation({
    required String depositId,
    required String token,
  }) => ApiClient.delete('/api/team/$depositId/reject', token: token);

  @override
  // Abandona un depósito mediante DELETE /:depositId/leave.
  Future<Result<void>> leaveDeposit({
    required String depositId,
    required String token,
  }) => ApiClient.delete('/api/team/$depositId/leave', token: token);
}
