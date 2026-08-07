import 'package:aqua_steward/core/theme/app_safe.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/bottom_bar_format.dart';
import 'package:aqua_steward/core/widgets/exit_confirmation_scope.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/features/auth/presentation/screens/profile_screen.dart';
import 'package:aqua_steward/features/reading/presentation/screens/dashborad_screen.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pantalla principal que permite navegar horizontalmente (swipe) entre Dashboard y Perfil.
class MainNavigationScreen extends StatefulWidget {
  final Map<String, dynamic>? switchValues;
  const MainNavigationScreen({super.key, this.switchValues});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationScope(
      child: ScaffoldMain(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: [
            securePage(
              DashboardScreen(switchValues: widget.switchValues),
              onRefresh: () async {
                final token =
                    context.read<AuthProvider>().currentUser?.token ?? '';
                if (token.isNotEmpty) {
                  await context.read<DepositProvider>().getDeposits(token: token);
                }
              },
            ),
            securePage(const ProfileScreen()),
          ],
        ),
        bottomNavigationBar: BottomBarFormat(
          selectedIndex: _currentIndex,
          onTap: (index) => _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.ease,
          ),
        ),
      ),
    );
  }

  AppSafe securePage(Widget widget, {Future<void> Function()? onRefresh}) {
    return AppSafe(
      onRefresh: onRefresh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [widget, AppSizedBox.height12],
      ),
    );
  }
}
