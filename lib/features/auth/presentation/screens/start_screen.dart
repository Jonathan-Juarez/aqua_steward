import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/exit_confirmation_scope.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationScope(
      child: ScaffoldMain.account(
        body: ContainerFormat(
          children: [
            ButtonFormat(
              padding: AppPadding.symmetric8_0,
              label: context.l10n.auth_registrarse,
              onConfirm: () => Navigator.pushNamed(context, AppRouter.signup),
            ),
            ButtonFormat(
              padding: AppPadding.symmetric8_0,
              label: context.l10n.auth_iniciar_sesion,
              onConfirm: () => Navigator.pushNamed(context, AppRouter.signin),
            ),
          ],
        ),
      ),
    );
  }
}
