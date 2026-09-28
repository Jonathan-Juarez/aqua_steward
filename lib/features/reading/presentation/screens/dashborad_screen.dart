import "dart:async";
import "package:aqua_steward/core/router/app_router.dart";
import "package:aqua_steward/core/theme/app_color.dart";
import "package:aqua_steward/core/widgets/button_format.dart";

import "package:aqua_steward/core/widgets/text_format.dart";
import "package:aqua_steward/core/theme/app_icon.dart";
import "package:aqua_steward/core/widgets/list_view_format.dart";
import "package:aqua_steward/features/auth/presentation/providers/auth_provider.dart";
import "package:aqua_steward/features/reading/presentation/widgets/deposit_skeleton.dart";
import "package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart";
import "package:aqua_steward/features/notification/presentation/providers/notification_provider.dart";
import "package:aqua_steward/features/reading/presentation/widgets/deposit_card.dart";
import "package:aqua_steward/features/team/presentation/providers/team_provider.dart";
import "package:aqua_steward/core/services/notification_service.dart";
import "package:aqua_steward/features/reading/presentation/widgets/deposit_menu_button.dart";
import "package:flutter/material.dart";
import "package:aqua_steward/core/extensions/l10n_extensions.dart";
import "package:provider/provider.dart";

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? switchValues;
  const DashboardScreen({super.key, this.switchValues});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  StreamSubscription? _dashboardMessageSubscription;

  @override
  // Mantiene el estado del widget aunque se navegue a otra pantalla.
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
          .listen((_) {
            final currentToken =
                context.read<AuthProvider>().currentUser?.token ?? "";
            if (currentToken.isNotEmpty) {
              context.read<TeamProvider>().getInvitations(token: currentToken);
              context.read<DepositProvider>().getDeposits(token: currentToken);
            }
          });
    });
  }

  @override
  void dispose() {
    _dashboardMessageSubscription?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
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
              // Se consume el provider de notificaciones y de invitaciones para mostrar el número total de notificaciones pendientes.
              Consumer2<NotificationProvider, TeamProvider>(
                builder: (context, notifProvider, teamProvider, _) {
                  // Cantidad total de notificaciones pendientes (alertas sin leer + invitaciones)
                  final unreadCount =
                      notifProvider.unreadCount +
                      teamProvider.invitations.length;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ButtonFormat(
                        type: "icon",
                        icon: AppIcon.notificationsOutlined(context: context),
                        onConfirm: () =>
                            Navigator.pushNamed(context, AppRouter.alerts),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          top: 6,
                          right: 6,
                          // Se ignora el click del punto rojo para que el click sea en el botón.
                          child: IgnorePointer(
                            // Contador de notificaciones.
                            child: Container(
                              width: 20,
                              height: 20,
                              // El borde simula un espacio invisible alrededor del punto rojo.
                              decoration: BoxDecoration(
                                color: AppColor.error,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.background,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              // El FittedBox asegura que el texto se escale sin alterar el tamaño del contenedor.
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: TextFormat(
                                    text: unreadCount > 99
                                        ? '99+'
                                        : '$unreadCount',
                                    type: "bodySmallWhite",
                                    context: context,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        // Lista de Depósitos mediante Consumer para reaccionar a cambios en el provider.
        Consumer<DepositProvider>(
          builder: (context, provider, child) {
            final deposits = provider.deposits;

            return ListViewFormat(
              isLoading: provider.isLoading,
              skeletonItem: const DepositSkeleton(),
              emptyMessage: context.l10n.dashboard_sin_depositos,
              emptyWidget: Image(
                image: const AssetImage("assets/images/deposit.png"),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                width: 100,
                height: 100,
              ),
              itemCount: deposits.length,
              itemBuilder: (indexContext, index) {
                // Mapeamos el objeto Deposit a la estructura que espera containerDeposit.
                final deposit = deposits[index];
                final ip = deposit.ip ?? "";
                double currentLitters = 0.0;
                double currentPh = 0.0;
                double currentTurbidity = 0.0;

                // Recupera los datos de sensores en tiempo real desde el provider.
                final realTime = provider.getRealTimeDataForDeposit(
                  ip: ip,
                  id: deposit.id,
                );
                if (realTime != null) {
                  currentLitters = realTime['level'] ?? 0.0;
                  currentPh = realTime['ph'] ?? 0.0;
                  currentTurbidity = realTime['turbidity'] ?? 0.0;
                } else if (ip.isNotEmpty && provider.realTimeData.containsKey(ip)) {
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
                  "latitude": deposit.latitude,
                  "longitude": deposit.longitude,
                  "sensors": deposit.sensors?.map((s) => {
                    "type": s.type,
                    "state": s.state,
                    "unit": s.unit,
                    "min_value": s.minValue,
                    "max_value": s.maxValue,
                  }).toList(),
                  "peakLevel": deposit.capacity,
                  "peakPh": 14.0,
                  "peakTurbidity": 3000,
                  "inputLevel": currentLitters,
                  "inputPh": currentPh,
                  "inputTurbidity": currentTurbidity,
                  "role": deposit.role,
                };
                return DepositCard(
                  depositData: depositDataMap,
                  key: ValueKey(deposit.id),
                  menuWidget: DepositMenuButton(depositData: depositDataMap),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
