import 'dart:async';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class DialogEmergent extends StatefulWidget {
  final String title;
  final Widget content;
  final FutureOr<void> Function() onPressed;
  final GlobalKey<FormState>? formKey;

  const DialogEmergent({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
    this.formKey,
  });

  // Muestra el diálogo en pantalla y retorna el resultado al cerrarse.
  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(context: context, builder: (_) => this);
  }

  @override
  State<DialogEmergent> createState() => _DialogEmergentState();
}

class _DialogEmergentState extends State<DialogEmergent> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppBorder.all8),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: TextFormat(
          text: widget.title,
          type: "titleSmall",
          context: context,
        ),
        content: SingleChildScrollView(child: widget.content),
        actions: [
          ButtonFormat(
            type: "dialog",
            onCancel: () => Navigator.pop(context),
            onConfirm: () async {
              setState(() => _isLoading = true);
              try {
                await widget.onPressed();
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
            formKey: widget.formKey,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
