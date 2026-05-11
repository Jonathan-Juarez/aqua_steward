import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/tab_bar_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/error/result_handler.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/features/auth/presentation/providers/auth_provider.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/features/team/presentation/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  // Estado de las pestañas (0: Alertas, 1: Invitaciones).
  int _currentTabIndex = 0;
  // Estado de los filtros (Tipos de alertas).
  late String _selectedType;

  // Se inicializa el filtro con el valor localizado "Todos"
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
    });
  }

  String get _token => context.read<AuthProvider>().currentUser?.token ?? "";

  void _loadInvitations() {
    if (_token.isNotEmpty) {
      context.read<TeamProvider>().getInvitations(token: _token);
    }
  }

  // Formato de fecha.
  static final DateFormat _dateFormat = DateFormat("d MMM yyyy, h:mm a");

  // Datos simulados de alertas
  final List<Map<String, dynamic>> _notifications = [
    {
      "id": 1,
      "title": "Nivel",
      "message": "El depósito está al 75% de su capacidad. ",
      "type": "Nivel",
      "icon": AppIcon.waterDrop,
      "date": DateTime.now(),
    },
    {
      "id": 2,
      "title": "Turbidez",
      "message": "Se ha superado el límite, actual 5 NTU.",
      "type": "Turbidez",
      "icon": AppIcon.water,
      "date": DateTime(2026, 3, 1, 12, 13),
    },
    {
      "id": 3,
      "title": "pH",
      "message": "El pH actual es 6.5, dentro del rango ideal.",
      "type": "pH",
      "icon": AppIcon.scienceRounded,
      "date": DateTime(2026, 2, 28, 11, 3),
    },
    {
      "id": 4,
      "title": "pH",
      "message": "Nivel de pH bajo (5.5). Requiere revisión.",
      "type": "pH",
      "icon": AppIcon.scienceRounded,
      "date": DateTime(2025, 12, 15, 10, 30),
    },
  ];

  // Lógica para filtrar la lista de alertas.
  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedType == context.l10n.alertas_filtro_todos) {
      return _notifications;
    }
    return _notifications
        .where((notif) => notif['type'] == _selectedType)
        .toList();
  }

  void _deleteAll() {
    setState(() {
      _notifications.clear();
    });
    SnackBarFormat.show(context, context.l10n.snackbar_alertas_eliminadas);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_alertas,
      children: [
        // Selector de pestaña principal.
        Padding(
          padding: AppPadding.symmetric16_0,
          child: TabBarFormat(
            labels: [
              context.l10n.alertas_filtro_alertas,
              context.l10n.alertas_filtro_invitaciones,
            ],
            selectedIndex: _currentTabIndex,
            onTabSelected: (index) => setState(() => _currentTabIndex = index),
            activeColor: AppColor.containerContrast,
          ),
        ),
        AppSizedBox.height8,
        // Filtros (Chips) y botón de eliminar (Solo visibles en la pestaña de Alertas).
        if (_currentTabIndex == 0)
          Padding(
            padding: AppPadding.symmetric16_0,
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChipFormat(
                          label: context.l10n.alertas_filtro_todos,
                          isSelected:
                              _selectedType ==
                              context.l10n.alertas_filtro_todos,
                          onSelected: (val) => setState(
                            () => _selectedType =
                                context.l10n.alertas_filtro_todos,
                          ),
                        ),
                        FilterChipFormat(
                          label: context.l10n.alertas_filtro_nivel,
                          isSelected:
                              _selectedType ==
                              context.l10n.alertas_filtro_nivel,
                          onSelected: (val) => setState(
                            () => _selectedType =
                                context.l10n.alertas_filtro_nivel,
                          ),
                        ),
                        FilterChipFormat(
                          label: context.l10n.alertas_filtro_ph,
                          isSelected:
                              _selectedType == context.l10n.alertas_filtro_ph,
                          onSelected: (val) => setState(
                            () =>
                                _selectedType = context.l10n.alertas_filtro_ph,
                          ),
                        ),
                        FilterChipFormat(
                          label: context.l10n.alertas_filtro_turbidez,
                          isSelected:
                              _selectedType ==
                              context.l10n.alertas_filtro_turbidez,
                          onSelected: (val) => setState(
                            () => _selectedType =
                                context.l10n.alertas_filtro_turbidez,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSizedBox.width8,
                ButtonFormat(
                  type: "icon",
                  onConfirm: _filteredNotifications.isNotEmpty
                      ? _deleteAll
                      : null,
                  icon: _filteredNotifications.isNotEmpty
                      ? AppIcon.deleteSweep()
                      : AppIcon.deleteSweep(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                ),
              ],
            ),
          ),

        // Lista de contenido.
        Consumer<TeamProvider>(
          builder: (context, teamProvider, _) {
            if (_currentTabIndex == 1) {
              return _buildInvitationsList(teamProvider);
            } else {
              return _buildAlertsList();
            }
          },
        ),
      ],
    );
  }

  // Lista de Invitaciones.
  Widget _buildInvitationsList(TeamProvider provider) {
    if (provider.isLoadingInvitations) {
      return const Center(heightFactor: 5, child: CircularProgressIndicator());
    }

    final invitations = provider.invitations;

    if (invitations.isEmpty) {
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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invitations.length,
      separatorBuilder: (_, _) => AppSizedBox.height12,
      itemBuilder: (_, index) => _buildInvitationCard(invitations[index]),
    );
  }

  // Lista de Alertas.
  Widget _buildAlertsList() {
    if (_filteredNotifications.isEmpty) {
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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredNotifications.length,
      separatorBuilder: (context, index) => AppSizedBox.height12,
      itemBuilder: (context, index) {
        final notif = _filteredNotifications[index];
        return Dismissible(
          key: Key(notif['id'].toString()),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            setState(() {
              _notifications.removeWhere((item) => item['id'] == notif['id']);
            });
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
            title: TextFormat(
              text: notif['title'],
              context: context,
              type: "titleSmall",
            ),
            subtitle: notif['message'],
            subsubtitle: _dateFormat.format(notif['date']),
            icon: notif['icon'],
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
      subtitle:
          "${context.l10n.alertas_invitacion_descripcion(depositName)} \n ${context.l10n.alertas_rol_asignado(filterRole(role))}",
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
