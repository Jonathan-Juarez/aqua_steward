import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:flutter/material.dart';

class ForgotPasword extends StatefulWidget {
  const ForgotPasword({super.key});

  @override
  State<ForgotPasword> createState() => _ForgotPaswordState();
}

class _ForgotPaswordState extends State<ForgotPasword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldAccount(
      formKey: formKey,
      body: ContainerFormat(
        children: [
          Text(
            "¿Olvidaste tu contraseña?",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextFieldFormat(
            labelText: "Correo electrónico",
            icon: AppIcon.emailOutlined,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            maxLength: 40,
            validator: AppValidators.validateEmail,
          ),
          ButtonMain(
            formKey: formKey,
            label: "Confirmar",
            onPressed: () => Navigator.pushNamed(
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
