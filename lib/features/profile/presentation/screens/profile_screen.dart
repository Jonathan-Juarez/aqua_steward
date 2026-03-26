import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_interactive.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/theme/theme_provider.dart';
import 'package:aqua_steward/core/widgets/menu_button_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:provider/provider.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/features/profile/presentation/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/exit_confirmation_scope.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String name, lastName, email;
  const ProfileScreen({
    super.key,
    this.name = "Jonathan",
    this.lastName = "Juárez",
    this.email = "jonathan@example.com",
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name, lastName;

  @override
  void initState() {
    name = widget.name;
    lastName = widget.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationScope(
      child: ScaffoldMain(
        selectedIndex: 1,
        children: [
          // Header
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Mi perfil",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          AppSizedBox.height16,
          // Avatar circular con iniciales
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              "${name.isNotEmpty ? name[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 32),

          // Sección Información Personal
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Información Personal",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          Row(
            children: [
              Expanded(
                child: containerProfile(
                  "Nombre",
                  name,
                  AppIcon.personOutlined,
                  (newName) => setState(() => name = newName),
                ),
              ),
              AppSizedBox.width8,
              Expanded(
                child: containerProfile(
                  "Apellido",
                  lastName,
                  AppIcon.personOutlined,
                  (newLastName) => setState(() => lastName = newLastName),
                ),
              ),
            ],
          ),

          AppSizedBox.height16,

          // Sección Cuenta
          Text(
            "Configuración de Cuenta",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          // Opción para cambiar el tema de la app.
          Padding(
            padding: AppPadding.symmetric8_0,
            child: MenuButtonFormat(
              onSelected: (value) =>
                  context.read<ThemeProvider>().setTheme(value),
              items: [
                MenuItemModel(
                  value: "system",
                  icon: AppIcon.colorLensOutlined,
                  text: "Sistema",
                ),
                MenuItemModel(
                  value: "light",
                  icon: AppIcon.lightMode,
                  text: "Claro",
                ),
                MenuItemModel(
                  value: "dark",
                  icon: AppIcon.darkMode,
                  text: "Oscuro",
                ),
              ],
              child: ContainerFormat(
                children: [
                  Padding(
                    padding: AppPadding.all8,
                    child: Row(
                      children: [
                        const IconFormat(icon: AppIcon.colorLensOutlined),
                        AppSizedBox.width8,
                        Text(
                          "Cambiar tema",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        AppIcon.arrowRight,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ContainerInteractive(
            onTap: () => Navigator.pushNamed(context, AppRouter.forgotPassword),
            title: "Cambiar contraseña",
            icon: AppIcon.lockOutline,
          ),
          ContainerInteractive(
            onTap: () => Navigator.pushNamed(context, AppRouter.start),
            title: "Cerrar sesión",
            icon: AppIcon.logoutOutlined,
          ),
        ],
      ),
    );
  }

  // Contenedor de la información personal.
  GestureDetector containerProfile(
    String title,
    String content,
    Icon icon,
    Function(String)? onChanged,
  ) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Función para cambiar el contenido del contenedor.
    Future<dynamic> changeContent() async {
      TextEditingController controller = TextEditingController();
      await showDialog<String>(
        context: context,
        builder: (context) => DialogEmergent(
          title: "Cambiar $title",
          content: Form(
            key: formKey,
            child: TextFieldFormat(
              labelText: title,
              icon: icon,
              controller: controller,
              maxLength: 20,
              validator: AppValidators.validateRequired,
            ),
          ),
          formKey: formKey,
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onChanged!(controller.text);
            }
            Navigator.of(context).pop();
          },
        ),
      );
    }

    // Contenedor
    return GestureDetector(
      onTap: () => onChanged != null ? changeContent() : null,
      child: ContainerFormat(
        children: [
          Padding(
            padding: AppPadding.symmetric16_8,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      AppIcon.edit,
                    ],
                  ),
                  AppSizedBox.height8,
                  Text(content, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
