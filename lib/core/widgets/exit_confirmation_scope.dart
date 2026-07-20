import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
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
            title: context.l10n.dialogo_salida_titulo,
            content: TextFormat(
              text: context.l10n.dialogo_salida,
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
