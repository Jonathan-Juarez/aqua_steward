import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
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
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
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
    // debugPrint(widget.email);

    return ScaffoldAccount(
      formKey: formKey,
      body: ContainerFormat(
        children: [
          TextFormat(
            text: context.l10n.auth_confirmar_codigo,
            context: context,
            type: "title",
          ),
          TextFormat(
            text: context.l10n.auth_ingresa_codigo,
            context: context,
            type: "body",
            alignCenter: true,
          ),

          Padding(
            padding: AppPadding.symmetric8_0,
            child: Row(
              children: [
                for (int i = 0; i < 4; i++) ...[
                  Expanded(
                    child: TextFieldFormat(
                      maxLength: 1,
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          AppValidators.validateRequired(context, val),
                      controller: _controllers[i],
                    ),
                  ),
                  // Agrega un espacio entre los campos, excepto después del último.
                  if (i < 3) AppSizedBox.width16,
                ],
              ],
            ),
          ),
          ButtonFormat(
            formKey: formKey,
            label: context.l10n.comun_confirmar,
            onConfirm: () => widget.screen == AppRouter.signin
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
              TextFormat(
                text: context.l10n.auth_no_recibiste,
                context: context,
                type: "body",
              ),
              ButtonFormat(
                type: "text",
                label: context.l10n.auth_reenviar,
                onConfirm: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
