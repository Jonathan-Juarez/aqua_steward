import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/storage/secure_storage.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionStorage {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static bool _isHandlingExpired = false;

  // Maneja la expiración de sesión de forma global. Muestra un mensaje, destruye la sesión guardada y redirige al SigninScreen.
  static Future<void> handleSessionExpired([String? message]) async {
    if (_isHandlingExpired) return;
    _isHandlingExpired = true;

    debugPrint("[SessionStorage] Expiración de sesión detectada: $message");

    // Limpiar almacenamiento seguro inmediatamente
    await SecureStorage.clearSession();

    // Se programa la navegación y notificación para el siguiente frame seguro
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final context = navigatorKey.currentContext;
      if (context != null) {
        try {
          final authProvider = context.read<AuthProvider>();
          await authProvider.logout();
        } catch (e) {
          debugPrint(
            "[SessionStorage] Error al cerrar sesión en AuthProvider: $e",
          );
        }

        final msg =
            message ??
            "Error: Tu sesión ha expirado. Por favor, inicia sesión nuevamente.";
        SnackBarFormat(context: context, message: msg, isError: true).show();

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRouter.signin,
          (route) => false,
        );
      }
      _isHandlingExpired = false;
    });
  }
}
