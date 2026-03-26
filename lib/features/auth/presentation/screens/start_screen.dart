import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/core/widgets/exit_confirmation_scope.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationScope(
      child: ScaffoldAccount(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonMain(
              label: 'Registrarse',
              onPressed: () => Navigator.pushNamed(context, AppRouter.signup),
            ),
            ButtonMain(
              label: 'Iniciar sesión',
              onPressed: () => Navigator.pushNamed(context, AppRouter.signin),
            ),
          ],
        ),
      ),
    );
  }
}
