import 'package:aqua_steward/features/profile/presentation/widgets/dialog_emergent.dart';
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
            content: Text(
              "¿Estás seguro de que quieres salir de la aplicación?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () => SystemNavigator.pop(),
          ),
        );
      },
      child: child,
    );
  }
}
