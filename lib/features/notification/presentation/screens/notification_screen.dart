import "package:aqua_steward/core/theme/app_border.dart";
import "package:aqua_steward/core/theme/app_color.dart";
import "package:aqua_steward/core/theme/app_icon.dart";
import "package:aqua_steward/core/theme/app_padding.dart";
import "package:aqua_steward/core/widgets/list_view_format.dart";
import "package:aqua_steward/core/widgets/button_format.dart";
import "package:aqua_steward/core/widgets/container_list_tile.dart";
import "package:aqua_steward/core/widgets/filter_chip_format.dart";
import "package:aqua_steward/core/widgets/scaffold_main.dart";
import "package:aqua_steward/core/widgets/snack_bar_format.dart";
import "package:aqua_steward/core/widgets/tab_bar_format.dart";
import "package:aqua_steward/core/widgets/text_format.dart";
import "package:aqua_steward/core/error/result_handler.dart";
import "package:aqua_steward/core/extensions/l10n_extensions.dart";
import "package:aqua_steward/features/auth/presentation/providers/auth_provider.dart";
import "package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart";
import "package:aqua_steward/features/notification/presentation/widgets/formater_time.dart";
import "package:aqua_steward/features/team/presentation/providers/team_provider.dart";
import "package:aqua_steward/features/notification/domain/entities/notification.dart";
import "package:aqua_steward/features/notification/presentation/providers/notification_provider.dart";
import "package:provider/provider.dart";
// Se oculta Notification para evitar conflictos de nombres.
import "package:flutter/material.dart" hide Notification;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Estado de las pestañas (0: Alertas, 1: Invitaciones).
  int _currentTabIndex = 0;
  // Estado de los filtros (Tipos de alertas).
  late String _selectedType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedType = context.l10n.alertas_filtro_todos;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInvitations();
      _loadNotifications();
    });
  }

  String get _token => context.read<AuthProvider>().currentUser?.token ?? "";

  void _loadInvitations() {
    if (_token.isNotEmpty) {
      context.read<TeamProvider>().getInvitations(token: _token);
    }
  }

  void _loadNotifications() async {
    if (_token.isNotEmpty) {
      final provider = context.read<NotificationProvider>();
      await provider.fetchNotifications(_token);
    }
  }

  void _markAllAsRead() async {
    final provider = context.read<NotificationProvider>();
    if (provider.hasUnreadNotifications) {
      await provider.markNotificationsAsRead(_token);
    }
  }

  Icon _getIconForType(String type) {
    if (type == "pH") {
      return AppIcon.scienceRounded;
    } else if (type == "Turbidez") {
      return AppIcon.water;
    } else {
      return AppIcon.waterDrop;
    }
  }

  List<Notification> _getFilteredNotifications(
    List<Notification> notifications,
  ) {
    // Excluir notificaciones de equipo en la pestaña de Alertas
    final sensorNotifications = notifications
        .where((n) => n.type != "team_removed" && n.type != "team_role_changed")
        .toList();
    if (_selectedType == context.l10n.alertas_filtro_todos) {
      return sensorNotifications;
    }
    return sensorNotifications
        .where((notif) => notif.type == _selectedType)
        .toList();
  }

  void _deleteAll() async {
    final result = await context
        .read<NotificationProvider>()
        .deleteAllNotifications(_token);
    if (!mounted) return;
    if (result.isSuccess) {
      SnackBarFormat(
        context: context,
        message: context.l10n.snackbar_alertas_eliminadas,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifProvider = context.watch<NotificationProvider>();
    final teamProvider = context.watch<TeamProvider>();
    final filteredNotifications = _getFilteredNotifications(
      notifProvider.notifications,
    );

    // Contar invitaciones pendientes + notificaciones de equipo activas
    final activeTeamNotifs = notifProvider.notifications
        .where(
          (n) =>
              (n.type == "team_removed" || n.type == "team_role_changed") &&
              n.state == "activa",
        )
        .length;
    final totalTeamCount = teamProvider.invitations.length + activeTeamNotifs;

    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_alertas,
      actions: [
        IconButton(
          onPressed: notifProvider.hasUnreadNotifications
              ? _markAllAsRead
              : null,
          icon: AppIcon.doneAll(
            color: notifProvider.hasUnreadNotifications
                ? AppColor.white
                : AppColor.blackSecondary,
          ),
          tooltip: context.l10n.alertas_marcar_leidas,
        ),
        IconButton(
          onPressed: filteredNotifications.isNotEmpty ? _deleteAll : null,
          icon: AppIcon.deleteSweep(
            color: filteredNotifications.isNotEmpty
                ? AppColor.error
                : Theme.of(context).colorScheme.inversePrimary,
          ),
          tooltip: context.l10n.alertas_eliminar_todas,
        ),
      ],
      children: [
        // Selector de pestaña principal.
        Padding(
          padding: AppPadding.symmetric16_0,
          child: TabBarFormat(
            labels: [
              context.l10n.alertas_filtro_alertas,
              totalTeamCount > 0
                  ? "${context.l10n.alertas_filtro_invitaciones} ($totalTeamCount)"
                  : context.l10n.alertas_filtro_invitaciones,
            ],
            selectedIndex: _currentTabIndex,
            onTabSelected: (index) => setState(() => _currentTabIndex = index),
            activeColor: AppColor.containerContrast,
          ),
        ),
        // Filtros (Chips) (Solo visibles en la pestaña de Alertas).
        if (_currentTabIndex == 0)
          Padding(
            padding: AppPadding.symmetric16_0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipFormat(
                    label: context.l10n.alertas_filtro_todos,
                    isSelected:
                        _selectedType == context.l10n.alertas_filtro_todos,
                    onSelected: (val) => setState(
                      () => _selectedType = context.l10n.alertas_filtro_todos,
                    ),
                  ),
                  FilterChipFormat(
                    label: context.l10n.alertas_filtro_nivel,
                    isSelected:
                        _selectedType == context.l10n.alertas_filtro_nivel,
                    onSelected: (val) => setState(
                      () => _selectedType = context.l10n.alertas_filtro_nivel,
                    ),
                  ),
                  FilterChipFormat(
                    label: context.l10n.alertas_filtro_ph,
                    isSelected: _selectedType == context.l10n.alertas_filtro_ph,
                    onSelected: (val) => setState(
                      () => _selectedType = context.l10n.alertas_filtro_ph,
                    ),
                  ),
                  FilterChipFormat(
                    label: context.l10n.alertas_filtro_turbidez,
                    isSelected:
                        _selectedType == context.l10n.alertas_filtro_turbidez,
                    onSelected: (val) => setState(
                      () =>
                          _selectedType = context.l10n.alertas_filtro_turbidez,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Lista de contenido.
        Consumer2<TeamProvider, NotificationProvider>(
          builder: (context, teamProvider, notificationProvider, _) {
            if (_currentTabIndex == 1) {
              return _buildTeamList(teamProvider, notificationProvider);
            } else {
              return _buildAlertsList(notificationProvider);
            }
          },
        ),
      ],
    );
  }

  // Lista combinada de Invitaciones y Eventos de Equipo.
  Widget _buildTeamList(
    TeamProvider teamProvider,
    NotificationProvider notifProvider,
  ) {
    if (teamProvider.isLoadingInvitations || notifProvider.isLoading) {
      return const Center(heightFactor: 5, child: CircularProgressIndicator());
    }

    final invitations = teamProvider.invitations;
    final teamNotifications = notifProvider.notifications
        .where((n) => n.type == "team_removed" || n.type == "team_role_changed")
        .toList();

    if (invitations.isEmpty && teamNotifications.isEmpty) {
      return Center(
        heightFactor: 5,
        child: Column(
          children: [
            AppIcon.notificationsOffOutlined(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            TextFormat(
              text: context.l10n.alertas_sin_invitaciones,
              context: context,
              type: "bodySecondary",
            ),
          ],
        ),
      );
    }

    return ListViewFormat(
      itemCount: invitations.length + teamNotifications.length,
      itemBuilder: (context, index) {
        if (index < invitations.length) {
          return _buildInvitationCard(invitations[index]);
        } else {
          final notif = teamNotifications[index - invitations.length];
          return _buildTeamNotificationCard(notif, notifProvider);
        }
      },
    );
  }

  Widget _buildTeamNotificationCard(
    Notification notif,
    NotificationProvider notifProvider,
  ) {
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        notifProvider.deleteNotification(notif.id, _token);
      },
      background: Container(
        decoration: BoxDecoration(
          borderRadius: AppBorder.all8,
          color: AppColor.error.withOpacity(0.2),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: AppIcon.deleteOutline,
      ),
      child: ContainerListTile(
        onTap: notif.state == "activa"
            ? () => notifProvider.markNotificationsAsRead(
                _token,
                notificationId: notif.id,
              )
            : null,
        title: Row(
          children: [
            TextFormat(text: notif.title, context: context, type: "titleSmall"),
            const Spacer(),
            notif.state == "activa"
                ? Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: AppColor.error,
                      shape: BoxShape.circle,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        subtitle: notif.message,
        subsubtitle: FormaterTime(
          dateTime: notif.date,
          context: context,
        ).format(),
        icon: AppIcon.groups2Outlined,
        showTrailing: false,
      ),
    );
  }

  // Lista de Alertas Reales.
  Widget _buildAlertsList(NotificationProvider provider) {
    if (provider.isLoading) {
      return const Center(heightFactor: 5, child: CircularProgressIndicator());
    }

    final filtered = _getFilteredNotifications(provider.notifications);

    if (filtered.isEmpty) {
      return Center(
        heightFactor: 5,
        child: Column(
          children: [
            AppIcon.notificationsOffOutlined(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            TextFormat(
              text: context.l10n.alertas_sin_notificaciones,
              context: context,
              type: "bodySecondary",
            ),
          ],
        ),
      );
    }

    return ListViewFormat(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final notif = filtered[index];
        return Dismissible(
          key: Key(notif.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            provider.deleteNotification(notif.id, _token);
          },
          background: Container(
            decoration: BoxDecoration(
              borderRadius: AppBorder.all8,
              color: AppColor.error.withOpacity(0.2),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: AppIcon.deleteOutline,
          ),
          child: ContainerListTile(
            onTap: notif.state == "activa"
                ? () => provider.markNotificationsAsRead(
                    _token,
                    notificationId: notif.id,
                  )
                : null,
            title: Row(
              children: [
                TextFormat(
                  text: notif.title,
                  context: context,
                  type: "titleSmall",
                ),
                const Spacer(),
                notif.state == "activa"
                    ? Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: AppColor.error,
                          shape: BoxShape.circle,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            subtitle: notif.message,
            subsubtitle: FormaterTime(
              dateTime: notif.date,
              context: context,
            ).format(),
            icon: _getIconForType(notif.type),
            showTrailing: false,
          ),
        );
      },
    );
  }

  // Tarjeta de invitación.
  Widget _buildInvitationCard(Map<String, dynamic> invitation) {
    final depositName = invitation["deposit_name"] ?? "";
    final role = invitation["role"] ?? "";
    final depositId = invitation["deposit_id"] ?? "";

    return ContainerListTile(
      title: TextFormat(
        text: context.l10n.alertas_invitacion_titulo,
        context: context,
        type: "titleSmall",
      ),
      subtitle: context.l10n.alertas_invitacion_descripcion(
        depositName,
        filterRole(role),
      ),
      icon: AppIcon.groups2Outlined,
      showTrailing: false,
      subsubtitle: ButtonFormat(
        type: "dialog",
        onCancel: () => rejectInvitation(depositId),
        onConfirm: () => acceptInvitation(depositId),
      ),
    );
  }

  void acceptInvitation(String depositId) async {
    final provider = context.read<TeamProvider>();
    final result = await provider.acceptInvitation(
      depositId: depositId,
      token: _token,
    );

    if (!mounted) return;
    final isSuccess = context.processResult(
      result,
      successMessage: context.l10n.snackbar_invitacion_aceptada,
    );
    if (isSuccess) {
      context.read<DepositProvider>().getDeposits(token: _token);
    }
  }

  void rejectInvitation(String depositId) async {
    final provider = context.read<TeamProvider>();
    final result = await provider.rejectInvitation(
      depositId: depositId,
      token: _token,
    );

    if (!mounted) return;
    context.processResult(
      result,
      successMessage: context.l10n.snackbar_invitacion_rechazada,
    );
  }

  String filterRole(String role) {
    return switch (role) {
      "owner" => context.l10n.miembros_rol_propietario,
      "admin" => context.l10n.miembros_rol_admin,
      "analyst" => context.l10n.miembros_rol_analista,
      _ => role,
    };
  }
}
