import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:flutter/material.dart';

extension ResultHandler on BuildContext {
  bool processResult(Result result, {String? successMessage}) {
    if (result.isSuccess) {
      if (successMessage != null) {
        SnackBarFormat.show(this, successMessage);
      }
      return true;
    } else {
      // Muestra el error formateado que ya viene procesado desde manage_http_response.
      SnackBarFormat.show(this, result.error ?? "Ocurrió un error inesperado");
      return false;
    }
  }
}
