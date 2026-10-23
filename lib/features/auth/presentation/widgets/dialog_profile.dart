import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:flutter/material.dart';

class DialogProfile {
  // Diálogo para cambiar el nombre o apellido del usuario.
  static Future<dynamic> show({
    required BuildContext context,
    required String title,
    required Widget content,
    required GlobalKey<FormState> formkey,
    required TextEditingController controller,
    required Future<bool> Function() onConfirm,
  }) async {
    return DialogEmergent(
      title: context.l10n.perfil_cambiar_dialogo_titulo(title.toLowerCase()),
      content: content,
      formKey: formkey,
      onPressed: () async {
        final success = await onConfirm();
        if (success && context.mounted) {
          Navigator.pop(context);
        }
      },
    ).show(context);
  }
}
