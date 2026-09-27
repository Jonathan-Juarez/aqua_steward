import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  // Solicita el permiso de notificaciones y maneja los estados de rechazo.
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

  // Solicita el permiso de ubicación y maneja los estados de rechazo.
  static Future<bool> requestLocationPermission(
    BuildContext context,
  ) async {
    PermissionStatus status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      return true;
    }

    status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(
          context,
          "Permiso de ubicación",
          "Para mostrar tu posición respecto al depósito en el mapa, habilita la ubicación en la configuración.",
        );
      }
    }
    return false;
  }

  // Muestra un cuadro de diálogo invitando al usuario a abrir la configuración nativa.
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
