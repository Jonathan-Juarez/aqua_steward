import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/linea_chart.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/circular_progress_parameters.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/state_parameters.dart';
import 'package:aqua_steward/core/extensions/to_clean_string.dart';
import 'package:flutter/material.dart';

class DepositCard extends StatefulWidget {
  final Map<String, dynamic> depositData;
  final Widget menuWidget;

  const DepositCard({
    super.key,
    required this.depositData,
    required this.menuWidget,
  });

  @override
  State<DepositCard> createState() => _DepositCardState();
}

class _DepositCardState extends State<DepositCard> {
  int? _selectedParameterIndex;
  String _selectedFilter = "Dia";

  bool _isSensorActive(dynamic sensors, int index) {
    if (sensors == null || sensors is! List || index >= sensors.length) {
      return true;
    }
    final sensor = sensors[index];
    return (sensor is Map ? sensor["state"] : sensor.state) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final depositData = widget.depositData;

    double peakLevel = (depositData["peakLevel"] as num).toDouble();
    double peakPh = (depositData["peakPh"] as num).toDouble();
    double peakTurbidity = (depositData["peakTurbidity"] as num).toDouble();

    double inputLevel = (depositData["inputLevel"] as num).toDouble();
    double inputPh = (depositData["inputPh"] as num).toDouble();
    double inputTurbidity = (depositData["inputTurbidity"] as num).toDouble();

    List<String> parametersLabel = [
      context.l10n.sensor_nivel,
      context.l10n.sensor_ph,
      context.l10n.sensor_turbidez,
    ];

    List<double> peakParameters = [peakLevel, peakPh, peakTurbidity];
    List<double> imputParameters = [inputLevel, inputPh, inputTurbidity];
    List<String> unitParameters = ["%", "pH", "NTU"];

    // Contenedor general.
    return ContainerFormat(
      children: [
        // Header de tarjeta
        Padding(
          padding: AppPadding.symmetric0_8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormat(
                text: depositData["name"],
                context: context,
                type: "titleSmall",
              ),
              widget.menuWidget,
            ],
          ),
        ),

        // Barras de progreso de los parámetros activos.
        Padding(
          padding: AppPadding.symmetric0_8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int index = 0; index < parametersLabel.length; index++)
                if (_isSensorActive(depositData["sensors"], index))
                  Expanded(
                    child: InkWell(
                      borderRadius: AppBorder.all8,
                      onTap: () {
                        setState(() {
                          if (_selectedParameterIndex == index) {
                            _selectedParameterIndex = null;
                          } else {
                            _selectedParameterIndex = index;
                          }
                        });
                      },
                      child: Container(
                        decoration: _selectedParameterIndex == index
                            ? BoxDecoration(
                                border: Border.all(
                                  color: index == 0
                                      ? AppColor.parameterAqua
                                      : index == 1
                                      ? AppColor.parameterPH
                                      : AppColor.parameterTurbidity,
                                  width: 2.0,
                                ),
                                borderRadius: AppBorder.all8,
                              )
                            : null,
                        child: CircularProgressParameters(
                          index: index,
                          peakParameters: peakParameters,
                          imputParameters: imputParameters,
                          parametersLabel: parametersLabel,
                          unit: unitParameters,
                          depositData: depositData,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),

        // Detalle desplegado del parámetro seleccionado si continúa activo
        if (_selectedParameterIndex != null &&
            _isSensorActive(
              depositData["sensors"],
              _selectedParameterIndex!,
            )) ...[
          AppSizedBox.height12,
          _buildParameterDetail(context, _selectedParameterIndex!),
        ],
      ],
    );
  }

  Widget _buildParameterDetail(BuildContext context, int index) {
    final depositData = widget.depositData;

    final sensorType = ["HC-SR04", "PH-4502C", "TS300B"][index];
    final unit = ["%", "pH", "NTU"][index];
    final color = [
      AppColor.parameterAqua,
      AppColor.parameterPH,
      AppColor.parameterTurbidity,
    ][index];

    double peakLevel = (depositData["peakLevel"] as num).toDouble();
    double peakPh = (depositData["peakPh"] as num).toDouble();
    double peakTurbidity = (depositData["peakTurbidity"] as num).toDouble();

    double inputLevel = (depositData["inputLevel"] as num).toDouble();
    double inputPh = (depositData["inputPh"] as num).toDouble();
    double inputTurbidity = (depositData["inputTurbidity"] as num).toDouble();

    double currentInputValue = [inputLevel, inputPh, inputTurbidity][index];
    double peakValue = [peakLevel, peakPh, peakTurbidity][index];
    double maxY = [100.0, 14.0, peakTurbidity][index];

    double? minVal, maxVal;
    final sensors = depositData["sensors"];
    if (sensors != null && sensors is List) {
      final matching = sensors.where(
        (s) => (s is Map ? s["type"] : s.type) == sensorType,
      );
      final sensor = matching.isNotEmpty ? matching.first : null;
      if (sensor != null) {
        minVal = sensor is Map
            ? (sensor["min_value"] as num?)?.toDouble()
            : sensor.minValue;
        maxVal = sensor is Map
            ? (sensor["max_value"] as num?)?.toDouble()
            : sensor.maxValue;
      }
    }

    final rangeMin = minVal?.toCleanString();
    final rangeMax = maxVal?.toCleanString();
    final stateText = StateParameters.show(context, currentInputValue, unit);

    return Padding(
      padding: AppPadding.symmetric0_8,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ContainerFormat(
                  children: [
                    if (unit != "%") ...[
                      // Estado actual de los sensores.
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
                      text: unit != "NTU"
                          ? "${context.l10n.comun_umbrales}:"
                          : "${context.l10n.comun_umbrales}:",
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
          // Filtros temporales (Día, Semana, Mes)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterChipFormat(
                label: context.l10n.detalles_diario,
                isSelected: _selectedFilter == "Dia",
                onSelected: (value) {
                  if (_selectedFilter == "Dia") return;
                  setState(() {
                    _selectedFilter = "Dia";
                  });
                },
              ),
              AppSizedBox.width8,
              FilterChipFormat(
                label: context.l10n.detalles_semanal,
                isSelected: _selectedFilter == "Semana",
                onSelected: (value) {
                  if (_selectedFilter == "Semana") return;
                  setState(() {
                    _selectedFilter = "Semana";
                  });
                },
              ),
              AppSizedBox.width8,
              FilterChipFormat(
                label: context.l10n.detalles_mensual,
                isSelected: _selectedFilter == "Mes",
                onSelected: (value) {
                  if (_selectedFilter == "Mes") return;
                  setState(() {
                    _selectedFilter = "Mes";
                  });
                },
              ),
            ],
          ),

          AppSizedBox.height12,

          // Gráfico de Líneas
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
      ),
    );
  }
}
