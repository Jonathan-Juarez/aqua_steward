import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      if (context.processResult(
        result,
        successMessage: "Código de verificación enviado a $email",
      )) {
        Navigator.pushNamed(context, route, arguments: arguments);
      }
    }
  }
}
