import 'dart:convert';
import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/network/global_variable.dart';
import 'package:aqua_steward/core/network/manage_http_response.dart';
import 'package:aqua_steward/core/error/exception_handler.dart';
import 'package:aqua_steward/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class IAuthDataSource {
  // Contrato para la petición de registro de usuario.
  Future<Result<void>> signup({
    required String name,
    required String lastName,
    required String email,
    required String password,
  });

  // Contrato para la petición de inicio de sesión. Retorna el UserModel construido o error.
  Future<Result<UserModel>> signin({
    required String email,
    required String password,
  });

  // Contrato para la petición de restablecimiento de contraseña.
  Future<Result<void>> resetPassword({
    required String email,
    required String password,
  });

  // Contrato para la petición de actualización de perfil.
  Future<Result<void>> update({
    required String id,
    String? name,
    String? lastName,
  });
}

class AuthDataSource implements IAuthDataSource {
  @override
  // Realiza el registro del usuario y retorna el resultado de la petición de red.
  Future<Result<void>> signup({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final UserModel user = UserModel(
      name: name,
      last_name: lastName,
      email: email,
      password: password,
    );

    try {
      // Ejecuta la petición HTTP POST al endpoint de registro con los datos del usuario.
      final http.Response response = await http.post(
        Uri.parse("$uri/api/auth/signup"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
        },
      );

      // Gestiona la respuesta del servidor mediante el manejador centralizado retornando Result.
      return manageHttpResponse(response: response);
    } catch (e) {
      // Captura excepciones de red o de parseo devolviendo un fallo en el Result.
      return handleException(e);
    }
  }

  @override
  // Ejecuta la petición de inicio de sesión y retorna el UserModel mapeado o el error.
  Future<Result<UserModel>> signin({
    required String email,
    required String password,
  }) async {
    final UserModel user = UserModel(email: email, password: password);

    try {
      // Realiza la petición HTTP POST al endpoint de autenticación codificada en JSON.
      final http.Response response = await http.post(
        Uri.parse("$uri/api/auth/signin"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
        },
      );

      // Procesa la respuesta para verificar el éxito de la autenticación.
      final result = manageHttpResponse(response: response);
      if (result.isSuccess) {
        // Decodifica la respuesta exitosa.
        final Map<String, dynamic> data = json.decode(response.body);

        // Maneja la lógica de mapeo condicional según la estructura del JSON recibido.
        late final UserModel authenticatedUser;
        if (data.containsKey('user')) {
          final userMap = Map<String, dynamic>.from(data['user']);
          // Inyecta el token dentro del mapa del usuario para una construcción completa.
          userMap['token'] = data['token'];
          authenticatedUser = UserModel.fromMap(userMap);
        } else {
          authenticatedUser = UserModel.fromMap(data);
        }

        return Result.success(authenticatedUser);
      } else {
        // Retorna el mensaje de error capturado por manageHttpResponse.
        return Result.failure(result.error);
      }
    } catch (e) {
      // Maneja errores inesperados durante el flujo de inicio de sesión.
      return handleException(e);
    }
  }

  @override
  // Invocación a la petición de red para el restablecimiento de contraseña.
  Future<Result<void>> resetPassword({
    required String email,
    required String password,
  }) async {
    final UserModel user = UserModel(email: email, password: password);

    try {
      // Ejecuta la petición HTTP PUT para actualizar la contraseña en el servidor.
      final http.Response response = await http.put(
        Uri.parse("$uri/api/auth/restore-password"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
        },
      );

      // Valida el código de estado de la respuesta del servidor mediante Result.
      return manageHttpResponse(response: response);
    } catch (e) {
      // Retorna el error capturado en caso de fallo en la conexión.
      return handleException(e);
    }
  }

  @override
  // Actualiza los datos de perfil del usuario a través de una petición HTTP PUT.
  Future<Result<void>> update({
    required String id,
    String? name,
    String? lastName,
  }) async {
    final UserModel user = UserModel(name: name, last_name: lastName);

    try {
      // Realiza la petición de actualización inyectando el ID y los datos modificados.
      final http.Response response = await http.put(
        Uri.parse("$uri/api/auth/update-user"),
        body: json.encode({"id": id, "data": user.toMap()}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=utf-8",
        },
      );

      // Delega la validación de la respuesta al manejador de respuestas centralizado.
      return manageHttpResponse(response: response);
    } catch (e) {
      // Captura y retorna cualquier error ocurrido durante la actualización de perfil.
      return handleException(e);
    }
  }
}
