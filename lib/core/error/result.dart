// Representa el resultado de una operación (exitosa o fallida).
class Result<T> {
  // Contiene los datos resultantes en caso de éxito.
  final T? data;
  // Almacena el mensaje de error en caso de fallo.
  final String? error;

  // Crea una instancia de éxito con los datos.
  Result.success(this.data) : error = null;
  // Crea una instancia de fallo con el mensaje de error.
  Result.failure(this.error) : data = null;

  // Retorna verdadero si la operación fue exitosa.
  bool get isSuccess => error == null;
  // Retorna verdadero si la operación falló.
  bool get isFailure => error != null;
}
