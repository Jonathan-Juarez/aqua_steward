import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:flutter/material.dart';

// Extension para procesar el resultado de una operación
extension ResultHandler on BuildContext {
  bool processResult(Result result, {String? successMessage}) {
    if (result.isSuccess) {
      if (successMessage != null) {
        SnackBarFormat(context: this, message: successMessage).show();
      }
      return true;
    } else {
      // Muestra el error formateado que ya viene procesado desde manage_http_response.
      SnackBarFormat(
        context: this,
        message: result.error ?? "Error",
        isError: true,
      ).show();
      return false;
    }
  }
}
