import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmationScreen extends StatefulWidget {
  final String screen;
  final String? email;
  final String? name;
  final String? lastName;
  final String? password;

  const ConfirmationScreen({
    super.key,
    required this.screen,
    this.email,
    this.name,
    this.lastName,
    this.password,
  });

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
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final String otp = _controllers.map((c) => c.text.trim()).join();
    final String targetEmail = widget.email ?? "";

    if (otp.length < 4) {
      SnackBarFormat(
        context: context,
        message: "Por favor ingresa los 4 dígitos del código",
        isError: true,
      ).show();
      return;
    }

    final authProvider = context.read<AuthProvider>();

    // Verificar OTP mediante el servicio externo
    final verifyResult = await authProvider.verifyOtp(
      email: targetEmail,
      otp: otp,
    );

    if (!mounted) return;

    if (!context.processResult(verifyResult)) return;

    // Si viene del flujo de registro (name/lastName/password presentes)
    if (widget.name != null && widget.password != null) {
      final signupResult = await authProvider.signup(
        name: widget.name!,
        lastName: widget.lastName ?? "",
        email: targetEmail,
        password: widget.password!,
      );

      if (!mounted) return;

      if (context.processResult(
        signupResult,
        successMessage: context.l10n.snackbar_usuario_registrado,
      )) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.start,
          (route) => false,
        );
      }
      return;
    }

    // Flujo de restablecimiento u otro destino
    if (widget.screen == AppRouter.signin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        widget.screen,
        (route) => false,
      );
    } else {
      Navigator.pushNamed(
        context,
        widget.screen,
        arguments: {"email": targetEmail},
      );
    }
  }

  Future<void> _handleResend() async {
    final String targetEmail = widget.email ?? "";
    if (targetEmail.isEmpty) return;

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.sendOtp(targetEmail);

    if (!mounted) return;

    context.processResult(
      result,
      successMessage: "Código de verificación reenviado a $targetEmail",
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldAccount(
      formKey: formKey,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return ContainerFormat(
            children: [
              TextFormat(
                text: context.l10n.auth_confirmar_codigo,
                context: context,
                type: "subtitle",
              ),
              TextFormat(
                text:
                    "${context.l10n.auth_ingresa_codigo}\n${widget.email ?? ''}",
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
                isLoading: authProvider.isLoading,
                onConfirm: _handleConfirm,
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
                    onConfirm: _handleResend,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
