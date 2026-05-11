import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/providers/theme_provider.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:provider/provider.dart';
import 'package:aqua_steward/core/providers/language_provider.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/exit_confirmation_scope.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:flutter/material.dart';

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

  // Diálogo para cambiar el nombre o apellido del usuario.
  Future<dynamic> _dialogProfile({
    required BuildContext context,
    required String title,
    required Widget content,
    required TextEditingController controller,
    required Future<bool> Function() onConfirm,
  }) async {
    await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        // Se pasa el proveedor existente al diálogo mediante .value, ya que showDialog crea una nueva ruta.
        return ChangeNotifierProvider.value(
          value: context.read<AuthProvider>(),
          child: Consumer<AuthProvider>(
            builder: (providerContext, provider, _) {
              return DialogEmergent(
                title: context.l10n.perfil_cambiar_dialogo_titulo(
                  title.toLowerCase(),
                ),
                content: content,
                formKey: _formkey,
                isLoading: provider.isLoading,
                onPressed: () async {
                  Navigator.of(providerContext).pop();
                  // Si el proceso de actualización es exitoso, se cierra el diálogo.
                  await onConfirm();
                },
              );
            },
          ),
        );
      },
    );
  }

  // Diálogo para cambiar el tema y el idioma de la aplicación.
  Future<void> _dialogSettings(BuildContext context) async {
    final themeProvider = context.read<ThemeProvider>();
    final languageProvider = context.read<LanguageProvider>();

    // Obtiene los valores actuales para el estado local del diálogo.
    String pendingTheme = themeProvider.themeMode == ThemeMode.system
        ? "system"
        : themeProvider.themeMode == ThemeMode.light
        ? "light"
        : "dark";
    String pendingLanguage = languageProvider.locale.languageCode;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return DialogEmergent(
              title: context.l10n.perfil_personalizacion,
              onPressed: () {
                // Aplica los cambios de tema e idioma al confirmar.
                themeProvider.setTheme(pendingTheme);
                languageProvider.setLanguage(pendingLanguage);
                Navigator.of(context).pop();
              },
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormat(
                    text: context.l10n.perfil_tema,
                    context: context,
                    type: "body",
                  ),
                  AppSizedBox.height12,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChipFormat(
                          label: context.l10n.perfil_tema_sistema,
                          isSelected: pendingTheme == "system",
                          onSelected: (_) =>
                              setDialogState(() => pendingTheme = "system"),
                        ),
                        FilterChipFormat(
                          label: context.l10n.perfil_tema_claro,
                          isSelected: pendingTheme == "light",
                          onSelected: (_) =>
                              setDialogState(() => pendingTheme = "light"),
                        ),
                        FilterChipFormat(
                          label: context.l10n.perfil_tema_oscuro,
                          isSelected: pendingTheme == "dark",
                          onSelected: (_) =>
                              setDialogState(() => pendingTheme = "dark"),
                        ),
                      ],
                    ),
                  ),
                  AppSizedBox.height12,
                  TextFormat(
                    text: context.l10n.perfil_idioma,
                    context: context,
                    type: "body",
                  ),
                  AppSizedBox.height12,
                  Row(
                    children: [
                      FilterChipFormat(
                        label: context.l10n.perfil_espanol,
                        isSelected: pendingLanguage == 'es',
                        onSelected: (_) =>
                            setDialogState(() => pendingLanguage = "es"),
                      ),
                      FilterChipFormat(
                        label: context.l10n.perfil_ingles,
                        isSelected: pendingLanguage == 'en',
                        onSelected: (_) =>
                            setDialogState(() => pendingLanguage = "en"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
            onTap: () => _dialogProfile(
              context: context,
              title: context.l10n.perfil_nombre,
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
            onTap: () => _dialogProfile(
              context: context,
              title: context.l10n.perfil_apellido,
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
            onTap: () => _dialogSettings(context),
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
            onTap: () {
              // Limpia los depósitos antes de cerrar sesión para evitar datos residuales.
              context.read<DepositProvider>().clearDeposits();
              provider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.start,
                (route) => false,
              );
            },
            title: context.l10n.perfil_cerrar_sesion,
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
