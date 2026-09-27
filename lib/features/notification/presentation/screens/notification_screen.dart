import "package:aqua_steward/core/theme/app_border.dart";
import "package:aqua_steward/core/theme/app_color.dart";
import "package:aqua_steward/core/theme/app_icon.dart";
import "package:aqua_steward/core/theme/app_padding.dart";
import "package:aqua_steward/core/widgets/dialog_emergent.dart";
import "package:aqua_steward/core/widgets/list_view_format.dart";
import "package:aqua_steward/core/widgets/button_format.dart";
import "package:aqua_steward/core/widgets/container_list_tile.dart";
import "package:aqua_steward/core/widgets/filter_chip_format.dart";
import "package:aqua_steward/core/widgets/scaffold_main.dart";
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

enum NotificationFilter { all, level, ph, turbidity, team }

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Filtro seleccionado actualmente.
  NotificationFilter _selectedFilter = NotificationFilter.all;

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

  Future<void> _onRefresh() async {
    if (_token.isNotEmpty) {
      await Future.wait([
        context.read<NotificationProvider>().fetchNotifications(_token),
        context.read<TeamProvider>().getInvitations(token: _token),
      ]);
    }
  }

  void _markAllAsRead() async {
    final provider = context.read<NotificationProvider>();
    if (provider.hasUnreadNotifications) {
      await provider.markNotificationsAsRead(_token);
    }
  }

  Widget _getIconForType(String type) {
    if (type == "pH") {
      return AppIcon.scienceRounded;
    } else if (type == "Turbidez") {
      return AppIcon.water;
    } else if (type == "team_removed" || type == "team_role_changed") {
      return AppIcon.groups2Outlined(context: context);
    } else {
      return AppIcon.waterDrop;
    }
  }

  Color? _getColor(String type) {
    if (type == "pH") {
      return AppColor.parameterPH;
    } else if (type == "Turbidez") {
      return AppColor.parameterTurbidity;
    } else if (type == "team_removed" || type == "team_role_changed") {
      return null;
    } else {
      return AppColor.parameterAqua;
    }
  }

  void _deleteAll() async {
    final result = await context
        .read<NotificationProvider>()
        .deleteAllNotifications(_token);
    if (!mounted) return;
    context.processResult(
      result,
      successMessage: context.l10n.snackbar_alertas_eliminadas,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifProvider = context.watch<NotificationProvider>();

    return ScaffoldMain(
      onRefresh: _onRefresh,
      titleAppBar: context.l10n.titulo_alertas,
      actions: [
        IconButton(
          onPressed: notifProvider.hasUnreadNotifications
              ? _markAllAsRead
              : null,
          icon: AppIcon.doneAll(
            color: notifProvider.hasUnreadNotifications
                ? AppColor.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          tooltip: context.l10n.alertas_marcar_leidas,
        ),
        IconButton(
          onPressed: notifProvider.notifications.isNotEmpty
              ? () => showDialog(
                  context: context,
                  builder: (dialogContext) => DialogEmergent(
                    title: context.l10n.dialogo_eliminar_alertas_titulo,
                    content: TextFormat(
                      text: context.l10n.dialogo_eliminar_alertas,
                      type: "body",
                      context: dialogContext,
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _deleteAll();
                    },
                  ),
                )
              : null,
          icon: AppIcon.deleteSweep(
            color: notifProvider.notifications.isNotEmpty
                ? AppColor.error
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          tooltip: context.l10n.alertas_eliminar_todas,
        ),
      ],
      children: [
        // Filtros (Chips).
        Padding(
          padding: AppPadding.symmetric16_0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipFormat(
                  label: context.l10n.alertas_filtro_todos,
                  isSelected: _selectedFilter == NotificationFilter.all,
                  onSelected: (val) =>
                      setState(() => _selectedFilter = NotificationFilter.all),
                ),
                FilterChipFormat(
                  label: context.l10n.alertas_filtro_nivel,
                  isSelected: _selectedFilter == NotificationFilter.level,
                  onSelected: (val) => setState(
                    () => _selectedFilter = NotificationFilter.level,
                  ),
                ),
                FilterChipFormat(
                  label: context.l10n.alertas_filtro_ph,
                  isSelected: _selectedFilter == NotificationFilter.ph,
                  onSelected: (val) =>
                      setState(() => _selectedFilter = NotificationFilter.ph),
                ),
                FilterChipFormat(
                  label: context.l10n.alertas_filtro_turbidez,
                  isSelected: _selectedFilter == NotificationFilter.turbidity,
                  onSelected: (val) => setState(
                    () => _selectedFilter = NotificationFilter.turbidity,
                  ),
                ),
                FilterChipFormat(
                  label: context.l10n.alertas_filtro_invitaciones,
                  isSelected: _selectedFilter == NotificationFilter.team,
                  onSelected: (val) =>
                      setState(() => _selectedFilter = NotificationFilter.team),
                ),
              ],
            ),
          ),
        ),

        // Lista unificada de notificaciones y equipo.
        Consumer2<TeamProvider, NotificationProvider>(
          builder: (context, teamProv, notifProv, _) {
            final List<Map<String, dynamic>> displayedInvitations;
            final List<Notification> displayedNotifications;

            switch (_selectedFilter) {
              case NotificationFilter.all:
                displayedInvitations = teamProv.invitations;
                displayedNotifications = notifProv.notifications;
                break;
              case NotificationFilter.team:
                displayedInvitations = teamProv.invitations;
                displayedNotifications = notifProv.notifications
                    .where(
                      (n) =>
                          n.type == "team_removed" ||
                          n.type == "team_role_changed",
                    )
                    .toList();
                break;
              case NotificationFilter.level:
                displayedInvitations = const [];
                displayedNotifications = notifProv.notifications
                    .where(
                      (n) =>
                          n.type == "Nivel" ||
                          n.type == "level" ||
                          n.type == context.l10n.alertas_filtro_nivel,
                    )
                    .toList();
                break;
              case NotificationFilter.ph:
                displayedInvitations = const [];
                displayedNotifications = notifProv.notifications
                    .where(
                      (n) =>
                          n.type == "pH" ||
                          n.type == "ph" ||
                          n.type == context.l10n.alertas_filtro_ph,
                    )
                    .toList();
                break;
              case NotificationFilter.turbidity:
                displayedInvitations = const [];
                displayedNotifications = notifProv.notifications
                    .where(
                      (n) =>
                          n.type == "Turbidez" ||
                          n.type == "turbidity" ||
                          n.type == context.l10n.alertas_filtro_turbidez,
                    )
                    .toList();
                break;
            }

            final totalCount =
                displayedInvitations.length + displayedNotifications.length;
            final isTeamOrAll =
                _selectedFilter == NotificationFilter.all ||
                _selectedFilter == NotificationFilter.team;
            final isLoading = isTeamOrAll
                ? (teamProv.isLoadingInvitations || notifProv.isLoading)
                : notifProv.isLoading;

            return ListViewFormat(
              isLoading: isLoading,
              emptyMessage: context.l10n.alertas_sin_notificaciones,
              emptyWidget: AppIcon.notificationsOffOutlined(context: context),
              itemCount: totalCount,
              itemBuilder: (context, index) {
                if (index < displayedInvitations.length) {
                  return _buildInvitationCard(displayedInvitations[index]);
                } else {
                  final notif =
                      displayedNotifications[index -
                          displayedInvitations.length];
                  return _buildNotificationCard(notif, notifProv);
                }
              },
            );
          },
        ),
      ],
    );
  }

  // Tarjeta unificada de Notificación (Alertas y Eventos de Equipo).
  Widget _buildNotificationCard(
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
        icon: _getIconForType(notif.type),
        color: _getColor(notif.type),
        showTrailing: false,
      ),
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
      icon: AppIcon.groups2Outlined(context: context),
      showTrailing: false,
      subsubtitle: ButtonFormat(
        type: "dialog",
        onCancel: () => rejectInvitation(depositId),
        onConfirm: () => acceptInvitation(depositId),
      ),
    );
  }

  void acceptInvitation(String depositId) async {
    if (depositId == "loading") return;
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
    if (depositId == "loading") return;
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
