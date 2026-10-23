import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/extensions/to_clean_string.dart';
import 'package:aqua_steward/core/theme/app_breakpoint.dart';
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
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit_snapshot.dart';
import 'package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/deposit_menu_button.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/map_deposit.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/state_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final Deposit deposit;
  final int initialParameterIndex;

  const DetailScreen({
    super.key,
    required this.deposit,
    this.initialParameterIndex = 0,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int _selectedSensorIndex;
  String _selectedFilter = "Dia";
  late final MapController _mapController;

  static const List<Color> _sensorColors = [
    AppColor.parameterAqua,
    AppColor.parameterPH,
    AppColor.parameterTurbidity,
  ];

  @override
  void initState() {
    super.initState();
    _selectedSensorIndex = widget.initialParameterIndex.clamp(0, 2);
    _mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionService.requestLocationPermission(context);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final depositId = widget.deposit.id;
    final isTablet = AppBreakpoint.isTablet(context);

    // Solo se reconstruye si cambia el depósito, no con cada lectura en vivo.
    final Deposit deposit = context.select<DepositProvider, Deposit>(
      (provider) => provider.snapshotById(depositId)?.deposit ?? widget.deposit,
    );

    final depositName = deposit.name ?? "";
    final title = depositName.isNotEmpty
        ? depositName
        : context.l10n.pantalla_detalles_titulo;

    final snapshot = context.read<DepositProvider>().snapshotOf(deposit);
    final activeIndices = snapshot.activeSensorIndices;
    final currentSensorIndex = activeIndices.contains(_selectedSensorIndex)
        ? _selectedSensorIndex
        : activeIndices.first;

    return ScaffoldMain(
      titleAppBar: title,
      actions: [
        DepositMenuButton(
          deposit: deposit,
          onDepositDeleted: () => Navigator.pop(context),
          onDepositLeft: () => Navigator.pop(context),
        ),
      ],
      children: [
        if (isTablet)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _buildLocationSection(
                  context,
                  deposit: deposit,
                  isTablet: true,
                ),
              ),
              AppSizedBox.width16,
              Expanded(
                flex: 7,
                child: _buildSensorSection(
                  context,
                  snapshot: snapshot,
                  currentSensorIndex: currentSensorIndex,
                  isTablet: true,
                ),
              ),
            ],
          )
        else ...[
          _buildLocationSection(context, deposit: deposit, isTablet: false),
          AppSizedBox.height12,
          _buildSensorSection(
            context,
            snapshot: snapshot,
            currentSensorIndex: currentSensorIndex,
            isTablet: false,
          ),
        ],
      ],
    );
  }

  // Sección con el mapa interactivo y coordenadas del depósito
  Widget _buildLocationSection(
    BuildContext context, {
    required Deposit deposit,
    required bool isTablet,
  }) {
    final hasCoordinates = deposit.hasValidCoordinates;
    final location = hasCoordinates
        ? LatLng(deposit.latitude!, deposit.longitude!)
        : const LatLng(19.4326, -99.1332);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormat(
          text: context.l10n.ubicacion_deposito,
          context: context,
          type: "subtitle",
          alignCenter: true,
        ),
        ContainerFormat(
          children: [
            AppSizedBox.height8,
            SizedBox(
              height: isTablet ? 340 : 220,
              width: double.infinity,
              child: MapDeposit(
                mapController: _mapController,
                depositLocation: location,
                depositName: deposit.name ?? "",
                interactive: true,
                showUserLocation: true,
              ),
            ),
            AppSizedBox.height8,
            if (hasCoordinates)
              Padding(
                padding: AppPadding.symmetric0_8,
                child: TextFormat(
                  text:
                      "${deposit.latitude!.toStringAsFixed(4)}, ${deposit.longitude!.toStringAsFixed(4)}",
                  context: context,
                  type: "bodySecondary",
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Sección interactiva del sensor: barra de pestañas activas, métricas y gráfico
  Widget _buildSensorSection(
    BuildContext context, {
    required DepositSnapshot snapshot,
    required int currentSensorIndex,
    required bool isTablet,
  }) {
    final labels = [
      context.l10n.sensor_nivel,
      context.l10n.sensor_ph,
      context.l10n.sensor_turbidez,
    ];
    final activeIndices = snapshot.activeSensorIndices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormat(
          text: context.l10n.detalles_historial,
          context: context,
          type: "subtitle",
        ),
        // Filtro TabBarFormat con únicamente los sensores activos
        TabBarFormat(
          labels: activeIndices.map((i) => labels[i]).toList(),
          selectedIndex: activeIndices.indexOf(currentSensorIndex),
          onTabSelected: (tab) {
            setState(() {
              _selectedSensorIndex = activeIndices[tab];
            });
          },
          activeColor: _sensorColors[currentSensorIndex],
        ),
        AppSizedBox.height12,

        // Detalle del sensor seleccionado con datos en tiempo real
        Consumer<DepositProvider>(
          builder: (context, provider, child) {
            final live = provider.snapshotById(snapshot.deposit.id) ?? snapshot;
            return _buildParameterDetail(
              context,
              snapshot: live,
              index: currentSensorIndex,
            );
          },
        ),
      ],
    );
  }

  Widget _buildParameterDetail(
    BuildContext context, {
    required DepositSnapshot snapshot,
    required int index,
  }) {
    final sensorType = snapshot.sensorTypeAt(index);
    final unit = snapshot.unitAt(index);
    final currentValue = snapshot.valueAt(index);
    final peakValue = snapshot.peakAt(index);
    final sensor = snapshot.sensorAt(index);

    final rangeMin = sensor?.minValue?.toCleanString();
    final rangeMax = sensor?.maxValue?.toCleanString();
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
                  TextFormat(
                    alignCenter: true,
                    text: context.l10n.detalles_valor_actual,
                    context: context,
                    type: "body",
                  ),
                  TextFormat(
                    alignCenter: true,
                    text: "${currentValue.toCleanString()} $unit",
                    context: context,
                    type: "titleSmall",
                  ),
                ],
              ),
            ),
            AppSizedBox.width8,
            Expanded(
              child: ContainerFormat(
                children: [
                  if (unit != "%") ...[
                    TextFormat(
                      alignCenter: true,
                      text: context.l10n.dashboard_estado,
                      context: context,
                      type: "body",
                    ),
                    TextFormat(
                      alignCenter: true,
                      text: stateText,
                      context: context,
                      type: "titleSmall",
                    ),
                  ] else ...[
                    TextFormat(
                      alignCenter: true,
                      text: "${context.l10n.detalles_capacidad}:",
                      context: context,
                      type: "body",
                    ),
                    TextFormat(
                      alignCenter: true,
                      text: "${peakValue.toCleanString()} L",
                      context: context,
                      type: "titleSmall",
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        AppSizedBox.height8,
        ContainerFormat(
          children: [
            Padding(
              padding: AppPadding.all8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormat(
                    text: "${context.l10n.comun_umbrales}:",
                    context: context,
                    type: "body",
                  ),
                  TextFormat(
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
          depositId: snapshot.deposit.id ?? "",
          sensorType: sensorType,
          color: _sensorColors[index],
          maxY: snapshot.chartMaxAt(index),
          unit: unit,
          selectedFilter: _selectedFilter,
        ),
      ],
    );
  }
}
