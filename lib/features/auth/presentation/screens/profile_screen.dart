import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/providers/language_provider.dart';
import 'package:aqua_steward/core/providers/theme_provider.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/features/notification/presentation/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  // Estado local para los formularios de actualización de perfil.
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late String _email;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Inicialización de controladores con los datos actuales del usuario.
    final currentUser = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: currentUser?.name);
    _lastNameController = TextEditingController(text: currentUser?.last_name);
    _email = currentUser?.email ?? "";
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
    super.build(context);
    // Se consumen ambos proveedores para separar responsabilidades de sesión y perfil.
    final provider = context.watch<AuthProvider>();

    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    final String currentTheme = themeProvider.themeMode == ThemeMode.system
        ? "system"
        : themeProvider.themeMode == ThemeMode.light
        ? "light"
        : "dark";
    final String currentLanguage = languageProvider.locale.languageCode;

    final String name = provider.currentUser?.name ?? "";
    final String lastName = provider.currentUser?.last_name ?? "";

    return Column(
      children: [
        Row(
          children: [
            TextFormat(
              text: context.l10n.perfil_titulo,
              context: context,
              type: "title",
            ),
          ],
        ),

        AppSizedBox.height12,

        // Encabezado Tarjeta Hero: Avatar interactivo + Datos de usuario
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showEditProfileDialog(provider),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: TextFormat(
                          text:
                              "${name.isNotEmpty ? name[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}",
                          context: context,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.background,
                            width: 0.5,
                          ),
                        ),
                        child: AppIcon.edit(
                          context: context,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSizedBox.height8,
                TextFormat(
                  text: "$name $lastName",
                  context: context,
                  type: "titleSmall",
                ),
                TextFormat(
                  text: _email,
                  context: context,
                  type: "bodySecondary",
                ),
              ],
            ),
          ),
        ),

        // Personalización
        TextFormat(
          text: context.l10n.perfil_personalizacion,
          context: context,
          type: "subtitle",
        ),
        ContainerFormat(
          children: [
            Padding(
              padding: AppPadding.all8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const IconFormat(icon: AppIcon.colorLensOutlined),
                      AppSizedBox.width8,
                      TextFormat(
                        text: context.l10n.perfil_tema,
                        context: context,
                        type: "body",
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ButtonFormat(
                        type: "icon",
                        icon: AppIcon.systemMode,
                        isSelected: currentTheme == "system",
                        onConfirm: () => themeProvider.setTheme("system"),
                      ),
                      ButtonFormat(
                        type: "icon",
                        icon: AppIcon.lightMode,
                        isSelected: currentTheme == "light",
                        onConfirm: () => themeProvider.setTheme("light"),
                      ),
                      ButtonFormat(
                        type: "icon",
                        icon: AppIcon.darkMode,
                        isSelected: currentTheme == "dark",
                        onConfirm: () => themeProvider.setTheme("dark"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSizedBox.height12,
        ContainerFormat(
          children: [
            Padding(
              padding: AppPadding.all8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const IconFormat(icon: Icon(Icons.language_outlined)),
                      AppSizedBox.width8,
                      TextFormat(
                        text: context.l10n.perfil_idioma,
                        context: context,
                        type: "body",
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      FilterChipFormat(
                        label: context.l10n.perfil_espanol,
                        isSelected: currentLanguage == 'es',
                        onSelected: (_) => languageProvider.setLanguage("es"),
                      ),
                      AppSizedBox.width8,
                      FilterChipFormat(
                        label: context.l10n.perfil_ingles,
                        isSelected: currentLanguage == 'en',
                        onSelected: (_) => languageProvider.setLanguage("en"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // Configuración de cuenta (Cambiar contraseña, Cerrar sesión, Eliminar cuenta)
        TextFormat(
          text: context.l10n.perfil_ajustes_cuenta,
          context: context,
          type: "subtitle",
        ),
        ContainerListTile(
          onTap: () => Navigator.pushNamed(
            context,
            AppRouter.forgotPassword,
            arguments: {"email": _email},
          ),
          title: context.l10n.perfil_cambiar_contrasenia,
          icon: AppIcon.lockOutline,
        ),
        AppSizedBox.height12,
        ContainerListTile(
          title: context.l10n.dialogo_cerrar_sesion_titulo,
          icon: AppIcon.logoutOutlined,
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
                  await context.read<NotificationProvider>().cleanup(token);
                }
                if (context.mounted) {
                  context.read<DepositProvider>().clearDeposits();
                  provider.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.start,
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ),
        AppSizedBox.height12,
        ContainerListTile(
          title: context.l10n.dialogo_eliminar_cuenta_titulo,
          icon: AppIcon.noAccounts,
          onTap: () => showDialog(
            context: context,
            builder: (context) => DialogEmergent(
              title: context.l10n.dialogo_eliminar_cuenta_titulo,
              content: TextFormat(
                text: context.l10n.dialogo_eliminar_cuenta,
                context: context,
                type: "body",
              ),
              onPressed: () async {
                final token = provider.currentUser?.token;
                if (token != null) {
                  await context.read<NotificationProvider>().cleanup(token);
                }
                final result = await deleteUser(_email);
                if (result) {
                  if (context.mounted) {
                    context.read<DepositProvider>().clearDeposits();
                    await provider.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouter.start,
                        (route) => false,
                      );
                    }
                  }
                }
              },
            ),
          ),
        ),

        // Soporte
        TextFormat(
          text: context.l10n.soporte_titulo,
          context: context,
          type: "subtitle",
        ),
        ContainerListTile(
          title: context.l10n.soporte_preguntas_frecuentes,
          onTap: () => Navigator.pushNamed(context, AppRouter.support),
          icon: AppIcon.supportOutline,
        ),
        AppSizedBox.height12,
        ContainerListTile(
          title: context.l10n.soporte_manual,
          icon: AppIcon.manual,
          onTap: () => Navigator.pushNamed(context, AppRouter.userManual),
        ),
        AppSizedBox.height12,
        ContainerListTile(
          title: context.l10n.soporte_acerca_de,
          icon: AppIcon.infoOutlined,
          onTap: () => Navigator.pushNamed(context, AppRouter.about),
        ),

        const SizedBox(height: 80),
      ],
    );
  }

  void _showEditProfileDialog(AuthProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogEmergent(
          title: context.l10n.perfil_editar_titulo,
          formKey: _formkey,
          content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldFormat(
                  labelText: context.l10n.perfil_nombre,
                  icon: AppIcon.personOutlined(context: context),
                  controller: _nameController,
                  maxLength: 20,
                  validator: (val) =>
                      AppValidators.validateRequired(context, val),
                ),
                AppSizedBox.height12,
                TextFieldFormat(
                  labelText: context.l10n.perfil_apellido,
                  icon: AppIcon.personOutlined(context: context),
                  controller: _lastNameController,
                  maxLength: 20,
                  validator: (val) =>
                      AppValidators.validateRequired(context, val),
                ),
              ],
            ),
          ),
          onPressed: () {
            updateProfile(provider, context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<bool> updateProfile(
    AuthProvider provider,
    BuildContext context,
  ) async {
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

  Future<bool> deleteUser(String email) async {
    final result = await context.read<AuthProvider>().deleteUser(email);
    if (!mounted) return false;
    return context.processResult(
      result,
      successMessage: context.l10n.snackbar_usuario_eliminado,
    );
  }
}
