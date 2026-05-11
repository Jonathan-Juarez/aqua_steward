import "package:aqua_steward/core/permissions/app_permission.dart";
import "package:aqua_steward/core/router/app_router.dart";
import "package:aqua_steward/core/theme/app_border.dart";
import "package:aqua_steward/core/theme/app_padding.dart";
import "package:aqua_steward/core/widgets/button_format.dart";
import "package:aqua_steward/core/widgets/snack_bar_format.dart";
import "package:aqua_steward/core/widgets/text_format.dart";
import "package:aqua_steward/core/theme/app_divider.dart";
import "package:aqua_steward/core/theme/app_icon.dart";
import "package:aqua_steward/core/theme/app_sizedbox.dart";
import "package:aqua_steward/core/widgets/container_formart.dart";
import "package:aqua_steward/core/widgets/scaffold_main.dart";
import "package:aqua_steward/features/auth/presentation/providers/auth_provider.dart";
import "package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart";
import "package:aqua_steward/features/reading/presentation/widgets/circular_progress_parameters.dart";
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

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // addPostFrameCallback sirve para ejecutar código después de que el widget se ha construido. permite que aparezca el loading.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DepositProvider>();
      // Se verifica si la lista de depósitos está vacía y si no se está cargando. Es decir, que no se está obteniendo los depósitos.
      if (provider.deposits.isEmpty && !provider.isLoading) {
        final authProvider = context.read<AuthProvider>();
        final token = authProvider.currentUser?.token ?? "";
        if (token.isNotEmpty) provider.getDeposits(token: token);
      }
    });
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
                buttonIconNavigation(
                  context,
                  AppRouter.alerts,
                  AppIcon.notificationsOutlined(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                buttonIconNavigation(
                  context,
                  AppRouter.support,
                  AppIcon.supportOutline(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
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
    // Parseo seguro de datos a double para usarlos en pantallas y gráficas
    double peakLevel = (depositData["peakLevel"] as num).toDouble();
    double peakPh = (depositData["peakPh"] as num).toDouble();
    double peakTurbidity = (depositData["peakTurbidity"] as num).toDouble();

    double inputLevel = (depositData["inputLevel"] as num).toDouble();
    double inputPh = (depositData["inputPh"] as num).toDouble();
    double inputTurbidity = (depositData["inputTurbidity"] as num).toDouble();

    // Nivel, pH y Turbidez.
    List<String> parametersLabel = [
      context.l10n.sensor_nivel,
      context.l10n.sensor_ph,
      context.l10n.sensor_turbidez,
    ];

    // Listas para el dashboard (barras de progreso)
    List<double> peakParameters = [peakLevel, peakPh, peakTurbidity];
    List<double> imputParameters = [inputLevel, inputPh, inputTurbidity];
    List<String> unitParameters = ["%", "pH", "NTU"];

    return ContainerFormat(
      children: [
        Padding(
          padding: AppPadding.symmetric0_8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de tarjeta
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormat(
                    text: depositData["name"],
                    context: context,
                    type: "titleSmall",
                  ),
                  menuDeposit(context, depositData),
                ],
              ),
              AppDivider.dv8,

              // Barras de progreso de los parámetros.
              Row(
                children: List.generate(parametersLabel.length, (index) {
                  return Expanded(
                    child: InkWell(
                      borderRadius: AppBorder.all8,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.registers,
                        arguments: {
                          "initialParameter": parametersLabel[index],
                          "depositData": depositData,
                        },
                      ),
                      child: CircularProgressParameters(
                        index: index,
                        peakParameters: peakParameters,
                        imputParameters: imputParameters,
                        parametersLabel: parametersLabel,
                        unit: unitParameters,
                        depositData: depositData,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget menuDeposit(BuildContext context, Map<String, dynamic> depositData) {
    final String role = depositData["role"] ?? "analyst";

    // Los items del menú se filtran automáticamente según los permisos del rol.
    final List<MenuItemModel> menuItems = [
      MenuItemModel(
        value: "members",
        icon: AppIcon.groups2Outlined,
        text: context.l10n.dashboard_menu_miembros,
      ),
      if (RolePermissions.has(role, AppPermission.editThresholds))
        MenuItemModel(
          value: "thresholds",
          icon: AppIcon.dataThresholdingOutlined,
          text: context.l10n.dashboard_menu_umbrales,
        ),
      if (RolePermissions.has(role, AppPermission.editDeposit))
        MenuItemModel(
          value: "edit",
          icon: AppIcon.edit(context: context),
          text: context.l10n.dashboard_menu_editar,
        ),
      if (RolePermissions.has(role, AppPermission.deleteDeposit))
        MenuItemModel(
          value: "delete",
          icon: AppIcon.deleteOutline,
          text: context.l10n.comun_eliminar,
          textStyle: "bodyRed",
        ),
    ];

    return MenuButtonFormat(
      items: menuItems,
      onSelected: (value) {
        // Mapa donde la clave es un String y el valor es una función.
        final Map<String, VoidCallback> action = {
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
              _deleteDeposit(depositData["id"]);
            });
          },
        };

        // Si el value (string) se recibe en el mapa, se llama la función.
        action[value]?.call();
      },
    );
  }

  Widget buttonIconNavigation(BuildContext context, String screen, Icon icon) {
    return ButtonFormat(
      type: "icon",
      onConfirm: () => Navigator.pushNamed(context, screen),
      icon: icon,
    );
  }
}
