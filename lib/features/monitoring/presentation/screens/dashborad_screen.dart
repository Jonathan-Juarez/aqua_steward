import "package:aqua_steward/controller/deposit_controller.dart";
import "package:aqua_steward/core/router/app_router.dart";
import "package:aqua_steward/core/theme/app_padding.dart";
import "package:aqua_steward/entity/deposit.dart";
import "package:aqua_steward/core/theme/app_divider.dart";
import "package:aqua_steward/core/theme/app_icon.dart";
import "package:aqua_steward/core/theme/app_sizedbox.dart";
import "package:aqua_steward/core/widgets/container_formart.dart";
import "package:aqua_steward/core/theme/app_color.dart";
import "package:aqua_steward/core/widgets/scaffold_main.dart";
import "package:aqua_steward/core/theme/app_text.dart";
import "package:aqua_steward/features/monitoring/presentation/widgets/circular_progress_parameters.dart";
import "package:aqua_steward/core/widgets/menu_button_format.dart";
import "package:aqua_steward/core/widgets/exit_confirmation_scope.dart";
import "package:flutter/material.dart";
import "package:aqua_steward/core/network/socket_service.dart";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<List<Deposit>>? _depositsFuture;
  final SocketService _socketService = SocketService();
  final Map<String, Map<String, double>> _realTimeData = {};

  @override
  void initState() {
    super.initState();
    _initSocket();
    _loadDeposits();
  }

  void _initSocket() async {
    await _socketService.connect((ip, type, value) {
      if (mounted) {
        setState(() {
          if (!_realTimeData.containsKey(ip)) {
            _realTimeData[ip] = {'level': 0.0, 'ph': 0.0, 'turbidity': 0.0};
          }
          _realTimeData[ip]![type] = value;
        });
      }
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  void _loadDeposits() {
    setState(() {
      _depositsFuture = DepositController().getDeposits(context: context).then((
        deposits,
      ) {
        for (var deposit in deposits) {
          if (deposit.ip != null && deposit.ip!.isNotEmpty) {
            _socketService.subscribeTo(deposit.ip!);
          }
        }
        return deposits;
      });
    });
  }

  void _deleteDeposit(String depositId) async {
    await DepositController().deleteDeposit(
      context: context,
      depositId: depositId,
    );
    _loadDeposits();
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
                  child: Text(
                    "Mis Depósitos",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                buttonIconNavigation(
                  context,
                  AppRouter.alerts,
                  AppIcon.notificationsOutlined,
                ),
                buttonIconNavigation(
                  context,
                  AppRouter.support,
                  AppIcon.supportOutline,
                ),
              ],
            ),
          ),

          // Lista de Depósitos
          FutureBuilder<List<Deposit>>(
            future: _depositsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Si no hay datos, se da un feedback que no hay depósitos.
                return const Column(
                  children: [
                    Image(
                      image: AssetImage("assets/images/deposit.png"),
                      color: AppColor.whiteSecondary,
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      "No hay depósitos agregados",
                      style: AppText.bodySecondary,
                    ),
                  ],
                );
              }

              final deposits = snapshot.data!;

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: deposits.length,
                separatorBuilder: (context, index) => AppSizedBox.height16,
                itemBuilder: (context, index) {
                  // Mapeamos el objeto Deposit a la estructura que espera containerDeposit
                  final deposit = deposits[index];
                  final ip = deposit.ip ?? "";
                  double currentLitters = 0.0;
                  double currentPh = 0.0;
                  double currentTurbidity = 0.0;

                  if (ip.isNotEmpty && _realTimeData.containsKey(ip)) {
                    currentLitters = _realTimeData[ip]!['level'] ?? 0.0;
                    currentPh = _realTimeData[ip]!['ph'] ?? 0.0;
                    currentTurbidity = _realTimeData[ip]!['turbidity'] ?? 0.0;
                  }

                  final dataDepositMap = {
                    "id": deposit.id,
                    "name": deposit.name,
                    "ip": ip, // Guardamos la IP para acciones
                    "peakLevel": deposit.capacity?.toDouble() ?? 1000.0,
                    "peakPh": 14.0, // Valor por defecto
                    "peakTurbidity": 5.0, // Valor por defecto
                    "inputLevel": currentLitters,
                    "inputPh": currentPh,
                    "inputTurbidity": currentTurbidity,
                  };
                  return containerDeposit(context, dataDepositMap);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Contenedor de depósito con los tres parámetros.
  Widget containerDeposit(
    BuildContext context,
    Map<String, dynamic> dataDeposit,
  ) {
    // Parseo seguro de datos a double para usarlos en pantallas y gráficas
    double peakLevel = (dataDeposit["peakLevel"] as num).toDouble();
    double peakPh = (dataDeposit["peakPh"] as num).toDouble();
    double peakTurbidity = (dataDeposit["peakTurbidity"] as num).toDouble();

    double inputLevel = (dataDeposit["inputLevel"] as num).toDouble();
    double inputPh = (dataDeposit["inputPh"] as num).toDouble();
    double inputTurbidity = (dataDeposit["inputTurbidity"] as num).toDouble();

    List<String> parametersLabel = ["Nivel", "pH", "Turbidez"];

    // Listas para el dashboard (barras de progreso)
    List<double> peakParameters = [peakLevel, peakPh, peakTurbidity];
    List<double> imputParameters = [inputLevel, inputPh, inputTurbidity];

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
                  Text(
                    dataDeposit["name"],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // Menú desplegable (...).
                  MenuButtonFormat(
                    items: [
                      MenuItemModel(
                        value: "members",
                        icon: AppIcon.groups2Outlined,
                        text: "Gestionar miembros",
                      ),
                      MenuItemModel(
                        value: "thresholds",
                        icon: AppIcon.dataThresholdingOutlined,
                        text: "Editar umbrales",
                      ),
                      MenuItemModel(
                        value: "edit",
                        icon: AppIcon.edit,
                        text: "Editar depósito",
                      ),
                      MenuItemModel(
                        value: "delete",
                        icon: AppIcon.deleteOutline,
                        text: "Eliminar",
                        textStyle: AppText.smallRed,
                      ),
                    ],
                    onSelected: (value) {
                      // Mapa donde la clave es el string y el valor es la función.
                      final Map<String, VoidCallback> action = {
                        "members": () {
                          Navigator.pushNamed(context, AppRouter.members);
                        },
                        "thresholds": () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.settingsThreshold,
                            arguments: {
                              "depositData": {
                                "name": dataDeposit["name"],
                                "ip": dataDeposit["ip"],
                              },
                            },
                          );
                        },
                        "edit": () {
                          Navigator.pushNamed(context, AppRouter.addDeposit);
                        },
                        "delete": () {
                          setState(() {
                            _deleteDeposit(dataDeposit["id"]);
                          });
                        },
                      };

                      // Si el value (string) se recibe en el mapa, se llama la función.
                      action[value]?.call();
                    },
                  ),
                ],
              ),
              AppDivider.dv24,

              // Barras de progreso de los parámetros.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(parametersLabel.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.parametersDetails,
                        arguments: {
                          "initialParameter": parametersLabel[index],
                          "depositData": dataDeposit,
                        },
                      ),
                      child: CircularProgressParameters(
                        index: index,
                        peakParameters: peakParameters,
                        imputParameters: imputParameters,
                        parametersLabel: parametersLabel,
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

  Widget buttonIconNavigation(BuildContext context, String screen, Icon icon) {
    return IconButton(
      onPressed: () => Navigator.pushNamed(context, screen),
      icon: icon,
    );
  }
}
