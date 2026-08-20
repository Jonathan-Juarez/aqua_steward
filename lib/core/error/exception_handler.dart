import "package:http/http.dart" as http;
import "package:aqua_steward/core/error/result.dart";

// Manejador global para las excepciones que ocurren durante las peticiones HTTP.
Result<T> handleException<T>(Object e) {
  final errorString = e.toString();

  if (e is http.ClientException ||
      errorString.contains("SocketException") ||
      errorString.contains("Connection timed out") ||
      errorString.contains("Network is unreachable") ||
      errorString.contains("TimeoutException") ||
      errorString.contains("Failed host lookup")) {
    return Result.failure("Error de conexión al servidor.");
  }

  return Result.failure("Error: $errorString");
}
