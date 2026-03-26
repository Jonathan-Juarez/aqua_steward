import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/widgets/button_dynamic.dart';
import 'package:flutter/material.dart';

class DialogEmergent extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onPressed;
  final GlobalKey<FormState>? formKey;

  const DialogEmergent({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: AppBorder.all8),
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      content: content,
      actions: [
        ButtonDynamic(
          onPressed: () => Navigator.pop(context),
          label: "Cancelar",
        ),
        ButtonDynamic(onPressed: onPressed, label: "Aceptar", formKey: formKey),
      ],
    );
  }
}
