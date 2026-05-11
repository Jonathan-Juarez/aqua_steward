import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:flutter/material.dart';

// Pantalla de recuperación de contraseña con gestión local de estado para UI.
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // Limpieza de controladores locales.
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldAccount(
      formKey: _formKey,
      body: ContainerFormat(
        children: [
          TextFormat(
            text: context.l10n.auth_olvido_contrasena,
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
          ButtonFormat(
            formKey: _formKey,
            label: context.l10n.comun_confirmar,
            onConfirm: () => Navigator.pushNamed(
              context,
              AppRouter.confirmationReset,
              arguments: {"email": _emailController.text},
            ),
          ),
        ],
      ),
    );
  }
}
