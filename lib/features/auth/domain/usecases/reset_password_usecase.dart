import 'package:aqua_steward/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutter/material.dart';

/// Caso de Uso que encapsula exclusivamente el reestablecimiento de contraseñas.
class ResetPasswordUseCase {
  final IAuthRepository Irepository;

  ResetPasswordUseCase(this.Irepository);

  /// Ejecuta la acción en el repositorio invocando los parámetros requeridos.
  Future<void> call({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    return Irepository.resetPassword(
      context: context,
      email: email,
      password: password,
    );
  }
}
