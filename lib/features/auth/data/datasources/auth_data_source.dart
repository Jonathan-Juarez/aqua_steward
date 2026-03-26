import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class AuthDataSource {
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String password,
  });
}

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final UserModel user = UserModel(email: email, password: password);

    // Llamada directa al API (Infraestructura de Red).
    final http.Response response = await http.put(
      Uri.parse("$uri/api/auth/restore-password"),
      body: user.toJson(),
      headers: <String, String>{
        "Content-Type": "application/json; charset=utf-8",
      },
    );

    // Delegamos el manejo de la respuesta HTTP y el parseo de errores.
    manageHttpResponse(
      response: response,
      context: context,
      onSuccess: () {
        SnackBarFormat.show(context, "Contraseña restablecida exitosamente");
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.signin,
          (route) => false,
        );
      },
    );
  }
}
