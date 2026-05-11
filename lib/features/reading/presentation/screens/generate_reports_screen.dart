import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_divider.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/switch_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class GenerateReportsScreen extends StatefulWidget {
  final Uint8List? chartImage;

  const GenerateReportsScreen({super.key, this.chartImage});

  @override
  State<GenerateReportsScreen> createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  // Estado para el rango de fechas
  DateTimeRange? _selectedDateRange;

  // Estados de configuración de secciones
  bool _includeStats = true; // Min, Max, Avg

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
      confirmText: context.l10n.comun_confirmar,
      cancelText: context.l10n.comun_cancelar,
      switchToCalendarEntryModeIcon: AppIcon.calendarMonth(
        color: AppColor.white,
      ),
      switchToInputEntryModeIcon: AppIcon.edit(color: AppColor.white),
    );
    // Se valida que el rango de fechas no sea nulo y se actualiza con el valor seleccionado.
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_reportes,
      children: [
        // Rango de Fechas
        TextFormat(
          text: context.l10n.reporte_periodo,
          context: context,
          type: "subtitle",
        ),
        ContainerListTile(
          title: context.l10n.reporte_seleccionar_fechas,
          subtitle: _selectedDateRange == null
              ? context.l10n.reporte_abrir_calendario
              : "${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}",
          icon: AppIcon.calendarMonth(context: context),
          onTap: _pickDateRange,
        ),

        // Configuración de Métricas y Visualización
        TextFormat(
          text: context.l10n.reporte_metricas,
          context: context,
          type: "subtitle",
        ),
        ContainerFormat(
          children: [
            // Estadísticas (Min, Max, Avg)
            SwitchFormat(
              title: context.l10n.reporte_estadisticas,
              subtitle: context.l10n.reporte_tendencias,
              value: _includeStats,
              icon: AppIcon.lineChart,
              onChanged: (val) => setState(() => _includeStats = val),
            ),

            AppDivider.dv8,

            // Cumplimiento (Pastel)
            SwitchFormat(
              title: context.l10n.reporte_cumplimiento,
              subtitle: context.l10n.reporte_grafico_pastel,
              value: _includeCompliance,
              icon: AppIcon.pieChartOutline,
              onChanged: (val) => setState(() => _includeCompliance = val),
            ),

            AppDivider.dv8,
            // Estabilidad (Gauge) - Antes Desviación
            SwitchFormat(
              title: context.l10n.reporte_estabilidad,
              subtitle: context.l10n.reporte_grafico_medidor,
              value: _includeStability,
              icon: AppIcon.speed,
              onChanged: (val) => setState(() => _includeStability = val),
            ),

            AppDivider.dv8,

            // Alertas Totales (Texto)
            SwitchFormat(
              title: context.l10n.reporte_total_alertas,
              subtitle: context.l10n.reporte_resumen_numerico,
              value: _includeAlerts,
              icon: AppIcon.notificationsActiveOutlined,
              onChanged: (val) => setState(() => _includeAlerts = val),
            ),

            AppDivider.dv8,

            // Eventos Críticos (Tabla)
            SwitchFormat(
              title: context.l10n.reporte_eventos_criticos,
              subtitle: context.l10n.reporte_tabla_logs,
              value: _includeCriticalEvents,
              icon: AppIcon.tableChartOutlined,
              onChanged: (val) => setState(() => _includeCriticalEvents = val),
            ),
          ],
        ),

        ButtonFormat(
          label: context.l10n.reporte_generar_pdf,
          onConfirm: () {
            // Datos de prueba, todavía se ingresarán los gráficos y valores importantes.
            Navigator.pushNamed(
              context,
              AppRouter.pdfPreview,
              arguments: {
                "filename": context.l10n.titulo_reporte_pdf,
                "dateRange": _selectedDateRange,
                "includeStats": _includeStats,
                "includeCompliance": _includeCompliance,
                "includeStability": _includeStability,
                "includeAlerts": _includeAlerts,
                "includeCriticalEvents": _includeCriticalEvents,
                "chartImage": _includeStats == true ? widget.chartImage : null,
              },
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
