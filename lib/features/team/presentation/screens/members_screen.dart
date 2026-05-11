import 'package:aqua_steward/core/permissions/app_permission.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/menu_button_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/team/domain/entities/team.dart';
import 'package:aqua_steward/features/team/presentation/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatefulWidget {
  final String depositId;

  const MembersScreen({super.key, required this.depositId});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  int _selectedIndex = 0;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = "analyst";

  // Getter reutilizable para el token del usuario autenticado.
  String get _token => context.read<AuthProvider>().currentUser?.token ?? "";

  // Rol del usuario autenticado en el depósito actual.
  String get _currentRole {
    final provider = context.read<TeamProvider>();
    final userId = context.read<AuthProvider>().currentUser?.id;
    final member = provider.members
        .where((member) => member.id == userId)
        .firstOrNull;
    return member?.role ?? "analyst";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_token.isNotEmpty) {
        context.read<TeamProvider>().getMembers(
          depositId: widget.depositId,
          token: _token,
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_miembros,
      children: [
        // Filtros y botón de agregar miembro.
        Padding(
          padding: AppPadding.symmetric16_0,
          child: Row(
            children: [
              FilterChipFormat(
                label: context.l10n.miembros_filtro_miembros,
                isSelected: _selectedIndex == 0,
                onSelected: (_) => setState(() => _selectedIndex = 0),
              ),
              FilterChipFormat(
                label: context.l10n.miembros_filtro_invitaciones,
                isSelected: _selectedIndex == 1,
                onSelected: (_) => setState(() => _selectedIndex = 1),
              ),
              const Spacer(),
              // Solo los roles con permiso de invitar ven el botón.
              PermissionActions(
                role: _currentRole,
                permission: AppPermission.inviteMember,
                child: ButtonFormat(
                  type: "icon",
                  icon: AppIcon.personAdd(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onConfirm: inviteDialog,
                ),
              ),
            ],
          ),
        ),

        // Lista reactiva de miembros.
        Consumer<TeamProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                heightFactor: 5,
                child: CircularProgressIndicator(),
              );
            }

            final filtered = _selectedIndex == 0
                ? provider.members
                      .where((m) => m.status == "accepted" || m.role == "owner")
                      .toList()
                : provider.members.where((m) => m.status == "pending").toList();

            if (filtered.isEmpty) {
              return const Center(heightFactor: 5, child: SizedBox.shrink());
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => AppSizedBox.height12,
              itemBuilder: (_, i) => containerMember(filtered[i]),
            );
          },
        ),
      ],
    );
  }

  // Tarjeta para cada miembro.
  Widget containerMember(Team member) {
    final name = "${member.name ?? ''} ${member.last_name ?? ''}".trim();
    final role = _labelForRole(member.role ?? "");

    // Los miembros sin permisos de gestión o el dueño siempre se muestran sin menú.
    if (member.role == "owner" ||
        !RolePermissions.has(_currentRole, AppPermission.editMemberRole)) {
      return ContainerListTile(
        title: name,
        subtitle: role,
        icon: AppIcon.personOutlined(context: context),
        showTrailing: false,
      );
    }

    return MenuButtonFormat(
      items: roleMenuItems(),
      onSelected: (value) async {
        final provider = context.read<TeamProvider>();

        if (value == "delete") {
          final result = await provider.deleteMember(
            depositId: widget.depositId,
            userId: member.id!,
            token: _token,
          );
          if (!mounted) return;
          context.processResult(
            result,
            successMessage: context.l10n.snackbar_miembro_eliminado,
          );
        } else {
          final result = await provider.updateMember(
            depositId: widget.depositId,
            userId: member.id!,
            role: value,
            token: _token,
          );
          if (!mounted) return;
          context.processResult(result);
        }
      },
      child: ContainerListTile(
        title: name,
        subtitle: role,
        icon: AppIcon.personOutlined(context: context),
      ),
    );
  }

  // Diálogo para invitar miembro

  void inviteDialog() {
    _emailController.clear();
    _selectedRole = "analyst";

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => DialogEmergent(
          formKey: _formKey,
          title: context.l10n.titulo_miembros,
          onPressed: () async {
            final provider = context.read<TeamProvider>();

            final result = await provider.inviteMember(
              depositId: widget.depositId,
              email: _emailController.text,
              role: _selectedRole,
              token: _token,
            );
            if (!mounted) return;

            Navigator.pop(dialogContext);
            context.processResult(
              result,
              successMessage: context.l10n.snackbar_miembro_invitado_exitoso,
            );
          },
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldFormat(
                  labelText: context.l10n.auth_correo,
                  icon: AppIcon.emailOutlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  maxLength: 40,
                  validator: (val) => AppValidators.validateEmail(context, val),
                ),
                AppSizedBox.height12,
                // Selector de rol.
                MenuButtonFormat(
                  items: roleMenuItems(showDelete: false),
                  onSelected: (value) {
                    setDialogState(() => _selectedRole = value);
                  },
                  child: ContainerListTile(title: _labelForRole(_selectedRole)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Genera la lista de MenuItemModel para roles, con opción de incluir "eliminar".
  List<MenuItemModel> roleMenuItems({bool showDelete = true}) {
    return [
      MenuItemModel(
        value: "analyst",
        icon: AppIcon.personOutlined(context: context),
        text: context.l10n.miembros_rol_analista,
      ),
      MenuItemModel(
        value: "admin",
        icon: AppIcon.personOutlined(context: context),
        text: context.l10n.miembros_rol_admin,
      ),
      if (showDelete &&
          RolePermissions.has(_currentRole, AppPermission.deleteMember))
        MenuItemModel(
          value: "delete",
          icon: AppIcon.deleteOutline,
          text: context.l10n.comun_eliminar,
          textStyle: "bodyRed",
        ),
    ];
  }

  // Convierte el valor del rol a su etiqueta localizada.
  String _labelForRole(String role) {
    return switch (role) {
      "owner" => context.l10n.miembros_rol_propietario,
      "admin" => context.l10n.miembros_rol_admin,
      "analyst" => context.l10n.miembros_rol_analista,
      _ => role,
    };
  }
}
