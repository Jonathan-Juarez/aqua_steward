import 'dart:convert';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';
import 'package:aqua_steward/features/auth/domain/entities/user.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aqua_steward/core/network/global_variable.dart';

class AuthController {
  // Variable estática para guardar la sesión del usuario actual
  static User? currentUser;

  //No será con una arquitectura, por lo que se van a utilizar varias funcionalidades (próximamente Clean architecture).
  Future<void> signupUser({
    required BuildContext context,
    required String name,
    required String last_name,
    required String email,
    required String password,
  }) async {
    try {
      final UserModel user = UserModel(
        id: "",
        name: name,
        last_name: last_name,
        email: email,
        password: password,
        role: "propietario",
        depositID: "",
      );
      final http.Response response = await http.post(
        Uri.parse("$uri/api/auth/signup"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          // Se guarda el usuario.
          currentUser = user;

          SnackBarFormat.show(context, "Usuario registrado exitosamente");
          Navigator.pushNamed(context, AppRouter.confirmationSignup);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      SnackBarFormat.show(context, e.toString());
    }
  }

  // Función asíncrona para iniciar sesión del usuario.
  Future<void> signinUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Crea una instancia del usuario con el correo y la contraseña proporcionados.
      final UserModel user = UserModel(email: email, password: password);

      // Realiza una solicitud HTTP POST al endpoint de inicio de sesión.
      // Envía los datos del usuario en formato JSON en el cuerpo de la solicitud.
      final http.Response response = await http.post(
        Uri.parse("$uri/api/auth/signin"),
        body: user.toJson(),
        headers: <String, String>{
          // Especifica que el contenido es JSON y la codificación es UTF-8.
          "Content-Type": "application/json; charset=utf-8",
        },
      );

      // Maneja la respuesta HTTP recibida.
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          // Si el inicio de sesión es exitoso, muestra un mensaje (SnackBar).
          // Guardamos el usuario y el token en la variable estática
          final responseData = json.decode(response.body);
          if (responseData.containsKey('user')) {
            final userMap = Map<String, dynamic>.from(responseData['user']);
            userMap['token'] = responseData['token'];
            currentUser = UserModel.fromMap(userMap);
          } else {
            currentUser = UserModel.fromMap(responseData);
          }
          //debugPrint("ID del usuario: ${currentUser?.id}");

          SnackBarFormat.show(context, "Usuario logueado exitosamente");
          // Navega a la pantalla del panel de control (Dashboard).
          Navigator.pushNamed(context, AppRouter.dashboard);
        },
      );
    } catch (e) {
      // Si ocurre una excepción, imprime el error en la consola para depuración.
      debugPrint(e.toString());
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String password,
    // required String code,
  }) async {
    try {
      final UserModel user = UserModel(email: email, password: password);
      final http.Response response = await http.put(
        Uri.parse("$uri/api/auth/restore-password"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
        },
      );
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
    } catch (e) {
      debugPrint(e.toString());
      SnackBarFormat.show(context, e.toString());
    }
  }
}
