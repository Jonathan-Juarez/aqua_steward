import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/container_list_tile.dart';
import 'package:aqua_steward/core/widgets/linea_chart.dart';
import 'package:aqua_steward/core/widgets/list_view_format.dart';
import 'package:aqua_steward/core/widgets/menu_button_format.dart';
import 'package:aqua_steward/core/widgets/scaffold_main.dart';
import 'package:aqua_steward/core/widgets/switch_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/features/deposit/presentation/widgets/slider_format.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:aqua_steward/core/widgets/responsive_grid.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';
import 'package:aqua_steward/features/deposit/domain/entities/sensor.dart';
import 'package:aqua_steward/features/reading/domain/entities/report_stats.dart';
import 'package:aqua_steward/features/reading/presentation/providers/reading_provider.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  final Deposit? deposit;

  const ReportsScreen({super.key, this.deposit});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // Llaves para capturar cada gráfico
  final GlobalKey _chartKeyLevel = GlobalKey();
  final GlobalKey _chartKeyPh = GlobalKey();
  final GlobalKey _chartKeyTurbidity = GlobalKey();

  // Estado para el filtro (Día, Semana, Mes)
  String _selectedFilter = "Dia";
  bool _isCapturing = false;

  // Estados de configuración de secciones
  bool _includeStats = false; // Tendencias de sensores (Gráficos)
  bool _includeCompliance = false; // Porcentaje cumplimiento
  bool _includeCriticalEvents = false; // Eventos críticos (Tabla + Resumen)
  double _limitCriticalEvents = 50;

  bool _isSensorActive(String sensorType) {
    return widget.deposit?.isSensorActive(sensorType) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMain(
      titleAppBar: context.l10n.titulo_reportes,
      children: [
        // Selector de Rango de Fecha (Día, Semana, Mes)
        TextFormat(
          text: context.l10n.reporte_periodo,
          context: context,
          type: "subtitle",
        ),
        MenuButtonFormat(
          items: [
            MenuItemModel(value: "Dia", text: context.l10n.reporte_filtro_dia),
            MenuItemModel(
              value: "Semana",
              text: context.l10n.reporte_filtro_semana,
            ),
            MenuItemModel(value: "Mes", text: context.l10n.reporte_filtro_mes),
          ],
          onSelected: (val) {
            setState(() => _selectedFilter = val);
          },
          child: ContainerListTile(
            title: context.l10n.reporte_seleccionar_fecha,
            subtitle: _selectedFilter,
            icon: AppIcon.calendarMonth(
              color: Theme.of(context).colorScheme.onSurface,
              context: context,
            ),
          ),
        ),

        // Configuración de Métricas y Visualización
        TextFormat(
          text: context.l10n.reporte_metricas,
          context: context,
          type: "subtitle",
        ),
        ListViewFormat(
          itemCount: 3,
          itemBuilder: (context, index) => ContainerFormat(
            children: [
              SwitchFormat(
                title: [
                  context.l10n.reporte_estadisticas,
                  context.l10n.reporte_cumplimiento,
                  context.l10n.reporte_eventos_criticos,
                ][index],
                subtitle: [
                  context.l10n.reporte_tendencias,
                  context.l10n.reporte_grafico_cumplimiento,
                  context.l10n.reporte_tabla_logs,
                ][index],
                value: [
                  _includeStats,
                  _includeCompliance,
                  _includeCriticalEvents,
                ][index],
                icon: [
                  AppIcon.lineChart,
                  AppIcon.linearProgress,
                  AppIcon.tableChartOutlined,
                ][index],
                onChanged: (val) {
                  if (index == 0) {
                    setState(() => _includeStats = val);
                  } else if (index == 1) {
                    setState(() => _includeCompliance = val);
                  } else if (index == 2) {
                    setState(() => _includeCriticalEvents = val);
                  }
                },
              ),
            ],
          ),
        ),

        // En caso de estar activo el switch de estadisticas, se muestra la vista previa del reporte general.
        if (_includeStats && widget.deposit != null) ...[
          TextFormat(
            text: context.l10n.reporte_estadisticas,
            context: context,
            type: "subtitle",
          ),
          TextFormat(
            text: context.l10n.reporte_nota_tema,
            context: context,
            type: "bodySecondary",
          ),
          AppSizedBox.height12,

          ResponsiveGrid(
            items: [
              if (_isSensorActive(SensorTypes.level))
                _buildChartCard(
                  title: context.l10n.sensor_nivel,
                  chartKey: _chartKeyLevel,
                  sensorType: SensorTypes.level,
                  color: AppColor.parameterAqua,
                  maxY: 100.0,
                  unit: "%",
                ),
              if (_isSensorActive(SensorTypes.ph))
                _buildChartCard(
                  title: context.l10n.sensor_ph,
                  chartKey: _chartKeyPh,
                  sensorType: SensorTypes.ph,
                  color: AppColor.parameterPH,
                  maxY: 14.0,
                  unit: "pH",
                ),
              if (_isSensorActive(SensorTypes.turbidity))
                _buildChartCard(
                  title: context.l10n.sensor_turbidez,
                  chartKey: _chartKeyTurbidity,
                  sensorType: SensorTypes.turbidity,
                  color: AppColor.parameterTurbidity,
                  maxY: 3000.0,
                  unit: "NTU",
                ),
            ],
          ),
          AppSizedBox.height12,
        ],

        if (_includeCriticalEvents && widget.deposit != null) ...[
          TextFormat(
            text: context.l10n.reporte_eventos_criticos,
            context: context,
            type: "subtitle",
          ),
          TextFormat(
            text: context.l10n.reporte_nota_eventos_criticos,
            context: context,
            type: "bodySecondary",
          ),
          AppSizedBox.height12,
          ContainerFormat(
            children: [
              SliderFormat(
                isSingle: true,
                min: 1,
                max: 500,
                divisions: 499,
                valueDefault: _limitCriticalEvents,
                labelLimit: context.l10n.cantidad_eventos_criticos,
                unit: "",
                onChanged: (newLimit) =>
                    setState(() => _limitCriticalEvents = newLimit),
              ),
            ],
          ),
        ],

        AppSizedBox.height12,

        ButtonFormat(
          isLoading: _isCapturing,
          label: context.l10n.reporte_generar_pdf,
          onConfirm: _onGeneratePdf,
        ),
      ],
    );
  }

  // Captura el widget de un gráfico específico
  Future<Uint8List?> _captureChartImage(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error capturando gráfico: $e");
      return null;
    }
  }

  Future<void> _onGeneratePdf() async {
    setState(() {
      _isCapturing = true;
    });

    List<Uint8List?> capturedImages = [];
    if (_includeStats) {
      // Breve espera para asegurar que los gráficos se han renderizado
      await Future.delayed(const Duration(milliseconds: 500));
      final img1 = _isSensorActive(SensorTypes.level)
          ? await _captureChartImage(_chartKeyLevel)
          : null;
      final img2 = _isSensorActive(SensorTypes.ph)
          ? await _captureChartImage(_chartKeyPh)
          : null;
      final img3 = _isSensorActive(SensorTypes.turbidity)
          ? await _captureChartImage(_chartKeyTurbidity)
          : null;
      capturedImages = [img1, img2, img3];
    }

    ReportStats? reportStats;
    if ((_includeCompliance || _includeCriticalEvents) &&
        widget.deposit != null) {
      final depositId = widget.deposit!.id ?? "";
      final readingProvider = context.read<ReadingProvider>();

      final result = await readingProvider.getReportStats(
        depositId: depositId,
        filter: _selectedFilter,
      );

      if (result.isSuccess) {
        reportStats = result.data;
      } else {
        debugPrint("Error al cargar estadísticas del reporte: ${result.error}");
      }
    }

    if (!mounted) return;
    setState(() {
      _isCapturing = false;
    });

    final String depositName = widget.deposit?.name ?? "";
    final String filename = depositName.isNotEmpty
        ? "${context.l10n.titulo_reporte_pdf}_$depositName"
        : context.l10n.titulo_reporte_pdf;

    Navigator.pushNamed(
      context,
      AppRouter.pdfPreview,
      arguments: {
        "filename": filename,
        "deposit": widget.deposit,
        "selectedFilter": _selectedFilter,
        "includeStats": _includeStats,
        "includeCompliance": _includeCompliance,
        "includeCriticalEvents": _includeCriticalEvents,
        "chartsImages": capturedImages,
        "reportStats": reportStats,
        "limitCriticalEvents": _limitCriticalEvents.toInt(),
      },
    );
  }

  // Genera la tarjeta con su contenedor y encabezado para cada gráfico en la cuadrícula
  Widget _buildChartCard({
    required String title,
    required GlobalKey chartKey,
    required String sensorType,
    required Color color,
    required double maxY,
    required String unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormat(
          text: title,
          context: context,
          type: "body",
        ),
        AppSizedBox.height8,
        RepaintBoundary(
          key: chartKey,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: LineaChart(
              depositId: widget.deposit!.id ?? "",
              sensorType: sensorType,
              color: color,
              maxY: maxY,
              unit: unit,
              selectedFilter: _selectedFilter,
            ),
          ),
        ),
      ],
    );
  }
}
