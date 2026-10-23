import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_breakpoint.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/widgets/bottom_bar_format.dart';
import 'package:aqua_steward/core/widgets/exit_confirmation_scope.dart';
import 'package:aqua_steward/core/widgets/side_bar_format.dart';
import 'package:aqua_steward/features/auth/presentation/screens/profile_screen.dart';
import 'package:aqua_steward/features/notification/presentation/providers/notification_provider.dart';
import 'package:aqua_steward/features/notification/presentation/screens/notification_screen.dart';
import 'package:aqua_steward/features/reading/presentation/screens/dashborad_screen.dart';
import 'package:aqua_steward/features/team/presentation/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pantalla principal que controla la navegación responsiva.
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
  void initState() {
    super.initState();
    // Carga inicial de notificaciones e invitaciones para el contador del badge.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
      context.read<TeamProvider>().getInvitations();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Cambia de página con animación al seleccionar una pestaña.
  void _handleSelectTab(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = AppBreakpoint.isTablet(context);
    final unreadCount =
        context.watch<NotificationProvider>().unreadCount +
        context.watch<TeamProvider>().invitations.length;

    final items = [
      BottomBarItem(
        icon: AppIcon.depositInactive,
        selectedIcon: AppIcon.depositActive,
        label: context.l10n.button_deposito,
      ),
      BottomBarItem(
        icon: AppIcon.notificationOutlined,
        selectedIcon: AppIcon.notification,
        label: context.l10n.titulo_alertas,
        badgeCount: unreadCount,
      ),
      BottomBarItem(
        icon: AppIcon.personOutlined(color: AppColor.whiteSecondary),
        selectedIcon: AppIcon.person,
        label: context.l10n.button_perfil,
      ),
    ];

    return ExitConfirmationScope(
      child: Scaffold(
        extendBody: true,
        body: Row(
          children: [
            if (isTablet)
              SideBarFormat(
                selectedIndex: _currentIndex,
                onPressed: _handleSelectTab,
                items: items,
              ),
            // La key mantiene el PageView al cambiar entre celular y tablet.
            Expanded(
              key: const ValueKey("pages"),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: [
                  DashboardScreen(switchValues: widget.switchValues),
                  const NotificationScreen(),
                  const ProfileScreen(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: isTablet
            ? null
            : BottomBarFormat(
                selectedIndex: _currentIndex,
                onPressed: _handleSelectTab,
                items: items,
              ),
      ),
    );
  }
}
