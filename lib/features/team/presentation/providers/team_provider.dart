import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/team/domain/entities/team.dart';
import 'package:aqua_steward/features/team/domain/usecases/get_members_usecase.dart';
import 'package:aqua_steward/features/team/domain/usecases/invite_member_usecase.dart';
import 'package:aqua_steward/features/team/domain/usecases/delete_member_usecase.dart';
import 'package:aqua_steward/features/team/domain/usecases/update_member_usecase.dart';
import 'package:aqua_steward/features/team/domain/usecases/get_invitations_usecase.dart';
import 'package:aqua_steward/features/team/domain/usecases/accept_invitation_usecase.dart';
import 'package:aqua_steward/features/team/domain/usecases/reject_invitation_usecase.dart';
import 'package:flutter/material.dart';

class TeamProvider extends ChangeNotifier {
  final GetMembersUseCase getMembersUseCase;
  final InviteMemberUseCase inviteMemberUseCase;
  final DeleteMemberUseCase deleteMemberUseCase;
  final UpdateMemberUseCase updateMemberUseCase;
  final GetInvitationsUseCase getInvitationsUseCase;
  final AcceptInvitationUseCase acceptInvitationUseCase;
  final RejectInvitationUseCase rejectInvitationUseCase;

  TeamProvider({
    required this.getMembersUseCase,
    required this.inviteMemberUseCase,
    required this.deleteMemberUseCase,
    required this.updateMemberUseCase,
    required this.getInvitationsUseCase,
    required this.acceptInvitationUseCase,
    required this.rejectInvitationUseCase,
  });

  List<Team> _members = [];
  List<Team> get members => _members;

  List<Map<String, dynamic>> _invitations = [];
  List<Map<String, dynamic>> get invitations => _invitations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingInvitations = false;
  bool get isLoadingInvitations => _isLoadingInvitations;

  // Carga la lista de miembros del equipo de un depósito y notifica a la vista.
  Future<Result<List<Team>>> getMembers({
    required String depositId,
    required String token,
  }) async {
    _isLoading = true;
    // Se evita notificar si el widget todavía se está construyendo para no causar error.
    Future.microtask(() => notifyListeners());

    try {
      final result = await getMembersUseCase.call(
        depositId: depositId,
        token: token,
      );
      if (result.isSuccess) {
        _members = result.data!;
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Invita a un miembro al equipo y refresca la lista local.
  Future<Result<bool>> inviteMember({
    required String depositId,
    required String email,
    required String role,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await inviteMemberUseCase.call(
        depositId: depositId,
        email: email,
        role: role,
        token: token,
      );
      if (result.isSuccess) {
        // Refresca la lista para reflejar el nuevo miembro.
        await getMembers(depositId: depositId, token: token);
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Elimina un miembro del equipo y actualiza la lista local.
  Future<Result<void>> deleteMember({
    required String depositId,
    required String userId,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await deleteMemberUseCase.call(
        depositId: depositId,
        userId: userId,
        token: token,
      );
      if (result.isSuccess) {
        // Elimina de la lista local para feedback visual inmediato.
        _members.removeWhere((member) => member.id == userId);
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualiza el rol de un miembro del equipo.
  Future<Result<void>> updateMember({
    required String depositId,
    required String userId,
    required String role,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await updateMemberUseCase.call(
        depositId: depositId,
        userId: userId,
        role: role,
        token: token,
      );
      if (result.isSuccess) {
        // Refresca la lista para reflejar el cambio de rol.
        await getMembers(depositId: depositId, token: token);
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtiene las invitaciones pendientes del usuario autenticado.
  Future<Result<List<Map<String, dynamic>>>> getInvitations({
    required String token,
  }) async {
    _isLoadingInvitations = true;
    Future.microtask(() => notifyListeners());

    try {
      final result = await getInvitationsUseCase.call(token: token);
      if (result.isSuccess) {
        _invitations = result.data!;
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    } finally {
      _isLoadingInvitations = false;
      notifyListeners();
    }
  }

  // Acepta una invitación y refresca la lista de invitaciones.
  Future<Result<void>> acceptInvitation({
    required String depositId,
    required String token,
  }) async {
    try {
      final result = await acceptInvitationUseCase.call(
        depositId: depositId,
        token: token,
      );
      if (result.isSuccess) {
        _invitations.removeWhere((inv) => inv["deposit_id"] == depositId);
        notifyListeners();
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // Rechaza una invitación y la elimina de la lista local.
  Future<Result<void>> rejectInvitation({
    required String depositId,
    required String token,
  }) async {
    try {
      final result = await rejectInvitationUseCase.call(
        depositId: depositId,
        token: token,
      );
      if (result.isSuccess) {
        _invitations.removeWhere((inv) => inv["deposit_id"] == depositId);
        notifyListeners();
      }
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // Limpia la lista de miembros al salir de la pantalla.
  void clearMembers() {
    _members = [];
    notifyListeners();
  }
}
