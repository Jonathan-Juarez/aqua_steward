import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:flutter/material.dart';

// Widget para mantener seguro y permitir scroll en la pantalla.
class AppSafe extends StatelessWidget {
  final Widget child;
  const AppSafe({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.symmetric0_16,
      child: SafeArea(
        // Bottom false para que el SafeArea no afecte el scroll. El top no se quita porque protege el notch de la pantalla.
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            //Se asegura que el contenido no se desborde en pantallas pequeñas.
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
