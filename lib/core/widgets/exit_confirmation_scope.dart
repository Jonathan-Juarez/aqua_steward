import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmationScope extends StatelessWidget {
  final Widget child;

  const ExitConfirmationScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        showDialog(
          context: context,
          builder: (context) => DialogEmergent(
            title: "¿Salir de la app?",
            content: TextFormat(
              text: "¿Estás seguro de que quieres salir de la aplicación?",
              context: context,
              type: "body",
            ),
            onPressed: () => SystemNavigator.pop(),
          ),
        );
      },
      child: child,
    );
  }
}
