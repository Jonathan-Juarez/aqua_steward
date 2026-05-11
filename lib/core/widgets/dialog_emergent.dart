import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class DialogEmergent extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onPressed;
  final GlobalKey<FormState>? formKey;
  final bool isLoading;

  const DialogEmergent({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
    this.formKey,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: AppBorder.all8),
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: TextFormat(text: title, type: "titleSmall", context: context),
      content: content,
      actions: [
        ButtonFormat(
          type: "dialog",
          onCancel: () => Navigator.pop(context),
          onConfirm: onPressed,
          formKey: formKey,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
