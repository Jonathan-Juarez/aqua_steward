import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_divider.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/snack_bar_format.dart';
import 'package:aqua_steward/core/widgets/switch_format.dart';
import 'package:flutter/material.dart';

class GenerateReportsScreen extends StatefulWidget {
  const GenerateReportsScreen({super.key});

  @override
  State<GenerateReportsScreen> createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  // Estado para el rango de fechas
  DateTimeRange? _selectedDateRange;

  // Estados de configuración de secciones
  bool _includeStats = true; // Min, Max, Avg
  String _statsChartType = 'Línea'; // Línea o Barra para estadísticas

  bool _includeCompliance = true; // Porcentaje cumplimiento (Pastel)
  bool _includeStability = false; // Estabilidad (Gauge) - Antes Desviación
  bool _includeAlerts = true; // Total alertas (Texto)
  bool _includeCriticalEvents = true; // Eventos críticos (Tabla)

  // Selector de Fechas
  Future<void> _pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColor.inactive,
              onPrimary: Colors.white,
              surface: AppColor.container,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: "Generar Reporte",
      children: [
        // Rango de Fechas
        Padding(
          padding: AppPadding.symmetric16_0,
          child: Text(
            "Periodo del reporte",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        GestureDetector(
          onTap: _pickDateRange,
          child: ContainerFormat(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const IconFormat(icon: AppIcon.calendarMonth),
                    AppSizedBox.width8,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedDateRange == null
                              ? "Seleccionar fechas"
                              : "${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (_selectedDateRange == null)
                          const Text(
                            "Toque para abrir calendario",
                            style: AppText.smallSecondary,
                          ),
                      ],
                    ),
                    const Spacer(),
                    AppIcon.arrowRight,
                  ],
                ),
              ),
            ],
          ),
        ),

        // Configuración de Métricas y Visualización
        Padding(
          padding: AppPadding.symmetric16_0,
          child: Text(
            "Métricas y Visualización",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        ContainerFormat(
          children: [
            // A. Estadísticas (Min, Max, Avg)
            SwitchFormat(
              title: "Estadísticas (Min, Max, Prom)",
              subtitle: "Visualización de tendencias",
              value: _includeStats,
              icon: AppIcon.analyticsOutlined,
              onChanged: (val) => setState(() => _includeStats = val),
            ),
            // Sub-selector de gráfico si está activo
            if (_includeStats)
              Padding(
                padding: const EdgeInsets.only(left: 56, bottom: 8),
                child: Row(
                  children: [
                    FilterChipFormat(
                      label: "Línea",
                      isSelected: _statsChartType == 'Línea',
                      onSelected: (val) =>
                          setState(() => _statsChartType = 'Línea'),
                    ),
                    FilterChipFormat(
                      label: "Barra",
                      isSelected: _statsChartType == 'Barra',
                      onSelected: (val) =>
                          setState(() => _statsChartType = 'Barra'),
                    ),
                  ],
                ),
              ),

            AppDivider.dv8,

            // B. Cumplimiento (Pastel)
            SwitchFormat(
              title: "Porcentaje de Cumplimiento",
              subtitle: "Gráfico de Pastel",
              value: _includeCompliance,
              icon: AppIcon.pieChartOutline,
              onChanged: (val) => setState(() => _includeCompliance = val),
            ),

            AppDivider.dv8,
            // C. Estabilidad (Gauge) - Antes Desviación
            SwitchFormat(
              title: "Estabilidad",
              subtitle: "Gráfico de Medidor (Gauge)",
              value: _includeStability,
              icon: AppIcon.speed,
              onChanged: (val) => setState(() => _includeStability = val),
            ),

            AppDivider.dv8,

            // D. Alertas Totales (Texto)
            SwitchFormat(
              title: "Total de Alertas",
              subtitle: "Resumen numérico",
              value: _includeAlerts,
              icon: AppIcon.notificationsActiveOutlined,
              onChanged: (val) => setState(() => _includeAlerts = val),
            ),

            AppDivider.dv8,

            // E. Eventos Críticos (Tabla)
            SwitchFormat(
              title: "Eventos Críticos",
              subtitle: "Tabla detallada de logs",
              value: _includeCriticalEvents,
              icon: AppIcon.tableChartOutlined,
              onChanged: (val) => setState(() => _includeCriticalEvents = val),
            ),
          ],
        ),

        AppSizedBox.height16,

        //  Botón Generar
        ButtonMain(
          label: "Generar PDF",
          onPressed: () {
            Navigator.pop(context);
            SnackBarFormat.show(context, "Generando reporte...");
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
