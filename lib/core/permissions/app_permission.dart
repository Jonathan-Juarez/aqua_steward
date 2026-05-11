import 'package:flutter/widgets.dart';

// Se define las acciones protegidas de la app.
enum AppPermission {
  // Depósitos
  createDeposit,
  editDeposit,
  deleteDeposit,
  editThresholds,

  // Miembros
  viewMembers,
  inviteMember,
  editMemberRole,
  deleteMember,

  // Detalles de depósitos
  exportCSVAndPDF,
}

// Se define los permisos que tiene cada rol.
class RolePermissions {
  RolePermissions._();

  static const Map<String, Set<AppPermission>> actions = {
    "owner": {
      AppPermission.editDeposit,
      AppPermission.deleteDeposit,
      AppPermission.editThresholds,
      AppPermission.inviteMember,
      AppPermission.editMemberRole,
      AppPermission.deleteMember,
    },
    "admin": {
      AppPermission.editThresholds,
      AppPermission.inviteMember,
      AppPermission.editMemberRole,
      AppPermission.deleteMember,
    },
    "analyst": {AppPermission.viewMembers},
  };

  /// Consulta si un rol tiene un permiso específico.
  static bool has(String? role, AppPermission permission) {
    if (role == null) return false;
    return actions[role]?.contains(permission) ?? false;
  }

  /// Devuelve todos los permisos de un rol.
  static Set<AppPermission> permissionsFor(String? role) {
    if (role == null) return {};
    return actions[role] ?? {};
  }
}

// Este widget da permiso para mostrar un widget dependiendo del rol del usuario.
class PermissionActions extends StatelessWidget {
  final String? role;
  final AppPermission permission;
  final Widget child;

  const PermissionActions({
    super.key,
    required this.role,
    required this.permission,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RolePermissions.has(role, permission)
        ? child
        : const SizedBox.shrink();
  }
}
