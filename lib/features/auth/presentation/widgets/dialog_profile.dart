import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        // Se pasa el proveedor existente al diálogo mediante .value, ya que showDialog crea una nueva ruta.
        return ChangeNotifierProvider.value(
          value: context.read<AuthProvider>(),
          child: Consumer<AuthProvider>(
            builder: (providerContext, provider, _) {
              return DialogEmergent(
                title: context.l10n.perfil_cambiar_dialogo_titulo(
                  title.toLowerCase(),
                ),
                content: content,
                formKey: formkey,
                isLoading: provider.isLoading,
                onPressed: () async {
                  Navigator.of(providerContext).pop();
                  await onConfirm();
                },
              );
            },
          ),
        );
      },
    );
  }
}
