import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/extensions/to_clean_string.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/permission_service.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/linea_chart.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/tab_bar_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/deposit_menu_button.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/map_deposit.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/state_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> depositData;
  final int initialParameterIndex;

  const DetailScreen({
    super.key,
    required this.depositData,
    this.initialParameterIndex = 0,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int _selectedTabIndex;
  String _selectedFilter = "Dia";
  late final MapController _mapController;
  // Coordenadas del depósito
  late final double? _depositLatitude;
  late final double? _depositLongitude;

  static const List<Color> _sensorColors = [
    AppColor.parameterAqua,
    AppColor.parameterPH,
    AppColor.parameterTurbidity,
  ];

  static const List<String> _sensorTypes = ["HC-SR04", "PH-4502C", "TS300B"];

  static const List<String> _unitParameters = ["%", "pH", "NTU"];

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialParameterIndex.clamp(0, 2);
    _mapController = MapController();

    // Inicializar coordenadas del depósito desde los datos recibidos
    _depositLatitude = (widget.depositData["latitude"] as num?)?.toDouble();
    _depositLongitude = (widget.depositData["longitude"] as num?)?.toDouble();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionService.requestLocationPermission(context);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Verifica si el depósito tiene coordenadas válidas almacenadas.
  bool get _hasValidCoordinates =>
      _depositLatitude != null &&
      _depositLongitude != null &&
      _depositLatitude != 0.0 &&
      _depositLongitude != 0.0;

  /// Resuelve las coordenadas del depósito o devuelve CDMX como predeterminado.
  LatLng get _depositLocation => _hasValidCoordinates
      ? LatLng(_depositLatitude!, _depositLongitude!)
      : const LatLng(19.4326, -99.1332);

  @override
  Widget build(BuildContext context) {
    final depositData = widget.depositData;
    final depositName = depositData["name"] as String? ?? "";
    final ip = depositData["ip"] as String? ?? "";
    final depositLocation = _depositLocation;

    final labels = [
      context.l10n.sensor_nivel,
      context.l10n.sensor_ph,
      context.l10n.sensor_turbidez,
    ];

    return ScaffoldMain(
      titleAppBar: depositName.isNotEmpty
          ? depositName
          : context.l10n.pantalla_detalles_titulo,
      actions: [
        DepositMenuButton(
          depositData: depositData,
          onDepositDeleted: () => Navigator.pop(context),
          onDepositLeft: () => Navigator.pop(context),
        ),
      ],
      children: [
        // 1. Ubicación del depósito como widget general
        TextFormat(
          text: context.l10n.ubicacion_deposito,
          context: context,
          type: "subtitle",
        ),
        ContainerFormat(
          children: [
            AppSizedBox.height8,
            SizedBox(
              height: 220,
              width: double.infinity,
              child: MapDeposit(
                mapController: _mapController,
                depositLocation: depositLocation,
                depositName: depositName,
                interactive: true,
                showUserLocation: true,
              ),
            ),
            AppSizedBox.height8,
            if (_hasValidCoordinates)
              Padding(
                padding: AppPadding.symmetric0_8,
                child: TextFormat(
                  text:
                      "${_depositLatitude!.toStringAsFixed(4)}, ${_depositLongitude!.toStringAsFixed(4)}",
                  context: context,
                  type: "bodySecondary",
                ),
              ),
          ],
        ),
        AppSizedBox.height12,

        // 2. Filtro TabBarFormat para cambiar entre nivel, pH y turbidez
        TabBarFormat(
          labels: labels,
          selectedIndex: _selectedTabIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          activeColor: _sensorColors[_selectedTabIndex],
        ),
        AppSizedBox.height12,

        // 3. Detalle del sensor seleccionado (Estado, Umbrales, Filtros y Gráfico)
        Consumer<DepositProvider>(
          builder: (context, provider, child) {
            double currentLitters =
                (depositData["inputLevel"] as num?)?.toDouble() ?? 0.0;
            double currentPh =
                (depositData["inputPh"] as num?)?.toDouble() ?? 0.0;
            double currentTurbidity =
                (depositData["inputTurbidity"] as num?)?.toDouble() ?? 0.0;

            if (ip.isNotEmpty && provider.realTimeData.containsKey(ip)) {
              currentLitters =
                  provider.realTimeData[ip]!['level'] ?? currentLitters;
              currentPh = provider.realTimeData[ip]!['ph'] ?? currentPh;
              currentTurbidity =
                  provider.realTimeData[ip]!['turbidity'] ?? currentTurbidity;
            }

            final List<double> inputParameters = [
              currentLitters,
              currentPh,
              currentTurbidity,
            ];

            final double peakLevel =
                (depositData["peakLevel"] as num?)?.toDouble() ??
                (depositData["capacity"] as num?)?.toDouble() ??
                100.0;
            final double peakPh =
                (depositData["peakPh"] as num?)?.toDouble() ?? 14.0;
            final double peakTurbidity =
                (depositData["peakTurbidity"] as num?)?.toDouble() ?? 3000.0;
            final List<double> peakParameters = [
              peakLevel,
              peakPh,
              peakTurbidity,
            ];

            return _buildParameterDetail(
              context,
              index: _selectedTabIndex,
              currentValue: inputParameters[_selectedTabIndex],
              peakValue: peakParameters[_selectedTabIndex],
            );
          },
        ),
      ],
    );
  }

  Widget _buildParameterDetail(
    BuildContext context, {
    required int index,
    required double currentValue,
    required double peakValue,
  }) {
    final depositData = widget.depositData;
    final sensorType = _sensorTypes[index];
    final unit = _unitParameters[index];
    final color = _sensorColors[index];
    final maxY = index == 2 ? peakValue : const [100.0, 14.0, 0.0][index];

    double? minVal;
    double? maxVal;
    final sensors = depositData["sensors"];
    if (sensors is List) {
      for (final s in sensors) {
        final type = s is Map ? s["type"] : s.type;
        if (type == sensorType) {
          minVal = s is Map ? (s["min_value"] as num?)?.toDouble() : s.minValue;
          maxVal = s is Map ? (s["max_value"] as num?)?.toDouble() : s.maxValue;
          break;
        }
      }
    }

    final rangeMin = minVal?.toCleanString();
    final rangeMax = maxVal?.toCleanString();
    final stateText = StateParameters.show(context, currentValue, unit);

    final filters = [
      ("Dia", context.l10n.detalles_diario),
      ("Semana", context.l10n.detalles_semanal),
      ("Mes", context.l10n.detalles_mensual),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ContainerFormat(
                children: [
                  if (unit != "%") ...[
                    TextFormat(
                      text: context.l10n.dashboard_estado,
                      context: context,
                      type: "body",
                    ),
                    TextFormat(
                      text: stateText,
                      context: context,
                      type: "titleSmall",
                    ),
                  ] else ...[
                    TextFormat(
                      text: "${context.l10n.detalles_capacidad}:",
                      context: context,
                      type: "body",
                    ),
                    TextFormat(
                      text: "${peakValue.toCleanString()} L",
                      context: context,
                      type: "titleSmall",
                    ),
                  ],
                ],
              ),
            ),
            AppSizedBox.width8,
            Expanded(
              child: ContainerFormat(
                children: [
                  TextFormat(
                    alignCenter: true,
                    text: "${context.l10n.comun_umbrales}:",
                    context: context,
                    type: "body",
                  ),
                  TextFormat(
                    alignCenter: true,
                    text: unit != "NTU"
                        ? "${rangeMin ?? ""} - ${rangeMax ?? ""} $unit"
                        : "${rangeMax ?? ""} $unit",
                    context: context,
                    type: "titleSmall",
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSizedBox.height12,

        // Filtros Día, Semana, Mes
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < filters.length; i++) ...[
              if (i > 0) AppSizedBox.width8,
              FilterChipFormat(
                label: filters[i].$2,
                isSelected: _selectedFilter == filters[i].$1,
                onSelected: (_) {
                  if (_selectedFilter != filters[i].$1) {
                    setState(() => _selectedFilter = filters[i].$1);
                  }
                },
              ),
            ],
          ],
        ),
        AppSizedBox.height12,

        // Gráfico histórico
        LineaChart(
          key: ValueKey("$sensorType-$_selectedFilter"),
          depositId: depositData["id"] ?? "",
          sensorType: sensorType,
          color: color,
          maxY: maxY,
          unit: unit,
          selectedFilter: _selectedFilter,
        ),
      ],
    );
  }
}
