import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class BadgeFormat extends StatelessWidget {
  final int unreadCount;
  final Widget child;

  const BadgeFormat({
    super.key,
    required this.unreadCount,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (unreadCount <= 0) return child;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: -4,
          right: -6,
          // Se ignora el click del punto rojo para que el click sea en el widget hijo.
          child: IgnorePointer(
            // Contador de notificaciones.
            child: Container(
              width: 18,
              height: 18,
              // El borde simula un espacio invisible alrededor del punto rojo.
              decoration: BoxDecoration(
                color: AppColor.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.containerContrast,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              // El FittedBox asegura que el texto se escale sin alterar el tamaño del contenedor.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: TextFormat(
                    text: unreadCount > 99 ? '99+' : '$unreadCount',
                    type: "bodySmallWhite",
                    context: context,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
