import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_divider.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  // Las llaves y controladores de UI pertenecen al estado efímero de la vista.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Se liberan los controladores al cerrar la pantalla.
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
            text: context.l10n.auth_iniciar_sesion,
            context: context,
            type: "title",
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
          // Se usa Consumer solo para observar el estado de carga global del provider.
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) => ButtonFormat(
              formKey: _formKey,
              label: context.l10n.auth_iniciar_sesion,
              isLoading: authProvider.isLoading,
              onConfirm: () async {
                // Se pasan los valores de los controladores locales al método limpio del provider.
                final result = await authProvider.signin(
                  email: _emailController.text,
                  password: _passwordController.text,
                );

                if (!mounted) return;

                final isSuccess = context.processResult(
                  result,
                  successMessage: context.l10n.snackbar_inicio_sesion_exitoso,
                );
                if (isSuccess) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.dashboard,
                    (route) => false,
                  );
                }
              },
            ),
          ),
          ButtonFormat(
            type: "text",
            label: context.l10n.auth_olvido_contrasena,
            onConfirm: () =>
                Navigator.pushNamed(context, AppRouter.forgotPassword),
          ),
          AppDivider.dv8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormat(
                text: context.l10n.auth_no_tiene_cuenta,
                context: context,
                type: "body",
              ),
              ButtonFormat(
                type: "text",
                label: context.l10n.auth_registrarse,
                onConfirm: () => Navigator.pushNamed(context, AppRouter.signup),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
