import "dart:convert";
import "package:aqua_steward/core/error/exception_handler.dart";
import "package:aqua_steward/core/error/result.dart";
import "package:aqua_steward/core/network/manage_http_response.dart";
import "package:http/http.dart" as http;
import "global_variable.dart";

// Cliente HTTP centralizado para simplificar y unificar las peticiones de red.
class ApiClient {
  // Cabeceras estándar inyectando el token si existe.
  static Map<String, String> _headers(String? token) => {
    "Content-Type": "application/json; charset=utf-8",
    if (token != null && token.isNotEmpty) "x-auth-token": token,
  };

  // Procesa la respuesta HTTP y transforma los datos según la función fromJson si fue provista.
  static Result<T> _processResponse<T>({
    required http.Response response,
    T Function(dynamic data)? fromJson,
  }) {
    final validation = manageHttpResponse(response: response);
    if (validation.isFailure) return Result.failure(validation.error);

    if (fromJson != null) {
      try {
        return Result.success(fromJson(json.decode(response.body)));
      } catch (e) {
        return Result.failure("Error al procesar la respuesta: $e");
      }
    }

    return Result.success(null as T);
  }

  // Ejecuta cualquier petición HTTP según el método indicado.
  static Future<Result<T>> _request<T>(
    String method,
    String endpoint, {
    Object? body,
    String? token,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final url = Uri.parse("$uri$endpoint");
      final headers = _headers(token);
      final encodedBody = body != null ? json.encode(body) : null;

      late final http.Response response;
      switch (method) {
        case "GET":
          response = await http.get(url, headers: headers);
        case "POST":
          response = await http.post(url, headers: headers, body: encodedBody);
        case "PUT":
          response = await http.put(url, headers: headers, body: encodedBody);
        case "DELETE":
          response = await http.delete(
            url,
            headers: headers,
            body: encodedBody,
          );
        default:
          return Result.failure("Método HTTP no soportado: $method");
      }

      return _processResponse<T>(response: response, fromJson: fromJson);
    } catch (e) {
      return handleException<T>(e);
    }
  }

  // Ejecuta una petición HTTP GET.
  static Future<Result<T>> get<T>(
    String endpoint, {
    String? token,
    T Function(dynamic data)? fromJson,
  }) => _request("GET", endpoint, token: token, fromJson: fromJson);

  // Ejecuta una petición HTTP POST.
  static Future<Result<T>> post<T>(
    String endpoint, {
    Object? body,
    String? token,
    T Function(dynamic data)? fromJson,
  }) =>
      _request("POST", endpoint, body: body, token: token, fromJson: fromJson);

  // Ejecuta una petición HTTP PUT.
  static Future<Result<T>> put<T>(
    String endpoint, {
    Object? body,
    String? token,
    T Function(dynamic data)? fromJson,
  }) => _request("PUT", endpoint, body: body, token: token, fromJson: fromJson);

  // Ejecuta una petición HTTP DELETE.
  static Future<Result<T>> delete<T>(
    String endpoint, {
    Object? body,
    String? token,
    T Function(dynamic data)? fromJson,
  }) => _request(
    "DELETE",
    endpoint,
    body: body,
    token: token,
    fromJson: fromJson,
  );
}
