import 'package:aqua_steward/core/utils/send_otp.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/password_requirements_widget.dart';
import 'package:flutter/material.dart';

// Pantalla de registro de usuario con gestión de controllers y formKey locales.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Estado local para la interfaz de usuario.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Registra el oyente del controlador de contraseña para reconstruir los requisitos.
    _passwordController.addListener(_onPasswordChanged);
  }

  // Notifica los cambios de texto para actualizar la interfaz.
  void _onPasswordChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    // Libera los recursos locales de la vista.
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldAccount(
      formKey: _formKey,
      body: ContainerFormat(
        children: [
          TextFormat(
            text: context.l10n.auth_registrarse,
            context: context,
            type: "subtitle",
          ),
          Row(
            children: [
              Expanded(
                child: TextFieldFormat(
                  labelText: context.l10n.auth_nombre,
                  icon: AppIcon.personOutlined(context: context),
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  maxLength: 20,
                  validator: (val) =>
                      AppValidators.validateRequired(context, val),
                ),
              ),
              AppSizedBox.width8,
              Expanded(
                child: TextFieldFormat(
                  labelText: context.l10n.auth_apellido,
                  icon: AppIcon.personOutlined(context: context),
                  keyboardType: TextInputType.name,
                  controller: _lastNameController,
                  maxLength: 20,
                  validator: (val) =>
                      AppValidators.validateRequired(context, val),
                ),
              ),
            ],
          ),
          TextFieldFormat(
            labelText: context.l10n.auth_correo,
            icon: AppIcon.emailOutlined,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            maxLength: 40,
            validator: (val) => AppValidators.validateEmail(context, val),
          ),
          TextFieldFormat(
            labelText: context.l10n.auth_contrasena,
            icon: AppIcon.password,
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            maxLength: 30,
            validator: (val) => AppValidators.validatePassword(context, val),
          ),
          if (_passwordController.text.isNotEmpty)
            PasswordRequirementsWidget(password: _passwordController.text),

          // Observa el estado de carga mediante
          ButtonFormat(
            formKey: _formKey,
            label: context.l10n.auth_registrarse,
            isLoading: context.watch<AuthProvider>().isLoading,
            onConfirm: () => SendOtp(
              context: context,
              route: AppRouter.confirmation,
              arguments: {
                "name": _nameController.text.trim(),
                "lastName": _lastNameController.text.trim(),
                "email": _emailController.text.trim(),
                "password": _passwordController.text,
              },
            ).execute(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormat(
                text: context.l10n.auth_tiene_cuenta,
                context: context,
                type: "body",
              ),
              ButtonFormat(
                type: "text",
                label: context.l10n.auth_iniciar_sesion,
                onConfirm: () =>
                    Navigator.pushReplacementNamed(context, AppRouter.signin),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
