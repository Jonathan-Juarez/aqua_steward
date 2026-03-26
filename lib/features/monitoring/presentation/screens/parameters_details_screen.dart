import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/features/monitoring/presentation/widgets/registers_screen.dart';
import 'package:aqua_steward/features/monitoring/presentation/widgets/reports_screen.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/widgets/tab_bar_format.dart';
import 'package:flutter/material.dart';

class ParametersDetailsScreen extends StatefulWidget {
  final String initialParameter;
  final Map<String, dynamic> depositData;

  const ParametersDetailsScreen({
    super.key,
    required this.initialParameter,
    required this.depositData,
  });

  @override
  State<ParametersDetailsScreen> createState() =>
      _ParametersDetailsScreenState();
}

class _ParametersDetailsScreenState extends State<ParametersDetailsScreen> {
  int _selectedIndex = 0;

  // Variables de estado para los datos dinámicos
  late String _selectedFilterName;
  late Color _color;
  late Icon _icon;
  late String _label;
  late String _value;
  late String _asset;
  late String _unit;
  late double _MaxY;

  @override
  void initState() {
    super.initState();
    // Filtro y datos basados en el argumento inicial recibido
    if (widget.initialParameter.contains("Nivel")) {
      _selectedFilterName = "Nivel";
    } else if (widget.initialParameter.contains("pH")) {
      _selectedFilterName = "pH";
    } else {
      _selectedFilterName = "Turbidez";
    }

    // Inicializa la vista con el filtro seleccionado
    _updateFilterData(_selectedFilterName);
  }

  // Lógica para cambiar de sensor y actualizar datos dinámicos usando depositData
  void _updateFilterData(String filter) {
    // Extracción segura de datos dinámicos
    double peakLevel = (widget.depositData["peakLevel"] as num).toDouble();
    double peakTurbidity = (widget.depositData["peakTurbidity"] as num)
        .toDouble();

    double inputLevel = (widget.depositData["inputLevel"] as num).toDouble();
    double inputPh = (widget.depositData["inputPh"] as num).toDouble();
    double inputTurbidity = (widget.depositData["inputTurbidity"] as num)
        .toDouble();

    setState(() {
      _selectedFilterName = filter;
      switch (filter) {
        case "Nivel":
          _color = AppColor.parameterAqua;
          _icon = AppIcon.waterDrop;
          _label = "Nivel Actual (L)";
          _value = "${inputLevel.toInt()} / ${peakLevel.toInt()}";
          _asset = "assets/data/water_level.json";
          _unit = "L";
          _MaxY = peakLevel;
          break;
        case "pH":
          _color = AppColor.parameterPH;
          _icon = AppIcon.scienceRounded;
          _label = "pH Actual";
          _value = "$inputPh";
          _asset = "assets/data/water_ph.json";
          _unit = "pH";
          _MaxY = 14;
          break;
        case "Turbidez":
          _color = AppColor.parameterTurbidity;
          _icon = AppIcon.water;
          _label = "Turbidez Actual (NTU)";
          _value = "$inputTurbidity / $peakTurbidity";
          _asset = "assets/data/water_turbidity.json";
          _unit = "NTU";
          _MaxY = 10;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: "$_selectedFilterName de agua",
      children: [
        AppSizedBox.height16,

        // Filtro de Parámetros
        Row(
          children: [
            FilterChipFormat(
              label: "Nivel",
              isSelected: _selectedFilterName == "Nivel",
              onSelected: (value) => _updateFilterData("Nivel"),
            ),
            FilterChipFormat(
              label: "pH",
              isSelected: _selectedFilterName == "pH",
              onSelected: (value) => _updateFilterData("pH"),
            ),
            FilterChipFormat(
              label: "Turbidez",
              isSelected: _selectedFilterName == "Turbidez",
              onSelected: (value) => _updateFilterData("Turbidez"),
            ),
          ],
        ),

        AppSizedBox.height16,

        // Selector de Sección
        TabBarFormat(
          titles: const ["Registros", "Reportes"],
          selectedIndex: _selectedIndex,
          activeColor: _color,
          onTabSelected: (index) => setState(() => _selectedIndex = index),
        ),

        AppSizedBox.height24,

        // Contenido Dinámico
        _selectedIndex == 0
            ? RegistersScreen(
                // Key fuerza la reconstrucción del gráfico al cambiar de asset
                key: ValueKey(_asset),
                summaryLabel: _label,
                summaryValue: _value,
                color: _color,
                icon: _icon,
                maxY: _MaxY,
                unit: _unit,
                asset: _asset,
              )
            : ReportsScreen(titleParameter: "$_selectedFilterName de agua"),
      ],
    );
  }
}
