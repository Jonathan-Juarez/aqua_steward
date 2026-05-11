import 'dart:convert';
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:aqua_steward/core/error/exception_handler.dart';
import 'package:aqua_steward/features/team/data/models/team_model.dart';
import 'package:http/http.dart' as http;

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
}

class TeamDataSourceImpl implements ITeamDataSource {
  @override
  // Obtiene los miembros del equipo mediante GET /:depositId.
  Future<Result<List<TeamModel>>> getTeam({
    required String depositId,
    required String token,
  }) async {
    try {
      final http.Response response = await http.get(
        Uri.parse("$uri/api/team/$depositId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      // Valida la respuesta y parsea la lista de miembros.
      final result = manageHttpResponse(response: response);
      if (result.isSuccess) {
        final List<dynamic> data = json.decode(response.body);
        final members = data.map((m) => TeamModel.fromMap(m)).toList();
        return Result.success(members);
      } else {
        return Result.failure(result.error);
      }
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  // Invita a un miembro al equipo mediante POST /:depositId/invite.
  Future<Result<void>> invite({
    required String depositId,
    required String email,
    required String role,
    required String token,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("$uri/api/team/$depositId/invite"),
        body: json.encode({"email": email, "role": role}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  // Elimina un miembro del equipo mediante DELETE /:depositId/members/:userId.
  Future<Result<void>> delete({
    required String depositId,
    required String userId,
    required String token,
  }) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse("$uri/api/team/$depositId/members/$userId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  // Actualiza el rol de un miembro mediante PUT /:depositId/members/:userId.
  Future<Result<void>> update({
    required String depositId,
    required String userId,
    required String role,
    required String token,
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse("$uri/api/team/$depositId/members/$userId"),
        body: json.encode({"role": role}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  // Obtiene las invitaciones pendientes del usuario autenticado.
  Future<Result<List<Map<String, dynamic>>>> getInvitations({
    required String token,
  }) async {
    try {
      final http.Response response = await http.get(
        Uri.parse("$uri/api/team/invitations"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      final result = manageHttpResponse(response: response);
      if (result.isSuccess) {
        final List<dynamic> data = json.decode(response.body);
        return Result.success(
          data.map((e) => Map<String, dynamic>.from(e)).toList(),
        );
      } else {
        return Result.failure(result.error);
      }
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  // Acepta una invitación pendiente mediante PUT /:depositId/members/:userId/accept.
  Future<Result<void>> acceptInvitation({
    required String depositId,
    required String token,
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse("$uri/api/team/$depositId/accept"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }

  @override
  // Rechaza una invitación pendiente mediante DELETE /:depositId/reject.
  Future<Result<void>> rejectInvitation({
    required String depositId,
    required String token,
  }) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse("$uri/api/team/$depositId/reject"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      return manageHttpResponse(response: response);
    } catch (e) {
      return handleException(e);
    }
  }
}
