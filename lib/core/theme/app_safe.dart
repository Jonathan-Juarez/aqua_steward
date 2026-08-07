import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:flutter/material.dart';

// Widget para mantener seguro y permitir scroll en la pantalla.
class AppSafe extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const AppSafe({
    super.key,
    required this.child,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.symmetric0_16,
      child: SafeArea(
        // Bottom false para que el SafeArea no afecte el scroll. El top no se quita porque protege el notch de la pantalla.
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scrollContent = SingleChildScrollView(
              // Permitirá deslizar o refrescar siempre.
              physics: const AlwaysScrollableScrollPhysics(),
              // Se asegura que el contenido no se desborde en pantallas pequeñas.
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: child,
              ),
            );

            return onRefresh != null
                ? RefreshIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                    onRefresh: onRefresh!,
                    child: scrollContent,
                  )
                : scrollContent;
          },
        ),
      ),
    );
  }
}
