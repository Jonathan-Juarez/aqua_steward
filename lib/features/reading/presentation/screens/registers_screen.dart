import "package:aqua_steward/core/router/app_router.dart";
import "package:aqua_steward/core/theme/app_color.dart";
import "package:aqua_steward/core/theme/app_icon.dart";
import "package:aqua_steward/core/theme/app_padding.dart";
import "package:aqua_steward/core/theme/app_sizedbox.dart";
import "package:aqua_steward/core/widgets/button_format.dart";
import "package:aqua_steward/core/widgets/container_formart.dart";
import "package:aqua_steward/core/widgets/filter_chip_format.dart";
import "package:aqua_steward/core/widgets/linea_chart.dart";
import "package:aqua_steward/core/widgets/scaffold_main.dart";
import "package:aqua_steward/core/widgets/text_format.dart";
import "package:aqua_steward/core/extensions/l10n_extensions.dart";
import "package:aqua_steward/features/deposit/presentation/providers/deposit_provider.dart";
import "package:provider/provider.dart";
import "package:screenshot/screenshot.dart";
import "package:flutter/material.dart";

class RegistersScreen extends StatefulWidget {
  final String initialParameter;
  final Map<String, dynamic> depositData;

  const RegistersScreen({
    super.key,
    required this.initialParameter,
    required this.depositData,
  });

  @override
  State<RegistersScreen> createState() => _RegistersScreenState();
}

class _RegistersScreenState extends State<RegistersScreen> {
  late String _currentParameter;

  // Variables de estado para los datos dinámicos
  late Color _color;
  late String _sensorType, _unit;
  String _selectedFilter = "Dia";
  late double _maxY, _peakValue;
  String? _rangeMin, _rangeMax;

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _currentParameter = widget.initialParameter;
    // Inicializa la vista con el filtro seleccionado
    _updateFilterData(_currentParameter);
  }

  // Lógica para cambiar de sensor y actualizar datos dinámicos usando depositData
  void _updateFilterData(String filter) {
    // Extraer rangos permitidos del sensor correspondiente
    double peakLevel = (widget.depositData["peakLevel"] as num).toDouble();
    double peakTurbidity = (widget.depositData["peakTurbidity"] as num)
        .toDouble();
    double peakPh = (widget.depositData["peakPh"] as num).toDouble();

    double? minVal, maxVal;
    final sensors = widget.depositData["sensors"];
    if (sensors != null && sensors is List) {
      final sensorType = switch (filter) {
        "Nivel" || "Level" => "HC-SR04",
        "pH" => "PH-4502C",
        "Turbidez" || "Turbidity" => "TS300B",
        _ => "",
      };

      // firstWhere para obtener el sensor correspondiente.
      final sensor = sensors.firstWhere(
        (sensor) =>
            (sensor is Map ? sensor["type"] : sensor.type) == sensorType,
      );

      minVal = sensor is Map
          ? (sensor["min_value"] as num?)?.toDouble()
          : sensor.minValue;
      maxVal = sensor is Map
          ? (sensor["max_value"] as num?)?.toDouble()
          : sensor.maxValue;
    }

    setState(() {
      _currentParameter = filter;
      _rangeMin = minVal?.toStringAsFixed(1);
      _rangeMax = maxVal?.toStringAsFixed(1);
      switch (filter) {
        case "Nivel" || "Level":
          _color = AppColor.parameterAqua;
          _peakValue = peakLevel;
          _sensorType = "HC-SR04";
          _unit = "%";
          _maxY = 100;
          break;
        case "pH":
          _color = AppColor.parameterPH;
          _peakValue = peakPh;
          _sensorType = "PH-4502C";
          _unit = "pH";
          _maxY = 14;
          break;
        case "Turbidez" || "Turbidity":
          _color = AppColor.parameterTurbidity;
          _peakValue = peakTurbidity;
          _sensorType = "TS300B";
          _unit = "NTU";
          _maxY = peakTurbidity;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar los datos en tiempo real usando DepositProvider
    final provider = context.watch<DepositProvider>();
    final ip = widget.depositData["ip"] ?? "";

    double inputLevel = (widget.depositData["inputLevel"] as num).toDouble();
    double inputPh = (widget.depositData["inputPh"] as num).toDouble();
    double inputTurbidity = (widget.depositData["inputTurbidity"] as num)
        .toDouble();

    if (ip.isNotEmpty && provider.realTimeData.containsKey(ip)) {
      inputLevel =
          (provider.realTimeData[ip]!["level"] as num?)?.toDouble() ??
          inputLevel;
      inputPh =
          (provider.realTimeData[ip]!["ph"] as num?)?.toDouble() ?? inputPh;
      inputTurbidity =
          (provider.realTimeData[ip]!["turbidity"] as num?)?.toDouble() ??
          inputTurbidity;
    }

    double currentInputValue = 0.0;
    switch (_currentParameter) {
      case "Nivel" || "Level":
        currentInputValue = inputLevel;
        break;
      case "pH":
        currentInputValue = inputPh;
        break;
      case "Turbidez" || "Turbidity":
        currentInputValue = inputTurbidity;
        break;
    }

    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_detalles_sensor(_currentParameter),
      children: [
        // Filtro de Parámetros
        Padding(
          padding: AppPadding.symmetric16_0,
          child: Row(
            children: [
              FilterChipFormat(
                label: context.l10n.sensor_nivel,
                isSelected: _currentParameter == context.l10n.sensor_nivel,
                onSelected: (value) =>
                    _updateFilterData(context.l10n.sensor_nivel),
              ),
              FilterChipFormat(
                label: context.l10n.sensor_ph,
                isSelected: _currentParameter == context.l10n.sensor_ph,
                onSelected: (value) =>
                    _updateFilterData(context.l10n.sensor_ph),
              ),
              FilterChipFormat(
                label: context.l10n.sensor_turbidez,
                isSelected: _currentParameter == context.l10n.sensor_turbidez,
                onSelected: (value) =>
                    _updateFilterData(context.l10n.sensor_turbidez),
              ),
            ],
          ),
        ),

        // Tarjeta de Resumen
        ContainerFormat(
          children: [
            TextFormat(
              text: _unit == "pH"
                  ? currentInputValue.toString()
                  : "${currentInputValue.toString()} $_unit",
              context: context,
            ),
            if (_unit != "%")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormat(text: "Estado: ", context: context, type: "body"),
                  TextFormat(
                    text: getBodyText(currentInputValue),
                    context: context,
                    type: "titleSmall",
                  ),
                  getBodyText(currentInputValue) != "Óptimo" &&
                          getBodyText(currentInputValue) != "Ideal" &&
                          getBodyText(currentInputValue) != "Aceptable"
                      ? AppIcon.warning
                      : AppIcon.success,
                ],
              ),
            if (_unit == "%")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormat(
                    text: "Capacidad total:",
                    context: context,
                    type: "body",
                  ),
                  AppSizedBox.width8,
                  TextFormat(
                    text: "${_peakValue.toStringAsFixed(0)} L",
                    context: context,
                    type: "titleSmall",
                  ),
                ],
              ),
          ],
        ),

        AppSizedBox.height12,

        ContainerFormat(
          children: [
            TextFormat(
              text: _unit != "NTU"
                  ? "Rango permitido: ${_rangeMin != null ? "$_rangeMin $_unit" : ""} - ${_rangeMax != null ? "$_rangeMax $_unit" : ""}"
                  : "Rango permitido: ${_rangeMax != null ? "$_rangeMax $_unit" : ""}",
              context: context,
              type: "body",
            ),
          ],
        ),

        AppSizedBox.height12,

        Row(
          children: [
            Text(
              context.l10n.detalles_historial,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),

            // Filtrador entre día, semana y mes.
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

        // Gráfico
        Screenshot(
          controller: _screenshotController,
          child: LineaChart(
            key: ValueKey("$_sensorType-$_selectedFilter"),
            depositId: widget.depositData["id"] ?? "",
            sensorType: _sensorType,
            color: _color,
            maxY: _maxY,
            unit: _unit,
            selectedFilter: _selectedFilter,
          ),
        ),

        // Botones para exportar CSV y generar reporte.
        Row(
          children: [
            Expanded(
              child: ButtonFormat(
                label: context.l10n.reporte_exportar_csv,
                icon: AppIcon.download,
                onConfirm: () {},
              ),
            ),
            AppSizedBox.width8,
            Expanded(
              child: ButtonFormat(
                label: context.l10n.reporte_generar_pdf,
                icon: AppIcon.pdf,
                onConfirm: () async {
                  final imageBytes = await _screenshotController.capture();
                  Navigator.pushNamed(
                    context,
                    AppRouter.generateReports,
                    arguments: imageBytes,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getBodyText(double inputValue) {
    if (_unit == "pH") {
      if (inputValue >= 0 && inputValue < 2) {
        return "Muy ácido";
      } else if (inputValue >= 2 && inputValue < 6.5) {
        return "Ácido";
      } else if (inputValue >= 6.5 && inputValue <= 8.5) {
        return "Óptimo";
      } else if (inputValue > 8.5 && inputValue <= 12) {
        return "Alcalino";
      } else {
        return "Muy alcalino";
      }
    }
    if (_unit == "NTU") {
      if (inputValue <= 1) {
        return "Ideal";
      } else if (inputValue <= 5) {
        return "Aceptable";
      } else if (inputValue <= 30) {
        return "Ligeramente turbio";
      } else if (inputValue <= 100) {
        return "Turbio";
      } else {
        return "Muy turbio";
      }
    }
    return "";
  }
}
