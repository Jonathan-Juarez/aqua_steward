// Se define las acciones protegidas de la app.
enum AppPermission {
  // Depósitos
  editDeposit,
  deleteDeposit,

  // Miembros
  inviteMember,
  editMemberRole,
  deleteMember,
}

// Se define los permisos que tiene cada rol.
class RolePermissions {
  RolePermissions._();

  static const Map<String, Set<AppPermission>> actions = {
    "owner": {
      AppPermission.inviteMember,
      AppPermission.editDeposit,
      AppPermission.editMemberRole,
      AppPermission.deleteMember,
      AppPermission.deleteDeposit,
    },
    "admin": {
      AppPermission.inviteMember,
      AppPermission.editDeposit,
      AppPermission.editMemberRole,
      AppPermission.deleteMember,
    },
    "analyst": {},
  };

  // Consulta si un rol tiene un permiso específico.
  static bool has(String? role, AppPermission permission) {
    if (role == null) return false;
    return actions[role]?.contains(permission) ?? false;
  }

  // Devuelve todos los permisos de un rol.
  static Set<AppPermission> permissionsFor(String? role) {
    if (role == null) return {};
    return actions[role] ?? {};
  }
}
