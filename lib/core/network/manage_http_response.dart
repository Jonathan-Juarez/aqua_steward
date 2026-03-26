import "dart:convert";
import "package:aqua_steward/core/widgets/snack_bar_format.dart";
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";

void manageHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    // 200 OK sirve cuando la petición es exitosa.
    case 200:
      onSuccess();
      break;
    // 201 Created sirve cuando se crea un nuevo recurso.
    case 201:
      onSuccess();
      break;
    // 400 Bad request sirve cuando el usuario manda datos incorrectos.
    case 400:
      SnackBarFormat.show(context, json.decode(response.body)["message"]);
      break;
    // 404 Not found sirve cuando no se encuentra un recurso.
    case 404:
      SnackBarFormat.show(context, json.decode(response.body)["message"]);
      break;
    // 409 conflict sirve cuando ya existe un recurso.
    case 409:
      SnackBarFormat.show(context, json.decode(response.body)["message"]);
      break;
    // 500 Internal server error sirve cuando hay un error en el servidor.
    case 500:
      SnackBarFormat.show(context, json.decode(response.body)["error"]);
      break;
    default:
      debugPrint("Código de estado no manejado: ${response.statusCode}");
      debugPrint("Cuerpo de la respuesta: ${response.body}");
      try {
        final body = json.decode(response.body);
        SnackBarFormat.show(
          context,
          body["message"] ??
              body["error"] ??
              "Error desconocido: ${response.statusCode}",
        );
      } catch (_) {
        SnackBarFormat.show(
          context,
          "Error desconocido: ${response.statusCode}",
        );
      }
      break;
  }
}
