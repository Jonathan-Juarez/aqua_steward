import "dart:convert";
import "package:aqua_steward/core/error/result.dart";
import 'package:http/http.dart' as http;

// Gestiona la respuesta HTTP y retorna un objeto Result con éxito o el mensaje de error procesado.
Result<void> manageHttpResponse({required http.Response response}) {
  switch (response.statusCode) {
    // 200 OK sirve cuando la petición es exitosa.
    case 200:
    // 201 Created sirve cuando se crea un nuevo recurso.
    case 201:
      // Retorna éxito sin datos adicionales al ser un código de éxito estándar.
      return Result.success(null);
    // 400 Bad request sirve cuando el usuario manda datos incorrectos.
    case 400:
    // 403 Forbidden sirve cuando el usuario no tiene permiso para realizar la acción.
    case 403:
    // 404 Not Found sirve cuando el recurso solicitado no existe.
    case 404:
    // 409 Conflict sirve cuando el recurso ya existe.
    case 409:
    // 401 Unauthorized sirve cuando el usuario no tiene autorización.
    case 401:
      try {
        final body = json.decode(response.body);
        // Extrae el mensaje de error del cuerpo de la respuesta para el fallo del Result.
        return Result.failure(
          body["errors"]?[0]["message"] ??
              body["message"] ??
              body["msg"] ??
              body["error"] ??
              "Error en la petición",
        );
      } catch (_) {
        // Retorna un error genérico si el cuerpo de la respuesta no es un JSON válido.
        return Result.failure("Error en la petición: ${response.statusCode}");
      }
    // 500 Internal server error sirve cuando hay un error en el servidor.
    case 500:
      try {
        final body = json.decode(response.body);
        return Result.failure(
          body["errors"]?[0]["message"] ??
              body["error"] ??
              "Error interno del servidor",
        );
      } catch (_) {
        // Retorna error interno por defecto si falla el parseo.
        return Result.failure("Error interno del servidor");
      }
    default:
      try {
        final body = json.decode(response.body);
        // Gestiona códigos de estado no contemplados explícitamente intentando leer el mensaje.
        return Result.failure(
          body["errors"]?[0]["message"] ??
              body["message"] ??
              body["error"] ??
              "Error desconocido: ${response.statusCode}",
        );
      } catch (_) {
        // Retorna error desconocido con el código de estado como última instancia.
        return Result.failure("Error desconocido: ${response.statusCode}");
      }
  }
}
