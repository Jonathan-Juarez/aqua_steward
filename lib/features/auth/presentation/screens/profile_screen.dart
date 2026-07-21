import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/exit_confirmation_scope.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/dialog_profile.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/dialog_settings.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/features/notification/presentation/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Estado local para los formularios de actualización de perfil.
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    // Inicialización de controladores con los datos actuales del usuario.
    final currentUser = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: currentUser?.name);
    _lastNameController = TextEditingController(text: currentUser?.last_name);
  }

  @override
  void dispose() {
    // Liberación de recursos al destruir el widget.
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se consumen ambos proveedores para separar responsabilidades de sesión y perfil.
    final provider = context.watch<AuthProvider>();

    final String name = provider.currentUser?.name ?? "";
    final String lastName = provider.currentUser?.last_name ?? "";

    return ExitConfirmationScope(
      child: ScaffoldMain(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: TextFormat(
              text: context.l10n.perfil_titulo,
              context: context,
              type: "title",
            ),
          ),

          AppSizedBox.height12,
          // Avatar circular que muestra las iniciales del usuario.
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: TextFormat(
              text:
                  "${name.isNotEmpty ? name[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}",
              context: context,
            ),
          ),

          // Título de la sección de información personal.
          TextFormat(
            text: context.l10n.perfil_info_personal,
            context: context,
            type: "subtitle",
          ),

          // Opción para editar el nombre del usuario.
          ContainerListTile(
            onTap: () => DialogProfile.show(
              context: context,
              title: context.l10n.perfil_nombre,
              formkey: _formkey,
              controller: _nameController,
              content: Form(
                key: _formkey,
                child: TextFieldFormat(
                  labelText: context.l10n.perfil_nombre,
                  icon: AppIcon.personOutlined(context: context),
                  controller: _nameController,
                  maxLength: 20,
                  validator: (val) =>
                      AppValidators.validateRequired(context, val),
                ),
              ),
              onConfirm: () => updateProfile(provider, context),
            ),
            title: context.l10n.perfil_nombre,
            subtitle: name,
            icon: AppIcon.personOutlined(context: context),
          ),
          AppSizedBox.height12,
          ContainerListTile(
            onTap: () => DialogProfile.show(
              context: context,
              title: context.l10n.perfil_apellido,
              formkey: _formkey,
              controller: _lastNameController,
              content: Form(
                key: _formkey,
                child: TextFieldFormat(
                  labelText: context.l10n.perfil_apellido,
                  icon: AppIcon.personOutlined(context: context),
                  controller: _lastNameController,
                  maxLength: 20,
                  validator: (val) =>
                      AppValidators.validateRequired(context, val),
                ),
              ),
              onConfirm: () => updateProfile(provider, context),
            ),
            title: context.l10n.perfil_apellido,
            subtitle: lastName,
            icon: AppIcon.personOutlined(context: context),
          ),

          TextFormat(
            text: context.l10n.perfil_ajustes_cuenta,
            context: context,
            type: "subtitle",
          ),
          ContainerListTile(
            onTap: () => DialogSettings.show(context),
            title: context.l10n.perfil_personalizacion,
            subtitle: context.l10n.perfil_tema_idioma,
            icon: AppIcon.colorLensOutlined,
          ),

          AppSizedBox.height12,
          ContainerListTile(
            onTap: () => Navigator.pushNamed(context, AppRouter.forgotPassword),
            title: context.l10n.perfil_cambiar_contrasenia,
            icon: AppIcon.lockOutline,
          ),
          AppSizedBox.height12,

          ContainerListTile(
            onTap: () => showDialog(
              context: context,
              builder: (context) => DialogEmergent(
                title: context.l10n.dialogo_cerrar_sesion_titulo,
                content: TextFormat(
                  text: context.l10n.dialogo_cerrar_sesion,
                  context: context,
                  type: "body",
                ),
                onPressed: () async {
                  final token = provider.currentUser?.token;
                  if (token != null) {
                    // Desregistrar token FCM antes de cerrar sesión
                    await context.read<NotificationProvider>().cleanup(token);
                  }
                  // Limpia los depósitos antes de cerrar sesión para evitar datos residuales.
                  context.read<DepositProvider>().clearDeposits();
                  provider.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouter.start,
                      (route) => false,
                    );
                  }
                },
              ),
            ),
            title: context.l10n.dialogo_cerrar_sesion_titulo,
            icon: AppIcon.logoutOutlined,
          ),
          const SizedBox(height: 76),
        ],
      ),
    );
  }

  Future<bool> updateProfile(
    AuthProvider provider,
    BuildContext context,
  ) async {
    // Utiliza AuthProvider para la lógica de actualización.
    final result = await provider.updateUser(
      name: _nameController.text,
      lastName: _lastNameController.text,
    );

    if (!mounted) return false;

    return context.processResult(
      result,
      successMessage: context.l10n.snackbar_perfil_actualizado,
    );
  }
}
