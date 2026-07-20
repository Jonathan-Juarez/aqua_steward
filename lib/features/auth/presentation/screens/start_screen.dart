import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/core/widgets/exit_confirmation_scope.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoLogin();
    });
  }

  void _checkAutoLogin() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser != null) {
      Navigator.pushNamedAndRemoveUntil(context, AppRouter.dashboard, (route) => false);
      return;
    }
    final loggedIn = await authProvider.tryAutoLogin();
    if (loggedIn && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRouter.dashboard, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationScope(
      child: ScaffoldAccount(
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
