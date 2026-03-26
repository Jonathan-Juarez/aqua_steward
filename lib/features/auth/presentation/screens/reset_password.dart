import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/features/auth/presentation/providers/reset_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasword extends StatelessWidget {
  final String email;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ResetPasword({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    // Se consume el provider inyectado desde main de manera reactiva (.watch). Es decir, cada que el provider cambie, la vista se reconstruirá.
    final provider = context.watch<ResetPasswordProvider>();

    debugPrint(email);
    return ScaffoldAccount(
      formKey: formKey,
      body: ContainerFormat(
        children: [
          Text(
            'Cambiar contraseña',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          TextFieldFormat(
            labelText: "Contraseña",
            icon: AppIcon.password,
            keyboardType: TextInputType.visiblePassword,
            // Se usa el controlador del Provider.
            controller: provider.passwordController,
            maxLength: 30,
            validator: AppValidators.validatePassword,
          ),
          ButtonMain(
            formKey: formKey,
            label: "Confirmar",
            // Se consume la variable booleana de indicador de carga.
            isLoading: provider.isLoading,
            // Se llama a la función del Provider (Capa app) sin tocar la infraestructura.
            onPressed: () => provider.resetPassword(context, email),
          ),
        ],
      ),
    );
  }
}
