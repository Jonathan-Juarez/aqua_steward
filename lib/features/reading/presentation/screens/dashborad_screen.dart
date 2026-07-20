import "dart:async";
import "package:aqua_steward/core/permissions/app_permission.dart";
import "package:aqua_steward/core/router/app_router.dart";
import "package:aqua_steward/core/error/result_handler.dart";
import "package:aqua_steward/core/theme/app_color.dart";
import "package:aqua_steward/core/widgets/button_format.dart";
import "package:aqua_steward/core/widgets/dialog_emergent.dart";
import "package:aqua_steward/core/widgets/snack_bar_format.dart";
import "package:aqua_steward/core/widgets/text_format.dart";
import "package:aqua_steward/core/theme/app_icon.dart";
import "package:aqua_steward/core/theme/app_sizedbox.dart";
import "package:aqua_steward/core/widgets/scaffold_main.dart";
import "package:aqua_steward/features/auth/presentation/providers/auth_provider.dart";
import "package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart";
import "package:aqua_steward/features/notification/presentation/providers/notification_provider.dart";
import "package:aqua_steward/features/reading/presentation/widgets/deposit_card.dart";
import "package:aqua_steward/features/reading/presentation/widgets/dialog_export_csv.dart";
import "package:aqua_steward/features/team/presentation/providers/team_provider.dart";
import "package:aqua_steward/core/services/notification_service.dart";
import "package:aqua_steward/core/widgets/menu_button_format.dart";
import "package:aqua_steward/core/widgets/exit_confirmation_scope.dart";
import "package:flutter/material.dart";
import "package:aqua_steward/core/extensions/l10n_extensions.dart";
import "package:provider/provider.dart";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  StreamSubscription? _dashboardMessageSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // addPostFrameCallback sirve para ejecutar código después de que el widget se ha construido. permite que aparezca el loading.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final token = authProvider.currentUser?.token ?? "";

      if (token.isNotEmpty) {
        // Inicializar notificaciones con el token del usuario actual
        context.read<NotificationProvider>().init(token);
        // Cargar invitaciones de equipo al inicio
        context.read<TeamProvider>().getInvitations(token: token);
        // Solicitar permisos de notificación
        NotificationService.instance.requestPermissions();
      }

      final provider = context.read<DepositProvider>();
      // Se verifica si la lista de depósitos está vacía y si no se está cargando. Es decir, que no se está obteniendo los depósitos.
      if (provider.deposits.isEmpty && !provider.isLoading) {
        if (token.isNotEmpty) provider.getDeposits(token: token);
      }

      // Escucha mensajes entrantes en tiempo real para refrescar invitaciones y depósitos
      _dashboardMessageSubscription = NotificationService
          .instance
          .onMessageReceived
          .listen((message) {
            final currentToken =
                context.read<AuthProvider>().currentUser?.token ?? "";
            if (currentToken.isNotEmpty) {
              // Refrescar invitaciones de equipo
              context.read<TeamProvider>().getInvitations(token: currentToken);
              // Refrescar depósitos si el push es de tipo equipo (expulsión o cambio de rol)
              final type = message.data["type"] ?? "";
              if (type == "team_removed" || type == "team_role_changed") {
                context.read<DepositProvider>().getDeposits(
                  token: currentToken,
                );
              }
            }
          });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dashboardMessageSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final authProvider = context.read<AuthProvider>();
      final token = authProvider.currentUser?.token ?? "";
      if (token.isNotEmpty) {
        // Refrescar depósitos e invitaciones cuando la app vuelve al primer plano
        context.read<DepositProvider>().getDeposits(token: token);
        context.read<TeamProvider>().getInvitations(token: token);
      }
    }
  }

  void _deleteDeposit(String depositId) async {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.currentUser?.token ?? "";

    // Ejecuta la eliminación del depósito y gestiona el feedback según el resultado.
    final result = await context.read<DepositProvider>().deleteDeposit(
      depositId: depositId,
      token: token,
    );
    if (mounted) {
      if (result.isSuccess) {
        // Notifica el éxito de la eliminación mediante un SnackBar.
        SnackBarFormat.show(context, context.l10n.snackbar_deposito_eliminado);
      } else {
        // Muestra un mensaje de error si la operación de borrado falló.
        SnackBarFormat.show(context, result.error ?? "Error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationScope(
      child: ScaffoldMain(
        children: [
          // Header: Botones de Acción
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormat(
                    text: context.l10n.titulo_dashboard,
                    context: context,
                    type: "title",
                  ),
                ),
                Consumer2<NotificationProvider, TeamProvider>(
                  builder: (context, notifProvider, teamProvider, _) {
                    // Guarda la cantidad total de notificaciones pendientes (alertas sin leer + invitaciones)
                    final unreadCount =
                        notifProvider.unreadCount +
                        teamProvider.invitations.length;
                    return Badge.count(
                      count: unreadCount,
                      // Solo se muestra si hay notificaciones sin leer o invitaciones pendientes.
                      isLabelVisible: unreadCount > 0,
                      backgroundColor: AppColor.error,
                      child: ButtonFormat(
                        type: "icon",
                        icon: AppIcon.notificationsOutlined(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onConfirm: () =>
                            Navigator.pushNamed(context, AppRouter.alerts),
                      ),
                    );
                  },
                ),
                ButtonFormat(
                  type: "icon",
                  icon: AppIcon.supportOutline(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onConfirm: () =>
                      Navigator.pushNamed(context, AppRouter.support),
                ),
              ],
            ),
          ),

          // Lista de Depósitos mediante Consumer para reaccionar a cambios en el provider.
          Consumer<DepositProvider>(
            builder: (context, provider, child) {
              // Muestra un indicador de carga circular mientras se obtienen los datos.
              if (provider.isLoading && provider.deposits.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Verifica si la lista cargada está vacía para dar feedback al usuario.
              if (provider.deposits.isEmpty) {
                return Column(
                  children: [
                    Image(
                      image: const AssetImage("assets/images/deposit.png"),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      width: 100,
                      height: 100,
                    ),
                    TextFormat(
                      text: context.l10n.dashboard_sin_depositos,
                      context: context,
                      type: "bodySecondary",
                    ),
                  ],
                );
              }

              final deposits = provider.deposits;

              // Construye la lista de depósitos con separadores estándar.
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: deposits.length,
                separatorBuilder: (context, index) => AppSizedBox.height12,
                itemBuilder: (context, index) {
                  // Mapeamos el objeto Deposit a la estructura que espera containerDeposit.
                  final deposit = deposits[index];
                  final ip = deposit.ip ?? "";
                  double currentLitters = 0.0;
                  double currentPh = 0.0;
                  double currentTurbidity = 0.0;

                  // Recupera los datos de sensores en tiempo real desde el mapa global del provider.
                  if (ip.isNotEmpty && provider.realTimeData.containsKey(ip)) {
                    currentLitters = provider.realTimeData[ip]!['level'] ?? 0.0;
                    currentPh = provider.realTimeData[ip]!['ph'] ?? 0.0;
                    currentTurbidity =
                        provider.realTimeData[ip]!['turbidity'] ?? 0.0;
                  }

                  // Prepara el mapa de datos del depósito.
                  final depositDataMap = {
                    "id": deposit.id,
                    "name": deposit.name,
                    "ip": ip,
                    "capacity": deposit.capacity,
                    "installation_height": deposit.installation_height,
                    "fill_gap": deposit.fill_gap,
                    "sensors": deposit.sensors,
                    "peakLevel": deposit.capacity,
                    "peakPh": 14.0,
                    "peakTurbidity": 3000,
                    "inputLevel": currentLitters,
                    "inputPh": currentPh,
                    "inputTurbidity": currentTurbidity,
                    "role": deposit.role,
                  };
                  return containerDeposit(context, depositDataMap);
                },
              );
            },
          ),
          AppSizedBox.height12,
        ],
      ),
    );
  }

  // Contenedor de depósito con los tres parámetros.
  Widget containerDeposit(
    BuildContext context,
    Map<String, dynamic> depositData,
  ) {
    return DepositCard(
      key: ValueKey(depositData["id"]),
      depositData: depositData,
      menuWidget: menuDeposit(context, depositData),
    );
  }

  Widget menuDeposit(BuildContext context, Map<String, dynamic> depositData) {
    final String role = depositData["role"] ?? "analyst";

    // Los items del menú se filtran automáticamente según los permisos del rol.
    final List<MenuItemModel> menuItems = [
      MenuItemModel(
        value: "members",
        icon: AppIcon.groups2Outlined,
        text: context.l10n.comun_miembros,
      ),
      if (RolePermissions.has(role, AppPermission.editThresholds))
        MenuItemModel(
          value: "thresholds",
          icon: AppIcon.dataThresholdingOutlined,
          text: context.l10n.comun_umbrales,
        ),
      if (RolePermissions.has(role, AppPermission.editDeposit))
        MenuItemModel(
          value: "edit",
          icon: AppIcon.edit(context: context),
          text: context.l10n.comun_deposito,
        ),
      MenuItemModel(
        value: "exportCsv",
        icon: AppIcon.download,
        text: context.l10n.reporte_exportar_csv,
      ),
      MenuItemModel(
        value: "generatePdf",
        icon: AppIcon.pdf,
        text: context.l10n.reporte_generar_pdf,
      ),
      if (RolePermissions.has(role, AppPermission.deleteDeposit))
        MenuItemModel(
          value: "delete",
          icon: AppIcon.deleteOutline,
          text: context.l10n.comun_eliminar,
          textStyle: "bodyRed",
        ),
      if (role != "owner")
        MenuItemModel(
          value: "leave",
          icon: AppIcon.deleteOutline,
          text: context.l10n.comun_abandonar,
          textStyle: "bodyRed",
        ),
    ];

    return MenuButtonFormat(
      items: menuItems,
      onSelected: (value) {
        // Mapa donde la clave es un String y el valor es una función.
        final Map<String, VoidCallback> action = {
          "exportCsv": () {
            DialogExportCsv.show(context: context, depositData: depositData);
          },
          "generatePdf": () {
            Navigator.pushNamed(context, AppRouter.generateReports);
          },
          "members": () {
            Navigator.pushNamed(
              context,
              AppRouter.members,
              arguments: {"depositId": depositData["id"]},
            );
          },
          "thresholds": () {
            Navigator.pushNamed(
              context,
              AppRouter.settingsThreshold,
              arguments: {"depositData": depositData},
            );
          },
          "edit": () {
            Navigator.pushNamed(
              context,
              AppRouter.addDeposit,
              arguments: {"depositData": depositData},
            );
          },
          "delete": () {
            setState(() {
              showDialog(
                context: context,
                builder: (context) => DialogEmergent(
                  title: context.l10n.dialogo_eliminar_titulo,
                  content: TextFormat(
                    text: context.l10n.dialogo_eliminar,
                    context: context,
                    type: "body",
                  ),
                  onPressed: () {
                    _deleteDeposit(depositData["id"]);
                    Navigator.pop(context);
                  },
                  formKey: null,
                  isLoading: false,
                ),
              );
            });
          },
          "leave": () async {
            final userId = context.read<AuthProvider>().currentUser?.id;
            final token = context.read<AuthProvider>().currentUser?.token ?? "";
            if (userId != null && token.isNotEmpty) {
              final result = await context.read<TeamProvider>().deleteMember(
                depositId: depositData["id"],
                userId: userId,
                token: token,
              );
              if (context.mounted) {
                context.processResult(
                  result,
                  successMessage: context.l10n.snackbar_abandonar_deposito,
                );
                if (result.isSuccess) {
                  // Refrescar depósitos
                  context.read<DepositProvider>().getDeposits(token: token);
                }
              }
            }
          },
        };

        // Si el value (string) se recibe en el mapa, se llama la función.
        action[value]?.call();
      },
    );
  }
}
