import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';

class SendOtp {
  final BuildContext context;
  final String route;
  final Map<String, dynamic> arguments;

  SendOtp({
    required this.context,
    required this.route,
    required this.arguments,
  });
  void execute() async {
    final provider = context.read<AuthProvider>();
    final email = arguments["email"];

    final result = await provider.sendOtp(email);
    if (context.mounted) {
      if (result.isSuccess) {
        SnackBarFormat(
          context: context,
          message: "Código de verificación enviado a $email",
        ).show();
        Navigator.pushNamed(context, route, arguments: arguments);
      } else {
        SnackBarFormat(
          context: context,
          message: result.error ?? "Error al enviar el código de verificación",
          isError: true,
        ).show();
      }
    }
  }
}
