import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Solicita el permiso de cámara y maneja los estados de rechazo permanente.
  /// Retorna `true` si fue concedido o `false` si fue denegado.
  static Future<bool> requestCameraPermission(BuildContext context) async {
    // Verificamos el estado actual
    PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    // Si no está concedido, solicitamos el permiso
    status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    }

    // Si el usuario marcó "No volver a preguntar" (denegado permanentemente)
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          "Permiso de cámara",
          "AquaSteward necesita acceder a tu cámara para escanear el QR del depósito.",
        );
      }
    }
    return false;
  }

  /// Solicita el permiso de notificaciones y maneja los estados de rechazo.
  static Future<bool> requestNotificationPermission(
    BuildContext context,
  ) async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    status = await Permission.notification.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          "Permiso de notificaciones",
          "Para recibir alertas importantes sobre tus sensores, habilita las notificaciones en la configuración.",
        );
      }
    }
    return false;
  }

  /// Muestra un cuadro de diálogo invitando al usuario a abrir la configuración nativa.
  static void _showSettingsDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder: (context) => DialogEmergent(
        title: title,
        content: TextFormat(text: content, type: "body", context: context),
        onPressed: () {
          Navigator.pop(context);
          openAppSettings(); // Abre la pantalla de permisos nativa (Android/iOS)
        },
      ),
    );
  }
}
