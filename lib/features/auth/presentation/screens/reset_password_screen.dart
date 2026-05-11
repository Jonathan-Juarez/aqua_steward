import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Se liberan los controladores al destruir el widget.
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
            text: context.l10n.auth_cambiar_contrasena,
            context: context,
            type: "title",
          ),
          TextFieldFormat(
            labelText: context.l10n.auth_contrasena,
            icon: AppIcon.password,
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            maxLength: 30,
            validator: (val) => AppValidators.validatePassword(context, val),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) => ButtonFormat(
              formKey: _formKey,
              label: context.l10n.comun_confirmar,
              isLoading: authProvider.isLoading,
              onConfirm: () => resetPasswordProvider(context, authProvider),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> resetPasswordProvider(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    // Ejecuta la petición pasando los datos locales.
    final result = await authProvider.resetPassword(
      widget.email,
      _passwordController.text,
    );

    if (!mounted) return;

    final isSuccess = context.processResult(
      result,
      successMessage: context.l10n.snackbar_contrasena_restablecida,
    );
    if (isSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.signin,
        (route) => false,
      );
    }
  }
}
