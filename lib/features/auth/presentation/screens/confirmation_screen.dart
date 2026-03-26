import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/button_dynamic.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:flutter/material.dart';

class ConfirmationScreen extends StatefulWidget {
  final String screen;
  final String? email;
  const ConfirmationScreen({super.key, required this.screen, this.email});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.email);

    return ScaffoldAccount(
      formKey: formKey,
      body: ContainerFormat(
        children: [
          Text(
            'Confirmar código',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Ingresa el código de confirmación enviado a tu correo electrónico.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          Padding(
            padding: AppPadding.symmetric8_0,
            child: Row(
              children: [
                for (int i = 0; i < 4; i++) ...[
                  Expanded(
                    child: TextFieldFormat(
                      keyboardType: TextInputType.number,
                      validator: AppValidators.validateUnique,
                      controller: _controllers[i],
                    ),
                  ),
                  // Agrega un espacio entre los campos, excepto después del último.
                  if (i < 3) AppSizedBox.width16,
                ],
              ],
            ),
          ),
          ButtonMain(
            formKey: formKey,
            label: "Confirmar",
            onPressed: () => widget.screen == AppRouter.signin
                ? Navigator.pushNamedAndRemoveUntil(
                    context,
                    widget.screen,
                    // Se le asigna false para que elimine el historial de pantallas.
                    (route) => false,
                  )
                : Navigator.pushNamed(
                    context,
                    widget.screen,
                    arguments: {"email": widget.email},
                  ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿No lo recibiste?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              ButtonDynamic(
                label: "Reenviar",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
