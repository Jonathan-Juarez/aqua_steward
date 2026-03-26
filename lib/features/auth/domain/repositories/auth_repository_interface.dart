import 'package:flutter/material.dart';

abstract class IAuthRepository {
  /// Contrato para restablecer la contraseña en la capa de dominio.
  /// En una futura refactorización completa, 'context' debería abstraerse en UI.
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String password,
  });
}
